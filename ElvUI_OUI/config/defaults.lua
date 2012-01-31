local E, L, DF = unpack(ElvUI); --Engine

DF["odine"] = {
	["dtFont"] = "Odine Datatext",
	["dtFS"] = 15,
	["chat"] = {
		['bubbles'] = true,
		['whisperwarning'] = true,
		["whispersound"] = "Whisper Sound",
	},
	['rcd'] = {
		['enable'] = true,
		['classcolor'] = true,
		['raid'] = true,
		['party'] = true,
		['arena'] = true,
	},
}

DF["actionbar"].microbar = {
	["enable"] = true,
	["mouseover"] = false,
}

--DF.actionbar.microbar = {}
--DF.actionbar.microbar.enable = true
--DF.actionbar.microbar.mouseover = false

--E.db.datatexts.panels.spec1.TopDataPanel = {}
--E.db.datatexts.panels.spec1.TopDataPanel.middle = 'Spec Switch';

--DF.unitframe.OORAlpha = 0.55
--DF.unitframe.colors.health = { r = .1, g = .1, b = .1 }
--DF.unitframe.colors.health_backdrop = { r = 0.68, g = 0.25, b = 0.25 }