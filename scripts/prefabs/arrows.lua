local assets=
{
	Asset("ANIM", "anim/arrows.zip"),
	Asset("ATLAS", "images/inventoryimages/arrows.xml")
}

local function fn(Sim)
	local inst = CreateEntity()
	inst.entity:AddTransform()
	inst.entity:AddAnimState()

    MakeInventoryPhysics(inst)
    
    inst.AnimState:SetBank("moditem")
    inst.AnimState:SetBuild("arrows")
    inst.AnimState:PlayAnimation("idle")
    
    inst:AddComponent("inventoryitem")
	inst.components.inventoryitem.atlasname = "images/inventoryimages/arrows.xml"

	inst:AddComponent("inspectable")
	
	    inst:AddComponent("stackable")
	inst.components.stackable.maxsize = 40
	
	----------------------------------------------------------------

    ---------------------
    inst:AddComponent("fuel")
    inst.components.fuel.fuelvalue = TUNING.SMALL_FUEL


    inst:AddComponent("edible")
    inst.components.edible.foodtype = "WOOD"
    inst.components.edible.woodiness = 5

    ---------------------        
	MakeSmallBurnable(inst, TUNING.SMALL_BURNTIME)
    MakeSmallPropagator(inst)

----------------------------------------------------------------
    
    return inst
end

return Prefab( "common/inventory/arrows", fn, assets)
