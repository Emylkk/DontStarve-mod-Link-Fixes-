local assets=
{
	Asset("ANIM", "anim/tunic_blue.zip"),
  Asset("ATLAS", "images/inventoryimages/tunic_blue.xml")
}


local function onequip(inst, owner) 
--    owner.AnimState:OverrideSymbol("swap_body", "tunic_blue", "swap_body")
    owner.components.temperature.hurtrate = 0
    owner.AnimState:SetBuild("bink")
end

local function onunequip(inst, owner) 
    owner.AnimState:ClearOverrideSymbol("swap_body")
    owner.components.temperature.hurtrate = TUNING.WILSON_HEALTH / TUNING.FREEZING_KILL_TIME
    owner.AnimState:SetBuild("link")
end

local function fn(Sim)
	local inst = CreateEntity()
    
	inst.entity:AddTransform()
	inst.entity:AddAnimState()
    MakeInventoryPhysics(inst)

    inst.AnimState:SetBank("armor_marble")
    inst.AnimState:SetBuild("tunic_blue")
    inst.AnimState:PlayAnimation("anim")
    
    inst:AddComponent("armor")
      inst.components.armor:InitCondition(math.huge, 0.999 )
      inst:DoTaskInTime(0, function(inst)
        inst.components.armor:SetCondition(math.huge)
      end)
    
    inst:AddComponent("inspectable")
    
    inst:AddTag("irreplaceable")
    
    inst:AddComponent("inventoryitem")
    	 inst.components.inventoryitem.atlasname = "images/inventoryimages/tunic_blue.xml"
    
    inst:AddComponent("equippable")
      inst.components.equippable.equipslot = EQUIPSLOTS.BODY
      inst.components.equippable:SetOnEquip( onequip )
      inst.components.equippable:SetOnUnequip( onunequip )
    
    inst:AddComponent("heater")
		  inst.components.heater.iscooler = true
      inst.components.heater.equippedheat = 60
    
   	inst:AddComponent("insulator")
      inst.components.insulator.insulation = (TUNING.INSULATION_LARGE * 4)

    inst:AddTag("venting")
    inst:AddTag("fogproof")
    
    inst:AddComponent("waterproofer")
      inst.components.waterproofer:SetEffectiveness(TUNING.WATERPROOFNESS_ABSOLUTE)
    return inst
end


return Prefab( "common/inventory/tunic_blue", fn, assets ) 
