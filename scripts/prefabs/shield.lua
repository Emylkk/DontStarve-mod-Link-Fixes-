local assets=
{
	Asset("ANIM", "anim/shield.zip"),
	Asset("ANIM", "anim/swap_shield.zip"),
	Asset("ATLAS", "images/inventoryimages/shield.xml")
}

local function onequip(inst, owner) 
    owner.AnimState:OverrideSymbol("swap_body", "swap_shield", "backpack")
    owner.AnimState:OverrideSymbol("swap_body", "swap_shield", "swap_body")
    owner.components.inventory:SetOverflow(inst)
    inst.components.container:Open(owner)
	
end

local function onunequip(inst, owner) 
    owner.AnimState:ClearOverrideSymbol("swap_body")
    owner.AnimState:ClearOverrideSymbol("backpack")
    owner.components.inventory:SetOverflow(nil)
    inst.components.container:Close(owner)
end


local function onopen(inst)
	inst.SoundEmitter:PlaySound("dontstarve/wilson/backpack_open", "open")
end

local function onclose(inst)
	inst.SoundEmitter:PlaySound("dontstarve/wilson/backpack_close", "open")
end


local slotpos = {}

for y = 0, 6 do
	table.insert(slotpos, Vector3(-162, -y*75 + 240 ,0))
	table.insert(slotpos, Vector3(-162 +75, -y*75 + 240 ,0))
end

local function fn(Sim)
	local inst = CreateEntity()
    
	inst.entity:AddTransform()
	inst.entity:AddAnimState()
	inst.entity:AddSoundEmitter()
    MakeInventoryPhysics(inst)
    
    inst.AnimState:SetBank("backpack1")
    inst.AnimState:SetBuild("swap_shield")
    inst.AnimState:PlayAnimation("anim")

	local minimap = inst.entity:AddMiniMapEntity()
	minimap:SetIcon("backpack.png")
    
	   inst:AddComponent("inventoryitem")
  	 inst.components.inventoryitem.atlasname = "images/inventoryimages/shield.xml"
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
    inst.components.armor:InitCondition(math.huge, 0.99 )
    inst:DoTaskInTime(0, function(inst)
    inst.components.armor:SetCondition(math.huge)
end)

   	inst:AddComponent("inspectable")
   	
   	inst:AddTag("irreplaceable")
    
    inst:AddComponent("container")
    inst.components.container:SetNumSlots(#slotpos)
    inst.components.container.widgetslotpos = slotpos
    inst.components.container.widgetanimbank = "ui_krampusbag_2x8"
    inst.components.container.widgetanimbuild = "ui_krampusbag_2x8"
    inst.components.container.widgetpos = Vector3(-5,-75,0)
	inst.components.container.side_widget = true    
    inst.components.container.type = "pack"
   
    inst.components.container.onopenfn = onopen
    inst.components.container.onclosefn = onclose
        
    return inst
end

return Prefab( "common/inventory/shield", fn, assets) 
