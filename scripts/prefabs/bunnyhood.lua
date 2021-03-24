local assets=
{
	Asset("ANIM", "anim/bunnyhood.zip"),
	Asset("ATLAS", "images/inventoryimages/bunnyhood.xml")
}

local function onequip(inst, owner) 
        owner.AnimState:OverrideSymbol("swap_hat", "bunnyhood", "swap_hat")
        owner.AnimState:Show("HAT")
        owner.AnimState:Show("HAT_HAIR")
        owner.AnimState:Hide("HAIR_NOHAT")
        owner.AnimState:Hide("HAIR")
end

local function onunequip(inst, owner) 
        owner.AnimState:Hide("HAT")
        owner.AnimState:Hide("HAT_HAIR")
        owner.AnimState:Show("HAIR_NOHAT")
        owner.AnimState:Show("HAIR")
end


local function fn(Sim)
	local inst = CreateEntity()
	local trans = inst.entity:AddTransform()
	local anim = inst.entity:AddAnimState()
    MakeInventoryPhysics(inst)
    
    inst:AddTag("hat")
    
    anim:SetBank("featherhat")
    anim:SetBuild("bunnyhood")
    anim:PlayAnimation("anim")    
        
    inst:AddComponent("inspectable")
    

    inst:AddTag("irreplaceable")
    inst:AddTag("gasmask")
    inst:AddComponent("inventoryitem")
    inst.components.inventoryitem.atlasname = "images/inventoryimages/bunnyhood.xml"
    
    inst:AddComponent("equippable")
    inst.components.equippable.equipslot = EQUIPSLOTS.HEAD
    inst.components.equippable.walkspeedmult = 1.8
    inst.components.equippable.dapperness = TUNING.CRAZINESS_SMALL
        inst.components.equippable.poisongasblocker = true
    
    inst.components.equippable:SetOnEquip( onequip )
    inst.components.equippable:SetOnUnequip( onunequip )
    
    return inst
end

return Prefab( "common/inventory/bunnyhood", fn, assets) 
