local E, L, DF = unpack(ElvUI); --Engine
local AB = E:GetModule('ActionBars');

local f

local microbuttons = {
	"CharacterMicroButton",
	"SpellbookMicroButton",
	"TalentMicroButton",
	"QuestLogMicroButton",
	"PVPMicroButton",
	"GuildMicroButton",
	"LFDMicroButton",
	"EJMicroButton",
	"RaidMicroButton",
	"HelpMicroButton",
	"MainMenuMicroButton",
	"AchievementMicroButton"
}

local function CheckFade(self, elapsed)
	local mouseactive
	for i, button in pairs(microbuttons) do
		local b = _G[button]
		if b.mouseover == true then
			mouseactive = true
			--[[if GameTooltip:IsShown() then
				GameTooltip:Hide()
			end--]]
		end
	end
	
	if E.db["actionbar"]["microbar"].mouseover ~= true then return end
	
	if MicroPlaceHolder.mouseover == true then
		mouseactive = true
		if GameTooltip:IsShown() then
			GameTooltip:Hide()
		end
	end
	
	if mouseactive == true then
		if MicroParent.shown ~= true then
			UIFrameFadeIn(MicroParent, 0.2)
			MicroParent.shown = true
		end
	else
		if MicroParent.shown == true then
			UIFrameFadeOut(MicroParent, 0.2)
			MicroParent.shown = false
		end
	end
end

function AB:UpdateMicroBar()
	if not MicroParent then
		self:CreateMicroBar()
	end
	if E.db["actionbar"]["microbar"].enable ~= true then
		f:SetAlpha(0);
		f:SetScale(0.000001);
	else
		f:SetAlpha(1);
		f:SetScale(1);
	end

	if E.db['actionbar']['microbar'].mouseover == true or E.db["actionbar"]["microbar"].enable == false then
		f:SetAlpha(0)
	else
		f:SetAlpha(1)
	end
end

function AB:CreateMicroBar()
	f = CreateFrame("Frame", "MicroParent", E.UIParent)
	MicroParent.shown = false
	f:SetScript("OnUpdate", CheckFade)
	
	for i, button in pairs(microbuttons) do
		local m = _G[button]
		local pushed = m:GetPushedTexture()
		local normal = m:GetNormalTexture()
		local disabled = m:GetDisabledTexture()
		
		m:SetParent(MicroParent)
		m.SetParent = E.noop
		_G[button.."Flash"]:SetTexture("")
		m:SetHighlightTexture("")
		m.SetHighlightTexture = E.noop

		local f = CreateFrame("Frame", nil, m)
		f:SetFrameLevel(1)
		f:SetFrameStrata("BACKGROUND")
		f:SetPoint("BOTTOMLEFT", m, "BOTTOMLEFT", 2, 0)
		f:SetPoint("TOPRIGHT", m, "TOPRIGHT", -2, -28)
		f:SetTemplate("Default", true)
		m.frame = f
		
		pushed:SetTexCoord(0.17, 0.87, 0.5, 0.908)
		pushed:ClearAllPoints()
		pushed:Point("TOPLEFT", m.frame, "TOPLEFT", 2, -2)
		pushed:Point("BOTTOMRIGHT", m.frame, "BOTTOMRIGHT", -2, 2)
		
		normal:SetTexCoord(0.17, 0.87, 0.5, 0.908)
		normal:ClearAllPoints()
		normal:Point("TOPLEFT", m.frame, "TOPLEFT", 2, -2)
		normal:Point("BOTTOMRIGHT", m.frame, "BOTTOMRIGHT", -2, 2)
		
		if disabled then
			disabled:SetTexCoord(0.17, 0.87, 0.5, 0.908)
			disabled:ClearAllPoints()
			disabled:Point("TOPLEFT", m.frame, "TOPLEFT", 2, -2)
			disabled:Point("BOTTOMRIGHT", m.frame, "BOTTOMRIGHT", -2, 2)
		end
			

		m.mouseover = false
		m:HookScript("OnEnter", function(self) 
			self.frame:SetBackdropBorderColor(unpack(E["media"].rgbvaluecolor)) 
			self.mouseover = true 
		end)
		m:HookScript("OnLeave", function(self) 
			local color = RAID_CLASS_COLORS[E.myclass] 
			self.frame:SetBackdropBorderColor(unpack(E["media"].bordercolor))
			self.mouseover = false 
		end)
	end
	
	local x = CreateFrame("Frame", "MicroPlaceHolder", MicroParent)
	x:SetPoint("TOPLEFT", CharacterMicroButton.frame, "TOPLEFT")
	x:SetPoint("BOTTOMRIGHT", HelpMicroButton.frame, "BOTTOMRIGHT")
	x:EnableMouse(true)
	x.mouseover = false
	x:CreateShadow("Default")
	x:SetScript("OnEnter", function(self) self.mouseover = true end)
	x:SetScript("OnLeave", function(self) self.mouseover = false end)
	
	--Fix/Create textures for buttons
	do
		MicroButtonPortrait:ClearAllPoints()
		MicroButtonPortrait:Point("TOPLEFT", CharacterMicroButton.frame, "TOPLEFT", 2, -2)
		MicroButtonPortrait:Point("BOTTOMRIGHT", CharacterMicroButton.frame, "BOTTOMRIGHT", -2, 2)
		
		GuildMicroButtonTabard:ClearAllPoints()
		GuildMicroButtonTabard:SetPoint("TOP", GuildMicroButton.frame, "TOP", 0, 25)
		GuildMicroButtonTabard.SetPoint = E.noop
		GuildMicroButtonTabard.ClearAllPoints = E.noop
	end
	
	MicroParent:SetPoint("TOPLEFT", E.UIParent, "TOPLEFT", 4, -4) --Default microbar position

	MicroParent:SetWidth(((CharacterMicroButton:GetWidth() + 4) * 9) + 12)
	MicroParent:SetHeight(CharacterMicroButton:GetHeight() - 28)

	CharacterMicroButton:ClearAllPoints()
	CharacterMicroButton:SetPoint("BOTTOMLEFT", MicroParent, "BOTTOMLEFT", 0,  0)
	CharacterMicroButton.SetPoint = E.noop
	CharacterMicroButton.ClearAllPoints = E.noop


	self:CreateMover(MicroParent, "MicroMover", "MicroBar")
	self:UpdateMicroBar()
end

local old = AB.CreateActionBars
AB.CreateActionBars = function(...)
	old(...)

	AB:CreateMicroBar()
end
