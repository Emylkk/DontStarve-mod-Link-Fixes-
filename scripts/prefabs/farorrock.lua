local assets=
{
	Asset("ANIM", "anim/farorrock.zip"),
	Asset("ATLAS", "images/inventoryimages/farorrock.xml")
}

local function OnMark(inst, doer)
   if not inst.components.telestone.marked or not inst.components.telestone.markedcave then
   print "Parore's Wind Point Marked!"
   end
end

local function OnRecall(inst, doer)

	if doer:HasTag("player") then
		doer.components.health:SetInvincible(true)
		doer.components.playercontroller:Enable(false)
		
		TheFrontEnd:SetFadeLevel(1)
		doer:DoTaskInTime(4, function() 
			TheFrontEnd:Fade(true,2)
			doer.sg:GoToState("wakeup")
			local var = math.random(1,2)
		end)
		doer:DoTaskInTime(5, function()
			doer.components.health:SetInvincible(false)
			doer.components.playercontroller:Enable(true)
		end)
	end
   print "Warped to Point!"
end

local function OnReset(inst, doer)
print "Farore's Wind Reset!"
end

local function OnLoad(inst, data)
    if inst.components.telestone:IsMarked() and GetSeasonManager():GetSeason() ~= "caves" then
print "Farore Wind marcou Este Ponto."
	elseif inst.components.telestone:IsMarkedCave() and GetSeasonManager():GetSeason() == "caves" then
print "Farore Wind marcou Este Ponto."
	end
end

local function fn(Sim)
	local inst = CreateEntity()
	inst.entity:AddTransform()
	inst.entity:AddAnimState()

    MakeInventoryPhysics(inst)
    
    inst.AnimState:SetBank("heat_rock")
    inst.AnimState:SetBuild("farorrock")
    inst.AnimState:PlayAnimation(5)
    inst.AnimState:SetBloomEffectHandle( "shaders/anim.ksh" )

    inst:AddComponent("inspectable")    
    
    inst:AddTag("irreplaceable")

    inst:AddComponent("inventoryitem")
  	 inst.components.inventoryitem.atlasname = "images/inventoryimages/farorrock.xml"
	
    inst.entity:AddLight()
	inst.Light:SetRadius(.6)
    inst.Light:SetFalloff(1)
    inst.Light:SetIntensity(.5)
--    inst.Light:SetColour(235/255,165/255,12/255)
    inst.Light:SetColour(12/255,235/255,165/255)
	inst.Light:Enable(true)

inst:AddComponent("telestone")
	inst.components.telestone.onMark = OnMark
	inst.components.telestone.onReset = OnReset
	inst.components.telestone.onRecall = OnRecall
	
	inst.OnLoad = OnLoad
	
	return inst
end

return Prefab( "common/inventory/farorrock", fn, assets) 
