local Assets =
{
	Asset("ANIM", "anim/bottle_e.zip"),
    Asset("ATLAS", "images/inventoryimages/bottle_e.xml")
}

local function fn(Sim)
	local inst = CreateEntity()
	inst.entity:AddTransform()
	inst.entity:AddAnimState()

    MakeInventoryPhysics(inst)
    
    inst.AnimState:SetBank("moditem")
    inst.AnimState:SetBuild("bottle_e")
    inst.AnimState:PlayAnimation("idle")
    
    inst:AddComponent("inventoryitem")
	inst.components.inventoryitem.atlasname = "images/inventoryimages/bottle_e.xml"

    inst:AddComponent("inspectable")
    inst:AddComponent("stackable")
	inst.components.stackable.maxsize = 999
	
	inst:AddTag("irreplaceable")
    
    return inst
end

return Prefab( "common/inventory/bottle_e", fn, Assets)

