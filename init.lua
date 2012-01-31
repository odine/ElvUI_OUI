local E, L, DF = unpack(ElvUI); --Engine
local OUI = E:NewModule('OUI', 'AceEvent-3.0');
local LSM = LibStub("LibSharedMedia-3.0")

StaticPopupDialogs["OUI_RL"] = {
	text = L["Clicking ACCEPT will modify existing ElvUI settings! Are you sure you want to do this?"],
	button1 = ACCEPT,
	button2 = CANCEL,
	OnAccept = function() OUI:CustomizeUI() end,
	timeout = 0,
	whileDead = 1,
}


function OUI:SetupExtraMedia()
	-- Fonts
	E["media"].normFont = LSM:Fetch("font", E.db["odine"].dtFont)

	-- Sounds
	E["media"].whisper = LSM:Fetch("sound", E.db["odine"].chat.whispersound)
end


function OUI:MonitorWhispers(event)
	if event == "CHAT_MSG_WHISPER" or "CHAT_MSG_BN_WHISPER" then
		if E.db.odine.chat.whisperwarning == true then
			PlaySoundFile(E["media"].whisper, "Master")
		end
	end
end


function OUI:Initialize()
	E:GetModule('Blizzard'):HandleBubbles()
	E:GetModule('Blizzard'):RegisterEvent('START_TIMER')

	self:SetupExtraMedia()
	E:GetModule('DataTexts'):UpdateDTFont()
	
	self:RegisterEvent('CHAT_MSG_BN_WHISPER', 'MonitorWhispers')
	self:RegisterEvent('CHAT_MSG_WHISPER', 'MonitorWhispers')
end

function OUI:CustomizeUI()
	-- There simply has to be a better way
	-- Forcing these changes everytime is not ideal in any way
	-- TODO
	-- Find a way to modify DEFAULTS so if user changes them it doesnt force back on next ReloadUI()


	-- core
	E.db.core.bordercolor = { r = .23,g = .23,b = .23 }
	E.db.core.backdropcolor = { r = .07,g = .07,b = .07 }
	
	--NP
	E.db.nameplate.showhealth = true
	E.db.nameplate.trackauras = true
	
	--DT
	E.db.datatexts.panels.spec1.LeftMiniPanel = 'System'
	E.db.datatexts.panels.spec2.LeftMiniPanel = 'System'
	E.db.datatexts.panels.spec1.RightMiniPanel = 'Time'
	E.db.datatexts.panels.spec2.RightMiniPanel = 'Time'
	E.db.datatexts.panels.spec1.RightChatDataPanel.left = 'Currency'
	E.db.datatexts.panels.spec2.RightChatDataPanel.left = 'Currency'
	E.db.datatexts.panels.spec1.RightChatDataPanel.middle = 'Gold'
	E.db.datatexts.panels.spec2.RightChatDataPanel.middle = 'Gold'
	E.db.datatexts.panels.spec1.RightChatDataPanel.right = 'Bags'
	E.db.datatexts.panels.spec2.RightChatDataPanel.right = 'Bags'

	--UF
	E.db.unitframe.colors.health = { r = .1, g = .1, b = .1 }
	E.db.unitframe.colors.health_backdrop = { r = 0.68, g = 0.25, b = 0.25 }
	

	ReloadUI()
end


--[[local myskin = CreateFrame("frame")
myskin:RegisterEvent("PLAYER_ENTERING_WORLD")
myskin:RegisterEvent("ADDON_LOADED")
myskin:RegisterEvent("VARIABLES_LOADED")
myskin:SetScript("OnEvent",function(self, event, addon)
    if event == "PLAYER_ENTERING_WORLD" then
			print("ENTERING WORLD")
	end
	if event == "ADDON_LOADED" then
		if addon == "ElvUI_OUI" then
			E:ImportDefaults()
			print("ELVUI_OUI ADDON LOADED")
		end
		if addon == "ElvUI" then
			print("ELVUI ADDON LOADED")
		end
	end
	if event == "VARIABLES_LOADED" then
			print("VAR LOADED")
	end
end)]]

E:RegisterModule(OUI:GetName())