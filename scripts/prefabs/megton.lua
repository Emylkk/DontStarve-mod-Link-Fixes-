local assets=
{
	Asset("ANIM", "anim/megton.zip"),
	Asset("ANIM", "anim/swap_megton.zip"),
	Asset("ATLAS", "images/inventoryimages/megton.xml")
}

local prefabs =
{
	"collapse_small",
	"collapse_big",
}

local function onfinished(inst)
    inst:Remove()
end
    

local function onequip(inst, owner) 
    owner.AnimState:OverrideSymbol("swap_object", "swap_megton", "swap_hammer")
    owner.AnimState:Show("ARM_carry") 
    owner.AnimState:Hide("ARM_normal") 
end

local function onunequip(inst, owner) 
    owner.AnimState:Hide("ARM_carry") 
    owner.AnimState:Show("ARM_normal") 
end
    
local function fn(Sim)
	local inst = CreateEntity()
	local trans = inst.entity:AddTransform()
	local anim = inst.entity:AddAnimState()
	inst.entity:AddSoundEmitter()
    MakeInventoryPhysics(inst)
    
    anim:SetBank("hammer")
    anim:SetBuild("megton")
    anim:PlayAnimation("idle")
    
    
    inst:AddComponent("weapon")
    inst.components.weapon:SetDamage(TUNING.HAMMER_DAMAGE * 1.8)

    -----
    inst:AddComponent("tool")
    inst.components.tool:SetAction(ACTIONS.HAMMER)
    inst.components.tool:SetAction(ACTIONS.MINE,2)
    -----
    
    inst:AddComponent("inventoryitem")
    inst.components.inventoryitem.atlasname = "images/inventoryimages/megton.xml"
    
   	inst:AddComponent("inspectable")
   	
   	inst:AddTag("irreplaceable")
    
    inst:AddComponent("equippable")

    inst.components.equippable:SetOnEquip( onequip )
    inst.components.equippable:SetOnUnequip( onunequip )
    
    return inst
end


return Prefab( "common/inventory/megton", fn, assets, prefabs) 
