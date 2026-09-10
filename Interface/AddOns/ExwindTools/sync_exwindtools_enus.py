"""
Minimal locale sync for ExwindTools.

Scope:
1. Scan source code for L["..."] keys.
2. Compare against ExwindCore/Locale/enUS.lua.
3. Prepend missing keys to enUS.lua as TODO placeholders.

This intentionally does not touch zhCN, zhTW, or other locale files yet.
"""

from __future__ import annotations

import re
from datetime import datetime
from pathlib import Path


SCRIPT_DIR = Path(__file__).resolve().parent
ADDONS_DIR = SCRIPT_DIR.parent
EXWINDTOOLS_DIR = SCRIPT_DIR
EXWINDCORE_DIR = ADDONS_DIR / "ExwindCore"
ENUS_PATH = EXWINDCORE_DIR / "Locale" / "enUS.lua"

L_KEY_PATTERN = re.compile(r'L\["((?:[^"\\]|\\.)*)"\]')
LOCALE_KEY_PATTERN = re.compile(r'^L\["((?:[^"\\]|\\.)*)"\]', re.MULTILINE)


def read_text(path: Path) -> str:
    return path.read_text(encoding="utf-8", errors="ignore")


def write_text(path: Path, content: str) -> None:
    path.write_text(content, encoding="utf-8", newline="\n")


def iter_source_files() -> list[Path]:
    files: list[Path] = []

    for path in EXWINDTOOLS_DIR.rglob("*.lua"):
        files.append(path)

    core_dir = EXWINDCORE_DIR / "Core"
    if core_dir.exists():
        for path in core_dir.rglob("*.lua"):
            files.append(path)

    return sorted(files)


def extract_source_keys() -> list[str]:
    seen: dict[str, None] = {}

    for lua_file in iter_source_files():
        content = read_text(lua_file)
        for match in L_KEY_PATTERN.finditer(content):
            key = match.group(1)
            if key not in seen:
                seen[key] = None

    return list(seen)


def extract_locale_keys(path: Path) -> list[str]:
    return LOCALE_KEY_PATTERN.findall(read_text(path))


def split_header(content: str) -> tuple[str, str]:
    match = re.search(r"^L\[", content, re.MULTILINE)
    if not match:
        return content, ""
    return content[: match.start()], content[match.start() :]


def prepend_missing_keys(path: Path, missing_keys: list[str]) -> None:
    content = read_text(path)
    header, body = split_header(content)
    timestamp = datetime.now().strftime("%Y-%m-%d %H:%M")

    new_lines = [f'L["{key}"] = "{key}"  -- TODO: translate' for key in missing_keys]
    block = f"-- added {timestamp}\n" + "\n".join(new_lines) + "\n\n"
    write_text(path, header + block + body)


def main() -> None:
    if not ENUS_PATH.exists():
        raise FileNotFoundError(f"Missing locale file: {ENUS_PATH}")

    source_keys = extract_source_keys()
    enus_keys = set(extract_locale_keys(ENUS_PATH))
    missing_keys = [key for key in source_keys if key not in enus_keys]

    print("=== sync_exwindtools_enus ===")
    print(f"Source keys: {len(source_keys)}")
    print(f"enUS keys: {len(enus_keys)}")
    print(f"Missing keys: {len(missing_keys)}")

    if not missing_keys:
        print("No missing keys.")
        return

    for key in missing_keys:
        print(f"  - {key}")

    prepend_missing_keys(ENUS_PATH, missing_keys)
    print(f"\nUpdated: {ENUS_PATH}")
    print("Next step: search enUS.lua for 'TODO: translate' and replace placeholders.")


if __name__ == "__main__":
    main()
