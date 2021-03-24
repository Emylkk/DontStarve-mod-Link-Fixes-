local assets=
{
	Asset("ANIM", "anim/herolan.zip"),
	Asset("ANIM", "anim/swap_herolan.zip"),
	Asset("ATLAS", "images/inventoryimages/herolan.xml"),
		Asset("SOUND", "sound/common.fsb")
}

local prefabs=
{
	"torchfire",
}


local function turnon(inst)
	if not inst.components.fueled:IsEmpty() then
		if not inst.components.machine.ison then
			if inst.components.fueled then
				inst.components.fueled:StartConsuming()		
				
			 inst:AddComponent("heater")
        inst.components.heater.heat = 70
--        inst.components.heater.carriedheat = 70
        inst.components.heater.equippedheat = 70
			end
			inst.Light:Enable(true)
			inst.AnimState:PlayAnimation("idle_off")
				
			assert( not inst.fire )
			
			if inst.components.equippable:IsEquipped() then
				--inst.components.inventoryitem.owner.AnimState:OverrideSymbol("swap_object", "swap_herolan", "swap_lantern_on")
				inst.components.inventoryitem.owner.AnimState:OverrideSymbol("swap_object", "swap_herolan", "swap_lantern_off")
				--inst.components.inventoryitem.owner.AnimState:Show("LANTERN_OVERLAY") 
				inst.components.inventoryitem.owner.AnimState:Hide("LANTERN_OVERLAY") 

				local function callback(owner)
					inst.fire = SpawnPrefab( "torchfire" )
					inst.fire.Transform:SetScale(9, 9, 9)
					local follower = inst.fire.entity:AddFollower()
					follower:FollowSymbol( owner.GUID, "swap_object", 63, 15, -0.0001 )
					inst:RemoveEventCallback("animover", callback, owner)
				end
				inst:ListenForEvent("animover", callback, inst.components.inventoryitem.owner)
			else
		--		print 'adding fire'
				inst.fire = SpawnPrefab( "torchfire" )
				inst.fire.Transform:SetScale(9, 9, 9)
				local follower = inst.fire.entity:AddFollower()
				follower:FollowSymbol( inst.GUID, "herolan01", -0, -60, -0.0001 )
			end
			inst.components.machine.ison = true

			inst.SoundEmitter:PlaySound("dontstarve/wilson/torch_swing")
			inst.SoundEmitter:PlaySound("dontstarve/wilson/torch_LP", "torch")

			inst.components.inventoryitem:ChangeImageName("herolan")
		end
	end
end

local function turnoff(inst)
	if inst.components.fueled then
		inst.components.fueled:StopConsuming()		
		
		inst:RemoveComponent("heater")
	end

	inst.Light:Enable(false)
	inst.AnimState:PlayAnimation("idle_off")

	if inst.components.equippable:IsEquipped() then
		inst.components.inventoryitem.owner.AnimState:OverrideSymbol("swap_object", "swap_herolan", "swap_lantern_off")
		--inst.components.inventoryitem.owner.AnimState:Hide("LANTERN_OVERLAY") 
	end

	if inst.fire then
		inst.fire:Remove()
		inst.fire = nil
	end

	inst.components.machine.ison = false

	inst.SoundEmitter:KillSound("torch")
	inst.SoundEmitter:PlaySound("dontstarve/common/fireOut")

	inst.components.inventoryitem:ChangeImageName("herolan")
end

local function OnLoad(inst, data)
	if inst.components.machine and inst.components.machine.ison then
		inst.AnimState:PlayAnimation("idle_on")
		turnon(inst)
	else
		inst.AnimState:PlayAnimation("idle_off")
		turnoff(inst)
	end
end

local function ondropped(inst)
	turnoff(inst)
	turnon(inst)
end

local function onpickup(inst)
	turnon(inst)
end

local function onputininventory(inst)
	turnoff(inst)
end

local function onequip(inst, owner) 
	owner.AnimState:Show("ARM_carry") 
	owner.AnimState:Hide("ARM_normal")
	--owner.AnimState:OverrideSymbol("lantern_overlay", "swap_herolan", "lantern_overlay")

	owner.AnimState:Hide("LANTERN_OVERLAY")

	owner.AnimState:OverrideSymbol("swap_object", "swap_herolan", "swap_lantern_off")

	turnon(inst)
end

local function onunequip(inst, owner) 
	owner.AnimState:Hide("ARM_carry") 
	owner.AnimState:Show("ARM_normal")
	owner.AnimState:ClearOverrideSymbol("lantern_overlay")
	--owner.AnimState:Hide("LANTERN_OVERLAY")	 

	if inst.fire then
		inst.fire:Remove()
		inst.fire = nil
	end
end

local function nofuel(inst)
	local owner = inst.components.inventoryitem and inst.components.inventoryitem.owner
	if owner then
		owner:PushEvent("torchranout", {torch = inst})
	end

	turnoff(inst)
end

local function takefuel(inst)
	if inst.components.equippable and inst.components.equippable:IsEquipped() then
		turnon(inst)
	end
	inst.SoundEmitter:PlaySound("dontstarve/common/fireAddFuel")
end

local function fuelupdate(inst)
	local fuelpercent = inst.components.fueled:GetPercent()
	inst.Light:SetIntensity(Lerp(0.5, 0.8, fuelpercent))
	inst.Light:SetRadius(Lerp(3, 7, fuelpercent))
	inst.Light:SetFalloff(.9)
end


local function fn(Sim)
	local inst = CreateEntity()
	local trans = inst.entity:AddTransform()
	local anim = inst.entity:AddAnimState()
	inst.entity:AddSoundEmitter()		
	MakeInventoryPhysics(inst)
	
	inst.AnimState:SetBank("lantern")
	inst.AnimState:SetBuild("herolan")
	inst.AnimState:PlayAnimation("idle_off")

	-- anim:SetBank("lantern")
	-- anim:SetBuild("lantern")
	-- anim:PlayAnimation("idle_off")

	inst:AddTag("light")

	inst:AddComponent("inspectable")
	
	inst:AddTag("irreplaceable")
	
	inst:AddComponent("inventoryitem")
	inst.components.inventoryitem.atlasname = "images/inventoryimages/herolan.xml"

	inst.components.inventoryitem:SetOnDroppedFn(ondropped)
	--inst.components.inventoryitem:SetOnPickupFn(makesmalllight)
	--inst.components.inventoryitem:SetOnActiveItemFn(makesmalllight)
	inst.components.inventoryitem:SetOnPutInInventoryFn(onputininventory)	

	inst:AddComponent("equippable")

	inst:AddComponent("fueled")
	inst.components.fueled:SetSectionCallback(function(newsection, oldsection)
		if newsection == 0 then
			if inst.components.lighter then
				inst:RemoveComponent("lighter")
				
--    inst:RemoveComponent("heater")
			end
		elseif oldsection == 0 then
			if not inst.components.lighter then
				inst:AddComponent("lighter")
				inst.components.lighter.onlight = function()
local curfuel = inst.components.fueled:GetPercent()
inst.components.fueled:SetPercent(curfuel - 0.01)
end

				
--    inst:AddComponent("heater")
--        inst.components.heater.heat = 20
--        inst.components.heater.carriedheat = 20
--        inst.components.heater.equippedheat = 20
			end
		end
	end)


	inst:AddComponent("machine")
	inst.components.machine.turnonfn = turnon
	inst.components.machine.turnofffn = turnoff
	inst.components.machine.cooldowntime = 0
    inst.components.machine.caninteractfn = function() return not inst.components.fueled:IsEmpty() and (inst.components.inventoryitem.owner == nil or inst.components.equippable.isequipped) end


	inst.components.fueled.fueltype = "BURNABLE"
	inst.components.fueled:InitializeFuelLevel(TUNING.LANTERN_LIGHTTIME * 0.3)
	inst.components.fueled:SetDepletedFn(nofuel)
	inst.components.fueled:SetUpdateFn(fuelupdate)
	inst.components.fueled.ontakefuelfn = takefuel
--	inst.components.fueled.ontakefuelfn = function() inst.SoundEmitter:PlaySound("dontstarve/common/fireAddFuel") end
	inst.components.fueled.accepting = true
	

	inst.entity:AddLight()
	inst.Light:SetColour(255/255, 235/255, 195/255)

	fuelupdate(inst)

	inst.components.equippable:SetOnEquip( onequip )
	inst.components.equippable:SetOnUnequip( onunequip ) 

	inst.OnLoad = OnLoad

	return inst
end


return Prefab( "common/inventory/herolan", fn, assets, prefabs)