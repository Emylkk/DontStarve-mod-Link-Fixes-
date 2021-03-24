local Assets =
{
	Asset("ANIM", "anim/bottle_b.zip"),
    Asset("ATLAS", "images/inventoryimages/bottle_b.xml")
}

local function fn(Sim)
	local inst = CreateEntity()
	inst.entity:AddTransform()
	inst.entity:AddAnimState()

    MakeInventoryPhysics(inst)
    
    inst.AnimState:SetBank("moditem")
    inst.AnimState:SetBuild("bottle_b")
    inst.AnimState:PlayAnimation("idle")
    
    inst:AddComponent("inventoryitem")
	inst.components.inventoryitem.atlasname = "images/inventoryimages/bottle_b.xml"

	inst:AddComponent("inspectable")
	
	inst:AddTag("irreplaceable")

    inst:AddComponent("edible")
    inst.components.edible.healthvalue = (math.huge)
    inst.components.edible.hungervalue = (math.huge)

    inst.components.edible.foodtype = "HERO_POTION"

inst:DoTaskInTime(0, function(inst)
	GetPlayer():ListenForEvent("onremove", function()
		GetPlayer().components.inventory:GiveItem( SpawnPrefab("bottle_e") )
	end, inst)
end)
    
    return inst
end

return Prefab( "common/inventory/bottle_b", fn, Assets)

