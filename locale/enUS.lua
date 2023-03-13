local ADDON_NAME, addon = ...

local L = LibStub("AceLocale-3.0"):NewLocale(ADDON_NAME, "enUS", true)
if not L then return end

-- Line One
L.GMON = "GM On"
L.GMOFF = "GM Off"
L.ReloadUI = "Reload UI"
-- Line Two
L.TELEPORT2TARGET = "Teleport to Player"
L.SUMMONTARGET = "Summon Player"
L.REVIVE = "Revive Player"
-- Line Three
L.NPCINFO = "NPC Info"
L.NPCNEAR = "NPC Near"
L.GOBJECTNEAR = "Object Near"
L.UNAURAALL = "Unaura All"
-- Line Four
L.NPCADD = "NPC Add"
L.GOBJECTADD = "Object Add"
L.GOBJECTDEL = "Object Delete"
-- Last Line
L.RUNSPEED = "Modify Run"
L.FLYSPEEDON = "Modify Fly On"
L.RESETSPEED = "Reset All"
L.CloseGUI = "Close"

--Locations
L.BORALUS = "Boralus"
L.DALARAN = "Dalaran"
L.DALARANLEGION = "Dalaran Legion"
L.DARNASSUS = "Darnassus"
L.DAZARALOR = "Dazar'alor"
L.IRONFORGE = "Ironforge"
L.ORGRIMMAR = "Orgrimmar"
L.ORIBOS = "Oribos"
L.SHATTRATH = "Shattrath"
L.SHRINEOFSEVENSTARS = "Shrine of Seven Stars"
L.SILVERMOON = "Silvermoon"
L.STORMSHIELD = "Stormshield - PVP Map Ashran"
L.STORMWIND = "Stormwind"
L.THEEXODAR = "The Exodar"
L.THUNDERBLUFF = "Thunder Bluff"
L.UNDERCITY = "Undercity"
L.VALDRAKKEN = "Valdrakken"

-- Strings
L.EMPTYINPUTFIELD = "Inputfield is Empty!"
L.NOTARGET = "No Target!"
L.TARGETIS = "Target is "
L.LOADED = " loaded."