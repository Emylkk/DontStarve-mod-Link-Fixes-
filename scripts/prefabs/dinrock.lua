local assets=
{
	Asset("ANIM", "anim/dinrock.zip"),
	Asset("ATLAS", "images/inventoryimages/dinrock.xml")
}

local function HeatFn(inst, observer)
	return inst.components.temperature:GetCurrent()
end

local function fn(Sim)
	local inst = CreateEntity()
	inst.entity:AddTransform()
	inst.entity:AddAnimState()

    MakeInventoryPhysics(inst)
    
    inst.AnimState:SetBank("heat_rock")
    inst.AnimState:SetBuild("dinrock")
    inst.AnimState:PlayAnimation(5)
    inst.AnimState:SetBloomEffectHandle( "shaders/anim.ksh" )
    
    inst:AddComponent("inspectable")
    
    inst:AddTag("irreplaceable")

    inst:AddComponent("inventoryitem")
  	 inst.components.inventoryitem.atlasname = "images/inventoryimages/dinrock.xml"
  	 
	
	--inst:AddComponent("singledroppable")

	
    inst.entity:AddLight()
	inst.Light:SetRadius(.6)
    inst.Light:SetFalloff(1)
    inst.Light:SetIntensity(.5)
    inst.Light:SetColour(235/255,165/255,12/255)
	inst.Light:Enable(true)


	--
	  inst:ListenForEvent("onsingledropped", function(inst)
          --if inst.didwedropsingle == true then
          local fire = SpawnPrefab("dinfire")
          fire.Transform:SetPosition(inst.Transform:GetWorldPosition())
            GetPlayer().components.health.fire_damage_scale = 0
            GetPlayer():AddTag("dinsfire")
            inst:Remove()
          ------------------------------
         	GetPlayer().components.inventory:GiveItem( SpawnPrefab("dinrock") )
          ------------------------------
          inst:DoTaskInTime(15, function(inst)
            if not GetPlayer():HasTag("wearingredtunic") then
         	    GetPlayer().components.health.fire_damage_scale = 1
         	    GetPlayer():RemoveTag("dinsfire")
         	  end
	         end, inst)
--end
   end)

 	
	return inst
end

return Prefab( "common/inventory/dinrock", fn, assets) 
