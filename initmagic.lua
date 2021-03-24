local require = GLOBAL.require
local TUNING = GLOBAL.TUNING
local GetPlayer = GLOBAL.GetPlayer

local MagicBadge = require "widgets/magicbadge"

--table.insert(Assets, Asset("ANIM", "anim/mana.zip"))

table.insert(Assets, Asset("ANIM", "anim/magic.zip"))

local function StatusDisplaysInit(class)

	if GetPlayer().components.magic then
		class.magic = class:AddChild(MagicBadge(class.owner))
		class.magic:SetPosition(0,15,0)
		class.magic:SetPercent(class.owner.components.magic:GetPercent(), class.owner.components.magic.max)
		    
		class.inst:ListenForEvent("magicdelta", function(inst, data) 
				class.magic:SetPercent(data.newpercent, class.owner.components.magic.max)
		    end, class.owner)
		    
		class.brain:Hide()
	end
	
end
AddClassPostConstruct("widgets/statusdisplays", StatusDisplaysInit)

AddPrefabPostInit("link", function(inst) inst:AddComponent("magic") end)

--[[MAGIC COST VALUES]]--
-----------------------------------------
TUNING.MAX_MAGIC = 100
TUNING.DINS_FIRE_MAGIC = 15
TUNING.FARORES_WIND_MARK_MAGIC = 5
TUNING.FARORES_WIND_TELEPORT_MAGIC = 20
TUNING.HEROS_BOOMERANG_MAGIC = 1
--THE FOLLOWING TWO DRAIN PER SECOND--
TUNING.NAYRUS_LOVE_MAGIC = 1
TUNING.LENS_OF_TRUTH_MAGIC = 0.5
-----------------------------------------
TUNING.FIRE_STAFF_MAGIC = 5
TUNING.ICE_STAFF_MAGIC = 5
TUNING.TELELOCATOR_STAFF_MAGIC = 5
TUNING.DECONSTRUCTION_STAFF_MAGIC = 5
TUNING.LAZY_EXPLORERS_STAFF_MAGIC = 5
TUNING.STAR_CALLERS_STAFF_MAGIC = 5
-----------------------------------------
