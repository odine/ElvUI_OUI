local E, L, DF = unpack(ElvUI); --Engine
local S = E:GetModule('Skins')

local function RegisterStyle()
	if not IsAddOnLoaded("AdvancedTradeSkillWindow") then return end

	ATSWFrame:StripTextures(true)
	ATSWSkillIcon:StripTextures(true)
	ATSWFrame:SetTemplate("Transparent")
	ATSWFrame:CreateShadow("Default")
	ATSWListScrollFrame:StripTextures(true)
	S:HandleScrollBar(ATSWListScrollFrameScrollBar)
	ATSWExpandButtonFrame:StripTextures()
	ATSWRankFrameBorder:StripTextures()
	ATSWRankFrame:StripTextures()
	ATSWRankFrame:CreateBackdrop("Default")
	ATSWRankFrame:SetStatusBarTexture(E["media"].normTex)
	ATSWRankFrame:SetHeight(13)

	S:HandleEditBox(ATSWFilterBox)
	S:HandleEditBox(ATSWInputBox)
	S:HandleEditBox(ATSWCSNewCategoryBox)

	S:HandleDropDownBox(ATSWSubClassDropDown)
	S:HandleDropDownBox(ATSWInvSlotDropDown)

	S:HandleButton(ATSWQueueAllButton, true)
	S:HandleButton(ATSWCreateAllButton, true)
	S:HandleButton(ATSWCreateButton, true)
	S:HandleButton(ATSWQueueButton, true)
	S:HandleButton(ATSWQueueStartStopButton, true)
	S:HandleButton(ATSWQueueDeleteButton, true)
	S:HandleButton(ATSWReagentsButton, true)
	S:HandleButton(ATSWOptionsButton, true)
	S:HandleButton(ATSWCSButton, true)
	S:HandleButton(ATSWBuyReagentsButton, true)
	S:HandleButton(ATSWOptionsFrameOKButton, true)
	S:HandleButton(ATSWAddCategoryButton, true)

	S:HandleCloseButton(ATSWFrameCloseButton)

	S:HandleCheckBox(ATSWHeaderSortButton)
	S:HandleCheckBox(ATSWNameSortButton)
	S:HandleCheckBox(ATSWDifficultySortButton)
	S:HandleCheckBox(ATSWCustomSortButton)
	S:HandleCheckBox(ATSWOnlyCreatableButton)
	S:HandleCheckBox(ATSWOFUnifiedCounterButton)
	S:HandleCheckBox(ATSWOFSeparateCounterButton)
	S:HandleCheckBox(ATSWOFIncludeBankButton)
	S:HandleCheckBox(ATSWOFIncludeAltsButton)
	S:HandleCheckBox(ATSWOFIncludeMerchantsButton)
	S:HandleCheckBox(ATSWOFAutoBuyButton)
	S:HandleCheckBox(ATSWOFTooltipButton)
	S:HandleCheckBox(ATSWOFShoppingListButton)
	S:HandleCheckBox(ATSWOFReagentListButton)
	S:HandleCheckBox(ATSWOFNewRecipeLinkButton)

	--Tooltip
	ATSWTradeskillTooltip:StripTextures(true)
	ATSWTradeskillTooltip:SetTemplate("Transparent")
	ATSWTradeskillTooltip:CreateShadow("Default")

	--Regeants frame
	ATSWReagentFrame:StripTextures(true)
	ATSWReagentFrame:SetTemplate("Transparent")
	ATSWReagentFrame:CreateShadow("Default")

	--Options frame
	ATSWOptionsFrame:StripTextures(true)
	ATSWOptionsFrame:SetTemplate("Transparent")
	ATSWOptionsFrame:CreateShadow("Default")

	--Edit frame
	ATSWCSFrame:StripTextures(true)
	ATSWCSUListScrollFrame:StripTextures()

	ATSWCSFrame:SetTemplate("Transparent")
		local once = false
			for i=1, ATSW_MAX_TRADE_SKILL_REAGENTS do
				local button = _G["ATSWReagent"..i]
				local icon = _G["ATSWReagent"..i.."IconTexture"]
				local count = _G["ATSWReagent"..i.."Count"]

				icon:SetTexCoord(.08, .92, .08, .92)
				icon:SetDrawLayer("OVERLAY")
				if not icon.backdrop then
					icon.backdrop = CreateFrame("Frame", nil, button)
					icon.backdrop:SetFrameLevel(button:GetFrameLevel() - 1)
					icon.backdrop:SetTemplate("Default")
					icon.backdrop:Point("TOPLEFT", icon, "TOPLEFT", -2, 2)
					icon.backdrop:Point("BOTTOMRIGHT", icon, "BOTTOMRIGHT", 2, -2)
				end

				icon:SetParent(icon.backdrop)
				count:SetParent(icon.backdrop)
				count:SetDrawLayer("OVERLAY")

				if i > 2 and once == false then
					local point, anchoredto, point2, x, y = button:GetPoint()
					button:ClearAllPoints()
					button:Point(point, anchoredto, point2, x, y - .8)
					--once = true
				end

				_G["ATSWReagent"..i.."NameFrame"]:Kill()
			end
		S:HandleScrollBar(ATSWCSUListScrollFrameScrollBar)
		S:HandleScrollBar(ATSWCSSListScrollFrameScrollBar)
		ATSWCSSListScrollFrame:StripTextures()
		S:HandleCloseButton(ATSWCSFrameCloseButton)
	for i = 1, 4 do
		S:HandleButton(_G["ATSWQueueItem"..i.."DeleteButton"])
	end

	ATSWQueueStartStopButton:Point("CENTER", ATSWFrame, "TOPLEFT", 425, -480)
	ATSWOptionsButton:Point("CENTER", ATSWFrame, "TOPLEFT", 685, -80)
	ATSWCSButton:Point("CENTER", ATSWFrame, "TOPLEFT", 390, -50)
	ATSWAddCategoryButton:Point("LEFT", ATSWCSNewCategoryBox, "RIGHT", 5, 0)
	ATSWFrameCloseButton:Point("TOPRIGHT", ATSWFrame, "TOPRIGHT", -5, -5)
	ATSWFilterBox:Point("TOPLEFT", ATSWFrame, "TOPLEFT", 126, -90)
	ATSWBuyReagentsButton:Point("CENTER", ATSWReagentFrame, "BOTTOMLEFT", 246, 50)
	ATSWQueueScrollFrame:StripTextures(True)
	S:HandleScrollBar(ATSWQueueScrollFrameScrollBar)
	S:HandleNextPrevButton(ATSWIncrementButton)
	S:HandleNextPrevButton(ATSWDecrementButton)
	S:HandleButton(ATSWAutoBuyButton)
	--Shopping List Frame
	ATSWShoppingListFrame:StripTextures(true)
	ATSWShoppingListFrame:SetTemplate("Transparent")
	S:HandleButton(ATSWSLCloseButton)
	ATSWSLScrollFrame:StripTextures(True)
	S:HandleScrollBar(ATSWSLScrollFrameScrollBar)

	--Delay Frame	
	ATSWScanDelayFrame:StripTextures(true)
	ATSWScanDelayFrame:SetTemplate("Transparent")
	ATSWScanDelayFrameBar:StripTextures(true)
	ATSWScanDelayFrameBar:SetTemplate("ClassColor")
	ATSWScanDelayFrameBar:SetStatusBarTexture(E["media"].normTex)
	ATSWScanDelayFrameBar:SetStatusBarColor(0, 0, 100)
	S:HandleButton(ATSWScanDelayFrameSkipButton)
	S:HandleButton(ATSWScanDelayFrameAbortButton)
end

S:RegisterSkin('AdvancedTradeSkillWindow', RegisterStyle, false)
