local Assets =
{
	Asset("ANIM", "anim/bottle_r.zip"),
    Asset("ATLAS", "images/inventoryimages/bottle_r.xml")
}

local function fn(Sim)
	local inst = CreateEntity()
	inst.entity:AddTransform()
	inst.entity:AddAnimState()

    MakeInventoryPhysics(inst)
    
    inst.AnimState:SetBank("moditem")
    inst.AnimState:SetBuild("bottle_r")
    inst.AnimState:PlayAnimation("idle")
    
    inst:AddComponent("inventoryitem")
	inst.components.inventoryitem.atlasname = "images/inventoryimages/bottle_r.xml"

	inst:AddComponent("inspectable")
	
	inst:AddTag("irreplaceable")
    
--    inst:AddComponent("healer")
--    inst.components.healer:SetHealthAmount(math.huge)

    inst:AddComponent("edible")
    inst.components.edible.healthvalue = (math.huge)
    inst.components.edible.hungervalue = (0)

    inst.components.edible.foodtype = "HERO_POTION"

inst:DoTaskInTime(0, function(inst)
	GetPlayer():ListenForEvent("onremove", function()
		GetPlayer().components.inventory:GiveItem( SpawnPrefab("bottle_e") )
	end, inst)
end)

    return inst
end

return Prefab( "common/inventory/bottle_r", fn, Assets)

