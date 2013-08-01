local _G = getfenv(0)
local teambot = _G.object

Echo("Loading asm powered teambot...")

runfile "bots/teambot/teambotbrain.lua"

teambot.bGroupAndPush = false
teambot.bDefense = false

Echo("Loaded asm powered teambot.")
