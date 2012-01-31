local E, L, DF = unpack(ElvUI); --Engine
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

function DT:UpdateDTFont()
	for panelName, panel in pairs(DT.RegisteredPanels) do
		for i=1, panel.numPoints do
			local pointIndex = DT.PointLocation[i]
			panel.dataPanels[pointIndex].text:FontTemplate(LSM:Fetch("font", E.db.odine.dtFont), E.db.odine.dtFS, nil)
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