local assets =
{
    Asset("ANIM", "anim/linksword.zip"),
   	Asset("ANIM", "anim/swap_linksword.zip"),
        Asset("ATLAS", "images/inventoryimages/linksword.xml")
}

local function onfinished(inst)
    inst:Remove()
end

local function onequip(inst, owner)
    owner.AnimState:OverrideSymbol("swap_object", "swap_linksword", "swap_nightmaresword")
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
	 MakeInventoryPhysics(inst)
	 
	 anim:SetBank("nightmaresword")
	 anim:SetBuild("linksword")
	 anim:PlayAnimation("idle")
	 
    inst:AddTag("sharp")
    
    inst:AddComponent("weapon")
    inst.components.weapon:SetDamage(TUNING.SPEAR_DAMAGE * 2.5)
    inst:AddComponent("lighter")
    
	inst:AddComponent("tool")
    
    inst.components.tool:SetAction(ACTIONS.CHOP,5)
    inst.components.tool:SetAction(ACTIONS.HACK,1)
    inst.components.tool:SetAction(ACTIONS.HARVEST,5)
    inst.components.tool:SetAction(ACTIONS.SHAVE)
    
    inst:AddTag("light")
	 inst:AddComponent("inventoryitem")
	 inst.components.inventoryitem.atlasname = "images/inventoryimages/linksword.xml"

     local light = inst.entity:AddLight()
     light:SetFalloff(0.7)
     light:SetIntensity(.5)
     light:SetRadius(0.5)
     light:SetColour(237/255, 237/255, 209/255)
    light:Enable(true)
    inst.AnimState:SetBloomEffectHandle( "shaders/anim.ksh" )
       inst:AddComponent("inspectable")
       
   	
   	inst:AddTag("irreplaceable")
    
    inst:AddComponent("equippable")
    inst.components.equippable:SetOnEquip( onequip )
    inst.components.equippable:SetOnUnequip( onunequip )
    
    return inst
	 
end

return Prefab( "common/inventory/linksword", fn, assets)
