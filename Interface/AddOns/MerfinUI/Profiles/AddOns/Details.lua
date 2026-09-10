local addonName, Private = ...
local L = Private.L
local E, _, V, P, G = unpack(ElvUI)
--local _detalhes = _G._detalhes

function Private.ImportDetails(theme)
  if not E:IsAddOnEnabled('Details') then
    Private:Print(string.format(L['You need to enable %s.'], 'Details'))
    return
  end

  _detalhes.encounter_spell_pool = {}
  _detalhes.npcid_pool = {}
  _detalhes.spell_pool = {}
  _detalhes.spell_school_cache = {}

  _detalhes:EraseProfile(Private.MerfinProfileName)

  _detalhes_global = _detalhes_global or {}
  _detalhes_global['__profiles'] = _detalhes_global['__profiles'] or {}

  if Private.GetProfileResolution() == 'QUAD_HD' then

    _detalhes_global['__profiles'][Private.MerfinProfileName] = {
        ["overall_clear_newtorghast"] = true,
        ["use_realtimedps"] = false,
        ["row_fade_in"] = {"in", 0.2},
        ["streamer_config"] = {
            ["faster_updates"] = false,
            ["quick_detection"] = false,
            ["reset_spec_cache"] = false,
            ["no_alerts"] = false,
            ["no_helptips"] = false,
            ["use_animation_accel"] = true,
            ["disable_mythic_dungeon"] = false
        },
        ["all_players_are_group"] = false,
        ["use_row_animations"] = true,
        ["report_heal_links"] = false,
        ["remove_realm_from_name"] = true,
        ["minimum_overall_combat_time"] = 10,
        ["damage_meter_type"] = 0,
        ["event_tracker"] = {
            ["enabled"] = false,
            ["font_color"] = {1, 1, 1, 1},
            ["show_crowdcontrol_pvm"] = false,
            ["line_color"] = {0.1, 0.1, 0.1, 0.3},
            ["font_shadow"] = "NONE",
            ["font_size"] = 10,
            ["font_face"] = "Friz Quadrata TT",
            ["line_height"] = 16,
            ["show_crowdcontrol_pvp"] = true,
            ["frame"] = {
                ["show_title"] = true,
                ["strata"] = "LOW",
                ["backdrop_color"] = {0.16, 0.16, 0.16, 0.47},
                ["locked"] = false,
                ["height"] = 300,
                ["width"] = 250
            },
            ["line_texture"] = "Details Serenity",
            ["options_frame"] = {}
        },
        ["report_to_who"] = "",
        ["class_specs_coords"] = {
            [62] = {0.251953125, 0.375, 0.125, 0.25},
            [1467] = {0.5, 0.625, 0.5, 0.625},
            [63] = {0.375, 0.5, 0.125, 0.25},
            [250] = {0, 0.125, 0, 0.125},
            [251] = {0.125, 0.25, 0, 0.125},
            [252] = {0.25, 0.375, 0, 0.125},
            [1468] = {0.625, 0.75, 0.5, 0.625},
            [253] = {0.875, 1, 0, 0.125},
            [254] = {0, 0.125, 0.125, 0.25},
            [255] = {0.125, 0.25, 0.125, 0.25},
            [66] = {0.125, 0.25, 0.25, 0.375},
            [257] = {0.5, 0.625, 0.25, 0.375},
            [258] = {0.6328125, 0.75, 0.25, 0.375},
            [259] = {0.75, 0.875, 0.25, 0.375},
            [260] = {0.875, 1, 0.25, 0.375},
            [577] = {0.25, 0.375, 0.5, 0.625},
            [262] = {0.125, 0.25, 0.375, 0.5},
            [581] = {0.375, 0.5, 0.5, 0.625},
            [264] = {0.375, 0.5, 0.375, 0.5},
            [265] = {0.5, 0.625, 0.375, 0.5},
            [266] = {0.625, 0.75, 0.375, 0.5},
            [267] = {0.75, 0.875, 0.375, 0.5},
            [268] = {0.625, 0.75, 0.125, 0.25},
            [269] = {0.875, 1, 0.125, 0.25},
            [270] = {0.75, 0.875, 0.125, 0.25},
            [70] = {0.251953125, 0.375, 0.25, 0.375},
            [102] = {0.375, 0.5, 0, 0.125},
            [71] = {0.875, 1, 0.375, 0.5},
            [103] = {0.5, 0.625, 0, 0.125},
            [72] = {0, 0.125, 0.5, 0.625},
            [1480] = {0.875, 1, 0.5, 0.625},
            [104] = {0.625, 0.75, 0, 0.125},
            [64] = {0.5, 0.625, 0.125, 0.25},
            [73] = {0.125, 0.25, 0.5, 0.625},
            [65] = {0, 0.125, 0.25, 0.375},
            [105] = {0.75, 0.875, 0, 0.125},
            [256] = {0.375, 0.5, 0.25, 0.375},
            [261] = {0, 0.125, 0.375, 0.5},
            [263] = {0.25, 0.375, 0.375, 0.5},
            [1473] = {0.75, 0.875, 0.5, 0.625}
        },
        ["all_in_one_windows"] = {},
        ["tooltip"] = {
            ["tooltip_max_abilities"] = 8,
            ["apocalypse_width_useline"] = false,
            ["bar_color"] = {0.396, 0.396, 0.396, 0.87},
            ["tooltip_max_pets"] = 2,
            ["show_help"] = true,
            ["header_text_color"] = {1, 0.9176, 0, 1},
            ["apocalypse_width"] = 300,
            ["background"] = {0.196078431372549, 0.196078431372549, 0.196078431372549, 0.8},
            ["rounded_corner"] = true,
            ["show_help_count"] = 0,
            ["divisor_color"] = {1, 1, 1, 1},
            ["menus_bg_texture"] = "Interface\\SPELLBOOK\\Spellbook-Page-1",
            ["anchor_screen_pos"] = {1207.699462890625, -462.499267578125},
            ["fontcontour"] = {0, 0, 0, 1},
            ["header_statusbar"] = {0.3, 0.3, 0.3, 0.8, false, false, "WorldState Score"},
            ["fontcolor_right"] = {1, 0.7, 0, 1},
            ["line_height"] = 17,
            ["tooltip_max_targets"] = 2,
            ["icon_size"] = {
                ["W"] = 17,
                ["H"] = 17
            },
            ["anchor_relative"] = "top",
            ["show_border_shadow"] = true,
            ["anchored_to"] = 2,
            ["fontsize"] = 13,
            ["show_dps_column"] = true,
            ["icon_border_texcoord"] = {
                ["B"] = 0.921875,
                ["L"] = 0.078125,
                ["T"] = 0.078125,
                ["R"] = 0.921875
            },
            ["grow_direction"] = "down",
            ["submenu_wallpaper"] = true,
            ["fontsize_title"] = 10,
            ["show_percent_column"] = true,
            ["commands"] = {},
            ["show_header"] = true,
            ["fontface"] = "Merfin Font 1",
            ["border_color"] = {0, 0, 0, 1},
            ["border_texture"] = "Details BarBorder 3",
            ["abbreviation"] = 2,
            ["fontshadow"] = false,
            ["show_amount"] = false,
            ["border_size"] = 14,
            ["maximize_method"] = 1,
            ["anchor_offset"] = {0, 0},
            ["anchor_point"] = "bottom",
            ["menus_bg_coords"] = {0.309777336120606, 0.924000015258789, 0.213000011444092, 0.279000015258789},
            ["fontcolor"] = {1, 1, 1, 1},
            ["menus_bg_color"] = {0.8, 0.8, 0.8, 0.2}
        },
        ["ps_abbreviation"] = 3,
        ["world_combat_is_trash"] = false,
        ["pvp_as_group"] = true,
        ["bookmark_text_size"] = 11,
        ["window2_data"] = {},
        ["animation_speed_mintravel"] = 0.45,
        ["track_item_level"] = true,
        ["fade_speed"] = 0.15,
        ["death_tooltip_spark"] = false,
        ["windows_fade_in"] = {"in", 0.2},
        ["instances_menu_click_to_open"] = false,
        ["overall_clear_newchallenge"] = true,
        ["segments_amount_boss_wipes"] = 10,
        ["use_self_color"] = false,
        ["default_bg_alpha"] = 0.5,
        ["profile_save_pos"] = true,
        ["data_cleanup_logout"] = false,
        ["instances_disable_bar_highlight"] = false,
        ["show_arena_role_icon"] = false,
        ["grouping_horizontal_gap"] = 20,
        ["animate_scroll"] = false,
        ["use_battleground_server_parser"] = false,
        ["trash_concatenate"] = false,
        ["deny_score_messages"] = false,
        ["numerical_system_symbols"] = "auto",
        ["disable_lock_ungroup_buttons"] = false,
        ["animation_speed"] = 33,
        ["force_activity_time_pvp"] = true,
        ["disable_stretch_from_toolbar"] = false,
        ["realtime_dps_meter"] = {
            ["enabled"] = false,
            ["font_color"] = {1, 1, 1, 1},
            ["arena_enabled"] = true,
            ["font_shadow"] = "NONE",
            ["font_size"] = 18,
            ["mythic_dungeon_enabled"] = false,
            ["sample_size"] = 3,
            ["frame_settings"] = {
                ["show_title"] = true,
                ["strata"] = "LOW",
                ["point"] = "TOP",
                ["scale"] = 1,
                ["width"] = 300,
                ["y"] = -110,
                ["x"] = 0,
                ["backdrop_color"] = {0, 0, 0, 0.2},
                ["locked"] = true,
                ["height"] = 23
            },
            ["font_face"] = "Friz Quadrata TT",
            ["text_offset"] = 2,
            ["update_interval"] = 0.3,
            ["options_frame"] = {}
        },
        ["memory_ram"] = 64,
        ["clear_ungrouped"] = true,
        ["death_tooltip_width"] = 350,
        ["disable_window_groups"] = true,
        ["class_icons_small"] = "Interface\\AddOns\\Details\\images\\classes_small",
        ["auto_swap_to_dynamic_overall"] = false,
        ["instances_suppress_trash"] = 0,
        ["player_details_window"] = {
            ["scale"] = 1,
            ["bar_texture"] = "Skyline",
            ["skin"] = "ElvUI"
        },
        ["options_window"] = {
            ["scale"] = 1.100000023841858
        },
        ["animation_speed_maxtravel"] = 3,
        ["time_type_original"] = 2,
        ["overall_clear_newboss"] = true,
        ["font_faces"] = {
            ["menus"] = "Merfin Font 1"
        },
        ["capture_real"] = {
            ["heal"] = true,
            ["spellcast"] = true,
            ["miscdata"] = true,
            ["aura"] = true,
            ["energy"] = true,
            ["damage"] = true
        },
        ["segments_amount"] = 40,
        ["report_lines"] = 2,
        ["instances"] = {{
            ["__pos"] = {
                ["normal"] = {
                    ["y"] = -578.2884368896484,
                    ["x"] = 1163.77587890625,
                    ["w"] = 222.4291839599609,
                    ["h"] = 221.4214630126953
                },
                ["solo"] = {
                    ["y"] = 2,
                    ["x"] = 1,
                    ["w"] = 300,
                    ["h"] = 200
                }
            },
            ["hide_in_combat_type"] = 1,
            ["menu_icons_size"] = 0.7899999618530273,
            ["titlebar_shown"] = true,
            ["menu_anchor"] = {
                16,
                0,
                ["side"] = 2
            },
            ["bg_r"] = 0,
            ["fullborder_size"] = 0.7999999523162842,
            ["hide_out_of_combat"] = false,
            ["color_buttons"] = {1, 1, 1, 1},
            ["toolbar_icon_file"] = "Interface\\AddOns\\Details\\images\\toolbar_icons_2",
            ["skin_custom"] = "",
            ["use_auto_align_multi_fontstrings"] = true,
            ["sessionId"] = 1,
            ["rowareaborder_shown"] = true,
            ["fullborder_shown"] = true,
            ["clickthrough_toolbaricons"] = false,
            ["clickthrough_rows"] = false,
            ["titlebar_texture"] = "Merfin Main Texture",
            ["switch_tank"] = false,
            ["fontstrings_text_limit_offset"] = -10,
            ["menu_icons"] = {
                true,
                true,
                true,
                true,
                true,
                false,
                ["space"] = 2,
                ["shadow"] = false
            },
            ["switch_damager"] = false,
            ["auto_hide_menu"] = {
                ["left"] = true,
                ["right"] = false
            },
            ["window_scale"] = 1,
            ["attribute_icon_size"] = 0,
            ["hide_icon"] = true,
            ["overallByUser"] = false,
            ["toolbar_side"] = 1,
            ["bg_g"] = 0,
            ["line_no_tooltip"] = false,
            ["__snapV"] = false,
            ["__snapH"] = false,
            ["menu_icons_alpha"] = 0.92,
            ["show_statusbar"] = false,
            ["plugins_grow_direction"] = 1,
            ["bg_b"] = 0,
            ["__was_opened"] = true,
            ["strata"] = "LOW",
            ["icon_desaturated"] = false,
            ["backdrop_texture"] = "Solid",
            ["color"] = {1, 1, 0, 0},
            ["hide_on_context"] = {{
                ["enabled"] = false,
                ["inverse"] = false,
                ["value"] = 100
            }, {
                ["enabled"] = false,
                ["inverse"] = false,
                ["value"] = 100
            }, {
                ["enabled"] = false,
                ["inverse"] = false,
                ["value"] = 100
            }, {
                ["enabled"] = false,
                ["inverse"] = false,
                ["value"] = 100
            }, {
                ["enabled"] = false,
                ["inverse"] = false,
                ["value"] = 100
            }, {
                ["enabled"] = false,
                ["inverse"] = false,
                ["value"] = 100
            }, {
                ["enabled"] = false,
                ["inverse"] = false,
                ["value"] = 100
            }, {
                ["enabled"] = false,
                ["inverse"] = false,
                ["value"] = 100
            }, {
                ["enabled"] = false,
                ["inverse"] = false,
                ["value"] = 100
            }, {
                ["enabled"] = false,
                ["inverse"] = false,
                ["value"] = 100
            }, {
                ["enabled"] = false,
                ["inverse"] = false,
                ["value"] = 100
            }, {
                ["enabled"] = false,
                ["inverse"] = false,
                ["value"] = 100
            }, {
                ["enabled"] = false,
                ["inverse"] = false,
                ["value"] = 100
            }, {
                ["enabled"] = false,
                ["inverse"] = false,
                ["value"] = 100
            }, {
                ["enabled"] = false,
                ["inverse"] = false,
                ["value"] = 100
            }},
            ["use_multi_fontstrings"] = false,
            ["clickthrough_window"] = false,
            ["total_bar"] = {
                ["enabled"] = false,
                ["only_in_group"] = true,
                ["icon"] = "Interface\\ICONS\\INV_Sigil_Thorim",
                ["color"] = {1, 1, 1}
            },
            ["attribute_text"] = {
                ["enabled"] = true,
                ["shadow"] = true,
                ["side"] = 1,
                ["text_color"] = {1, 1, 1, 1},
                ["custom_text"] = "{name}",
                ["show_timer_arena"] = true,
                ["text_face"] = "Merfin Font 1",
                ["show_timer_always"] = false,
                ["text_size"] = 14,
                ["anchor"] = {-17, 2},
                ["enable_custom_text"] = false,
                ["show_timer"] = true,
                ["show_timer_bg"] = true
            },
            ["following"] = {
                ["enabled"] = true,
                ["bar_color"] = {1, 1, 1},
                ["text_color"] = {1, 1, 1}
            },
            ["skin"] = "Minimalistic",
            ["switch_healer_in_combat"] = false,
            ["source_type"] = 0,
            ["menu_anchor_down"] = {16, -3},
            ["switch_healer"] = false,
            ["SegmentType"] = 1,
            ["bars_inverted"] = false,
            ["bars_grow_direction"] = 1,
            ["switch_all_roles_in_combat"] = false,
            ["ignore_mass_showhide"] = false,
            ["row_info"] = {
                ["textR_outline"] = true,
                ["spec_file"] = "Interface\\AddOns\\Details\\images\\spec_icons_normal",
                ["textL_outline"] = true,
                ["playername_size_auto"] = true,
                ["row_offsets"] = {
                    ["top"] = 0,
                    ["right"] = 0,
                    ["left"] = 0,
                    ["bottom"] = 0
                },
                ["textR_outline_small"] = false,
                ["textR_show_data"] = {true, true, false},
                ["percent_type"] = 1,
                ["fixed_text_color"] = {1, 1, 1},
                ["textL_offset"] = -1,
                ["text_yoffset"] = 0,
                ["texture_background_class_color"] = false,
                ["playername_alignment_auto"] = true,
                ["font_face_file"] = "Interface\\AddOns\\MerfinPlus\\Media\\font\\SFUIDisplayCondensed-Semibold.otf",
                ["texture_custom_file"] = "Interface\\",
                ["models"] = {
                    ["upper_model"] = "Spells\\AcidBreath_SuperGreen.M2",
                    ["lower_model"] = "World\\EXPANSION02\\DOODADS\\Coldarra\\COLDARRALOCUS.m2",
                    ["upper_alpha"] = 0.5,
                    ["lower_enabled"] = false,
                    ["lower_alpha"] = 0.1,
                    ["upper_enabled"] = false
                },
                ["faction_icon_size_offset"] = -10,
                ["textL_outline_small_color"] = {0, 0, 0, 1},
                ["backdrop"] = {
                    ["color"] = {0, 0, 0, 1},
                    ["size"] = 0.5999999642372131,
                    ["enabled"] = false,
                    ["texture"] = "Details BarBorder 2"
                },
                ["start_after_icon"] = true,
                ["font_size"] = 13,
                ["textL_enable_custom_text"] = true,
                ["textL_outline_small"] = false,
                ["textL_translit_text"] = false,
                ["playername_size"] = 80,
                ["texture_file"] = "Interface\\Addons\\MerfinPlus\\Media\\statusbar\\MerfinTexture.blp",
                ["icon_size_offset"] = 0,
                ["texts"] = {
                    {
                        ["font"] = {
                            ["outline"] = "SLUG,OUTLINE"
                        },
                        ["justifyH"] = "left",
                        ["color"] = {
                            ["byClass"] = true
                        },
                        ["shadow"] = {
                            ["color"] = {0, 0, 0, 1},
                            ["offset"] = {0, 0}
                        },
                        ["justifyV"] = "middle",
                        ["anchor"] = {
                            ["y"] = 0,
                            ["relativeTo"] = "icon",
                            ["point"] = "left",
                            ["relativePoint"] = "right",
                            ["x"] = 3
                        }
                    },
                    {
                        ["font"] = {
                            ["outline"] = "SLUG,OUTLINE"
                        },
                        ["justifyH"] = "right",
                        ["color"] = {
                            ["byClass"] = true
                        },
                        ["shadow"] = {
                            ["color"] = {0, 0, 0, 1},
                            ["offset"] = {0, 0}
                        },
                        ["justifyV"] = "middle",
                        ["anchor"] = {
                            ["y"] = 0,
                            ["relativeTo"] = "statusbar",
                            ["point"] = "right",
                            ["relativePoint"] = "right",
                            ["gap"] = -4,
                            ["x"] = -70
                        }
                    },
                    {
                        ["font"] = {
                            ["outline"] = "SLUG,OUTLINE"
                        },
                        ["justifyH"] = "right",
                        ["color"] = {
                            ["byClass"] = true
                        },
                        ["shadow"] = {
                            ["color"] = {0, 0, 0, 1},
                            ["offset"] = {0, 0}
                        },
                        ["justifyV"] = "middle",
                        ["anchor"] = {
                            ["y"] = 0,
                            ["relativeTo"] = "statusbar",
                            ["point"] = "right",
                            ["relativePoint"] = "right",
                            ["gap"] = -4,
                            ["x"] = -35
                        }
                    },
                    {
                        ["font"] = {
                            ["outline"] = "SLUG,OUTLINE"
                        },
                        ["justifyH"] = "right",
                        ["color"] = {
                            ["byClass"] = true
                        },
                        ["shadow"] = {
                            ["color"] = {0, 0, 0, 1},
                            ["offset"] = {0, 0}
                        },
                        ["justifyV"] = "middle",
                        ["anchor"] = {
                            ["y"] = 0,
                            ["relativeTo"] = "statusbar",
                            ["point"] = "right",
                            ["relativePoint"] = "right",
                            ["x"] = 0
                        }
                    },
                    ["__version"] = 1
                },
                ["icon_mask"] = "",
                ["overlay_color"] = {0.7019608020782471, 0.7019608020782471, 0.7019608020782471, 0},
                ["texture_highlight"] = "Interface\\FriendsFrame\\UI-FriendsList-Highlight",
                ["textR_bracket"] = "(",
                ["arena_role_icon_size_offset"] = -10,
                ["icon_grayscale"] = false,
                ["texture_background_file"] = "Interface\\Addons\\MerfinPlus\\Media\\statusbar\\MerfinTexture.blp",
                ["use_spec_icons"] = true,
                ["textR_enable_custom_text"] = false,
                ["textR_outline_small_color"] = {0, 0, 0, 1},
                ["fixed_texture_color"] = {0.1803921568627451, 0.1607843137254902, 0.1607843137254902},
                ["textL_show_number"] = false,
                ["textL_custom_text"] = "{data1}. {data3}{data2}",
                ["texture_custom"] = "",
                ["textR_custom_text"] = "{data1} ({data2}, {data3}%)",
                ["texture"] = "Merfin Main Texture",
                ["show_faction_icon"] = true,
                ["fixed_texture_background_color"] = {0.615686297416687, 0.615686297416687, 0.615686297416687,
                                                        0.6299999952316284},
                ["overlay_texture"] = "Merfin Main Texture",
                ["show_percent"] = false,
                ["show_arena_role_icon"] = false,
                ["texture_background"] = "Merfin Main Texture",
                ["alpha"] = 1,
                ["no_icon"] = false,
                ["icon_offset"] = {0, 0},
                ["icon_file"] = "Interface\\AddOns\\Details\\images\\classes_small",
                ["font_face"] = "Merfin Font 1",
                ["texture_class_colors"] = false,
                ["space"] = {
                    ["right"] = 0,
                    ["left"] = 0,
                    ["between"] = 1
                },
                ["fast_ps_update"] = false,
                ["textR_separator"] = "NONE",
                ["height"] = 21
            },
            ["StatusBarSaved"] = {
                ["center"] = "DETAILS_STATUSBAR_PLUGIN_CLOCK",
                ["right"] = "DETAILS_STATUSBAR_PLUGIN_PDPS",
                ["options"] = {
                    ["DETAILS_STATUSBAR_PLUGIN_PDPS"] = {
                        ["segmentType"] = 2,
                        ["textFace"] = "Accidental Presidency",
                        ["textAlign"] = 3,
                        ["timeType"] = 1,
                        ["textSize"] = 10,
                        ["textColor"] = {1, 1, 1, 1}
                    },
                    ["DETAILS_STATUSBAR_PLUGIN_PSEGMENT"] = {
                        ["segmentType"] = 2,
                        ["textFace"] = "Accidental Presidency",
                        ["textAlign"] = 1,
                        ["timeType"] = 1,
                        ["textSize"] = 10,
                        ["textColor"] = {1, 1, 1, 1}
                    },
                    ["DETAILS_STATUSBAR_PLUGIN_CLOCK"] = {
                        ["segmentType"] = 2,
                        ["textFace"] = "Accidental Presidency",
                        ["textAlign"] = 2,
                        ["timeType"] = 1,
                        ["textSize"] = 10,
                        ["textColor"] = {1, 1, 1, 1}
                    }
                },
                ["left"] = "DETAILS_STATUSBAR_PLUGIN_PSEGMENT"
            },
            ["instance_button_anchor"] = {-27, 1},
            ["bg_alpha"] = 0.2999999821186066,
            ["switch_tank_in_combat"] = false,
            ["version"] = 3,
            ["show_interrupt_casts"] = false,
            ["__locked"] = true,
            ["menu_alpha"] = {
                ["enabled"] = false,
                ["onenter"] = 1,
                ["iconstoo"] = true,
                ["ignorebars"] = false,
                ["onleave"] = 1
            },
            ["tempId"] = -1,
            ["rowareaborder_color"] = {0, 0, 0, 1},
            ["fullborder_color"] = {0, 0, 0, 1},
            ["rowareaborder_size"] = 0.7999999523162842,
            ["clickthrough_incombatonly"] = true,
            ["__snap"] = {},
            ["micro_displays_side"] = 2,
            ["hide_in_combat_alpha"] = 0,
            ["automation"] = {
                ["overall_mythic_plus"] = true
            },
            ["rounded_corner_enabled"] = false,
            ["libwindow"] = {
                ["y"] = 31.00082206726074,
                ["x"] = -5.009521484375,
                ["point"] = "BOTTOMRIGHT",
                ["scale"] = 1
            },
            ["statusbar_info"] = {
                ["alpha"] = 0,
                ["overlay"] = {1, 1, 0}
            },
            ["sessionType_user"] = 1,
            ["row_show_animation"] = {
                ["anim"] = "Fade",
                ["options"] = {}
            },
            ["sessionType"] = 1,
            ["switch_damager_in_combat"] = false,
            ["bars_sort_direction"] = 1,
            ["grab_on_top"] = false,
            ["micro_displays_locked"] = true,
            ["tooltip"] = {
                ["n_abilities"] = 3,
                ["n_enemies"] = 3
            },
            ["auto_current"] = true,
            ["segmento"] = 0,
            ["sessionId_user"] = 1,
            ["desaturated_menu"] = false,
            ["hide_in_combat"] = false,
            ["posicao"] = {
                ["normal"] = {
                    ["y"] = -578.2884368896484,
                    ["x"] = 1163.77587890625,
                    ["w"] = 222.4291839599609,
                    ["h"] = 221.4214630126953
                },
                ["solo"] = {
                    ["y"] = 2,
                    ["x"] = 1,
                    ["w"] = 300,
                    ["h"] = 200
                }
            },
            ["switch_all_roles_after_wipe"] = false,
            ["show_sidebars"] = false,
            ["wallpaper"] = {
                ["overlay"] = {1, 1, 1, 1},
                ["alpha"] = 0.5,
                ["width"] = 283.000183105469,
                ["texcoord"] = {0, 1, 0, 0.703125},
                ["height"] = 114.042518615723,
                ["anchor"] = "all",
                ["level"] = 2,
                ["enabled"] = false,
                ["texture"] = "Interface\\TALENTFRAME\\bg-druid-restoration"
            },
            ["stretch_button_side"] = 2,
            ["titlebar_height"] = 8,
            ["segmento_user"] = 0,
            ["menu_icons_color"] = {1, 1, 1},
            ["titlebar_texture_color"] = {0, 0, 0, 0.699999988079071}
        }, {
            ["__pos"] = {
                ["normal"] = {
                    ["y"] = -578.3673400878906,
                    ["x"] = 936.771728515625,
                    ["w"] = 222.4291839599609,
                    ["h"] = 220.4213714599609
                },
                ["solo"] = {
                    ["y"] = 2,
                    ["x"] = 1,
                    ["w"] = 300,
                    ["h"] = 200
                }
            },
            ["hide_in_combat_type"] = 1,
            ["menu_icons_size"] = 0.7899999618530273,
            ["titlebar_shown"] = true,
            ["segmento"] = 0,
            ["bg_r"] = 0,
            ["fullborder_size"] = 0.7999999523162842,
            ["hide_out_of_combat"] = false,
            ["color_buttons"] = {1, 1, 1, 1},
            ["toolbar_icon_file"] = "Interface\\AddOns\\Details\\images\\toolbar_icons_2",
            ["skin_custom"] = "",
            ["use_auto_align_multi_fontstrings"] = true,
            ["sessionId"] = 1,
            ["rowareaborder_shown"] = true,
            ["fullborder_shown"] = true,
            ["clickthrough_toolbaricons"] = false,
            ["clickthrough_rows"] = false,
            ["titlebar_texture"] = "Merfin Main Texture",
            ["switch_tank"] = {2, 1, 9},
            ["fontstrings_text_limit_offset"] = -10,
            ["menu_icons"] = {
                true,
                true,
                true,
                true,
                true,
                false,
                ["space"] = 2,
                ["shadow"] = false
            },
            ["switch_damager"] = {2, 1, 9},
            ["show_sidebars"] = false,
            ["window_scale"] = 1,
            ["attribute_icon_size"] = 0,
            ["hide_icon"] = true,
            ["overallByUser"] = false,
            ["toolbar_side"] = 1,
            ["bg_g"] = 0,
            ["line_no_tooltip"] = false,
            ["__snapV"] = false,
            ["__snapH"] = false,
            ["menu_icons_alpha"] = 0.92,
            ["show_statusbar"] = false,
            ["plugins_grow_direction"] = 1,
            ["bg_b"] = 0,
            ["__was_opened"] = true,
            ["strata"] = "LOW",
            ["desaturated_menu"] = false,
            ["backdrop_texture"] = "Solid",
            ["color"] = {1, 1, 0, 0},
            ["hide_on_context"] = {{
                ["enabled"] = false,
                ["inverse"] = false,
                ["value"] = 100
            }, {
                ["enabled"] = false,
                ["inverse"] = false,
                ["value"] = 100
            }, {
                ["enabled"] = false,
                ["inverse"] = false,
                ["value"] = 100
            }, {
                ["enabled"] = false,
                ["inverse"] = false,
                ["value"] = 100
            }, {
                ["enabled"] = false,
                ["inverse"] = false,
                ["value"] = 100
            }, {
                ["enabled"] = false,
                ["inverse"] = false,
                ["value"] = 100
            }, {
                ["enabled"] = false,
                ["inverse"] = false,
                ["value"] = 100
            }, {
                ["enabled"] = false,
                ["inverse"] = false,
                ["value"] = 100
            }, {
                ["enabled"] = false,
                ["inverse"] = false,
                ["value"] = 100
            }, {
                ["enabled"] = false,
                ["inverse"] = false,
                ["value"] = 100
            }, {
                ["enabled"] = false,
                ["inverse"] = false,
                ["value"] = 100
            }, {
                ["enabled"] = false,
                ["inverse"] = false,
                ["value"] = 100
            }, {
                ["enabled"] = false,
                ["inverse"] = false,
                ["value"] = 100
            }, {
                ["enabled"] = false,
                ["inverse"] = false,
                ["value"] = 100
            }, {
                ["enabled"] = false,
                ["inverse"] = false,
                ["value"] = 100
            }},
            ["use_multi_fontstrings"] = false,
            ["clickthrough_window"] = false,
            ["total_bar"] = {
                ["enabled"] = false,
                ["only_in_group"] = true,
                ["icon"] = "Interface\\ICONS\\INV_Sigil_Thorim",
                ["color"] = {1, 1, 1}
            },
            ["tooltip"] = {
                ["n_abilities"] = 3,
                ["n_enemies"] = 3
            },
            ["following"] = {
                ["bar_color"] = {1, 1, 1},
                ["enabled"] = true,
                ["text_color"] = {1, 1, 1}
            },
            ["skin"] = "Minimalistic",
            ["switch_healer_in_combat"] = {"raid", "DETAILS_PLUGIN_TINY_THREAT", 32},
            ["source_type"] = 0,
            ["menu_anchor_down"] = {16, -3},
            ["switch_healer"] = {2, 1, 9},
            ["SegmentType"] = 1,
            ["bars_inverted"] = false,
            ["bars_grow_direction"] = 1,
            ["switch_all_roles_in_combat"] = false,
            ["ignore_mass_showhide"] = false,
            ["row_info"] = {
                ["show_arena_role_icon"] = false,
                ["spec_file"] = "Interface\\AddOns\\Details\\images\\spec_icons_normal",
                ["textL_outline"] = true,
                ["playername_size_auto"] = true,
                ["row_offsets"] = {
                    ["top"] = 0,
                    ["right"] = 0,
                    ["left"] = 0,
                    ["bottom"] = 0
                },
                ["texture_highlight"] = "Interface\\FriendsFrame\\UI-FriendsList-Highlight",
                ["textR_show_data"] = {true, true, false},
                ["percent_type"] = 1,
                ["fixed_text_color"] = {1, 1, 1},
                ["textL_offset"] = -1,
                ["text_yoffset"] = 0,
                ["texture_background_class_color"] = false,
                ["playername_alignment_auto"] = true,
                ["font_face_file"] = "Interface\\AddOns\\MerfinPlus\\Media\\font\\SFUIDisplayCondensed-Semibold.otf",
                ["texture_custom_file"] = "Interface\\",
                ["font_size"] = 13,
                ["faction_icon_size_offset"] = -10,
                ["textL_outline_small_color"] = {0, 0, 0, 1},
                ["backdrop"] = {
                    ["enabled"] = false,
                    ["color"] = {0, 0, 0, 1},
                    ["texture"] = "Details BarBorder 2",
                    ["use_class_colors"] = false,
                    ["size"] = 0.5999999642372131
                },
                ["start_after_icon"] = true,
                ["models"] = {
                    ["upper_model"] = "Spells\\AcidBreath_SuperGreen.M2",
                    ["lower_model"] = "World\\EXPANSION02\\DOODADS\\Coldarra\\COLDARRALOCUS.m2",
                    ["upper_alpha"] = 0.5,
                    ["lower_enabled"] = false,
                    ["lower_alpha"] = 0.1,
                    ["upper_enabled"] = false
                },
                ["textL_enable_custom_text"] = true,
                ["textL_outline_small"] = false,
                ["textL_translit_text"] = false,
                ["playername_size"] = 80,
                ["texture_file"] = "Interface\\Addons\\MerfinPlus\\Media\\statusbar\\MerfinTexture.blp",
                ["icon_size_offset"] = 0,
                ["texts"] = {
                    {
                        ["font"] = {
                            ["outline"] = "SLUG,OUTLINE"
                        },
                        ["justifyH"] = "left",
                        ["color"] = {
                            ["byClass"] = true
                        },
                        ["shadow"] = {
                            ["color"] = {0, 0, 0, 1},
                            ["offset"] = {0, 0}
                        },
                        ["justifyV"] = "middle",
                        ["anchor"] = {
                            ["y"] = 0,
                            ["relativeTo"] = "icon",
                            ["point"] = "left",
                            ["relativePoint"] = "right",
                            ["x"] = 3
                        }
                    },
                    {
                        ["font"] = {
                            ["outline"] = "SLUG,OUTLINE"
                        },
                        ["justifyH"] = "right",
                        ["color"] = {
                            ["byClass"] = true
                        },
                        ["shadow"] = {
                            ["color"] = {0, 0, 0, 1},
                            ["offset"] = {0, 0}
                        },
                        ["justifyV"] = "middle",
                        ["anchor"] = {
                            ["y"] = 0,
                            ["relativeTo"] = "statusbar",
                            ["point"] = "right",
                            ["relativePoint"] = "right",
                            ["gap"] = -4,
                            ["x"] = -70
                        }
                    },
                    {
                        ["font"] = {
                            ["outline"] = "SLUG,OUTLINE"
                        },
                        ["justifyH"] = "right",
                        ["color"] = {
                            ["byClass"] = true
                        },
                        ["shadow"] = {
                            ["color"] = {0, 0, 0, 1},
                            ["offset"] = {0, 0}
                        },
                        ["justifyV"] = "middle",
                        ["anchor"] = {
                            ["y"] = 0,
                            ["relativeTo"] = "statusbar",
                            ["point"] = "right",
                            ["relativePoint"] = "right",
                            ["gap"] = -4,
                            ["x"] = -35
                        }
                    },
                    {
                        ["font"] = {
                            ["outline"] = "SLUG,OUTLINE"
                        },
                        ["justifyH"] = "right",
                        ["color"] = {
                            ["byClass"] = true
                        },
                        ["shadow"] = {
                            ["color"] = {0, 0, 0, 1},
                            ["offset"] = {0, 0}
                        },
                        ["justifyV"] = "middle",
                        ["anchor"] = {
                            ["y"] = 0,
                            ["relativeTo"] = "statusbar",
                            ["point"] = "right",
                            ["relativePoint"] = "right",
                            ["x"] = 0
                        }
                    },
                    ["__version"] = 1
                },
                ["icon_mask"] = "",
                ["overlay_color"] = {0.7019608020782471, 0.7019608020782471, 0.7019608020782471, 0},
                ["textR_outline_small"] = false,
                ["textR_bracket"] = "(",
                ["arena_role_icon_size_offset"] = -10,
                ["icon_grayscale"] = false,
                ["texture_background_file"] = "Interface\\Addons\\MerfinPlus\\Media\\statusbar\\MerfinTexture.blp",
                ["use_spec_icons"] = true,
                ["textR_enable_custom_text"] = false,
                ["alpha"] = 1,
                ["fixed_texture_color"] = {0.1803921568627451, 0.1607843137254902, 0.1607843137254902},
                ["textL_show_number"] = false,
                ["textL_custom_text"] = "{data1}. {data3}{data2}",
                ["texture_custom"] = "",
                ["textR_custom_text"] = "{data1} ({data2}, {data3}%)",
                ["texture"] = "Merfin Main Texture",
                ["show_faction_icon"] = true,
                ["fixed_texture_background_color"] = {0.615686297416687, 0.615686297416687, 0.615686297416687,
                                                        0.6299999952316284},
                ["overlay_texture"] = "Merfin Main Texture",
                ["show_percent"] = false,
                ["textR_outline"] = true,
                ["texture_background"] = "Merfin Main Texture",
                ["textR_outline_small_color"] = {0, 0, 0, 1},
                ["no_icon"] = false,
                ["icon_offset"] = {0, 0},
                ["icon_file"] = "Interface\\AddOns\\Details\\images\\classes_small",
                ["font_face"] = "Merfin Font 1",
                ["texture_class_colors"] = false,
                ["space"] = {
                    ["right"] = 0,
                    ["left"] = 0,
                    ["between"] = 1
                },
                ["fast_ps_update"] = false,
                ["textR_separator"] = "NONE",
                ["height"] = 21
            },
            ["StatusBarSaved"] = {
                ["center"] = "DETAILS_STATUSBAR_PLUGIN_CLOCK",
                ["right"] = "DETAILS_STATUSBAR_PLUGIN_PDPS",
                ["options"] = {
                    ["DETAILS_STATUSBAR_PLUGIN_PDPS"] = {
                        ["segmentType"] = 2,
                        ["textFace"] = "Accidental Presidency",
                        ["textAlign"] = 3,
                        ["timeType"] = 1,
                        ["textSize"] = 10,
                        ["textColor"] = {1, 1, 1, 1}
                    },
                    ["DETAILS_STATUSBAR_PLUGIN_PSEGMENT"] = {
                        ["segmentType"] = 2,
                        ["textFace"] = "Accidental Presidency",
                        ["textAlign"] = 1,
                        ["timeType"] = 1,
                        ["textSize"] = 10,
                        ["textColor"] = {1, 1, 1, 1}
                    },
                    ["DETAILS_STATUSBAR_PLUGIN_CLOCK"] = {
                        ["segmentType"] = 2,
                        ["textFace"] = "Accidental Presidency",
                        ["textAlign"] = 2,
                        ["timeType"] = 1,
                        ["textSize"] = 10,
                        ["textColor"] = {1, 1, 1, 1}
                    }
                },
                ["left"] = "DETAILS_STATUSBAR_PLUGIN_PSEGMENT"
            },
            ["instance_button_anchor"] = {-27, 1},
            ["bg_alpha"] = 0.2999999821186066,
            ["switch_tank_in_combat"] = {"raid", "DETAILS_PLUGIN_TINY_THREAT", 32},
            ["version"] = 3,
            ["show_interrupt_casts"] = false,
            ["__locked"] = true,
            ["menu_alpha"] = {
                ["enabled"] = false,
                ["onleave"] = 1,
                ["ignorebars"] = false,
                ["iconstoo"] = true,
                ["onenter"] = 1
            },
            ["tempId"] = -1,
            ["rowareaborder_color"] = {0, 0, 0, 1},
            ["fullborder_color"] = {0, 0, 0, 1},
            ["rowareaborder_size"] = 0.7999999523162842,
            ["clickthrough_incombatonly"] = true,
            ["__snap"] = {},
            ["micro_displays_side"] = 2,
            ["hide_in_combat_alpha"] = 0,
            ["automation"] = {
                ["overall_mythic_plus"] = true
            },
            ["rounded_corner_enabled"] = false,
            ["libwindow"] = {
                ["y"] = 31.42197608947754,
                ["x"] = -232.013671875,
                ["point"] = "BOTTOMRIGHT",
                ["scale"] = 1
            },
            ["statusbar_info"] = {
                ["alpha"] = 0,
                ["overlay"] = {1, 1, 0}
            },
            ["sessionType_user"] = 1,
            ["row_show_animation"] = {
                ["anim"] = "Fade",
                ["options"] = {}
            },
            ["sessionType"] = 1,
            ["switch_damager_in_combat"] = {"raid", "DETAILS_PLUGIN_TINY_THREAT", 32},
            ["bars_sort_direction"] = 1,
            ["grab_on_top"] = false,
            ["micro_displays_locked"] = true,
            ["menu_anchor"] = {
                16,
                0,
                ["side"] = 2
            },
            ["auto_current"] = true,
            ["attribute_text"] = {
                ["enabled"] = true,
                ["shadow"] = true,
                ["side"] = 1,
                ["text_color"] = {1, 1, 1, 1},
                ["custom_text"] = "{name}",
                ["show_timer_arena"] = true,
                ["text_face"] = "Merfin Font 1",
                ["show_timer_always"] = false,
                ["text_size"] = 14,
                ["anchor"] = {-17, 2},
                ["show_timer"] = true,
                ["enable_custom_text"] = false,
                ["show_timer_bg"] = true
            },
            ["sessionId_user"] = 1,
            ["auto_hide_menu"] = {
                ["left"] = true,
                ["right"] = false
            },
            ["hide_in_combat"] = false,
            ["posicao"] = {
                ["normal"] = {
                    ["y"] = -578.3673400878906,
                    ["x"] = 936.771728515625,
                    ["w"] = 222.4291839599609,
                    ["h"] = 220.4213714599609
                },
                ["solo"] = {
                    ["y"] = 2,
                    ["x"] = 1,
                    ["w"] = 300,
                    ["h"] = 200
                }
            },
            ["icon_desaturated"] = false,
            ["switch_all_roles_after_wipe"] = false,
            ["wallpaper"] = {
                ["enabled"] = false,
                ["alpha"] = 0.5,
                ["width"] = 283.000183105469,
                ["texcoord"] = {0, 1, 0, 0.703125},
                ["anchor"] = "all",
                ["height"] = 114.042518615723,
                ["level"] = 2,
                ["overlay"] = {1, 1, 1, 1},
                ["texture"] = "Interface\\TALENTFRAME\\bg-druid-restoration"
            },
            ["stretch_button_side"] = 1,
            ["titlebar_height"] = 8,
            ["segmento_user"] = 0,
            ["menu_icons_color"] = {1, 1, 1},
            ["titlebar_texture_color"] = {0, 0, 0, 0.699999988079071}
        }},
        ["overall_clear_pvp"] = true,
        ["windows_fade_out"] = {"out", 0.2},
        ["default_bg_color"] = 0.0941,
        ["skin"] = "Minimalistic",
        ["override_spellids"] = true,
        ["minimum_combat_time"] = 5,
        ["font_sizes"] = {
            ["menus"] = 13
        },
        ["overall_clear_logout"] = false,
        ["new_window_size"] = {
            ["height"] = 158,
            ["width"] = 310
        },
        ["realtimedps_always_arena"] = false,
        ["broadcaster_enabled"] = false,
        ["cloud_capture"] = true,
        ["damage_taken_everything"] = false,
        ["scroll_speed"] = 2,
        ["window_clamp"] = {-8, 0, 21, -14},
        ["memory_threshold"] = 3,
        ["deadlog_events"] = 32,
        ["total_abbreviation"] = 2,
        ["close_shields"] = false,
        ["class_coords"] = {
            ["HUNTER"] = {0, 0.125, 0.125, 0.25},
            ["WARRIOR"] = {0, 0.125, 0, 0.125},
            ["PALADIN"] = {0, 0.125, 0.25, 0.375},
            ["MAGE"] = {0.125, 0.248046875, 0, 0.125},
            ["PET"] = {0.125, 0.248046875, 0.375, 0.5},
            ["DRUID"] = {0.37109375, 0.494140625, 0, 0.125},
            ["MONK"] = {0.25, 0.369140625, 0.25, 0.375},
            ["DEATHKNIGHT"] = {0.125, 0.25, 0.25, 0.375},
            ["MONSTER"] = {0, 0.125, 0.375, 0.5},
            ["ROGUE"] = {0.248046875, 0.37109375, 0, 0.125},
            ["UNKNOW"] = {0.25, 0.375, 0.375, 0.5},
            ["PRIEST"] = {0.248046875, 0.37109375, 0.125, 0.25},
            ["UNGROUPPLAYER"] = {0.25, 0.375, 0.375, 0.5},
            ["Alliance"] = {0.248046875, 0.02968748, 0.375, 0.5},
            ["ENEMY"] = {0, 0.125, 0.375, 0.5},
            ["DEMONHUNTER"] = {0.36914063, 0.5, 0.25, 0.375},
            ["Horde"] = {0.37109375, 0.494140625, 0.375, 0.5},
            ["SHAMAN"] = {0.125, 0.248046875, 0.125, 0.25},
            ["EVOKER"] = {0.50390625, 0.625, 0, 0.125},
            ["WARLOCK"] = {0.37109375, 0.494140625, 0.125, 0.25}
        },
        ["segments_auto_erase"] = 1,
        ["disable_alldisplays_window"] = false,
        ["trash_auto_remove"] = true,
        ["segments_boss_wipes_keep_best_performance"] = true,
        ["hotcorner_topleft"] = {
            ["hide"] = false
        },
        ["chat_tab_embed"] = {
            ["enabled"] = false,
            ["y_offset"] = 0,
            ["x_offset"] = 0,
            ["tab_name"] = "",
            ["single_window"] = false
        },
        ["clear_graphic"] = true,
        ["class_colors"] = {
            ["HUNTER"] = {0.67, 0.83, 0.45},
            ["WARRIOR"] = {0.78, 0.61, 0.43},
            ["PALADIN"] = {0.96, 0.55, 0.73},
            ["MAGE"] = {0.41, 0.8, 0.94},
            ["ARENA_YELLOW"] = {1, 1, 0.25},
            ["UNGROUPPLAYER"] = {0.4, 0.4, 0.4},
            ["DRUID"] = {1, 0.49, 0.04},
            ["MONK"] = {0, 1, 0.59},
            ["DEATHKNIGHT"] = {0.77, 0.12, 0.23},
            ["ARENA_GREEN"] = {0.6862745098039216, 0.3843137254901961, 1},
            ["PET"] = {0.3, 0.4, 0.5},
            ["ROGUE"] = {1, 0.96, 0.41},
            ["UNKNOW"] = {0.2, 0.2, 0.2},
            ["PRIEST"] = {1, 1, 1},
            ["SHAMAN"] = {0, 0.44, 0.87},
            ["version"] = 1,
            ["ENEMY"] = {0.94117, 0, 0.0196, 1},
            ["DEMONHUNTER"] = {0.64, 0.19, 0.79},
            ["WARLOCK"] = {0.58, 0.51, 0.79},
            ["NEUTRAL"] = {1, 1, 0},
            ["EVOKER"] = {0.2, 0.498, 0.5764},
            ["SELF"] = {0.89019, 0.32156, 0.89019}
        },
        ["animation_speed_triggertravel"] = 5,
        ["options_group_edit"] = false,
        ["segments_amount_to_save"] = 40,
        ["minimap"] = {
            ["onclick_what_todo"] = 1,
            ["radius"] = 160,
            ["text_type"] = 1,
            ["minimapPos"] = 261.9297625328454,
            ["text_format"] = 3,
            ["hide"] = false
        },
        ["instances_amount"] = 5,
        ["max_window_size"] = {
            ["height"] = 450,
            ["width"] = 480
        },
        ["righttext_simple_formatting"] = {
            ["enabled"] = true,
            ["format_tsp"] = "%s (%s)",
            ["format_ts"] = "%s (%s)",
            ["use_alignment"] = false,
            ["alignment_space"] = 60,
            ["first_run"] = true,
            ["format_tp"] = "%s"
        },
        ["only_pvp_frags"] = false,
        ["disable_stretch_button"] = true,
        ["color_by_arena_team"] = true,
        ["use_scroll"] = false,
        ["overall_flag"] = 16,
        ["segments_panic_mode"] = false,
        ["realtimedps_order_bars"] = false,
        ["damage_meter_position"] = {},
        ["row_fade_out"] = {"out", 0.2},
        ["numerical_system"] = 1,
        ["time_type"] = 2,
        ["update_speed"] = 1,
        ["report_schema"] = 1,
        ["standard_skin"] = false,
        ["death_tooltip_texture"] = "Details Serenity",
        ["disable_reset_button"] = false,
        ["data_broker_text"] = "",
        ["instances_no_libwindow"] = false,
        ["instances_segments_locked"] = false,
        ["deadlog_limit"] = 16,
        ["death_log_colors"] = {
            ["debuff"] = "purple",
            ["buff"] = "silver",
            ["friendlyfire"] = "darkorange",
            ["heal"] = "green",
            ["cooldown"] = "yellow",
            ["damage"] = "red"
        }
    }

  elseif Private.GetProfileResolution() == 'FULL_HD' then

    _detalhes_global['__profiles'][Private.MerfinProfileName] = {
        ["overall_clear_newtorghast"] = true,
        ["use_realtimedps"] = false,
        ["row_fade_in"] = {"in", 0.2},
        ["streamer_config"] = {
            ["faster_updates"] = false,
            ["quick_detection"] = false,
            ["reset_spec_cache"] = false,
            ["no_alerts"] = false,
            ["no_helptips"] = false,
            ["disable_mythic_dungeon"] = false,
            ["use_animation_accel"] = true
        },
        ["all_players_are_group"] = false,
        ["use_row_animations"] = true,
        ["report_heal_links"] = false,
        ["remove_realm_from_name"] = true,
        ["minimum_overall_combat_time"] = 10,
        ["damage_meter_type"] = 0,
        ["event_tracker"] = {
            ["enabled"] = false,
            ["font_color"] = {1, 1, 1, 1},
            ["show_crowdcontrol_pvm"] = false,
            ["line_color"] = {0.1, 0.1, 0.1, 0.3},
            ["font_shadow"] = "NONE",
            ["font_size"] = 10,
            ["font_face"] = "Friz Quadrata TT",
            ["line_height"] = 16,
            ["show_crowdcontrol_pvp"] = true,
            ["frame"] = {
                ["show_title"] = true,
                ["strata"] = "LOW",
                ["backdrop_color"] = {0.16, 0.16, 0.16, 0.47},
                ["locked"] = false,
                ["height"] = 300,
                ["width"] = 250
            },
            ["line_texture"] = "Details Serenity",
            ["options_frame"] = {}
        },
        ["report_to_who"] = "",
        ["instances_segments_locked"] = false,
        ["profile_save_pos"] = true,
        ["use_battleground_server_parser"] = false,
        ["ps_abbreviation"] = 3,
        ["world_combat_is_trash"] = false,
        ["update_speed"] = 1,
        ["bookmark_text_size"] = 11,
        ["all_in_one_windows"] = {},
        ["animation_speed_mintravel"] = 0.45,
        ["track_item_level"] = true,
        ["fade_speed"] = 0.15,
        ["death_tooltip_spark"] = false,
        ["windows_fade_in"] = {"in", 0.2},
        ["instances_menu_click_to_open"] = false,
        ["overall_clear_newchallenge"] = true,
        ["segments_amount_boss_wipes"] = 10,
        ["use_self_color"] = false,
        ["default_bg_alpha"] = 0.5,
        ["instances_no_libwindow"] = false,
        ["data_cleanup_logout"] = false,
        ["instances_disable_bar_highlight"] = false,
        ["pvp_as_group"] = true,
        ["grouping_horizontal_gap"] = 20,
        ["animate_scroll"] = false,
        ["numerical_system_symbols"] = "auto",
        ["trash_concatenate"] = false,
        ["color_by_arena_team"] = true,
        ["class_icons_small"] = "Interface\\AddOns\\Details\\images\\classes_small",
        ["standard_skin"] = false,
        ["animation_speed"] = 33,
        ["force_activity_time_pvp"] = true,
        ["disable_stretch_from_toolbar"] = false,
        ["disable_lock_ungroup_buttons"] = false,
        ["memory_ram"] = 64,
        ["tooltip"] = {
            ["tooltip_max_abilities"] = 8,
            ["apocalypse_width_useline"] = false,
            ["bar_color"] = {0.396, 0.396, 0.396, 0.87},
            ["tooltip_max_pets"] = 2,
            ["show_help"] = true,
            ["header_text_color"] = {1, 0.9176, 0, 1},
            ["apocalypse_width"] = 300,
            ["background"] = {0.196078431372549, 0.196078431372549, 0.196078431372549, 0.8},
            ["rounded_corner"] = true,
            ["show_help_count"] = 0,
            ["divisor_color"] = {1, 1, 1, 1},
            ["menus_bg_texture"] = "Interface\\SPELLBOOK\\Spellbook-Page-1",
            ["anchor_screen_pos"] = {1207.699462890625, -462.499267578125},
            ["fontcontour"] = {0, 0, 0, 1},
            ["header_statusbar"] = {0.3, 0.3, 0.3, 0.8, false, false, "WorldState Score"},
            ["fontcolor_right"] = {1, 0.7, 0, 1},
            ["line_height"] = 17,
            ["tooltip_max_targets"] = 2,
            ["icon_size"] = {
                ["W"] = 17,
                ["H"] = 17
            },
            ["anchor_relative"] = "top",
            ["menus_bg_color"] = {0.8, 0.8, 0.8, 0.2},
            ["anchored_to"] = 2,
            ["fontsize"] = 11,
            ["show_dps_column"] = true,
            ["fontcolor"] = {1, 1, 1, 1},
            ["grow_direction"] = "down",
            ["submenu_wallpaper"] = true,
            ["fontsize_title"] = 10,
            ["show_percent_column"] = true,
            ["commands"] = {},
            ["border_texture"] = "Details BarBorder 3",
            ["fontface"] = "Merfin Font 1",
            ["border_color"] = {0, 0, 0, 1},
            ["show_header"] = true,
            ["anchor_offset"] = {0, 0},
            ["fontshadow"] = false,
            ["show_amount"] = false,
            ["border_size"] = 14,
            ["maximize_method"] = 1,
            ["abbreviation"] = 2,
            ["anchor_point"] = "bottom",
            ["menus_bg_coords"] = {0.309777336120606, 0.924000015258789, 0.213000011444092, 0.279000015258789},
            ["icon_border_texcoord"] = {
                ["R"] = 0.921875,
                ["L"] = 0.078125,
                ["T"] = 0.078125,
                ["B"] = 0.921875
            },
            ["show_border_shadow"] = true
        },
        ["time_type"] = 2,
        ["disable_window_groups"] = true,
        ["time_type_original"] = 2,
        ["auto_swap_to_dynamic_overall"] = false,
        ["instances_suppress_trash"] = 0,
        ["overall_clear_newboss"] = true,
        ["options_window"] = {
            ["scale"] = 1.100000023841858
        },
        ["animation_speed_maxtravel"] = 3,
        ["overall_flag"] = 16,
        ["use_scroll"] = false,
        ["font_faces"] = {
            ["menus"] = "Merfin Font 1"
        },
        ["death_tooltip_width"] = 350,
        ["default_bg_color"] = 0.0941,
        ["report_lines"] = 2,
        ["instances"] = {{
            ["__pos"] = {
                ["normal"] = {
                    ["y"] = -427.6635589599609,
                    ["x"] = 866.155029296875,
                    ["w"] = 177.1793670654297,
                    ["h"] = 163.1716613769531
                },
                ["solo"] = {
                    ["y"] = 2,
                    ["x"] = 1,
                    ["w"] = 300,
                    ["h"] = 200
                }
            },
            ["hide_in_combat_type"] = 1,
            ["menu_icons_size"] = 0.7899999618530273,
            ["titlebar_shown"] = true,
            ["segmento"] = 0,
            ["bg_r"] = 0,
            ["fullborder_size"] = 0.7999999523162842,
            ["hide_out_of_combat"] = false,
            ["color_buttons"] = {1, 1, 1, 1},
            ["toolbar_icon_file"] = "Interface\\AddOns\\Details\\images\\toolbar_icons_2",
            ["skin_custom"] = "",
            ["use_auto_align_multi_fontstrings"] = true,
            ["sessionId"] = 1,
            ["rowareaborder_shown"] = true,
            ["fullborder_shown"] = true,
            ["clickthrough_toolbaricons"] = false,
            ["clickthrough_rows"] = false,
            ["titlebar_texture"] = "Merfin Main Texture",
            ["switch_tank"] = false,
            ["fontstrings_text_limit_offset"] = -10,
            ["menu_icons"] = {
                true,
                true,
                true,
                true,
                true,
                false,
                ["space"] = 2,
                ["shadow"] = false
            },
            ["switch_damager"] = false,
            ["show_sidebars"] = false,
            ["window_scale"] = 1,
            ["attribute_icon_size"] = 0,
            ["hide_icon"] = true,
            ["overallByUser"] = false,
            ["toolbar_side"] = 1,
            ["bg_g"] = 0,
            ["line_no_tooltip"] = false,
            ["__snapV"] = false,
            ["__snapH"] = false,
            ["menu_icons_alpha"] = 0.92,
            ["show_statusbar"] = false,
            ["plugins_grow_direction"] = 1,
            ["bg_b"] = 0,
            ["__was_opened"] = true,
            ["strata"] = "LOW",
            ["desaturated_menu"] = false,
            ["backdrop_texture"] = "Solid",
            ["color"] = {1, 1, 0, 0},
            ["hide_on_context"] = {{
                ["enabled"] = false,
                ["inverse"] = false,
                ["value"] = 100
            }, {
                ["enabled"] = false,
                ["inverse"] = false,
                ["value"] = 100
            }, {
                ["enabled"] = false,
                ["inverse"] = false,
                ["value"] = 100
            }, {
                ["enabled"] = false,
                ["inverse"] = false,
                ["value"] = 100
            }, {
                ["enabled"] = false,
                ["inverse"] = false,
                ["value"] = 100
            }, {
                ["enabled"] = false,
                ["inverse"] = false,
                ["value"] = 100
            }, {
                ["enabled"] = false,
                ["inverse"] = false,
                ["value"] = 100
            }, {
                ["enabled"] = false,
                ["inverse"] = false,
                ["value"] = 100
            }, {
                ["enabled"] = false,
                ["inverse"] = false,
                ["value"] = 100
            }, {
                ["enabled"] = false,
                ["inverse"] = false,
                ["value"] = 100
            }, {
                ["enabled"] = false,
                ["inverse"] = false,
                ["value"] = 100
            }, {
                ["enabled"] = false,
                ["inverse"] = false,
                ["value"] = 100
            }, {
                ["enabled"] = false,
                ["inverse"] = false,
                ["value"] = 100
            }, {
                ["enabled"] = false,
                ["inverse"] = false,
                ["value"] = 100
            }, {
                ["enabled"] = false,
                ["inverse"] = false,
                ["value"] = 100
            }},
            ["use_multi_fontstrings"] = false,
            ["clickthrough_window"] = false,
            ["total_bar"] = {
                ["enabled"] = false,
                ["only_in_group"] = true,
                ["icon"] = "Interface\\ICONS\\INV_Sigil_Thorim",
                ["color"] = {1, 1, 1}
            },
            ["tooltip"] = {
                ["n_abilities"] = 3,
                ["n_enemies"] = 3
            },
            ["following"] = {
                ["enabled"] = true,
                ["bar_color"] = {1, 1, 1},
                ["text_color"] = {1, 1, 1}
            },
            ["skin"] = "Minimalistic",
            ["switch_healer_in_combat"] = false,
            ["source_type"] = 0,
            ["menu_anchor_down"] = {16, -3},
            ["switch_healer"] = false,
            ["SegmentType"] = 1,
            ["bars_inverted"] = false,
            ["bars_grow_direction"] = 1,
            ["switch_all_roles_in_combat"] = false,
            ["ignore_mass_showhide"] = false,
            ["row_info"] = {
                ["textR_outline"] = true,
                ["spec_file"] = "Interface\\AddOns\\Details\\images\\spec_icons_normal",
                ["textL_outline"] = true,
                ["playername_size_auto"] = true,
                ["row_offsets"] = {
                    ["top"] = 0,
                    ["right"] = 0,
                    ["left"] = 0,
                    ["bottom"] = 0
                },
                ["textR_outline_small"] = false,
                ["textR_show_data"] = {true, true, false},
                ["textL_enable_custom_text"] = true,
                ["fixed_text_color"] = {1, 1, 1},
                ["textL_offset"] = -1,
                ["text_yoffset"] = 0,
                ["texture_background_class_color"] = false,
                ["textL_outline_small_color"] = {0, 0, 0, 1},
                ["font_face_file"] = "Interface\\AddOns\\MerfinPlus\\Media\\font\\SFUIDisplayCondensed-Semibold.otf",
                ["height"] = 17,
                ["backdrop"] = {
                    ["color"] = {0, 0, 0, 1},
                    ["texture"] = "Details BarBorder 2",
                    ["enabled"] = false,
                    ["size"] = 0.5999999642372131
                },
                ["faction_icon_size_offset"] = -10,
                ["playername_alignment_auto"] = true,
                ["textL_custom_text"] = "{data1}. {data3}{data2}",
                ["start_after_icon"] = true,
                ["font_size"] = 11,
                ["percent_type"] = 1,
                ["textL_outline_small"] = false,
                ["textL_translit_text"] = false,
                ["playername_size"] = 80,
                ["show_percent"] = false,
                ["icon_size_offset"] = 0,
                ["texts"] = {
                    {
                        ["shadow"] = {
                            ["color"] = {0, 0, 0, 1},
                            ["offset"] = {0, 0}
                        },
                        ["justifyH"] = "left",
                        ["anchor"] = {
                            ["y"] = 0,
                            ["relativeTo"] = "icon",
                            ["point"] = "left",
                            ["relativePoint"] = "right",
                            ["x"] = 3
                        },
                        ["color"] = {
                            ["byClass"] = true
                        },
                        ["justifyV"] = "middle",
                        ["font"] = {
                            ["outline"] = "SLUG,OUTLINE"
                        }
                    },
                    {
                        ["shadow"] = {
                            ["color"] = {0, 0, 0, 1},
                            ["offset"] = {0, 0}
                        },
                        ["justifyH"] = "right",
                        ["anchor"] = {
                            ["y"] = 0,
                            ["relativeTo"] = "statusbar",
                            ["point"] = "right",
                            ["relativePoint"] = "right",
                            ["gap"] = -4,
                            ["x"] = -70
                        },
                        ["color"] = {
                            ["byClass"] = true
                        },
                        ["justifyV"] = "middle",
                        ["font"] = {
                            ["outline"] = "SLUG,OUTLINE"
                        }
                    },
                    {
                        ["shadow"] = {
                            ["color"] = {0, 0, 0, 1},
                            ["offset"] = {0, 0}
                        },
                        ["justifyH"] = "right",
                        ["anchor"] = {
                            ["y"] = 0,
                            ["relativeTo"] = "statusbar",
                            ["point"] = "right",
                            ["relativePoint"] = "right",
                            ["gap"] = -4,
                            ["x"] = -35
                        },
                        ["color"] = {
                            ["byClass"] = true
                        },
                        ["justifyV"] = "middle",
                        ["font"] = {
                            ["outline"] = "SLUG,OUTLINE"
                        }
                    },
                    {
                        ["shadow"] = {
                            ["color"] = {0, 0, 0, 1},
                            ["offset"] = {0, 0}
                        },
                        ["justifyH"] = "right",
                        ["anchor"] = {
                            ["y"] = 0,
                            ["relativeTo"] = "statusbar",
                            ["point"] = "right",
                            ["relativePoint"] = "right",
                            ["x"] = 0
                        },
                        ["color"] = {
                            ["byClass"] = true
                        },
                        ["justifyV"] = "middle",
                        ["font"] = {
                            ["outline"] = "SLUG,OUTLINE"
                        }
                    },
                    ["__version"] = 1
                },
                ["icon_mask"] = "",
                ["overlay_color"] = {0.7019608020782471, 0.7019608020782471, 0.7019608020782471, 0},
                ["icon_file"] = "Interface\\AddOns\\Details\\images\\classes_small",
                ["textR_bracket"] = "(",
                ["arena_role_icon_size_offset"] = -10,
                ["icon_grayscale"] = false,
                ["texture_background_file"] = "Interface\\Addons\\MerfinPlus\\Media\\statusbar\\MerfinTexture.blp",
                ["use_spec_icons"] = true,
                ["textR_enable_custom_text"] = false,
                ["alpha"] = 1,
                ["fixed_texture_color"] = {0.1803921568627451, 0.1607843137254902, 0.1607843137254902},
                ["textL_show_number"] = false,
                ["show_arena_role_icon"] = false,
                ["models"] = {
                    ["upper_model"] = "Spells\\AcidBreath_SuperGreen.M2",
                    ["lower_model"] = "World\\EXPANSION02\\DOODADS\\Coldarra\\COLDARRALOCUS.m2",
                    ["upper_alpha"] = 0.5,
                    ["lower_enabled"] = false,
                    ["lower_alpha"] = 0.1,
                    ["upper_enabled"] = false
                },
                ["textR_custom_text"] = "{data1} ({data2}, {data3}%)",
                ["texture"] = "Merfin Main Texture",
                ["texture_file"] = "Interface\\Addons\\MerfinPlus\\Media\\statusbar\\MerfinTexture.blp",
                ["fixed_texture_background_color"] = {0.615686297416687, 0.615686297416687, 0.615686297416687,
                                                        0.6299999952316284},
                ["overlay_texture"] = "Merfin Main Texture",
                ["show_faction_icon"] = true,
                ["texture_custom"] = "",
                ["texture_background"] = "Merfin Main Texture",
                ["textR_outline_small_color"] = {0, 0, 0, 1},
                ["no_icon"] = false,
                ["icon_offset"] = {0, 0},
                ["texture_highlight"] = "Interface\\FriendsFrame\\UI-FriendsList-Highlight",
                ["font_face"] = "Merfin Font 1",
                ["texture_class_colors"] = false,
                ["space"] = {
                    ["right"] = 0,
                    ["left"] = 0,
                    ["between"] = 1
                },
                ["fast_ps_update"] = false,
                ["textR_separator"] = "NONE",
                ["texture_custom_file"] = "Interface\\"
            },
            ["StatusBarSaved"] = {
                ["center"] = "DETAILS_STATUSBAR_PLUGIN_CLOCK",
                ["right"] = "DETAILS_STATUSBAR_PLUGIN_PDPS",
                ["options"] = {
                    ["DETAILS_STATUSBAR_PLUGIN_PDPS"] = {
                        ["segmentType"] = 2,
                        ["textFace"] = "Accidental Presidency",
                        ["textAlign"] = 3,
                        ["timeType"] = 1,
                        ["textSize"] = 10,
                        ["textColor"] = {1, 1, 1, 1}
                    },
                    ["DETAILS_STATUSBAR_PLUGIN_PSEGMENT"] = {
                        ["segmentType"] = 2,
                        ["textFace"] = "Accidental Presidency",
                        ["textAlign"] = 1,
                        ["timeType"] = 1,
                        ["textSize"] = 10,
                        ["textColor"] = {1, 1, 1, 1}
                    },
                    ["DETAILS_STATUSBAR_PLUGIN_CLOCK"] = {
                        ["segmentType"] = 2,
                        ["textFace"] = "Accidental Presidency",
                        ["textAlign"] = 2,
                        ["timeType"] = 1,
                        ["textSize"] = 10,
                        ["textColor"] = {1, 1, 1, 1}
                    }
                },
                ["left"] = "DETAILS_STATUSBAR_PLUGIN_PSEGMENT"
            },
            ["instance_button_anchor"] = {-27, 1},
            ["bg_alpha"] = 0.2999999821186066,
            ["switch_tank_in_combat"] = false,
            ["version"] = 3,
            ["show_interrupt_casts"] = false,
            ["__locked"] = true,
            ["menu_alpha"] = {
                ["enabled"] = false,
                ["onleave"] = 1,
                ["ignorebars"] = false,
                ["iconstoo"] = true,
                ["onenter"] = 1
            },
            ["tempId"] = -1,
            ["rowareaborder_color"] = {0, 0, 0, 1},
            ["fullborder_color"] = {0, 0, 0, 1},
            ["rowareaborder_size"] = 0.7999999523162842,
            ["clickthrough_incombatonly"] = true,
            ["__snap"] = {},
            ["micro_displays_side"] = 2,
            ["hide_in_combat_alpha"] = 0,
            ["automation"] = {
                ["overall_mythic_plus"] = true
            },
            ["rounded_corner_enabled"] = false,
            ["libwindow"] = {
                ["y"] = 30.75054168701172,
                ["x"] = -5.25537109375,
                ["point"] = "BOTTOMRIGHT",
                ["scale"] = 1
            },
            ["statusbar_info"] = {
                ["alpha"] = 0,
                ["overlay"] = {1, 1, 0}
            },
            ["sessionType_user"] = 1,
            ["row_show_animation"] = {
                ["anim"] = "Fade",
                ["options"] = {}
            },
            ["sessionType"] = 1,
            ["switch_damager_in_combat"] = false,
            ["bars_sort_direction"] = 1,
            ["grab_on_top"] = false,
            ["micro_displays_locked"] = true,
            ["menu_anchor"] = {
                16,
                0,
                ["side"] = 2
            },
            ["auto_current"] = true,
            ["attribute_text"] = {
                ["enabled"] = true,
                ["shadow"] = true,
                ["side"] = 1,
                ["text_color"] = {1, 1, 1, 1},
                ["custom_text"] = "{name}",
                ["show_timer_arena"] = true,
                ["text_face"] = "Merfin Font 1",
                ["show_timer_always"] = false,
                ["text_size"] = 13,
                ["anchor"] = {-17, 2},
                ["show_timer"] = true,
                ["enable_custom_text"] = false,
                ["show_timer_bg"] = true
            },
            ["sessionId_user"] = 1,
            ["auto_hide_menu"] = {
                ["left"] = true,
                ["right"] = false
            },
            ["hide_in_combat"] = false,
            ["posicao"] = {
                ["normal"] = {
                    ["y"] = -427.6635589599609,
                    ["x"] = 866.155029296875,
                    ["w"] = 177.1793670654297,
                    ["h"] = 163.1716613769531
                },
                ["solo"] = {
                    ["y"] = 2,
                    ["x"] = 1,
                    ["w"] = 300,
                    ["h"] = 200
                }
            },
            ["icon_desaturated"] = false,
            ["switch_all_roles_after_wipe"] = false,
            ["wallpaper"] = {
                ["overlay"] = {1, 1, 1, 1},
                ["alpha"] = 0.5,
                ["width"] = 283.000183105469,
                ["texcoord"] = {0, 1, 0, 0.703125},
                ["anchor"] = "all",
                ["height"] = 114.042518615723,
                ["level"] = 2,
                ["enabled"] = false,
                ["texture"] = "Interface\\TALENTFRAME\\bg-druid-restoration"
            },
            ["stretch_button_side"] = 2,
            ["titlebar_height"] = 8,
            ["segmento_user"] = 0,
            ["menu_icons_color"] = {1, 1, 1},
            ["titlebar_texture_color"] = {0, 0, 0, 0.699999988079071}
        }, {
            ["__pos"] = {
                ["normal"] = {
                    ["y"] = -427.4897918701172,
                    ["x"] = 684.531494140625,
                    ["w"] = 176.9291076660156,
                    ["h"] = 162.6715545654297
                },
                ["solo"] = {
                    ["y"] = 2,
                    ["x"] = 1,
                    ["w"] = 300,
                    ["h"] = 200
                }
            },
            ["hide_in_combat_type"] = 1,
            ["menu_icons_size"] = 0.7899999618530273,
            ["titlebar_shown"] = true,
            ["segmento"] = 0,
            ["bg_r"] = 0,
            ["fullborder_size"] = 0.7999999523162842,
            ["hide_out_of_combat"] = false,
            ["color_buttons"] = {1, 1, 1, 1},
            ["toolbar_icon_file"] = "Interface\\AddOns\\Details\\images\\toolbar_icons_2",
            ["skin_custom"] = "",
            ["use_auto_align_multi_fontstrings"] = true,
            ["sessionId"] = 1,
            ["rowareaborder_shown"] = true,
            ["fullborder_shown"] = true,
            ["clickthrough_toolbaricons"] = false,
            ["clickthrough_rows"] = false,
            ["titlebar_texture"] = "Merfin Main Texture",
            ["switch_tank"] = {2, 1, 9},
            ["fontstrings_text_limit_offset"] = -10,
            ["menu_icons"] = {
                true,
                true,
                true,
                true,
                true,
                false,
                ["space"] = 2,
                ["shadow"] = false
            },
            ["switch_damager"] = {2, 1, 9},
            ["show_sidebars"] = false,
            ["window_scale"] = 1,
            ["attribute_icon_size"] = 0,
            ["hide_icon"] = true,
            ["overallByUser"] = false,
            ["toolbar_side"] = 1,
            ["bg_g"] = 0,
            ["line_no_tooltip"] = false,
            ["__snapV"] = false,
            ["__snapH"] = false,
            ["menu_icons_alpha"] = 0.92,
            ["show_statusbar"] = false,
            ["plugins_grow_direction"] = 1,
            ["bg_b"] = 0,
            ["__was_opened"] = true,
            ["strata"] = "LOW",
            ["desaturated_menu"] = false,
            ["backdrop_texture"] = "Solid",
            ["color"] = {1, 1, 0, 0},
            ["hide_on_context"] = {{
                ["enabled"] = false,
                ["inverse"] = false,
                ["value"] = 100
            }, {
                ["enabled"] = false,
                ["inverse"] = false,
                ["value"] = 100
            }, {
                ["enabled"] = false,
                ["inverse"] = false,
                ["value"] = 100
            }, {
                ["enabled"] = false,
                ["inverse"] = false,
                ["value"] = 100
            }, {
                ["enabled"] = false,
                ["inverse"] = false,
                ["value"] = 100
            }, {
                ["enabled"] = false,
                ["inverse"] = false,
                ["value"] = 100
            }, {
                ["enabled"] = false,
                ["inverse"] = false,
                ["value"] = 100
            }, {
                ["enabled"] = false,
                ["inverse"] = false,
                ["value"] = 100
            }, {
                ["enabled"] = false,
                ["inverse"] = false,
                ["value"] = 100
            }, {
                ["enabled"] = false,
                ["inverse"] = false,
                ["value"] = 100
            }, {
                ["enabled"] = false,
                ["inverse"] = false,
                ["value"] = 100
            }, {
                ["enabled"] = false,
                ["inverse"] = false,
                ["value"] = 100
            }, {
                ["enabled"] = false,
                ["inverse"] = false,
                ["value"] = 100
            }, {
                ["enabled"] = false,
                ["inverse"] = false,
                ["value"] = 100
            }, {
                ["enabled"] = false,
                ["inverse"] = false,
                ["value"] = 100
            }},
            ["use_multi_fontstrings"] = false,
            ["clickthrough_window"] = false,
            ["total_bar"] = {
                ["enabled"] = false,
                ["only_in_group"] = true,
                ["icon"] = "Interface\\ICONS\\INV_Sigil_Thorim",
                ["color"] = {1, 1, 1}
            },
            ["tooltip"] = {
                ["n_abilities"] = 3,
                ["n_enemies"] = 3
            },
            ["following"] = {
                ["bar_color"] = {1, 1, 1},
                ["enabled"] = true,
                ["text_color"] = {1, 1, 1}
            },
            ["skin"] = "Minimalistic",
            ["switch_healer_in_combat"] = {"raid", "DETAILS_PLUGIN_TINY_THREAT", 32},
            ["source_type"] = 0,
            ["menu_anchor_down"] = {16, -3},
            ["switch_healer"] = {2, 1, 9},
            ["SegmentType"] = 1,
            ["bars_inverted"] = false,
            ["bars_grow_direction"] = 1,
            ["switch_all_roles_in_combat"] = false,
            ["ignore_mass_showhide"] = false,
            ["row_info"] = {
                ["show_arena_role_icon"] = false,
                ["spec_file"] = "Interface\\AddOns\\Details\\images\\spec_icons_normal",
                ["textL_outline"] = true,
                ["playername_size_auto"] = true,
                ["row_offsets"] = {
                    ["top"] = 0,
                    ["right"] = 0,
                    ["left"] = 0,
                    ["bottom"] = 0
                },
                ["texture_highlight"] = "Interface\\FriendsFrame\\UI-FriendsList-Highlight",
                ["textR_show_data"] = {true, true, false},
                ["textL_enable_custom_text"] = true,
                ["fixed_text_color"] = {1, 1, 1},
                ["textL_offset"] = -1,
                ["text_yoffset"] = 0,
                ["texture_background_class_color"] = false,
                ["textL_outline_small_color"] = {0, 0, 0, 1},
                ["font_face_file"] = "Interface\\AddOns\\MerfinPlus\\Media\\font\\SFUIDisplayCondensed-Semibold.otf",
                ["height"] = 17,
                ["backdrop"] = {
                    ["enabled"] = false,
                    ["color"] = {0, 0, 0, 1},
                    ["size"] = 0.5999999642372131,
                    ["use_class_colors"] = false,
                    ["texture"] = "Details BarBorder 2"
                },
                ["faction_icon_size_offset"] = -10,
                ["playername_alignment_auto"] = true,
                ["textL_custom_text"] = "{data1}. {data3}{data2}",
                ["start_after_icon"] = true,
                ["models"] = {
                    ["upper_model"] = "Spells\\AcidBreath_SuperGreen.M2",
                    ["lower_model"] = "World\\EXPANSION02\\DOODADS\\Coldarra\\COLDARRALOCUS.m2",
                    ["upper_alpha"] = 0.5,
                    ["lower_enabled"] = false,
                    ["lower_alpha"] = 0.1,
                    ["upper_enabled"] = false
                },
                ["percent_type"] = 1,
                ["textL_outline_small"] = false,
                ["textL_translit_text"] = false,
                ["playername_size"] = 80,
                ["show_percent"] = false,
                ["icon_size_offset"] = 0,
                ["texts"] = {
                    {
                        ["shadow"] = {
                            ["color"] = {0, 0, 0, 1},
                            ["offset"] = {0, 0}
                        },
                        ["justifyH"] = "left",
                        ["anchor"] = {
                            ["y"] = 0,
                            ["relativeTo"] = "icon",
                            ["point"] = "left",
                            ["relativePoint"] = "right",
                            ["x"] = 3
                        },
                        ["color"] = {
                            ["byClass"] = true
                        },
                        ["justifyV"] = "middle",
                        ["font"] = {
                            ["outline"] = "SLUG,OUTLINE"
                        }
                    },
                    {
                        ["shadow"] = {
                            ["color"] = {0, 0, 0, 1},
                            ["offset"] = {0, 0}
                        },
                        ["justifyH"] = "right",
                        ["anchor"] = {
                            ["y"] = 0,
                            ["relativeTo"] = "statusbar",
                            ["point"] = "right",
                            ["relativePoint"] = "right",
                            ["gap"] = -4,
                            ["x"] = -70
                        },
                        ["color"] = {
                            ["byClass"] = true
                        },
                        ["justifyV"] = "middle",
                        ["font"] = {
                            ["outline"] = "SLUG,OUTLINE"
                        }
                    },
                    {
                        ["shadow"] = {
                            ["color"] = {0, 0, 0, 1},
                            ["offset"] = {0, 0}
                        },
                        ["justifyH"] = "right",
                        ["anchor"] = {
                            ["y"] = 0,
                            ["relativeTo"] = "statusbar",
                            ["point"] = "right",
                            ["relativePoint"] = "right",
                            ["gap"] = -4,
                            ["x"] = -35
                        },
                        ["color"] = {
                            ["byClass"] = true
                        },
                        ["justifyV"] = "middle",
                        ["font"] = {
                            ["outline"] = "SLUG,OUTLINE"
                        }
                    },
                    {
                        ["shadow"] = {
                            ["color"] = {0, 0, 0, 1},
                            ["offset"] = {0, 0}
                        },
                        ["justifyH"] = "right",
                        ["anchor"] = {
                            ["y"] = 0,
                            ["relativeTo"] = "statusbar",
                            ["point"] = "right",
                            ["relativePoint"] = "right",
                            ["x"] = 0
                        },
                        ["color"] = {
                            ["byClass"] = true
                        },
                        ["justifyV"] = "middle",
                        ["font"] = {
                            ["outline"] = "SLUG,OUTLINE"
                        }
                    },
                    ["__version"] = 1
                },
                ["icon_mask"] = "",
                ["overlay_color"] = {0.7019608020782471, 0.7019608020782471, 0.7019608020782471, 0},
                ["icon_file"] = "Interface\\AddOns\\Details\\images\\classes_small",
                ["textR_bracket"] = "(",
                ["arena_role_icon_size_offset"] = -10,
                ["icon_grayscale"] = false,
                ["texture_background_file"] = "Interface\\Addons\\MerfinPlus\\Media\\statusbar\\MerfinTexture.blp",
                ["use_spec_icons"] = true,
                ["textR_enable_custom_text"] = false,
                ["textR_outline_small_color"] = {0, 0, 0, 1},
                ["fixed_texture_color"] = {0.1803921568627451, 0.1607843137254902, 0.1607843137254902},
                ["textL_show_number"] = false,
                ["textR_outline"] = true,
                ["font_size"] = 11,
                ["textR_custom_text"] = "{data1} ({data2}, {data3}%)",
                ["texture"] = "Merfin Main Texture",
                ["texture_file"] = "Interface\\Addons\\MerfinPlus\\Media\\statusbar\\MerfinTexture.blp",
                ["fixed_texture_background_color"] = {0.615686297416687, 0.615686297416687, 0.615686297416687,
                                                        0.6299999952316284},
                ["overlay_texture"] = "Merfin Main Texture",
                ["show_faction_icon"] = true,
                ["texture_custom"] = "",
                ["texture_background"] = "Merfin Main Texture",
                ["alpha"] = 1,
                ["no_icon"] = false,
                ["icon_offset"] = {0, 0},
                ["textR_outline_small"] = false,
                ["font_face"] = "Merfin Font 1",
                ["texture_class_colors"] = false,
                ["space"] = {
                    ["right"] = 0,
                    ["left"] = 0,
                    ["between"] = 1
                },
                ["fast_ps_update"] = false,
                ["textR_separator"] = "NONE",
                ["texture_custom_file"] = "Interface\\"
            },
            ["StatusBarSaved"] = {
                ["center"] = "DETAILS_STATUSBAR_PLUGIN_CLOCK",
                ["right"] = "DETAILS_STATUSBAR_PLUGIN_PDPS",
                ["options"] = {
                    ["DETAILS_STATUSBAR_PLUGIN_PDPS"] = {
                        ["segmentType"] = 2,
                        ["textFace"] = "Accidental Presidency",
                        ["textAlign"] = 3,
                        ["timeType"] = 1,
                        ["textSize"] = 10,
                        ["textColor"] = {1, 1, 1, 1}
                    },
                    ["DETAILS_STATUSBAR_PLUGIN_PSEGMENT"] = {
                        ["segmentType"] = 2,
                        ["textFace"] = "Accidental Presidency",
                        ["textAlign"] = 1,
                        ["timeType"] = 1,
                        ["textSize"] = 10,
                        ["textColor"] = {1, 1, 1, 1}
                    },
                    ["DETAILS_STATUSBAR_PLUGIN_CLOCK"] = {
                        ["segmentType"] = 2,
                        ["textFace"] = "Accidental Presidency",
                        ["textAlign"] = 2,
                        ["timeType"] = 1,
                        ["textSize"] = 10,
                        ["textColor"] = {1, 1, 1, 1}
                    }
                },
                ["left"] = "DETAILS_STATUSBAR_PLUGIN_PSEGMENT"
            },
            ["instance_button_anchor"] = {-27, 1},
            ["bg_alpha"] = 0.2999999821186066,
            ["switch_tank_in_combat"] = {"raid", "DETAILS_PLUGIN_TINY_THREAT", 32},
            ["version"] = 3,
            ["show_interrupt_casts"] = false,
            ["__locked"] = true,
            ["menu_alpha"] = {
                ["enabled"] = false,
                ["onenter"] = 1,
                ["iconstoo"] = true,
                ["ignorebars"] = false,
                ["onleave"] = 1
            },
            ["tempId"] = -1,
            ["rowareaborder_color"] = {0, 0, 0, 1},
            ["fullborder_color"] = {0, 0, 0, 1},
            ["rowareaborder_size"] = 0.7999999523162842,
            ["clickthrough_incombatonly"] = true,
            ["__snap"] = {},
            ["micro_displays_side"] = 2,
            ["hide_in_combat_alpha"] = 0,
            ["automation"] = {
                ["overall_mythic_plus"] = true
            },
            ["rounded_corner_enabled"] = false,
            ["libwindow"] = {
                ["y"] = 31.17437171936035,
                ["x"] = -187.0040283203125,
                ["point"] = "BOTTOMRIGHT",
                ["scale"] = 1
            },
            ["statusbar_info"] = {
                ["alpha"] = 0,
                ["overlay"] = {1, 1, 0}
            },
            ["sessionType_user"] = 1,
            ["row_show_animation"] = {
                ["anim"] = "Fade",
                ["options"] = {}
            },
            ["sessionType"] = 1,
            ["switch_damager_in_combat"] = {"raid", "DETAILS_PLUGIN_TINY_THREAT", 32},
            ["bars_sort_direction"] = 1,
            ["grab_on_top"] = false,
            ["micro_displays_locked"] = true,
            ["menu_anchor"] = {
                16,
                0,
                ["side"] = 2
            },
            ["auto_current"] = true,
            ["attribute_text"] = {
                ["enabled"] = true,
                ["shadow"] = true,
                ["side"] = 1,
                ["text_color"] = {1, 1, 1, 1},
                ["custom_text"] = "{name}",
                ["show_timer_arena"] = true,
                ["text_face"] = "Merfin Font 1",
                ["show_timer_always"] = false,
                ["text_size"] = 13,
                ["anchor"] = {-17, 2},
                ["enable_custom_text"] = false,
                ["show_timer"] = true,
                ["show_timer_bg"] = true
            },
            ["sessionId_user"] = 1,
            ["auto_hide_menu"] = {
                ["left"] = true,
                ["right"] = false
            },
            ["hide_in_combat"] = false,
            ["posicao"] = {
                ["normal"] = {
                    ["y"] = -427.4897918701172,
                    ["x"] = 684.531494140625,
                    ["w"] = 176.9291076660156,
                    ["h"] = 162.6715545654297
                },
                ["solo"] = {
                    ["y"] = 2,
                    ["x"] = 1,
                    ["w"] = 300,
                    ["h"] = 200
                }
            },
            ["icon_desaturated"] = false,
            ["switch_all_roles_after_wipe"] = false,
            ["wallpaper"] = {
                ["enabled"] = false,
                ["alpha"] = 0.5,
                ["width"] = 283.000183105469,
                ["texcoord"] = {0, 1, 0, 0.703125},
                ["height"] = 114.042518615723,
                ["anchor"] = "all",
                ["level"] = 2,
                ["overlay"] = {1, 1, 1, 1},
                ["texture"] = "Interface\\TALENTFRAME\\bg-druid-restoration"
            },
            ["stretch_button_side"] = 1,
            ["titlebar_height"] = 8,
            ["segmento_user"] = 0,
            ["menu_icons_color"] = {1, 1, 1},
            ["titlebar_texture_color"] = {0, 0, 0, 0.699999988079071}
        }},
        ["overall_clear_pvp"] = true,
        ["deny_score_messages"] = false,
        ["minimum_combat_time"] = 5,
        ["skin"] = "Minimalistic",
        ["override_spellids"] = true,
        ["new_window_size"] = {
            ["height"] = 158,
            ["width"] = 310
        },
        ["realtimedps_always_arena"] = false,
        ["window_clamp"] = {-8, 0, 21, -14},
        ["chat_tab_embed"] = {
            ["enabled"] = false,
            ["y_offset"] = 0,
            ["x_offset"] = 0,
            ["tab_name"] = "",
            ["single_window"] = false
        },
        ["overall_clear_logout"] = false,
        ["broadcaster_enabled"] = false,
        ["cloud_capture"] = true,
        ["damage_taken_everything"] = false,
        ["scroll_speed"] = 2,
        ["font_sizes"] = {
            ["menus"] = 13
        },
        ["memory_threshold"] = 3,
        ["deadlog_events"] = 32,
        ["total_abbreviation"] = 2,
        ["close_shields"] = false,
        ["class_coords"] = {
            ["HUNTER"] = {0, 0.125, 0.125, 0.25},
            ["WARRIOR"] = {0, 0.125, 0, 0.125},
            ["PALADIN"] = {0, 0.125, 0.25, 0.375},
            ["MAGE"] = {0.125, 0.248046875, 0, 0.125},
            ["PET"] = {0.125, 0.248046875, 0.375, 0.5},
            ["DRUID"] = {0.37109375, 0.494140625, 0, 0.125},
            ["MONK"] = {0.25, 0.369140625, 0.25, 0.375},
            ["DEATHKNIGHT"] = {0.125, 0.25, 0.25, 0.375},
            ["ENEMY"] = {0, 0.125, 0.375, 0.5},
            ["ROGUE"] = {0.248046875, 0.37109375, 0, 0.125},
            ["UNKNOW"] = {0.25, 0.375, 0.375, 0.5},
            ["PRIEST"] = {0.248046875, 0.37109375, 0.125, 0.25},
            ["SHAMAN"] = {0.125, 0.248046875, 0.125, 0.25},
            ["Alliance"] = {0.248046875, 0.02968748, 0.375, 0.5},
            ["WARLOCK"] = {0.37109375, 0.494140625, 0.125, 0.25},
            ["DEMONHUNTER"] = {0.36914063, 0.5, 0.25, 0.375},
            ["Horde"] = {0.37109375, 0.494140625, 0.375, 0.5},
            ["UNGROUPPLAYER"] = {0.25, 0.375, 0.375, 0.5},
            ["EVOKER"] = {0.50390625, 0.625, 0, 0.125},
            ["MONSTER"] = {0, 0.125, 0.375, 0.5}
        },
        ["segments_auto_erase"] = 1,
        ["disable_alldisplays_window"] = false,
        ["trash_auto_remove"] = true,
        ["segments_boss_wipes_keep_best_performance"] = true,
        ["class_colors"] = {
            ["HUNTER"] = {0.67, 0.83, 0.45},
            ["WARRIOR"] = {0.78, 0.61, 0.43},
            ["PALADIN"] = {0.96, 0.55, 0.73},
            ["MAGE"] = {0.41, 0.8, 0.94},
            ["ARENA_YELLOW"] = {1, 1, 0.25},
            ["UNGROUPPLAYER"] = {0.4, 0.4, 0.4},
            ["DRUID"] = {1, 0.49, 0.04},
            ["MONK"] = {0, 1, 0.59},
            ["DEATHKNIGHT"] = {0.77, 0.12, 0.23},
            ["SELF"] = {0.89019, 0.32156, 0.89019},
            ["PET"] = {0.3, 0.4, 0.5},
            ["ROGUE"] = {1, 0.96, 0.41},
            ["UNKNOW"] = {0.2, 0.2, 0.2},
            ["PRIEST"] = {1, 1, 1},
            ["ENEMY"] = {0.94117, 0, 0.0196, 1},
            ["WARLOCK"] = {0.58, 0.51, 0.79},
            ["version"] = 1,
            ["DEMONHUNTER"] = {0.64, 0.19, 0.79},
            ["SHAMAN"] = {0, 0.44, 0.87},
            ["NEUTRAL"] = {1, 1, 0},
            ["EVOKER"] = {0.2, 0.498, 0.5764},
            ["ARENA_GREEN"] = {0.6862745098039216, 0.3843137254901961, 1}
        },
        ["death_log_colors"] = {
            ["debuff"] = "purple",
            ["buff"] = "silver",
            ["friendlyfire"] = "darkorange",
            ["heal"] = "green",
            ["cooldown"] = "yellow",
            ["damage"] = "red"
        },
        ["clear_graphic"] = true,
        ["hotcorner_topleft"] = {
            ["hide"] = false
        },
        ["animation_speed_triggertravel"] = 5,
        ["options_group_edit"] = true,
        ["segments_amount_to_save"] = 40,
        ["minimap"] = {
            ["onclick_what_todo"] = 1,
            ["radius"] = 160,
            ["hide"] = false,
            ["minimapPos"] = 261.9297625328454,
            ["text_format"] = 3,
            ["text_type"] = 1
        },
        ["instances_amount"] = 5,
        ["max_window_size"] = {
            ["height"] = 450,
            ["width"] = 480
        },
        ["righttext_simple_formatting"] = {
            ["enabled"] = true,
            ["format_tp"] = "%s",
            ["format_ts"] = "%s (%s)",
            ["use_alignment"] = false,
            ["alignment_space"] = 60,
            ["first_run"] = true,
            ["format_tsp"] = "%s (%s)"
        },
        ["only_pvp_frags"] = false,
        ["disable_stretch_button"] = true,
        ["segments_amount"] = 40,
        ["capture_real"] = {
            ["heal"] = true,
            ["spellcast"] = true,
            ["miscdata"] = true,
            ["aura"] = true,
            ["energy"] = true,
            ["damage"] = true
        },
        ["windows_fade_out"] = {"out", 0.2},
        ["segments_panic_mode"] = false,
        ["realtimedps_order_bars"] = false,
        ["damage_meter_position"] = {},
        ["row_fade_out"] = {"out", 0.2},
        ["show_arena_role_icon"] = false,
        ["player_details_window"] = {
            ["scale"] = 1,
            ["skin"] = "ElvUI",
            ["bar_texture"] = "Skyline"
        },
        ["numerical_system"] = 1,
        ["report_schema"] = 1,
        ["realtime_dps_meter"] = {
            ["enabled"] = false,
            ["font_color"] = {1, 1, 1, 1},
            ["arena_enabled"] = true,
            ["font_shadow"] = "NONE",
            ["font_size"] = 18,
            ["mythic_dungeon_enabled"] = false,
            ["sample_size"] = 3,
            ["frame_settings"] = {
                ["show_title"] = true,
                ["strata"] = "LOW",
                ["point"] = "TOP",
                ["scale"] = 1,
                ["width"] = 300,
                ["y"] = -110,
                ["x"] = 0,
                ["backdrop_color"] = {0, 0, 0, 0.2},
                ["locked"] = true,
                ["height"] = 23
            },
            ["update_interval"] = 0.3,
            ["text_offset"] = 2,
            ["font_face"] = "Friz Quadrata TT",
            ["options_frame"] = {}
        },
        ["death_tooltip_texture"] = "Details Serenity",
        ["disable_reset_button"] = false,
        ["data_broker_text"] = "",
        ["class_specs_coords"] = {
            [62] = {0.251953125, 0.375, 0.125, 0.25},
            [1467] = {0.5, 0.625, 0.5, 0.625},
            [63] = {0.375, 0.5, 0.125, 0.25},
            [250] = {0, 0.125, 0, 0.125},
            [251] = {0.125, 0.25, 0, 0.125},
            [252] = {0.25, 0.375, 0, 0.125},
            [1468] = {0.625, 0.75, 0.5, 0.625},
            [253] = {0.875, 1, 0, 0.125},
            [254] = {0, 0.125, 0.125, 0.25},
            [255] = {0.125, 0.25, 0.125, 0.25},
            [66] = {0.125, 0.25, 0.25, 0.375},
            [257] = {0.5, 0.625, 0.25, 0.375},
            [258] = {0.6328125, 0.75, 0.25, 0.375},
            [259] = {0.75, 0.875, 0.25, 0.375},
            [260] = {0.875, 1, 0.25, 0.375},
            [577] = {0.25, 0.375, 0.5, 0.625},
            [262] = {0.125, 0.25, 0.375, 0.5},
            [581] = {0.375, 0.5, 0.5, 0.625},
            [264] = {0.375, 0.5, 0.375, 0.5},
            [265] = {0.5, 0.625, 0.375, 0.5},
            [266] = {0.625, 0.75, 0.375, 0.5},
            [267] = {0.75, 0.875, 0.375, 0.5},
            [268] = {0.625, 0.75, 0.125, 0.25},
            [269] = {0.875, 1, 0.125, 0.25},
            [270] = {0.75, 0.875, 0.125, 0.25},
            [70] = {0.251953125, 0.375, 0.25, 0.375},
            [102] = {0.375, 0.5, 0, 0.125},
            [71] = {0.875, 1, 0.375, 0.5},
            [103] = {0.5, 0.625, 0, 0.125},
            [72] = {0, 0.125, 0.5, 0.625},
            [1480] = {0.875, 1, 0.5, 0.625},
            [104] = {0.625, 0.75, 0, 0.125},
            [64] = {0.5, 0.625, 0.125, 0.25},
            [73] = {0.125, 0.25, 0.5, 0.625},
            [65] = {0, 0.125, 0.25, 0.375},
            [105] = {0.75, 0.875, 0, 0.125},
            [256] = {0.375, 0.5, 0.25, 0.375},
            [261] = {0, 0.125, 0.375, 0.5},
            [263] = {0.25, 0.375, 0.375, 0.5},
            [1473] = {0.75, 0.875, 0.5, 0.625}
        },
        ["clear_ungrouped"] = true,
        ["deadlog_limit"] = 16,
        ["window2_data"] = {}
    }

  end

  if theme == 'NORMAL' then
    local color, backdrop = Private.GetDarkThemeColors()
    local windows = _detalhes_global['__profiles'][Private.MerfinProfileName]['instances']
    for i = 1, #windows do
      windows[i]['row_info']['fixed_texture_color'] = { color.r, color.g, color.b }
      windows[i]['row_info']['fixed_texture_background_color'] = { backdrop.r, backdrop.g, backdrop.b }
      windows[i]['row_info']['textL_class_colors'] = false
      windows[i]['row_info']['textR_class_colors'] = false
      windows[i]['row_info']['texture_class_colors'] = true
      windows[i]['row_info']['fixed_texture_background_color'] = {
        1.0,
        0.1803921569,
        0.1607843137,
        0.1607843137,
      }
    end
  else
    local color, backdrop = Private.GetDarkThemeColors()
    local windows = _detalhes_global['__profiles'][Private.MerfinProfileName]['instances']
    for i = 1, #windows do
      windows[i]['row_info']['fixed_texture_color'] = { color.r, color.g, color.b }
      windows[i]['row_info']['fixed_texture_background_color'] = { backdrop.r, backdrop.g, backdrop.b }
      windows[i]['row_info']['textL_class_colors'] = true
      windows[i]['row_info']['textR_class_colors'] = true
      windows[i]['row_info']['texture_class_colors'] = false
      windows[i]['row_info']['fixed_texture_background_color'] = {
        0.615686297416687,
        0.615686297416687,
        0.615686297416687,
        0.6299999952316284,
      }
    end
  end

  if _detalhes:GetCurrentProfileName() ~= Private.MerfinProfileName then
    _detalhes:ApplyProfile(Private.MerfinProfileName)
  end

  _detalhes.always_use_profile = true
  _detalhes.always_use_profile_name = Private.MerfinProfileName

  _detalhes_database = _detalhes_database or {}
  _detalhes_database.plugin_database = _detalhes_database.plugin_database or {}
  _detalhes_database.plugin_database.DETAILS_PLUGIN_TINY_THREAT = {
    ["enabled"] = true,
    ["only_my_group"] = false,
    ["animate"] = false,
    ["updatespeed"] = 1,
    ["hide_pull_bar"] = false,
    ["useclasscolors"] = true,
    ["usefocus"] = false,
    ["disable_gouge"] = false,
    ["playSound"] = false,
    ["showamount"] = false,
    ["absolute_mode"] = false,
    ["show_party_pets"] = false,
    ["playSoundFile"] = "Details Threat Warning Volume 3",
    ["author"] = "Terciob",
    ["useplayercolor"] = false,
    ["playercolor"] = {
        0.7490196228027344,
        0.7490196228027344,
        0,
        0.699999988079071,
    }
  }


  Private:PluginInstallStepComplete('Details')
end
