local Assets =
{
	Asset("ANIM", "anim/bottle_g.zip"),
    Asset("ATLAS", "images/inventoryimages/bottle_g.xml")
}

local function fn(Sim)
	local inst = CreateEntity()
	inst.entity:AddTransform()
	inst.entity:AddAnimState()

    MakeInventoryPhysics(inst)
    
    inst.AnimState:SetBank("moditem")
    inst.AnimState:SetBuild("bottle_g")
    inst.AnimState:PlayAnimation("idle")
    
    inst:AddComponent("inventoryitem")
	inst.components.inventoryitem.atlasname = "images/inventoryimages/bottle_g.xml"

	inst:AddComponent("inspectable")
	
	inst:AddTag("irreplaceable")

    inst:AddComponent("edible")
    inst.components.edible.healthvalue = (100)
    inst.components.edible.hungervalue = (math.huge) 

    inst.components.edible.foodtype = "HERO_POTION"
--    inst:AddComponent("healer")
--    inst.components.healer:SetHealthAmount(0)

inst:DoTaskInTime(0, function(inst)
	GetPlayer():ListenForEvent("onremove", function()
		GetPlayer().components.inventory:GiveItem( SpawnPrefab("bottle_e") )
	end, inst)
end)

--[[
inst:DoTaskInTime(0, function(inst)
	GetPlayer():ListenForEvent("onremove", function()
		GetPlayer().components.hunger:SetCurrent(math.huge)
	end, inst)
end)
--]]
    
    return inst
end

return Prefab( "common/inventory/bottle_g", fn, Assets)

