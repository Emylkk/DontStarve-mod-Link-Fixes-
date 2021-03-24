local assets=
{
	Asset("ANIM", "anim/nayrurock.zip"),
	Asset("ATLAS", "images/inventoryimages/nayrurock.xml")
}

local function HeatFn(inst, observer)
	return inst.components.temperature:GetCurrent()
end
local function GetStatus(inst)
	if inst.currentTempRange == 1 then
		return "COLD"
	elseif inst.currentTempRange == 5 then
		return "HOT"
	elseif inst.currentTempRange == 4 or inst.currentTempRange == 3 then
		return "WARM"
	end
end

local function fn(Sim)
	local inst = CreateEntity()
	inst.entity:AddTransform()
	inst.entity:AddAnimState()

    MakeInventoryPhysics(inst)
    
    inst.AnimState:SetBank("heat_rock")
    inst.AnimState:SetBuild("nayrurock")
    inst.AnimState:PlayAnimation(5)
    inst.AnimState:SetBloomEffectHandle( "shaders/anim.ksh" )

    inst:AddComponent("inspectable")    
    inst.components.inspectable.getstatus = GetStatus

    inst:AddTag("irreplaceable")

    inst:AddComponent("inventoryitem")
  	inst.components.inventoryitem.atlasname = "images/inventoryimages/nayrurock.xml"
  	 
	
--	inst:AddComponent("singledroppable") 


   inst.entity:AddLight()
	inst.Light:SetRadius(.6)
    inst.Light:SetFalloff(1)
    inst.Light:SetIntensity(.5)
    inst.Light:SetColour(12/255,165/255,235/255)
	inst.Light:Enable(true)

  inst:AddComponent("temperature")
	inst.components.temperature.maxtemp = 60
	inst.components.temperature.current = 1
  inst.components.temperature.inherentinsulation = TUNING.INSULATION_MED
  
  inst:AddComponent("heater")
	inst.components.heater.heatfn = HeatFn
	inst.components.heater.carriedheatfn = HeatFn
	--[[
	  inst:ListenForEvent("ondropped", function(inst)
          local fire = SpawnPrefab("dinfire")
          fire.Transform:SetPosition(inst.Transform:GetWorldPosition())
            GetPlayer().components.health.fire_damage_scale = 0
            GetPlayer():AddTag("dinsfire")
          ------------------------------
          inst:DoTaskInTime(15, function(inst)
            if not GetPlayer():HasTag("wearingredtunic") then
         	    GetPlayer().components.health.fire_damage_scale = 1
         	    GetPlayer():RemoveTag("dinsfire")
         	  end
	         end, inst)
end)
 --]]
 	
	return inst
end

return Prefab( "common/inventory/nayrurock", fn, assets) 
