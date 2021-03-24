local assets=
{
	     Asset("ANIM", "anim/ocarina.zip"),
		    Asset("ATLAS", "images/inventoryimages/ocarina.xml")
}

local function onfinished(inst)
    inst:Remove()
end

local function HearPanFlute(inst, musician, instrument)
	if inst.components.sleeper then
	    inst.components.sleeper:AddSleepiness(10, TUNING.PANFLUTE_SLEEPTIME * 0.8)
	end
end


local function fn(Sim)
	local inst = CreateEntity()
	inst.entity:AddTransform()
	inst.entity:AddAnimState()
	
	inst:AddTag("flute")
	inst:AddTag("ocarina")
    
    inst.AnimState:SetBank("pan_flute")
    inst.AnimState:SetBuild("ocarina")
    inst.AnimState:PlayAnimation("idle")
    MakeInventoryPhysics(inst)
    
    inst:AddComponent("instrument")
    inst.components.instrument.range = TUNING.PANFLUTE_SLEEPRANGE
    inst.components.instrument:SetOnHeardFn(HearPanFlute)
    
    inst:AddComponent("tool")
    inst.components.tool:SetAction(ACTIONS.PLAY)
    
   	inst:AddComponent("inspectable")
   	
   	inst:AddTag("irreplaceable")
        
	 inst:AddComponent("inventoryitem")
	 inst.components.inventoryitem.atlasname = "images/inventoryimages/ocarina.xml"
    
    return inst
end

return Prefab( "common/inventory/ocarina", fn, assets)