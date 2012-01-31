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

DF.datatexts.panels.spec1.TopDataPanel = {
	left = 'Guild',
	middle = 'Spec Switch',
	right = 'Friends',
}

DF.datatexts.panels.spec2.TopDataPanel = {
	left = 'Guild',
	middle = 'Spec Switch',
	right = 'Friends',
}
