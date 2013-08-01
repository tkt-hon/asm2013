local _G = getfenv(0)
local rampage = _G.object

runfile "bots/asm/rampage_asm.lua"

local core, behaviorLib, skills = rampage.core, rampage.behaviorLib, rampage.skills

local tinsert = _G.table.insert

behaviorLib.StartingItems = { "Item_RunesOfTheBlight", "Item_IronBuckler", "Item_LoggersHatchet" }
behaviorLib.LaneItems = { "Item_Marchers", "Item_Lifetube", "Item_ManaBattery" }
behaviorLib.MidItems = { "Item_EnhancedMarchers", "Item_Shield2", "Item_PowerSupply", "Item_MysticVestments" }
behaviorLib.LateItems = { "Item_Immunity", "Item_DaemonicBreastplate" }

rampage.tSkills = {
	1, 2, 1, 0, 1,
	3, 1, 2, 2, 2,
	3, 0, 0, 0, 4,
	3
}

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

	if skills.abilBash:IsReady() then
		nUtil = nUtil + 10
	end

	if skills.abilCharge:CanActivate() then
		nUtil = nUtil + 20
	end

	if skills.abilUltimate:CanActivate() then
		nUtil = nUtil + 50
	end

	return nUtil
end
behaviorLib.CustomHarassUtility = CustomHarassUtilityFnOverride

local function HarassHeroExecuteOverride(botBrain)
	local abilCharge = skills.abilCharge
	local abilUltimate = skills.abilUltimate
	local abilSlow = skills.abilSlow

	local unitTarget = behaviorLib.heroTarget
	if unitTarget == nil then
		return rampage.harassExecuteOld(botBrain)
	end

	local unitSelf = core.unitSelf
	local nTargetDistanceSq = Vector3.Distance2DSq(unitSelf:GetPosition(), unitTarget:GetPosition())
	local nLastHarassUtility = behaviorLib.lastHarassUtil

	local bActionTaken = false

	if core.CanSeeUnit(botBrain, unitTarget) then

		if abilUltimate:CanActivate() then
			local nRange = abilUltimate:GetRange()
			if nTargetDistanceSq < (nRange * nRange) then
				bActionTaken = core.OrderAbilityEntity(botBrain, abilUltimate, unitTarget)
			end
		end

		if not bActionTaken and abilCharge:CanActivate() then
			bActionTaken = core.OrderAbilityEntity(botBrain, abilCharge, unitTarget)
		end

		if not bActionTaken and abilSlow:CanActivate() then
			local nRange = 300
			if nTargetDistanceSq < (nRange * nRange) then
				return core.OrderAbility(botBrain, abilSlow)
			end
		end

	end

	if not bActionTaken then
		return rampage.harassExecuteOld(botBrain)
	end
end
rampage.harassExecuteOld = behaviorLib.HarassHeroBehavior["Execute"]
behaviorLib.HarassHeroBehavior["Execute"] = HarassHeroExecuteOverride


local function IsCharging(unit)
	local tStates = {
		"State_Rampage_Ability1_Self",
		"State_Rampage_Ability1_Sight",
		"State_Rampage_Ability1_Timer",
		"State_Rampage_Ability1_Warp"
	}
	for _, state in ipairs(tStates) do
		if unit:HasState(state) then
			return true
		end
	end
	return false
end

local function ChargeUtility(botBrain)
	local unitSelf = core.unitSelf
	if IsCharging(unitSelf) then
		return 9999
	end
	return 0
end

local function ChargeExecute(botBrain)
	return
end

local ChargeBehavior = {}
ChargeBehavior["Utility"] = ChargeUtility
ChargeBehavior["Execute"] = ChargeExecute
ChargeBehavior["Name"] = "Charge like a boss"
tinsert(behaviorLib.tBehaviors, ChargeBehavior)
