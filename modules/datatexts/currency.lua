-- Improved Currency Datatext
-- Written by: Mirach
-- Slightly changed to work in ElvUI (Elv v3 edit)
local E, L, DF = unpack(ElvUI); --Engine
local DT = E:GetModule('DataTexts')

local lastPanel
local displayString = "---"
local _hex

EIICCurrencyID = {241, 402, 483, 484, 390, 81, 61, 398, 384, 393, 392, 361, 395, 416, 400, 394, 397, 391, 401, 385, 396, 399}
EIICFrame = nil
EIICCurrDict = nil
EIIC_VERBOSE_LEFT_COLOR1 = {r=0.5, g=0.5, b=0.85}
EIIC_VERBOSE_RIGHT_COLOR1 = {r=0.5, g=0.5, b=0.85}
EIIC_VERBOSE_LEFT_COLOR2 = {r=0.5, g=0.5, b=0.6}
EIIC_VERBOSE_RIGHT_COLOR2 = {r=0.5, g=0.5, b=0.6}

local function Update(self, t)

end

local function OnEvent(self, event, ...)
	lastPanel = self
	
	local _text = "---"
	if not _hex then return end
	for i = 1, MAX_WATCHED_TOKENS do
		if i == 1 then 
			displayString = '' 
		end
		local name, count, extraCurrencyType, icon, itemid = GetBackpackCurrencyInfo(i)
		if name and count then
			if(i ~= 1) then _text = " " else _text = "" end
			words = { strsplit(" ", name) }
			for _, word in ipairs(words) do
				_text = _text .. string.sub(word,1,1)
			end
			local str = tostring(_text..": ".._hex..count.."|r")
			displayString = displayString..str
		elseif i == 1 and not name and not count then 
			displayString = tostring(_hex.."---")
		end
	end	
	if self then 
		self.text:SetFormattedText(displayString)
	end
	displayString = "---"

end

local function Click()
	ToggleCharacter("TokenFrame")
end

function EIICFormatGeneral(cli, curr, lines)
    local lcolorR, lcolorG, lcolorB = EIIC_VERBOSE_LEFT_COLOR1.r, EIIC_VERBOSE_LEFT_COLOR1.g, EIIC_VERBOSE_LEFT_COLOR1.b
    local rcolorR, rcolorG, rcolorB = EIIC_VERBOSE_RIGHT_COLOR1.r, EIIC_VERBOSE_RIGHT_COLOR1.g, EIIC_VERBOSE_RIGHT_COLOR1.b
    
    local lcolorR2, lcolorG2, lcolorB2 = EIIC_VERBOSE_LEFT_COLOR2.r, EIIC_VERBOSE_LEFT_COLOR2.g, EIIC_VERBOSE_LEFT_COLOR2.b
    local rcolorR2, rcolorG2, rcolorB2 = EIIC_VERBOSE_RIGHT_COLOR2.r, EIIC_VERBOSE_RIGHT_COLOR2.g, EIIC_VERBOSE_RIGHT_COLOR2.b
        
    if (curr["id"] == 395) then  -- Justice point
        local line2 = {}
        line2["left"] = EIIC_SPACER..FROM_ALL_SOURCES
        line2["right"] =  tostring(cli["count"]).."/"..tostring(curr["totalMax"])
        line2["lr"],line2["lg"],line2["lb"] = lcolorR, lcolorG, lcolorB
        line2["rr"],line2["rg"],line2["rb"] = rcolorR, rcolorG, rcolorB
        tinsert(lines, line2)
        return
    end
        
    if (not curr["lfdID"]) then return end
        
       -- Get the point info
	local capbar = {}
        
    capbar["currencyID"], capbar["tier1DungeonID"], capbar["tier1Quantity"], capbar["tier1Limit"], capbar["overallQuantity"], capbar["overallLimit"], capbar["periodPurseQuantity"], capbar["periodPurseLimit"] = GetLFGDungeonRewardCapBarInfo(curr["lfdID"]);
	
    if (not capbar["currencyID"]) then return end
	
    local tier1Name = GetLFGDungeonInfo(capbar["tier1DungeonID"])

    local line2 = {}
    line2["left"] = EIIC_SPACER..FROM_ALL_SOURCES
    line2["right"] =  format(CURRENCY_WEEKLY_CAP_FRACTION, capbar["periodPurseQuantity"], capbar["periodPurseLimit"])
    line2["lr"],line2["lg"],line2["lb"] = lcolorR, lcolorG, lcolorB
    line2["rr"],line2["rg"],line2["rb"] = rcolorR, rcolorG, rcolorB
    tinsert(lines, line2)

    local line3 = {}
    line3["left"] = EIIC_SPACER.." -"..FROM_RAID
    line3["right"] = format(CURRENCY_WEEKLY_CAP_FRACTION, capbar["periodPurseQuantity"] - capbar["overallQuantity"], capbar["periodPurseLimit"])
    line3["lr"],line3["lg"],line3["lb"] = lcolorR2, lcolorG2, lcolorB2
    line3["rr"],line3["rg"],line3["rb"] = rcolorR2, rcolorG2, rcolorB2
    tinsert(lines, line3)

    local line4 = {}
    line4["left"] = EIIC_SPACER.." -"..FROM_DUNGEON_FINDER_SOURCES
    line4["right"] = format(CURRENCY_WEEKLY_CAP_FRACTION, capbar["overallQuantity"], capbar["overallLimit"])
    line4["lr"],line4["lg"],line4["lb"] = lcolorR, lcolorG, lcolorB
    line4["rr"],line4["rg"],line4["rb"] = rcolorR, rcolorG, rcolorB
    tinsert(lines, line4)

    local line5 = {}
    line5["left"] = EIIC_SPACER.."   -"..FROM_TROLLPOCALYPSE
    line5["right"] = format(CURRENCY_WEEKLY_CAP_FRACTION, capbar["overallQuantity"] - capbar["tier1Quantity"], capbar["overallLimit"])
    line5["lr"],line5["lg"],line5["lb"] = lcolorR2, lcolorG2, lcolorB2
    line5["rr"],line5["rg"],line5["rb"] = rcolorR2, rcolorG2, rcolorB2
    tinsert(lines, line5)

    local line6 = {}
    line6["left"] = EIIC_SPACER.."   -"..format(FROM_A_DUNGEON, tier1Name)
    line6["right"] = format(CURRENCY_WEEKLY_CAP_FRACTION, capbar["tier1Quantity"], capbar["tier1Limit"])
    line6["lr"],line6["lg"],line6["lb"] = lcolorR, lcolorG, lcolorB
    line6["rr"],line6["rg"],line6["rb"] = rcolorR, rcolorG, rcolorB
    tinsert(lines, line6)
end

function EIICFormatCurrency(cli)
    local lines = {}
    local line1 = {}

    line1["left"] = "|cffFFFFFF"..cli["name"]
    line1["right"] = cli["count"]
    line1["addTex"] = true
    tinsert(lines, line1)

    if (not EIICCurrDict) then
        EIICCurrDict = {}
		for k,v in pairs(EIICCurrencyID) do
			curr = {}
			curr["name"], curr["count"], curr["texture"], curr["4"], curr["weeklyMax"], curr["totalMax"], curr["7"] = GetCurrencyInfo(v)
			
			if (curr["weeklyMax"] and curr["weeklyMax"] >= 10000) then 
				curr["weeklyMax"] = curr["weeklyMax"] / 100
			end
			
			if (curr["totalMax"] and curr["totalMax"] >= 10000) then 
				curr["totalMax"] = curr["totalMax"] / 100
			end
			
			curr["id"] = v
			
			if (v == 396) then -- valor pt
				curr["lfdID"] = 301
			end

			EIICCurrDict[curr["name"]] = curr
		end
    end
    
    local curr = EIICCurrDict[cli["name"]]

    if (not curr) then
        return lines
    end

	if (curr["weeklyMax"] and curr["weeklyMax"] > 0) then
		line1["right"] = line1["right"].." |cff777777("..tostring(cli["currentWeeklyAmt"]).."/"..tostring(curr["weeklyMax"])..")"
	elseif (curr["totalMax"] and curr["totalMax"] > 0) then
		line1["right"] = tostring(cli["count"]).."/"..tostring(curr["totalMax"])
	end

    return lines
end

local function OnEnter(self)
	DT:SetupTooltip(self)
	
	local unused = {} 
    for i=1, GetCurrencyListSize() do
        local cli = {}
        cli["name"], cli["isHeader"], cli["isExpanded"], cli["isUnused"], cli["isWatched"], cli["count"], cli["texture"], cli["max"], cli["weeklyLimit"], cli["currentWeeklyAmt"] = GetCurrencyListInfo(i)   
        cli["isUnused"] = false
        
        if (cli["isHeader"] == true and cli["isUnused"] == false) then
            if (i > 1) then GameTooltip:AddLine(" ") end
            GameTooltip:AddLine(cli["name"])
        elseif (cli["isUnused"] == false) then
            local lines = EIICFormatCurrency(cli)
            for k,v in ipairs(lines) do
	    	GameTooltip:AddDoubleLine(v["left"], v["right"], v["lr"], v["lg"], v["lb"], v["rr"], v["rg"], v["rb"])
	    	GameTooltip:AddTexture(cli["texture"])
	    end
        end
    end

	GameTooltip:Show()
end

local function ValueColorUpdate(hex, r, g, b)
	_hex = hex
	if lastPanel ~= nil then
		OnEvent(lastPanel)
	end
end
E['valueColorUpdateFuncs'][ValueColorUpdate] = true

--[[
	DT:RegisterDatatext(name, events, eventFunc, updateFunc, clickFunc, onEnterFunc)
	
	name - name of the datatext (required)
	events - must be a table with string values of event names to register 
	eventFunc - function that gets fired when an event gets triggered
	updateFunc - onUpdate script target function
	click - function to fire when clicking the datatext
	onEnterFunc - function to fire OnEnter
]]
DT:RegisterDatatext('Currency', {"PLAYER_LOGIN"}, OnEvent, nil, Click, OnEnter)

 hooksecurefunc("BackpackTokenFrame_Update", function(...) OnEvent(lastPanel) end )