local assets=
{
	Asset("ANIM", "anim/rupee.zip"),
	Asset("ATLAS", "images/inventoryimages/rupee.xml")
}

local function fn(Sim)
	local inst = CreateEntity()
	inst.entity:AddTransform()
	inst.entity:AddAnimState()

    MakeInventoryPhysics(inst)
    
    inst.AnimState:SetBank("coin")
    inst.AnimState:SetBuild("rupee")
    inst.AnimState:PlayAnimation("idle")
    
    inst:AddComponent("inventoryitem")
	inst.components.inventoryitem.atlasname = "images/inventoryimages/rupee.xml"

	inst:AddComponent("inspectable")
	
	    inst:AddComponent("stackable")
	inst.components.stackable.maxsize = 999
	
    inst:AddComponent("appeasement")
    inst.components.appeasement.appeasementvalue = TUNING.APPEASEMENT_TIN

	inst:AddComponent("currency")
	inst:AddComponent("bait")
    inst:AddTag("molebait")
	inst:AddTag("oinc")
	inst.oincvalue = 10
	
	
	inst:AddComponent("tradable")
	inst.components.tradable.goldvalue = 2
    
    return inst
end

return Prefab( "common/inventory/rupee", fn, assets)