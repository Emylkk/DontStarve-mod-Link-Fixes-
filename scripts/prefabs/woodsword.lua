local assets =
{
    Asset("ANIM", "anim/woodsword.zip"),
   	Asset("ANIM", "anim/swap_woodsword.zip"),
	    Asset("ATLAS", "images/inventoryimages/woodsword.xml")
}

local function onfinished(inst)
    inst:Remove()
end

local function onequip(inst, owner)
    owner.AnimState:OverrideSymbol("swap_object", "swap_woodsword", "swap_nightmaresword")
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
	 anim:SetBuild("woodsword")
	 anim:PlayAnimation("idle")
	 
    inst:AddTag("sharp")
    
    inst:AddComponent("weapon")
    inst.components.weapon:SetDamage(TUNING.SPEAR_DAMAGE * 0.8)
----------------------------------------------------------------
    inst:AddComponent("finiteuses")
    inst.components.finiteuses:SetMaxUses(TUNING.NIGHTSWORD_USES)
    inst.components.finiteuses:SetUses(TUNING.NIGHTSWORD_USES)
    
    inst.components.finiteuses:SetOnFinished( onfinished )
----------------------------------------------------------------
    -----------------
    inst:AddComponent("fuel")
    inst.components.fuel.fuelvalue = TUNING.SMALL_FUEL


    inst:AddComponent("edible")
    inst.components.edible.foodtype = "WOOD"
    inst.components.edible.woodiness = 5

    ---------------------        
	MakeSmallBurnable(inst, TUNING.SMALL_BURNTIME)
    MakeSmallPropagator(inst)
----------------------------------------------------------------
	 inst:AddComponent("inventoryitem")
	 inst.components.inventoryitem.atlasname = "images/inventoryimages/woodsword.xml"
	 
 	inst:AddComponent("inspectable")
    
    inst:AddComponent("equippable")
    inst.components.equippable:SetOnEquip( onequip )
    inst.components.equippable:SetOnUnequip( onunequip )
    
    return inst
	 
end

return Prefab( "common/inventory/woodsword", fn, assets)
