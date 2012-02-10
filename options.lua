local E, L, DF = unpack(ElvUI); --Engine
local OUI = E:GetModule('OUI')

local selectedFilter, selectedSpell, compareTable = nil, nil, {};

local function UpdateFilterGroup()

end

E.Options.args.chat.args.sounds = {
	order = 200,
	type = "group",
	name = L["Sounds"],
	desc = L["Sounds"],
	get = function(info) return E.db.odine.chat[ info[#info] ] end,
	set = function(info, value) E.db.odine.chat[ info[#info] ] = value end,
	guiInline = true,
	args = {
		whisperwarning = {
			order = 1,
			type = 'toggle',
			name = L['Whisper Warning'],
			desc = L['Plays a sound when you receive a whisper.'],
			set = function(info, value) E.db.odine.chat.whisperwarning = value; end,
		},
		whispersound = {
			order = 2,
			type = 'select', dialogControl = 'LSM30_Sound',
			name = L['Warning Sound'],
			desc = L['Choose what sound to play.'],
			disabled = function() return not E.db.odine.chat.whisperwarning end,
			values = AceGUIWidgetLSMlists.sound,
			set = function(info, value) E.db.odine.chat.whispersound = value; OUI:SetupExtraMedia(); end,
		},
	}
}

E.Options.args.odine = {
	type = "group",
	name = L["OUI"],
	childGroups = "select",
	get = function(info) return E.db.odine[ info[#info] ] end,
	set = function(info, value) E.db.odine[ info[#info] ] = value end,
	args = {
		intro = {
			order = 1,
			type = "description",
			name = L["OUI_DESC"],
		},
		general = {
			order = 2,
			type = "group",
			name = L["General"],
			args = {
				misc = {
					name = L['General'],
					type = 'group',
					guiInline = true,
					get = function(info) return E.db.odine[ info[#info] ] end,
					set = function(info, value) E.db.odine[ info[#info] ] = value end,
					order = 1,
					args = {
						pvpautorelease = {
							type = "toggle",
							order = 1,
							name = L["PVP Autorelease"],
							desc = L["Automatically release body when dead inside a bg"],
							disabled = function() return E.myclass == "SHAMAN" end,
						},
						autogreed = {
							type = "toggle",
							order = 3,
							name = L["Auto Greed/DE"],
							desc = L["Automatically roll greed or Disenchant on green quality items"],								
						},
					},
				},
				rcd = {
					order = 3,
					type = "group",
					name = L["Raid Cooldowns"],
					get = function(info) return E.db.odine.rcd[ info[#info] ] end,
					set = function(info, value) E.db.odine.rcd[ info[#info] ] = value end,
					guiInline = true,
					args = {
						enable = {
							order = 1,
							type = 'toggle',
							name = ENABLE,
							desc = L['Enable display of raid cooldowns while in a raid group.'],
							set = function(info, value) E.db.odine.rcd[ info[#info] ] = value; StaticPopup_Show("CONFIG_RL") end
						},
						classcolor = {
							order = 2,
							type = 'toggle',
							name = L["Class Colors"],
							desc = L['Color bars based on class.'],
						},
					},
				},
			},
		},
		filters = {
			order = 4,
			type = 'group',
			name = L['Filters'],
			--disabled = function() return not E.Reminder; end,
			--guiInline = true,
			args = {
				filterType = {
					name = "Select Group",
					type = "select",
					order = 1,
					values = function()
						local groupTable = {};
						for group, table in pairs(E.db['odine'].reminder[E.myclass]) do
							groupTable[group] = tostring(group)
						end
						return groupTable;
					end,					
					get = function(info) return selectedFilter end,
					set = function(info, value) selectedFilter = value; selectedSpell = nil; wipe(compareTable); UpdateFilterGroup() end,
				},
			},
		},
	},
}