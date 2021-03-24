local assets=
{
	       Asset("ANIM", "anim/trulens.zip"),
	       Asset("ANIM", "anim/swap_trulens.zip"),
        Asset("ATLAS", "images/inventoryimages/trulens.xml")
}

------------------------------------
local function fireproof(val, owner)
 --   if owner.components.health then
  --      owner.components.sanity.inducedinsanity = val
 --   end
    if owner.components.sanitymonsterspawner then
        --Ensure the popchangetimer fully ticks over by running max tick time twice.
        owner.components.sanitymonsterspawner:UpdateMonsters(20)
        owner.components.sanitymonsterspawner:UpdateMonsters(20)
    end

    local pt = owner:GetPosition()
    local ents = TheSim:FindEntities(pt.x,pt.y,pt.z, 100)

    for k,v in pairs(ents) do
        if (v:HasTag("rabbit") or v:HasTag("manrabbit")) and v.CheckTransformState ~= nil then
            v.CheckTransformState(v)
        end
    end

end
------------------------------------

local function onfinished(inst)
    inst:Remove()
end

local function onequip(inst, owner) 
    owner.AnimState:OverrideSymbol("swap_object", "swap_trulens", "swap_ham_bat")
    owner.AnimState:Show("ARM_carry") 
    owner.AnimState:Hide("ARM_normal") 
    
    owner.components.sanity.inducedinsanity = true
    owner:PushEvent("goinsane", {})
    --[[------
    if owner.components.sanitymonsterspawner then
        --Ensure the popchangetimer fully ticks over by running max tick time twice.
        owner.components.sanitymonsterspawner:UpdateMonsters(20)
        owner.components.sanitymonsterspawner:UpdateMonsters(20)
    end
    --]]------
end

local function onunequip(inst, owner) 
    owner.AnimState:Hide("ARM_carry") 
    owner.AnimState:Show("ARM_normal") 
    
    owner.components.sanity.inducedinsanity = false
    owner:PushEvent("gosane", {})
end


local function fn(Sim)
	local inst = CreateEntity()
	local trans = inst.entity:AddTransform()
	local anim = inst.entity:AddAnimState()
    MakeInventoryPhysics(inst)
    
    anim:SetBank("ham_bat")
    anim:SetBuild("trulens")
    anim:PlayAnimation("idle")
    
    -------
    
    inst:AddComponent("inspectable")
    
    inst:AddTag("irreplaceable")
    
    inst:AddComponent("inventoryitem")
  	 inst.components.inventoryitem.atlasname = "images/inventoryimages/trulens.xml"
    
    inst:AddComponent("equippable")
    inst.components.equippable:SetOnEquip( onequip )
    inst.components.equippable:SetOnUnequip( onunequip )
    
    inst:AddComponent("weapon")
    inst.components.weapon:SetDamage(TUNING.BUGNET_DAMAGE)
    
    return inst
end

return Prefab( "common/inventory/trulens", fn, assets) 