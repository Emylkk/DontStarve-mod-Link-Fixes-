local assets=
{
	Asset("ANIM", "anim/bombs.zip"),
	Asset("ANIM", "anim/explode.zip"),
	Asset("ATLAS", "images/inventoryimages/bombs.xml")
}

local prefabs =
{
		"explode_small"
}
local function OnIgniteFn(inst)
    inst.SoundEmitter:PlaySound("dontstarve/common/blackpowder_fuse_LP", "hiss")
end


local function OnExplodeFn(inst)
	local pos = Vector3(inst.Transform:GetWorldPosition())
	inst.SoundEmitter:PlaySound("dontstarve/common/blackpowder_explo")

	local explode = SpawnPrefab("explode_small")
	local pos = inst:GetPosition()
	explode.Transform:SetPosition(pos.x, pos.y, pos.z)

	--local explode = PlayFX(pos,"explode", "explode", "small")
	explode.AnimState:SetBloomEffectHandle( "shaders/anim.ksh" )
	explode.AnimState:SetLightOverride(1)
end

local function OnFuseEnd( inst )
	inst.components.explosive:OnBurnt()
end


local function fn(Sim)
	local inst = CreateEntity()
	inst.entity:AddTransform()
	inst.entity:AddAnimState()
	inst.entity:AddSoundEmitter()		
	MakeInventoryPhysics(inst)
	
	inst.AnimState:SetBank("heat_rock")
	inst.AnimState:SetBuild("bombs")
	inst.AnimState:PlayAnimation(3)
	inst.AnimState:SetBloomEffectHandle( "shaders/anim.ksh" )
	
	inst:AddComponent("inspectable")

	inst:AddComponent("stackable")
	inst.components.stackable.maxsize = 40

	inst:AddComponent("explosive")
    inst.components.explosive:SetOnExplodeFn(OnExplodeFn)
    inst.components.explosive:SetOnIgniteFn(OnIgniteFn)
    inst.components.explosive.explosivedamage = TUNING.GUNPOWDER_DAMAGE

	inst:AddComponent("burnable")
	-- burntime is the delay before exploding when ignited (by a flame or other bombs)
	MakeSmallBurnable(inst, 3+math.random()*3)

	MakeSmallPropagator(inst)
	--inst.components.propagator.flashpoint = 0  -- flashpoint of 0 means any spreading fire at all will ignite it

	inst:AddComponent("heroicfuse")
	inst.components.heroicfuse:SetLength( 5 )
	inst.components.heroicfuse:SetSound( "dontstarve/common/blackpowder_fuse_LP" )
	-- first parameter is default animation name, second is a table of { percent_of_fuselength, animname } pairs
	inst.components.heroicfuse:SetAnimTiming( 3, { 
		{.16, 3}, {.32, 5}, {.48, 3}, {.64, 5}, {.70, 3}, {.76, 5}, {.82, 3}, 
		{.84, 4}, {.86, 2}, {.88, 4}, {.90, 2}, {.92, 4}, {.94, 2}, {.96, 4}, 
		{.98, 2}
	} )
	inst.components.heroicfuse:SetOnFuseEndFn( OnFuseEnd )
	
	inst:AddComponent("inventoryitem")
	inst.components.inventoryitem.atlasname = "images/inventoryimages/bombs.xml"
	
	--inst:AddComponent("singledroppable")

	inst:ListenForEvent("onsingledropped", function(inst)
		inst.components.heroicfuse:Light()

		-- can't pick lit bombs back up
		if inst.components.inventoryitem then
			inst:RemoveComponent("inventoryitem")
		end
	end)

	inst:ListenForEvent("ondropped", function(inst)
		-- dropped inv items have a propagator delay of 5 seconds set, so we need to get rid of that
		-- we have to do this after a frame because the delay gets set after the ondropped event gets pushed
		inst:DoTaskInTime(0, function() 
			inst.components.propagator.delay = false; 
		end)
	end)
	
	return inst
end

return Prefab( "common/inventory/bombs", fn, assets, prefabs) 
