local E, L, DF = unpack(ElvUI); --Engine
local OUI = E:NewModule('OUI', 'AceEvent-3.0');
local DT = E:GetModule('DataTexts');
local M = E:GetModule('Misc');
local LSM = LibStub("LibSharedMedia-3.0")

-- Create Extra DT Panel
do
	local top_bar = CreateFrame('Frame', 'TopDataPanel', E.UIParent)
	top_bar:Width(430)
	top_bar:Height(22)
	top_bar:Point("TOP", E.UIParent, "TOP", 0, -4)
	top_bar:SetTemplate("Default", true)
	E:GetModule('DataTexts'):RegisterPanel(top_bar, 3, 'ANCHOR_BOTTOM', 0, -5)
end


function OUI:SetupExtraMedia()
	-- Fonts
	E["media"].normFont = LSM:Fetch("font", E.db["odine"].dtFont)

	-- Sounds
	E["media"].whisper = LSM:Fetch("sound", E.db["odine"].chat.whispersound)
end

function OUI:UpdateDTFont()
	for panelName, panel in pairs(DT.RegisteredPanels) do
		for i=1, panel.numPoints do
			local pointIndex = DT.PointLocation[i]
			panel.dataPanels[pointIndex].text:FontTemplate(LSM:Fetch("font", E.db.odine.dtFont), E.db.odine.dtFS, nil)
		end
	end
end

function OUI:MonitorWhispers(event)
	if event == "CHAT_MSG_WHISPER" or "CHAT_MSG_BN_WHISPER" then
		if E.db.odine.chat.whisperwarning == true then
			PlaySoundFile(E["media"].whisper, "Master")
		end
	end
end

local old = M.UpdateExpRepBarAnchor
M.UpdateExpRepBarAnchor = function(...)
	old(...)

	if E.db.core.expRepPos == 'TOP_SCREEN' then
		UpperRepExpBarHolder:ClearAllPoints()
		UpperRepExpBarHolder:Point('TOP', E.UIParent, 'TOP', 0, -26)
	end
end


function OUI:Initialize()
	E:GetModule('Blizzard'):HandleBubbles()
	E:GetModule('Blizzard'):RegisterEvent('START_TIMER')

	self:SetupExtraMedia()
	self:UpdateDTFont()
	
	self:RegisterEvent('CHAT_MSG_BN_WHISPER', 'MonitorWhispers')
	self:RegisterEvent('CHAT_MSG_WHISPER', 'MonitorWhispers')
end

E:RegisterModule(OUI:GetName())