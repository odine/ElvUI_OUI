local E, L, DF = unpack(ElvUI); --Engine
local OUI = E:NewModule('OUI', 'AceEvent-3.0');
local LSM = LibStub("LibSharedMedia-3.0")


--variables
E.OUI = GetAddOnMetadata("ElvUI_OUI", "Version"); 


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


function OUI:AutoRelease()
	if E.db.odine.pvpautorelease ~= true then return end

	local soulstone = GetSpellInfo(20707)
	if ((E.myclass ~= "SHAMAN") and not (soulstone and UnitBuff("player", soulstone))) and MiniMapBattlefieldFrame.status == "active" then
		RepopMe()
	end
end


function OUI:AutoGreedLoot()
	if E.db.odine.autogreed ~= true then return end
	
	--local party = GetNumPartyMembers()
	local raid = GetNumRaidMembers()
	
	if raid > 0 then  -- only work in parties to prevent rolling while in LFR
		E:Print("PASSING ON LOOT WHILE IN RAID GROUP")
		return
	end

	local name = select(2, GetLootRollItemInfo(id))
	
	--Auto Need Chaos Orb
	if (name == select(1, GetItemInfo(52078))) then
		RollOnLoot(id, 1)
	end
	
	if E.level ~= MAX_PLAYER_LEVEL then return end
	if (id and select(4, GetLootRollItemInfo(id))==2 and not (select(5, GetLootRollItemInfo(id)))) then
		if RollOnLoot(id, 3) then
			RollOnLoot(id, 3)
		else
			RollOnLoot(id, 2)
		end
	end
end

-- buy max number value with alt
local savedMerchantItemButton_OnModifiedClick = MerchantItemButton_OnModifiedClick
function MerchantItemButton_OnModifiedClick(self, ...)
	if ( IsAltKeyDown() ) then
		local maxStack = select(8, GetItemInfo(GetMerchantItemLink(self:GetID())))
		if ( maxStack and maxStack > 1 ) then
			BuyMerchantItem(self:GetID(), GetMerchantItemMaxStack(self:GetID()))
		end
	end
	savedMerchantItemButton_OnModifiedClick(self, ...)
end


function OUI:Initialize()
	E:GetModule('Blizzard'):HandleBubbles()
	E:GetModule('Blizzard'):RegisterEvent('START_TIMER')

	self:SetupExtraMedia()
	self:RegisterEvent('CHAT_MSG_BN_WHISPER', 'MonitorWhispers')
	self:RegisterEvent('CHAT_MSG_WHISPER', 'MonitorWhispers')
	self:RegisterEvent('PLAYER_DEAD', 'AutoRelease')
	self:RegisterEvent('START_LOOT_ROLL', 'AutoGreedLoot')
end


E:RegisterModule(OUI:GetName())