local assets=
{
    Asset("ANIM", "anim/fairy.zip"),
}

--local INTENSITY = 2
local function onnear(inst)
    inst.components.locomotor.walkspeed = inst.components.locomotor.walkspeed*.08
 end

local function onfar(inst)
    inst.components.locomotor.walkspeed = GetPlayer().components.locomotor.groundspeedmultiplier*GetPlayer().components.locomotor.walkspeed*GetPlayer().components.locomotor.fastmultiplier+5.3
end

local function ShouldKeepTarget(inst, target)
    return false -- chester can't attack, and won't sleep if he has a target
end
    
local function fn(Sim)
    local inst = CreateEntity()
    
    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddSoundEmitter()
    inst.Transform:SetTwoFaced()
    inst.entity:AddDynamicShadow()
    inst.DynamicShadow:SetSize( .8, .5 )
    inst.AnimState:SetBloomEffectHandle( "shaders/anim.ksh" )
    
    inst.entity:AddPhysics()
 
 	inst.soundsname = "wendy"
 
--
    local light = inst.entity:AddLight()
    light:SetFalloff(0.9)
    light:SetIntensity(0.9)
    light:SetRadius(0.7)
    light:SetColour(155/255, 225/255, 250/255)
    light:Enable(true)
--[[    
    inst.entity:AddLight()
    inst.Light:SetRadius(1)
    inst.Light:SetFalloff(1)
    inst.Light:SetIntensity(1)
    inst.Light:SetColourSetColour(180/255, 195/255, 150/255)
    inst.Light:Enable(true)
--]]    
    
    ----------
    
    inst:AddTag("fairy")
    inst:AddTag("smallcreature")
   
    MakeCharacterPhysics(inst, 1, .25)
    inst.Physics:SetCollisionGroup(COLLISION.FLYERS)
    inst.Physics:ClearCollisionMask()
    inst.Physics:CollidesWith(COLLISION.GROUND)
    
    
    inst.AnimState:SetBuild("fairy")
    inst.AnimState:SetBank("butterfly")
    inst.AnimState:PlayAnimation("idle")
    inst.AnimState:SetRayTestOnBB(true);
    
    inst:AddComponent("locomotor") -- locomotor must be constructed before the stategraph
    inst.components.locomotor:EnableGroundSpeedMultiplier(false)
--  inst.components.locomotor.groundspeedmultiplier = 10
	
	inst:AddComponent("talker")
	inst.components.talker.colour = Point(155/255, 225/255, 250/255) -- (r, g, b)
	inst.components.talker.fontsize = 28
	-- The vertical offset is reversed, the higher it is, the lower the text.
	inst.components.talker.offset = Point(0, -450, 0)


    inst:AddComponent("playerprox")
    inst.components.playerprox:SetDist(1, 2)
    inst.components.playerprox:SetOnPlayerNear(onnear)
    inst.components.playerprox:SetOnPlayerFar(onfar)
    
    inst.components.locomotor.walkspeed = GetPlayer().components.locomotor.groundspeedmultiplier*GetPlayer().components.locomotor.walkspeed*GetPlayer().components.locomotor.fastmultiplier
    inst.components.locomotor.runspeed = GetPlayer().components.locomotor.groundspeedmultiplier*GetPlayer().components.locomotor.walkspeed*GetPlayer().components.locomotor.fastmultiplier+4
--  inst.components.locomotor.isrunning = true
    inst.components.locomotor:SetTriggersCreep(false)

    inst:SetStateGraph("SGfairy")
    
    inst:AddComponent("inspectable")
        
    inst:AddComponent("follower")

    ---------------------       
    inst:AddTag("FX")
    inst:AddTag("companion")
    inst:AddTag("notraptrigger")
    inst:AddTag("light")
    ------------------
	inst:AddComponent("combat")
	inst.components.combat:SetKeepTargetFunction(ShouldKeepTarget)
	inst.components.combat.canbeattackedfn = function(self, attacker) 
		if attacker == GetPlayer() then 
			return false 
		end
		return true
	end
    ------------------
    inst:AddComponent("health")
    inst.components.health:SetInvincible(true)
    ------------------

    local brain = require "brains/fairybrain"
--  local brain = require "brains/butterflybrain"
    inst:SetBrain(brain)

    return inst
end

return Prefab( "common/fairy", fn, assets)
