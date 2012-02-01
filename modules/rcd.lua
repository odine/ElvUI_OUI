--
-- W.I.P - RCD Module
-- initial code from Tukui forums via Duffed, updated to work for Elv v3 by odine
local E, L, DF = unpack(ElvUI)
local R = E:NewModule('RCD', 'AceEvent-3.0');

spell_list = {
	[20484] = 600, -- Rebirth
	[61999] = 600, -- Raise Ally
	[20707] = 900, -- Soulstone
	[6346] = 180, -- Fear Ward
	[29166] = 180, -- Innervate
	[32182] = 300, -- Heroism
	[2825] = 300, -- Bloodlust
	[80353] = 300, -- Time Warp
	[90355] = 300, -- Ancient Hysteria
	[31821] = 120, -- Aura Mastery
	[62618] = 180, -- Power Word: Barrier
	[98008] = 180, -- Spirit Link Totem
	[740] = 480, -- Tranquility
}

local show = { }

local day, hour, minute, second = 86400, 3600, 60, 1
function R:FormatTime(s)
	if s >= day then
		return format("%dd", ceil(s / hour))
	elseif s >= hour then
		return format("%dh", ceil(s / hour))
	elseif s >= minute then
		return format("%dm", ceil(s / minute))
	elseif s >= minute / 12 then
		return floor(s)
	end
	
	return format("%.1f", s)
end

local barw = 185
local barh = 15

local filter = COMBATLOG_OBJECT_AFFILIATION_RAID + COMBATLOG_OBJECT_AFFILIATION_PARTY + COMBATLOG_OBJECT_AFFILIATION_MINE
local band = bit.band
local sformat = string.format
local floor = math.floor
local timer = 0
local bars = {}

local CreateFS = function(frame, fsize, fstyle)
	local fstring = frame:CreateFontString(nil, "OVERLAY")
	fstring:FontTemplate()
	return fstring
end

local UpdatePositions = function()
	for i = 1, #bars do
		bars[i]:ClearAllPoints()
		if i == 1 then
			bars[i]:Point("TOPLEFT", RCDMover, "BOTTOMLEFT", -2, -5)
		else
			bars[i]:Point("TOPLEFT", bars[i-1], "BOTTOMLEFT", 0, -8)
		end
		bars[i].id = i
	end
end

local StopTimer = function(bar)
	bar:SetScript("OnUpdate", nil)
	bar:Hide()
	tremove(bars, bar.id)
	UpdatePositions()
end

local BarUpdate = function(self, elapsed)
	local curTime = GetTime()
	if self.endTime < curTime then
		StopTimer(self)
		return
	end
	self:SetValue(100 - (curTime - self.startTime) / (self.endTime - self.startTime) * 100)
	self.right:SetText(R:FormatTime(self.endTime - curTime))
	
	local remaining = self.endTime - curTime;
	local barpos = 100 - (curTime - self.startTime) / (self.endTime - self.startTime) * 100
	self.spark:SetPoint("CENTER", self, "LEFT", barpos * 1.85, 0);
	
	--need to update colors incase changed in config
	--prolly move this to a seperate update function and ONLY call when needed...
	if E.db['odine']['rcd'].classcolor == true then
		if self.cname then -- sloppy shit
			local color = RAID_CLASS_COLORS[select(2, UnitClass(self.cname))]
			self:SetStatusBarColor(color.r, color.g, color.b)
		else
			elf:SetStatusBarColor(unpack(E["media"].backdropcolor))
		end
	else
		self:SetStatusBarColor(unpack(E["media"].backdropcolor))
	end
	self.bg:SetVertexColor(.15, .15, .15, .25)
end

local CreateBar = function()
	local bar = CreateFrame("Statusbar", nil, UIParent)
	bar:SetFrameStrata("LOW")
	bar:Size(barw, barh)
	bar:SetStatusBarTexture(E["media"].normTex)
	bar:SetMinMaxValues(0, 100)

	bar.backdrop = CreateFrame("Frame", nil, bar)
	bar.backdrop:Point("TOPLEFT", -2, 2)
	bar.backdrop:Point("BOTTOMRIGHT", 2, -2)
	bar.backdrop:SetTemplate("Default")
	bar.backdrop:SetFrameStrata("BACKGROUND")

	bar.bg = bar:CreateTexture(nil, "BACKGROUND")
	bar.bg:SetAllPoints(bar)
	bar.bg:SetTexture(E["media"].normTex)
	
	bar.left = CreateFS(bar)
	bar.left:Point("LEFT", 2, 0)
	bar.left:SetJustifyH("LEFT")
	bar.left:Size(barw - 30, barh)

	bar.right = CreateFS(bar)
	bar.right:Point("RIGHT", 1, 0)
	bar.right:SetJustifyH("RIGHT")

	bar.icon = CreateFrame("Button", nil, bar)
	bar.icon:Width(bar:GetHeight())
	bar.icon:Height(bar.icon:GetWidth())
	bar.icon:Point("BOTTOMRIGHT", bar, "BOTTOMLEFT", -7, 0)

	bar.icon.backdrop = CreateFrame("Frame", nil, bar.icon)
	bar.icon.backdrop:Point("TOPLEFT", -2, 2)
	bar.icon.backdrop:Point("BOTTOMRIGHT", 2, -2)
	bar.icon.backdrop:SetTemplate("Default")
	bar.icon.backdrop:SetFrameStrata("BACKGROUND")
	
	local spark = bar:CreateTexture(nil, "OVERLAY", nil);
	spark:SetTexture([[Interface\CastingBar\UI-CastingBar-Spark]]);
	spark:SetWidth(12);
	spark:SetBlendMode("ADD");
	spark:Show();
	bar.spark = spark;

	return bar
end

local StartTimer = function(name, spellId)
	local bar = CreateBar()
	local spell, rank, icon = GetSpellInfo(spellId)
	bar.endTime = GetTime() + spell_list[spellId]
	bar.startTime = GetTime()
	bar.left:SetText(spell.." - "..name)
	bar.right:SetText(R:FormatTime(spell_list[spellId]))
	bar.icon:SetNormalTexture(icon)
	bar.icon:GetNormalTexture():SetTexCoord(.1, .9, .1, .9)
	bar.spell = spell
	bar.cname = name
	bar:Show()
	if E.db['odine']['rcd'].classcolor == true then
		local color = RAID_CLASS_COLORS[select(2, UnitClass(name))]
		bar:SetStatusBarColor(color.r, color.g, color.b)
	else
		bar:SetStatusBarColor(unpack(E["media"].backdropcolor))
	end
	bar.bg:SetVertexColor(.15, .15, .15, .25)
	bar:SetScript("OnUpdate", BarUpdate)
	bar:EnableMouse(true)
	tinsert(bars, bar)
	UpdatePositions()
end

local OnEvent = function(self, event, ...)
	if event == "COMBAT_LOG_EVENT_UNFILTERED" then
		local _, eventType, _, _, sourceName, sourceFlags = ...

		if band(sourceFlags, filter) == 0 then return end
		local spellId = select(12, ...)

		if spell_list[spellId] and show[select(2, IsInInstance())] then
			if eventType == "SPELL_RESURRECT" and not spellId == 61999 then
				if spellId == 95750 then spellId = 6203 end
				StartTimer(sourceName, spellId)
			elseif eventType == "SPELL_RESURRECT" and spellId == 20484 then
				StartTimer(sourceName, spellId)
			elseif eventType == "SPELL_AURA_APPLIED" then
				if spellId == 20707 then
					local _, class = UnitClass(sourceName)
					if class == "WARLOCK" then
						StartTimer(sourceName, spellId)
					end
				end
			elseif eventType == "SPELL_CAST_SUCCESS" then
				StartTimer(sourceName, spellId)
			end
		end
	elseif event == "ZONE_CHANGED_NEW_AREA" and select(2, IsInInstance()) == "arena" then
		for k, v in pairs(bars) do
			StopTimer(v)
		end
	end
end

SlashCmdList.RaidCD = function(msg)
	StartTimer(UnitName("player"), 32182)	-- Heroism
	StartTimer(UnitName("player"), 2825)	-- Bloodlust
	StartTimer(UnitName("player"), 98008)
end
SLASH_RaidCD1 = "/rcd" -- testing purposes

function R:Initialize()
	if E.db['odine'].rcd.enable ~= true then return end
	
	show = {
		raid = E.db['odine']['rcd'].raid,
		party = E.db['odine']['rcd'].party,
		arena = E.db['odine']['rcd'].arena,
	}
	
	local rcda = CreateFrame("Frame", "RCDAnchor", E.UIParent)
	rcda:Width(barw)
	rcda:Height(barh)
	rcda:Point('LEFT', E.UIParent, 'LEFT', 300, 200)
	rcda:CreateBackdrop('Transparent')
	rcda.backdrop:SetAllPoints()
	rcda:SetClampedToScreen(true)
	rcda:SetMovable(true)
	rcda:SetBackdropColor(0, 0, 0)
	rcda:SetBackdropBorderColor(1, 0, 0)
	rcda:Hide()
	
	E:CreateMover(rcda, 'RCDMover', 'Raid CD Mover', nil, UpdatePositions)
	
	local addon = CreateFrame("Frame")
	addon:SetScript("OnEvent", OnEvent)
	addon:RegisterEvent("COMBAT_LOG_EVENT_UNFILTERED")
	addon:RegisterEvent("ZONE_CHANGED_NEW_AREA")
end

E:RegisterModule(R:GetName())