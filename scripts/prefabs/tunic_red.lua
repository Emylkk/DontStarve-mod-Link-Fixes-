local assets=
{
	Asset("ANIM", "anim/tunic_red.zip"),
  Asset("ATLAS", "images/inventoryimages/tunic_red.xml")
}

local function GetHeatFn(inst)
	return -200
end

local function onequip(inst, owner) 
--    owner.AnimState:OverrideSymbol("swap_body", "tunic_red", "swap_body")
    owner.components.health.fire_damage_scale = 0
    owner:AddTag("wearingredtunic")
    owner.AnimState:SetBuild("rink")
end

local function onunequip(inst, owner) 
    owner.AnimState:ClearOverrideSymbol("swap_body")
    owner:RemoveTag("wearingredtunic")
  if not owner:HasTag("dinsfire") then
         owner.components.health.fire_damage_scale = 1
  end
    owner.AnimState:SetBuild("link")
end

local function fn(Sim)
  local inst = CreateEntity()
  
  inst:AddComponent("insulator")
  inst.components.insulator:SetSummer()
  inst.components.insulator:SetInsulation(TUNING.INSULATION_LARGE*4)
  inst.components.insulator:SetSummer()
  
  
  inst:AddComponent("heater")
		inst.components.heater.iscooler = true
		inst.components.heater.equippedheat = -60

	inst.entity:AddTransform()
	inst.entity:AddAnimState()
    MakeInventoryPhysics(inst)

    inst.AnimState:SetBank("armor_marble")
    inst.AnimState:SetBuild("tunic_red")
    inst.AnimState:PlayAnimation("anim")
    
    inst:AddComponent("armor")
    inst.components.armor:InitCondition(math.huge, 0.99 )
    inst:DoTaskInTime(0, function(inst)
    inst.components.armor:SetCondition(math.huge)
end)
    inst:AddComponent("inspectable")
    
    inst:AddTag("irreplaceable")
    
    inst:AddComponent("inventoryitem")
  	 inst.components.inventoryitem.atlasname = "images/inventoryimages/tunic_red.xml"
    
    inst:AddComponent("equippable")
    inst.components.equippable.equipslot = EQUIPSLOTS.BODY
    inst.components.equippable.insulated = true
      
    inst.components.equippable:SetOnEquip( onequip )
    inst.components.equippable:SetOnUnequip( onunequip )
    
    return inst
end


return Prefab( "common/inventory/tunic_red", fn, assets ) 
