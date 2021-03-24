function MakeDinPropagator(inst)
    
    inst:AddComponent("propagator")
    inst.components.propagator.acceptsheat = true
    inst.components.propagator:SetOnFlashPoint(DefaultIgniteFn)
    inst.components.propagator.flashpoint = 15+math.random()*10
    inst.components.propagator.decayrate = 1
    inst.components.propagator.propagaterange = 6
    inst.components.propagator.heatoutput = 100
    
    inst.components.propagator.damagerange = 6
    inst.components.propagator.damages = true
end

local function fn(Sim)
	local inst = CreateEntity()
	inst.entity:AddTransform()
    MakeInventoryPhysics(inst)

 MakeLargeBurnable(inst)
    inst.components.burnable:SetFXLevel(10)
    MakeDinPropagator(inst)
    inst.components.burnable:Ignite()

    
    inst:AddComponent("heater")
    inst.components.heater.heat = 220
    
    inst.Transform:SetScale(3.5, 2, 3.5)
    
    return inst
end

return Prefab( "common/dinfire", fn) 


