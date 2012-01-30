local E, L, DF = unpack(ElvUI); --Engine
local S = E:GetModule('Skins')

local function RegisterStyle()
	if not IsAddOnLoaded("Clique") then return end

	CliqueConfig:StripTextures()
	CliqueConfig:SetTemplate("Default")
	CliqueConfigInset:StripTextures()
	S:HandleButton(CliqueConfigPage1Column1)
	S:HandleButton(CliqueConfigPage1Column2)
	S:HandleCloseButton(CliqueConfigCloseButton)
	CliqueConfigPage1ButtonOptions:StripTextures()
	CliqueConfigPage1ButtonOther:StripTextures()
	CliqueConfigPage1ButtonSpell:StripTextures()
	S:HandleButton(CliqueConfigPage1ButtonSpell)
	S:HandleButton(CliqueConfigPage1ButtonOther)
	S:HandleButton(CliqueConfigPage1ButtonOptions)
end

S:RegisterSkin('Clique', RegisterStyle, false)