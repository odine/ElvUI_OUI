local E, L, DF = unpack(ElvUI); --Engine
local OUI = E:NewModule('OUI', 'AceEvent-3.0');
local LSM = LibStub("LibSharedMedia-3.0")

--variables
E.OUI = GetAddOnMetadata("ElvUI_OUI", "Version"); 

StaticPopupDialogs["OUI_INSTALL"] = {
	text = L["Welcome to OUI.\n\nIn order to ensure proper installation of this module some of your settings may need to be modified.\n\nPlease click ACCEPT to continue."],
	button1 = ACCEPT,
	button2 = CANCEL,
	OnAccept = function() OUI:SetupOUI() end,
	timeout = 0,
	whileDead = 1,
}


function OUI:SetupExtraMedia()
	-- Fonts
	E["media"].dtFont = LSM:Fetch("font", E.db["odine"].dtFont)

	-- Sounds
	E["media"].whisper = LSM:Fetch("sound", E.db["odine"].chat.whispersound)
	
	
	E:GetModule('DataTexts'):UpdateDTFont()
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
	
	if E.db.odine.installed == nil or (E.db.odine.installed and type(tonumber(E.db.odine.installed)) == 'number' and tonumber(E.db.odine.installed) <= 0.8) then
		StaticPopup_Show("OUI_INSTALL")
	end

	self:RegisterEvent('CHAT_MSG_BN_WHISPER', 'MonitorWhispers')
	self:RegisterEvent('CHAT_MSG_WHISPER', 'MonitorWhispers')
end

function OUI:SetupOUI()
	-- Man i wish there was another way..... *sadface*

	-- Core
	E.db.core.bordercolor = { r = .23, g = .23, b = .23 }
	E.db.core.backdropcolor = { r = .07, g = .07, b = .07 }
	
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
	E.db.unitframe.colors.colorhealthbyvalue = false
	E.db.unitframe.colors.customhealthbackdrop = true
	
	E.db.odine.installed = E.OUI
	ReloadUI()
end

E:RegisterModule(OUI:GetName())