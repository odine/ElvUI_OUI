local E, L, DF = unpack(ElvUI); --Engine
local OUI = E:GetModule('OUI')

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

E.Options.args.datatexts.args.dtFontSize = {
	order = 200,
	name = L["Font Size"],
	desc = L["Set the font size for Datatexts."],
	type = "range",
	min = 6, max = 22, step = 1,
	set = function(info, value) E.db.odine.dtFS = value; OUI:UpdateDTFont(); end,
	get = function(info) return E.db.odine.dtFS end,
}

E.Options.args.datatexts.args.dtFont = {
	type = "select", dialogControl = 'LSM30_Font',
	order = 201,
	name = L["Datatext Font"],
	desc = L["The font that the datatexts will use."],
	values = AceGUIWidgetLSMlists.font,	
	set = function(info, value) E.db.odine.dtFont = value; OUI:UpdateDTFont(); end,
	get = function(info) return E.db.odine.dtFont end,
}

E.Options.args.actionbar.args.microbar = {
	type = "group",
	order = 600,
	name = L["Micro Bar"],
	childGroups = "select",
	get = function(info) return E.db.actionbar.microbar[ info[#info] ] end,
	set = function(info, value) E.db.actionbar.microbar[ info[#info] ] = value; E:GetModule('ActionBars'):UpdateMicroBar(); end,
	args = {
		enable = {
			order = 1,
			type = 'toggle',
			name = L['Enable'],
		},
		mouseover = {
			type = "toggle",
			order = 11,
			name = L['Mouse Over'],
			desc = L['The frame is not shown unless you mouse over the frame.'],
			disabled = function() return not E.db.actionbar.enable or not E.db.actionbar.microbar.enable end,
		},
	},
}

E.Options.args.odine = {
	type = "group",
	name = L["Extra Options"],
	childGroups = "select",
	get = function(info) return E.db.odine[ info[#info] ] end,
	set = function(info, value) E.db.odine[ info[#info] ] = value end,
	args = {
		intro = {
			order = 1,
			type = "description",
			name = L["EXTRA_DESC"],
		},
		rcd = {
			order = 2,
			type = "group",
			name = L["Raid Cooldowns"],
			get = function(info) return E.db.odine.rcd[ info[#info] ] end,
			set = function(info, value) E.db.odine.rcd[ info[#info] ] = value end,
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
}