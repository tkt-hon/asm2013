local _G = getfenv(0)
local rampage = _G.object

runfile "bots/asm/rampage_asm.lua"

local core, behaviorLib, skills = rampage.core, rampage.behaviorLib, rampage.skills

local tinsert = _G.table.insert

--behaviorLib.StartingItems = { }
--behaviorLib.LaneItems = { }
--behaviorLib.MidItems = { }
--behaviorLib.LateItems = { }

--rampage.tSkills = { }

------------------------------------------------------
-- onthink override --
-- Called every bot tick, custom onthink code here --
------------------------------------------------------
-- @param: tGameVariables
-- @return: none
function rampage:onthinkOverride(tGameVariables)
	self:onthinkOld(tGameVariables)

	-- custom code here
end
rampage.onthinkOld = rampage.onthink
rampage.onthink = rampage.onthinkOverride

----------------------------------------------
-- oncombatevent override --
-- use to check for infilictors (fe. buffs) --
----------------------------------------------
-- @param: eventdata
-- @return: none
function rampage:oncombateventOverride(EventData)
	self:oncombateventOld(EventData)

	-- custom code here
end
rampage.oncombateventOld = rampage.oncombatevent
rampage.oncombatevent = rampage.oncombateventOverride

local function CustomHarassUtilityFnOverride(hero)
	local nUtil = 0

	-- custom code here

	return nUtil
end
behaviorLib.CustomHarassUtility = CustomHarassUtilityFnOverride

local function HarassHeroExecuteOverride(botBrain)
	-- custom code here
end
--rampage.harassExecuteOld = behaviorLib.HarassHeroBehavior["Execute"]
--behaviorLib.HarassHeroBehavior["Execute"] = HarassHeroExecuteOverride
