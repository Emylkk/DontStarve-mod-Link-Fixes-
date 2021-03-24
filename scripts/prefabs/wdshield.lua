local assets=
{
	Asset("ANIM", "anim/wdshield.zip"),
	Asset("ANIM", "anim/swap_wdshield.zip"),
	Asset("ATLAS", "images/inventoryimages/wdshield.xml")
}

local function onequip(inst, owner) 
    owner.AnimState:OverrideSymbol("swap_body", "swap_wdshield", "backpack")
    owner.AnimState:OverrideSymbol("swap_body", "swap_wdshield", "swap_body")
    owner.components.inventory.overflow = inst
    inst.components.container:Open(owner)
end

local function onunequip(inst, owner) 
    owner.AnimState:ClearOverrideSymbol("swap_body")
    owner.AnimState:ClearOverrideSymbol("backpack")
    owner.components.inventory.overflow = nil
    inst.components.container:Close(owner)
end


local function onopen(inst)
	inst.SoundEmitter:PlaySound("dontstarve/wilson/backpack_open", "open")
end

local function onclose(inst)
	inst.SoundEmitter:PlaySound("dontstarve/wilson/backpack_close", "open")
end


local slotpos = {}

for y = 0, 3 do
	table.insert(slotpos, Vector3(-162 +37, -y*75 + 114 ,0))
--	table.insert(slotpos, Vector3(-162 +75, -y*75 + 114 ,0))
end

local function fn(Sim)
	local inst = CreateEntity()
    
	inst.entity:AddTransform()
	inst.entity:AddAnimState()
	inst.entity:AddSoundEmitter()
    MakeInventoryPhysics(inst)
    
    inst.AnimState:SetBank("backpack1")
    inst.AnimState:SetBuild("swap_wdshield")
    inst.AnimState:PlayAnimation("anim")

	local minimap = inst.entity:AddMiniMapEntity()
	minimap:SetIcon("backpack.png")
    
	   inst:AddComponent("inventoryitem")
  	 inst.components.inventoryitem.atlasname = "images/inventoryimages/wdshield.xml"
    inst.components.inventoryitem.cangoincontainer = true
    inst.components.inventoryitem.foleysound = "dontstarve/movement/foley/backpack"

    inst:AddComponent("equippable")
  if EQUIPSLOTS["BACK"] then
     	inst.components.equippable.equipslot = EQUIPSLOTS.BACK
  elseif EQUIPSLOTS["PACK"] then
     	inst.components.equippable.equipslot = EQUIPSLOTS.PACK
  else
     	inst.components.equippable.equipslot = EQUIPSLOTS.BODY
  end
    
    inst.components.equippable:SetOnEquip( onequip )
    inst.components.equippable:SetOnUnequip( onunequip )
    
    inst:AddComponent("armor")
    inst.components.armor:InitCondition(TUNING.ARMORWOOD * 0.66667, 0.5 )
    
   	inst:AddComponent("inspectable")
    
    inst:AddComponent("container")
    inst.components.container:SetNumSlots(4)
    inst.components.container.widgetslotpos = slotpos
    inst.components.container.widgetanimbank = "ui_backpack_2x4"
    inst.components.container.widgetanimbuild = "ui_backpack_2x4"
    inst.components.container.widgetpos = Vector3(-120,-5,0)
    inst.components.container.side_widget = true
   
    inst.components.container.onopenfn = onopen
    inst.components.container.onclosefn = onclose
    
----------------------------------------------------------------

    ---------------------
    inst:AddComponent("fuel")
    inst.components.fuel.fuelvalue = TUNING.SMALL_FUEL


    inst:AddComponent("edible")
    inst.components.edible.foodtype = "WOOD"
    inst.components.edible.woodiness = 5

    ---------------------        
	MakeSmallBurnable(inst, TUNING.SMALL_BURNTIME)
    MakeSmallPropagator(inst)

----------------------------------------------------------------
 
    
    return inst
end

return Prefab( "common/inventory/wdshield", fn, assets) 
