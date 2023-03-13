local ADDON_NAME, addon = ...
if not _G[ADDON_NAME] then
	_G[ADDON_NAME] = CreateFrame("Frame", ADDON_NAME, UIParent, BackdropTemplateMixin and "BackdropTemplate")
end
addon = _G[ADDON_NAME]

local L = LibStub("AceLocale-3.0"):GetLocale(ADDON_NAME)

addon:RegisterEvent("ADDON_LOADED")
addon:SetScript("OnEvent", function(self, event, ...)
	if event == "ADDON_LOADED" or event == "PLAYER_LOGIN" then
		if event == "ADDON_LOADED" then
			local arg1 = ...
			if arg1 and arg1 == ADDON_NAME then
				self:UnregisterEvent("ADDON_LOADED")
				self:RegisterEvent("PLAYER_LOGIN")
			end
			return
		end
		if IsLoggedIn() then
			self:EnableAddon(event, ...)
			self:UnregisterEvent("PLAYER_LOGIN")
		end
		return
	end
	if self[event] then
		return self[event](self, event, ...)
	end
end)

local IsRetail = WOW_PROJECT_ID == WOW_PROJECT_MAINLINE

--Blizzard_Console_AutoComplete.lua Enum.ConsoleCategory
local CategoryNames = {
	[0] = "Debug",
	[1] = "Graphics",
	[2] = "Console",
	[3] = "Combat",
	[4] = "Game",
	[5] = "Default",
	[6] = "Net",
	[7] = "Sound",
	[8] = "GM",
	[9] = "None",
}



local function IsInBG()
	if (GetNumBattlefieldScores() > 0) then
		return true
	end
	return false
end

local function IsInArena()
	if not IsRetail then return false end
	local a,b = IsActiveBattlefieldArena()
	if not a then
		return false
	end
	return true
end

local function CheckCombatStatus()
	return IsInBG() or IsInArena() or InCombatLockdown() or UnitAffectingCombat("player") or (IsRetail and C_PetBattles.IsInBattle())
end

-- This Function return the Endpoint Position off any Object
local function GetLastObjectEntPoint(object)
	local point, relativeTo, relativePoint, xOffset, yOffset = object:GetPoint(1)
	local buttonWidth = object:GetWidth()
	return xOffset + buttonWidth
  end


----------------------
--      Enable      --
----------------------

function addon:EnableAddon()

	self:CreateUtilityFrame()

	local ver = GetAddOnMetadata(ADDON_NAME,"Version") or '1.0'
	DEFAULT_CHAT_FRAME:AddMessage(string.format("|cFF99CC33%s|r [v|cFF20ff20%s|r]%s", ADDON_NAME, ver or "1.0", L.LOADED))
end


function addon:CreateUtilityFrame()

	self:SetWidth(550)
	self:SetHeight(250)
	self:SetMovable(true)
	self:SetClampedToScreen(true)
	self:EnableMouse(true)
	self:RegisterForDrag("LeftButton")
	self:SetScript("OnDragStart",self.StartMoving)
	self:SetScript("OnDragStop",self.StopMovingOrSizing)

	-- Default Button Height
	local defaultH = 25
	-- Default Space between Buttons
	local defaultSpace = 10
	
	self:SetPoint("CENTER", UIParent, "CENTER")
	
	self:SetBackdrop( {
		bgFile = "Interface\\TutorialFrame\\TutorialFrameBackground";
		edgeFile = "Interface\\Tooltips\\UI-Tooltip-Border";
		tile = true; tileSize = 32; edgeSize = 16;
		insets = { left = 5; right = 5; top = 5; bottom = 5; };
	} );
	self:SetBackdropBorderColor(0.5, 0.5, 0.5);
	self:SetBackdropColor(0.5, 0.5, 0.5, 0.6)
	
	-- Title
	local g = self:CreateFontString("$parentText", "ARTWORK", "GameFontNormalSmall")
	g:SetJustifyH("LEFT")
	g:SetScale(1.5)
	g:SetPoint("TOP",0,-5)
	g:SetText("FireGMod by MuDZaHeDiN")


	----------------------
	--    Line One		--
	----------------------

	-- GM On Button
	local gmonButton = CreateFrame("Button", ADDON_NAME.."_gmon_button", self, "UIPanelButtonTemplate")
	gmonButton:SetText(L.GMON)
	gmonButton:SetHeight(defaultH)
	gmonButton:SetWidth(gmonButton:GetTextWidth() + 20)
	gmonButton:SetPoint("TOPLEFT", self, "TOPLEFT", 10, -30)
	gmonButton:SetScript("OnClick", function()
		SendChatMessage(".gm on", "GUILD")
		print(L.GMON + L.LOADED)
	end)

	-- GM Off Button
	local gmoffButton = CreateFrame("Button", ADDON_NAME.."_gmoff_button", self, "UIPanelButtonTemplate")
	gmoffButton:SetText(L.GMOFF)
	gmoffButton:SetHeight(defaultH)
	gmoffButton:SetWidth(gmoffButton:GetTextWidth() + 20)
	gmoffButton:SetPoint("TOPLEFT", self, "TOPLEFT", GetLastObjectEntPoint(gmonButton) + defaultSpace, -30)
	gmoffButton:SetScript("OnClick", function()
		SendChatMessage(".gm off", "GUILD")
		print(L.GMOFF + L.LOADED)
	end)

	-- Info Button
	local infoButton = CreateFrame("Button", ADDON_NAME.."_info_button", self, "UIPanelButtonTemplate")
	infoButton:SetText("!")
	infoButton:SetHeight(defaultH)
	infoButton:SetWidth(infoButton:GetTextWidth() + 15)
	infoButton:SetPoint("TOPRIGHT", self, "TOPRIGHT", -10, -30)
	infoButton:SetScript("OnClick", function()
		local author = GetAddOnMetadata(ADDON_NAME,"Author") or 'MuDZaHeDiN'
		DEFAULT_CHAT_FRAME:AddMessage(string.format("|cFF99CC33%s|r by |cFF20ff20%s|r for |cFF20ff00fire1808|r", ADDON_NAME, author or "MuDZaHeDiN"))
	end)

	-- ReloadUI Button
	local reloadUIButton = CreateFrame("Button", ADDON_NAME.."_reloadui_button", self, "UIPanelButtonTemplate")
	reloadUIButton:SetText(L.ReloadUI)
	reloadUIButton:SetHeight(defaultH)
	reloadUIButton:SetWidth(reloadUIButton:GetTextWidth() + 20)
	reloadUIButton:SetPoint("TOPLEFT", self, "TOPLEFT", GetLastObjectEntPoint(gmoffButton) + defaultSpace, -30)
	reloadUIButton:SetScript("OnClick", function()
		ReloadUI()
	end)


	----------------------
	--    Line Two		--
	----------------------

	-- Teleport to Player Button
	local teleportButton = CreateFrame("Button", ADDON_NAME.."_teleport_button", self, "UIPanelButtonTemplate")
	teleportButton:SetText(L.TELEPORT2TARGET)
	teleportButton:SetHeight(defaultH)
	teleportButton:SetWidth(teleportButton:GetTextWidth() + 20)
	teleportButton:SetPoint("TOPLEFT", self, "TOPLEFT", 10, -65)
	teleportButton:SetScript("OnClick", function()
		local myTarget = nil

		if UnitExists("target") and UnitIsPlayer("target") then
			myTarget = UnitName("target")
			print(L.TARGETIS .. myTarget)
		else
			myTarget = nil
		end
		
		if myTarget == nil then
			print(L.NOTARGET)
		else
			SendChatMessage(".appear " .. myTarget, "GUILD")
		end

	end)

	-- Summon Player Button
	local summonButton = CreateFrame("Button", ADDON_NAME.."_summon_button", self, "UIPanelButtonTemplate")
	summonButton:SetText(L.SUMMONTARGET)
	summonButton:SetHeight(defaultH)
	summonButton:SetWidth(summonButton:GetTextWidth() + 20)
	summonButton:SetPoint("TOPLEFT", self, "TOPLEFT", GetLastObjectEntPoint(teleportButton) + defaultSpace, -65)
	summonButton:SetScript("OnClick", function()
		local myTarget = nil

		if UnitExists("target") and UnitIsPlayer("target") then
			myTarget = UnitName("target")
			print(L.TARGETIS .. myTarget)
		else
			myTarget = nil
		end
		
		if myTarget == nil then
			print(L.NOTARGET)
		else
			SendChatMessage(".summon " .. myTarget, "GUILD")
		end

	end)

	-- Revive Player Button
	local reviveButton = CreateFrame("Button", ADDON_NAME.."_revive_button", self, "UIPanelButtonTemplate")
	reviveButton:SetText(L.REVIVE)
	reviveButton:SetHeight(defaultH)
	reviveButton:SetWidth(reviveButton:GetTextWidth() + 20)
	reviveButton:SetPoint("TOPLEFT", self, "TOPLEFT", GetLastObjectEntPoint(summonButton) + defaultSpace, -65)
	reviveButton:SetScript("OnClick", function()
		local myTarget = nil

		if UnitExists("target") and UnitIsPlayer("target") then
			myTarget = UnitName("target")
			print(L.TARGETIS .. myTarget)
		else
			myTarget = nil
		end
		
		if myTarget == nil then
			SendChatMessage(".revive", "GUILD")
		else
			SendChatMessage(".revive " .. myTarget, "GUILD")
		end

	end)


	----------------------
	--   Line Three		--
	----------------------

	-- NPC Info Button
	local npcInfoButton = CreateFrame("Button", ADDON_NAME.."_npcinfo_button", self, "UIPanelButtonTemplate")
	npcInfoButton:SetText(L.NPCINFO)
	npcInfoButton:SetHeight(defaultH)
	npcInfoButton:SetWidth(npcInfoButton:GetTextWidth() + 20)
	npcInfoButton:SetPoint("TOPLEFT", self, "TOPLEFT", 10, -100)
	npcInfoButton:SetScript("OnClick", function()
		local tar = nil

		if UnitExists("target") then
			tar = UnitName("target")
			print(L.TARGETIS .. tar)
		else
			tar = nil
		end
		
		if tar == nil then
			print(L.NOTARGET)
		else
			SendChatMessage(".npc info", "GUILD")
		end

	end)

	-- NPC Near Button
	local npcNearButton = CreateFrame("Button", ADDON_NAME.."_npcnear_button", self, "UIPanelButtonTemplate")
	npcNearButton:SetText(L.NPCNEAR)
	npcNearButton:SetHeight(defaultH)
	npcNearButton:SetWidth(npcNearButton:GetTextWidth() + 20)
	npcNearButton:SetPoint("TOPLEFT", self, "TOPLEFT", GetLastObjectEntPoint(npcInfoButton) + defaultSpace, -100)
	npcNearButton:SetScript("OnClick", function()
		SendChatMessage(".npc near", "GUILD")
	end)

	-- Game Object Near Button
	local gobjectNearButton = CreateFrame("Button", ADDON_NAME.."_gobjectnear_button", self, "UIPanelButtonTemplate")
	gobjectNearButton:SetText(L.GOBJECTNEAR)
	gobjectNearButton:SetHeight(defaultH)
	gobjectNearButton:SetWidth(gobjectNearButton:GetTextWidth() + 20)
	gobjectNearButton:SetPoint("TOPLEFT", self, "TOPLEFT", GetLastObjectEntPoint(npcNearButton) + defaultSpace, -100)
	gobjectNearButton:SetScript("OnClick", function()
		SendChatMessage(".gobject near", "GUILD")
	end)

	-- Unaura All Button
	local unauraAllButton = CreateFrame("Button", ADDON_NAME.."_unauraall_button", self, "UIPanelButtonTemplate")
	unauraAllButton:SetText(L.UNAURAALL)
	unauraAllButton:SetHeight(defaultH)
	unauraAllButton:SetWidth(unauraAllButton:GetTextWidth() + 20)
	unauraAllButton:SetPoint("TOPLEFT", self, "TOPLEFT", GetLastObjectEntPoint(gobjectNearButton) + defaultSpace, -100)
	unauraAllButton:SetScript("OnClick", function()
		SendChatMessage(".unaura all", "GUILD")
	end)


	----------------------
	--    Line Four		--
	----------------------

	-- Label ID
	local idLabel = self:CreateFontString("$parentText", "ARTWORK", "GameFontNormalSmall")
	idLabel:SetScale(1)
	idLabel:SetSize(15, defaultH)
	idLabel:SetPoint("TOPLEFT", self, "TOPLEFT", 10, -135)
	idLabel:SetText("ID")

	-- ID Inputfield
	local idInputfield = CreateFrame("EditBox", ADDON_NAME.."_id_editbox", self, "InputBoxTemplate")
	idInputfield:SetPoint("TOPLEFT", self, "TOPLEFT", GetLastObjectEntPoint(idLabel) + defaultSpace, -135)
	idInputfield:SetSize(80, defaultH)
	idInputfield:SetAutoFocus(false)
	idInputfield:SetNumeric(true)

	-- NPC Add Button
	local npcAddButton = CreateFrame("Button", ADDON_NAME.."_npcadd_button", self, "UIPanelButtonTemplate")
	npcAddButton:SetText(L.NPCADD)
	npcAddButton:SetHeight(defaultH)
	npcAddButton:SetWidth(npcAddButton:GetTextWidth() + 20)
	npcAddButton:SetPoint("TOPLEFT", self, "TOPLEFT", GetLastObjectEntPoint(idInputfield) + defaultSpace, -135)
	npcAddButton:SetScript("OnClick", function()
		local id = tonumber(idInputfield:GetText())
		if id then
			SendChatMessage(".npc add " .. id, "GUILD")
			idInputfield:SetText("")
		else
			print(L.EMPTYINPUTFIELD)
		end
		idInputfield:ClearFocus()
	end)

	-- Game Object Add Button
	local gObjectAddButton = CreateFrame("Button", ADDON_NAME.."_gobjectadd_button", self, "UIPanelButtonTemplate")
	gObjectAddButton:SetText(L.GOBJECTADD)
	gObjectAddButton:SetHeight(defaultH)
	gObjectAddButton:SetWidth(gObjectAddButton:GetTextWidth() + 20)
	gObjectAddButton:SetPoint("TOPLEFT", self, "TOPLEFT", GetLastObjectEntPoint(npcAddButton) + defaultSpace, -135)
	gObjectAddButton:SetScript("OnClick", function()
		local id = tonumber(idInputfield:GetText())
		if id then
			SendChatMessage(".npc add " .. id, "GUILD")
			idInputfield:SetText("")
		else
			print(L.EMPTYINPUTFIELD)
		end
		idInputfield:ClearFocus()
	end)

	-- Game Object Del Button
	local gObjectDelButton = CreateFrame("Button", ADDON_NAME.."_gobjectdel_button", self, "UIPanelButtonTemplate")
	gObjectDelButton:SetText(L.GOBJECTDEL)
	gObjectDelButton:SetHeight(defaultH)
	gObjectDelButton:SetWidth(gObjectDelButton:GetTextWidth() + 20)
	gObjectDelButton:SetPoint("TOPLEFT", self, "TOPLEFT", GetLastObjectEntPoint(gObjectAddButton) + defaultSpace, -135)
	gObjectDelButton:SetScript("OnClick", function()
		local id = tonumber(idInputfield:GetText())
		if id then
			SendChatMessage(".npc del " .. id, "GUILD")
			idInputfield:SetText("")
		else
			print(L.EMPTYINPUTFIELD)
		end
		idInputfield:ClearFocus()
	end)


	----------------------
	--    Line Five		--
	----------------------

	-- Label Teleport to
	local teleportToLabel = self:CreateFontString("$parentText", "ARTWORK", "GameFontNormalSmall")
	teleportToLabel:SetPoint("TOPLEFT", self, "TOPLEFT", 10, -170)
	teleportToLabel:SetText("Teleport:")
	teleportToLabel:SetScale(1)
	teleportToLabel:SetSize(47, defaultH)

	-- DropDown Menu
	local teleportDropDown = CreateFrame("Frame", ADDON_NAME.."_teleport_dropdown", self, "UIDropDownMenuTemplate")
	local dropdownOptions = {
		{ text = L.BORALUS, teleString = "BORALUS" },
		{ text = L.DALARAN, teleString = "DALARAN" },
		{ text = L.DALARANLEGION, teleString = "DALARANLEGION" },
		{ text = L.DARNASSUS, teleString = "DARNASSUS" },
		{ text = L.DAZARALOR, teleString = "DAZARALOR" },
		{ text = L.IRONFORGE, teleString = "IRONFORGE" },
		{ text = L.ORGRIMMAR, teleString = "ORGRIMMAR" },
		{ text = L.ORIBOS, teleString = "ORIBOS" },
		{ text = L.SHATTRATH, teleString = "SHATTRATH" },
		{ text = L.SHRINEOFSEVENSTARS, teleString = "SHRINEOFSEVENSTARS" },
		{ text = L.SILVERMOON, teleString = "SILVERMOON" },
		{ text = L.STORMSHIELD, teleString = "STORMSHIELD" },
		{ text = L.STORMWIND, teleString = "STORMWIND" },
		{ text = L.THEEXODAR, teleString = "THEEXODAR" },
		{ text = L.THUNDERBLUFF, teleString = "THUNDERBLUFF" },
		{ text = L.UNDERCITY, teleString = "UNDERCITY" },
		{ text = L.VALDRAKKEN, teleString = "VALDRAKKEN" }
	}
	local function Dropdown_OnClick(self)
		UIDropDownMenu_SetSelectedID(teleportDropDown, self:GetID())
		local selectedOption = dropdownOptions[self:GetID()]
		SendChatMessage(".tele " .. selectedOption.teleString, "GUILD")
	end
	UIDropDownMenu_Initialize(teleportDropDown, function()
		for i, option in ipairs(dropdownOptions) do
			local info = UIDropDownMenu_CreateInfo()
			info.text = option.text
			info.value = option
			info.func = Dropdown_OnClick
			UIDropDownMenu_AddButton(info)
		end
	end)
	teleportDropDown:SetPoint("TOPLEFT", self, "TOPLEFT", GetLastObjectEntPoint(teleportToLabel) + defaultSpace, -170)
	teleportDropDown:SetSize(200, defaultH)
	UIDropDownMenu_SetWidth(teleportDropDown, 200)
	UIDropDownMenu_SetButtonWidth(teleportDropDown, 124)
	UIDropDownMenu_SetSelectedID(teleportDropDown, 1)
	UIDropDownMenu_JustifyText(teleportDropDown, "LEFT")
	local selectedOption = dropdownOptions[UIDropDownMenu_GetSelectedID(teleportDropDown)]
	UIDropDownMenu_SetText(teleportDropDown, selectedOption.text)


	----------------------
	--    Last Line		--
	----------------------

	-- Label Speed
	local speedLabel = self:CreateFontString("$parentText", "ARTWORK", "GameFontNormalSmall")
	speedLabel:SetScale(1)
	speedLabel:SetJustifyH("LEFT")
	speedLabel:SetText("Speed")
	speedLabel:SetSize(35, defaultH)
	speedLabel:SetPoint("BOTTOMLEFT", self, "BOTTOMLEFT", 10, 10)

	-- Speed Inputfield
	local speedInputfield = CreateFrame("EditBox", ADDON_NAME.."_speed_editbox", self, "InputBoxTemplate")
	speedInputfield:SetPoint("BOTTOMLEFT", self, "BOTTOMLEFT", GetLastObjectEntPoint(speedLabel) + defaultSpace, 10)
	speedInputfield:SetSize(25, defaultH)
	speedInputfield:SetAutoFocus(false)
	speedInputfield:SetNumeric(true)

	-- Run Speed Button
	local runSpeedButton = CreateFrame("Button", ADDON_NAME.."_runspeed_button", self, "UIPanelButtonTemplate")
	runSpeedButton:SetText(L.RUNSPEED)
	runSpeedButton:SetHeight(defaultH)
	runSpeedButton:SetWidth(runSpeedButton:GetTextWidth() + 20)
	runSpeedButton:SetPoint("BOTTOMLEFT", self, "BOTTOMLEFT", GetLastObjectEntPoint(speedInputfield) + defaultSpace, 10)
	runSpeedButton:SetScript("OnClick", function()
		local speedValue = tonumber(speedInputfield:GetText())
		if speedValue then
			SendChatMessage(".modify speed " .. speedValue, "GUILD")
			speedInputfield:SetText("1")
		else
			print(L.EMPTYINPUTFIELD)
		end
		speedInputfield:ClearFocus()
	end)

	-- Fly Speed Button
	local flySpeedButton = CreateFrame("Button", ADDON_NAME.."_flyspeed_button", self, "UIPanelButtonTemplate")
	flySpeedButton:SetText(L.FLYSPEEDON)
	flySpeedButton:SetHeight(defaultH)
	flySpeedButton:SetWidth(flySpeedButton:GetTextWidth() + 20)
	flySpeedButton:SetPoint("BOTTOMLEFT", self, "BOTTOMLEFT", GetLastObjectEntPoint(runSpeedButton) + defaultSpace, 10)
	flySpeedButton:SetScript("OnClick", function()
		local speedValue = tonumber(speedInputfield:GetText())
		if speedValue then
			SendChatMessage(".gm fly on", "GUILD")
			SendChatMessage(".modify speed fly " .. speedValue, "GUILD")
			speedInputfield:SetText("1")
		else
			print(L.EMPTYINPUTFIELD)
		end
		speedInputfield:ClearFocus()
	end)

	-- Reset All Speeds Button
	local resetSpeedButton = CreateFrame("Button", ADDON_NAME.."_resetspeed_button", self, "UIPanelButtonTemplate")
	resetSpeedButton:SetText(L.RESETSPEED)
	resetSpeedButton:SetHeight(defaultH)
	resetSpeedButton:SetWidth(resetSpeedButton:GetTextWidth() + 20)
	resetSpeedButton:SetPoint("BOTTOMLEFT", self, "BOTTOMLEFT", GetLastObjectEntPoint(flySpeedButton) + defaultSpace, 10)
	resetSpeedButton:SetScript("OnClick", function()
		SendChatMessage(".modify speed " .. 1, "GUILD")
		SendChatMessage(".modify speed fly " .. 1, "GUILD")
		SendChatMessage(".gm fly off", "GUILD")
		speedInputfield:ClearFocus()
	end)

	-- CloseGUI Button
	local closeGUIButton = CreateFrame("Button", ADDON_NAME.."_closeGUI_button", self, "UIPanelButtonTemplate")
	closeGUIButton:SetText(L.CloseGUI)
	closeGUIButton:SetHeight(defaultH)
	closeGUIButton:SetWidth(closeGUIButton:GetTextWidth() + 20)
	closeGUIButton:SetPoint("BOTTOMRIGHT", self, "BOTTOMRIGHT", -10, 10)
	closeGUIButton:SetScript("OnClick", function()
		self:Hide()
	end)
	self:Show()
end

-- Slash Command to open the GUI.
function addon:SlashHandler(message, editbox)
	addon:Show()
  end
  SLASH_FGM1 = "/fgm"
  SlashCmdList["FGM"] = function(message, editbox) addon:SlashHandler(message, editbox) end