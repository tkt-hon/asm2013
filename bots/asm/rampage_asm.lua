local _G = getfenv(0)
local rampage = _G.object

rampage.myName = rampage:GetName()
rampage.heroName = "Hero_Rampage"

rampage.bRunLogic = true
rampage.bRunBehaviors = true
rampage.bUpdates = true
rampage.bUseShop = true

rampage.bRunCommands = true
rampage.bMoveCommands = true
rampage.bAttackCommands = true
rampage.bAbilityCommands = true
rampage.bOtherCommands = true

rampage.bReportBehavior = false
rampage.bDebugUtility = false
rampage.bDebugExecute = false

rampage.logger = {}
rampage.logger.bWriteLog = false
rampage.logger.bVerboseLog = false

rampage.core = {}
rampage.eventsLib = {}
rampage.metadata = {}
rampage.behaviorLib = {}
rampage.skills = {}

runfile "bots/core.lua"
runfile "bots/botbraincore.lua"
runfile "bots/eventsLib.lua"
runfile "bots/metadata.lua"
runfile "bots/behaviorLib.lua"

local core, skills = rampage.core, rampage.skills

rampage.tSkills = {
	0, 1, 0, 1, 0,
	3, 0, 1, 1, 2,
	3, 2, 2, 2, 4,
	3
}

function rampage:SkillBuild()
	local unitSelf = core.unitSelf

	if not skills.abilCharge then
		skills.abilCharge = unitSelf:GetAbility(0)
		skills.abilSlow = unitSelf:GetAbility(1)
		skills.abilBash = unitSelf:GetAbility(2)
		skills.abilUltimate = unitSelf:GetAbility(3)
	end

	if unitSelf:GetAbilityPointsAvailable() <= 0 then
		return
	end

	local nLevel = unitSelf:GetLevel()
	local nPoints = unitSelf:GetAbilityPointsAvailable()
	local nStartPoint = 1 + nLevel - nPoints -- This makes sure that correct skill is leveled up after ReloadBots
	local tSkills = self.tSkills
	for i = nStartPoint, nLevel do
		unitSelf:GetAbility( tSkills[i] or 4 ):LevelUp()
	end
end
