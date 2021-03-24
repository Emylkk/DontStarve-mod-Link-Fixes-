local MakePlayerCharacter = require "prefabs/player_common"


local assets = {

        Asset( "ANIM", "anim/player_basic.zip" ),
        Asset( "ANIM", "anim/player_idles_shiver.zip" ),
        Asset( "ANIM", "anim/player_actions.zip" ),
        Asset( "ANIM", "anim/player_actions_axe.zip" ),
        Asset( "ANIM", "anim/player_actions_pickaxe.zip" ),
        Asset( "ANIM", "anim/player_actions_shovel.zip" ),
        Asset( "ANIM", "anim/player_actions_blowdart.zip" ),
        Asset( "ANIM", "anim/player_actions_eat.zip" ),
        Asset( "ANIM", "anim/player_actions_item.zip" ),
        Asset( "ANIM", "anim/player_actions_uniqueitem.zip" ),
        Asset( "ANIM", "anim/player_actions_bugnet.zip" ),
        Asset( "ANIM", "anim/player_actions_fishing.zip" ),
        Asset( "ANIM", "anim/player_actions_boomerang.zip" ),
        Asset( "ANIM", "anim/player_bush_hat.zip" ),
        Asset( "ANIM", "anim/player_attacks.zip" ),
        Asset( "ANIM", "anim/player_idles.zip" ),
        Asset( "ANIM", "anim/player_rebirth.zip" ),
        Asset( "ANIM", "anim/player_jump.zip" ),
        Asset( "ANIM", "anim/player_amulet_resurrect.zip" ),
        Asset( "ANIM", "anim/player_teleport.zip" ),
        Asset( "ANIM", "anim/wilson_fx.zip" ),
        Asset( "ANIM", "anim/player_one_man_band.zip" ),
        Asset( "ANIM", "anim/shadow_hands.zip" ),
        Asset( "SOUND", "sound/sfx.fsb" ),
        Asset( "SOUND", "sound/wilson.fsb" ),
--------------------------------------------------------------------
        Asset( "ANIM", "anim/link.zip" ),
        Asset( "ANIM", "anim/bink.zip" ),
        Asset( "ANIM", "anim/rink.zip" )
}

local prefabs = 
{

}

local start_inv = 
{
	"linksword",
	"shield",
	"ocarina",
	"linkerang",
	"megton",
	"herolan",
	"tunic_red",
	"tunic_blue",
	"trulens",
	"bunnyhood",
	"bottle_e",
	"bottle_e",
	"bottle_e",
	"trade01",
	"dinrock",
	"farorrock",
	"nayrurock",
}

local fn = function(inst)
	
	inst.soundsname = "wendy"

	inst.MiniMapEntity:SetIcon( "wilson.png" )

--------------------------------------------------------------------

	inst.components.health:SetMaxHealth(300)
	inst.components.hunger:SetMax(300)
	inst.components.hunger:SetRate(TUNING.WILSON_HUNGER_RATE * 0.5)
	inst.components.sanity.ignore = true
	inst.components.combat.damagemultiplier = 1.2
	inst.components.combat.min_attack_period = 0.25
	inst.components.locomotor.walkspeed = (TUNING.WILSON_WALK_SPEED * 1.2)
	inst.components.locomotor.runspeed = (TUNING.WILSON_RUN_SPEED * 1.2)
	inst.components.sanity.neg_aura_mult = 0
	inst.components.sanity.night_drain_mult = 0
	inst.components.eater.strongstomach = true
	
	inst:AddComponent("dapperness")
    inst.components.dapperness.mitigates_rain = true
 
 if(inst.components.eater.ablefoods)then
     table.insert( inst.components.eater.ablefoods, "HERO_POTION" )
 end
 table.insert( inst.components.eater.foodprefs, "HERO_POTION" )
 
 function inst:ActionStringOverride(bufaction)
	if bufaction.action == ACTIONS.EAT and bufaction.invobject.prefab and bufaction.invobject.prefab:match("^bottle_") then
		return "Drink"
	end

	if bufaction.action == ACTIONS.DROPSINGLE and bufaction.invobject.prefab and bufaction.invobject.prefab:match("^bombs") then
		return "Drop Bomb"
	end

	if bufaction.action == ACTIONS.DROPSINGLE and bufaction.invobject.prefab and bufaction.invobject.prefab:match("^dinrock") then
		return "Activate Din's Fire"
	end

	if bufaction.action == ACTIONS.DROPSINGLE and bufaction.invobject.prefab and bufaction.invobject.prefab:match("^farorrock") then
		return "Activate Farore's Wind"
	end

	if bufaction.action == ACTIONS.DROPSINGLE and bufaction.invobject.prefab and bufaction.invobject.prefab:match("^nayrurock") then
		return "Activate Nayru's Love"
	end
end

------------------------------------------------------------------
------------------------------------------------------------------
    inst:AddComponent("childspawner")
    inst.components.childspawner.childname = "fairy"
    inst.components.childspawner:StartSpawning()
    inst.components.childspawner.maxchildren = 1
    ----------------------------------------------------------

    if inst.components.leader then

        local x,y,z = inst.Transform:GetWorldPosition()

        local ents = TheSim:FindEntities(x,y,z, 100, {"fairy"})

        for k,v in pairs(ents) do

            if v.components.follower then

                inst.components.leader:AddFollower(v)

            end

        end


        for k,v in pairs(inst.components.leader.followers) do

            if k:HasTag("fairy") and k.components.follower then

                k.components.follower:AddLoyaltyTime(3)

            end

           end
   end
------------------------------------------------------------------
------------------------------------------------------------------
	
end

return MakePlayerCharacter("link", prefabs, assets, fn, start_inv)
