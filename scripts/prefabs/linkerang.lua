local assets=
{
	Asset("ANIM", "anim/linkerang.zip"),
	Asset("ANIM", "anim/swap_linkerang.zip"),
	    Asset("ATLAS", "images/inventoryimages/linkerang.xml")
}

    
local prefabs =
{
}

local function OnFinished(inst)
    inst.AnimState:PlayAnimation("used")
    inst:ListenForEvent("animover", function() inst:Remove() end)
end

local function OnEquip(inst, owner) 
    owner.AnimState:OverrideSymbol("swap_object", "swap_linkerang", "swap_boomerang")
    owner.AnimState:Show("ARM_carry") 
    owner.AnimState:Hide("ARM_normal") 
end

local function OnDropped(inst)
    inst.AnimState:PlayAnimation("idle")
end

local function OnUnequip(inst, owner) 
    owner.AnimState:Hide("ARM_carry") 
    owner.AnimState:Show("ARM_normal") 
end

local function OnThrown(inst, owner, target)
    if target ~= owner then
        owner.SoundEmitter:PlaySound("dontstarve/wilson/boomerang_throw")
    end
    inst.AnimState:PlayAnimation("spin_loop", true)
end

local function OnCaught(inst, catcher)
    if catcher then
        if catcher.components.inventory then
            if inst.components.equippable and not catcher.components.inventory:GetEquippedItem(inst.components.equippable.equipslot) then
				catcher.components.inventory:Equip(inst)
			else
                catcher.components.inventory:GiveItem(inst)
            end
            catcher:PushEvent("catch")
        end
    end
end

local function ReturnToOwner(inst, owner)
    if owner and not (inst.components.finiteuses and inst.components.finiteuses:GetUses() < 1) then
        owner.SoundEmitter:PlaySound("dontstarve/wilson/boomerang_return")
        inst.components.projectile:Throw(owner, owner)
    end
end

--[[ added by no_signal for gathering loot
local function getLoot(player, point, dist)
	local ents = TheSim:FindEntities(point.x, point.y, point.z, dist)
	for k,v in pairs(ents) do
		if v.components.inventoryitem and not v.components.projectile and
			not v.components.combat and not v.components.inventoryitem.owner then
				player.components.inventory:GiveItem(v)
		end
	end
end
---]]

local function OnHit(inst, owner, target)
    if owner == target then
        OnDropped(inst)
	else
		if target.components.inventoryitem and not target.components.lootdropper then
			owner.components.inventory:GiveItem(target,nil,owner:GetPosition() )	
		end
		
		ReturnToOwner(inst, owner)
    end
    local impactfx = SpawnPrefab("impact")
	--  2 lines added by no_signal for gathering loot
--	if target.components.combat then -- this line
		if impactfx then
			local follower = impactfx.entity:AddFollower()
			follower:FollowSymbol(target.GUID, target.components.combat.hiteffectsymbol, 0, 0, 0 )
			impactfx:FacePoint(Vector3(inst.Transform:GetWorldPosition()))
		end
-- end -- and this line
end


local function fn(Sim)
	local inst = CreateEntity()
	local trans = inst .entity:AddTransform()
	local anim = inst.entity:AddAnimState()
    MakeInventoryPhysics(inst)
    RemovePhysicsColliders(inst)
    
    anim:SetBank("boomerang")
    anim:SetBuild("linkerang")
    anim:PlayAnimation("idle")
    anim:SetRayTestOnBB(true);
    
    inst:AddTag("projectile")
    inst:AddTag("thrown")
    
    inst:AddComponent("weapon")
    inst.components.weapon:SetDamage(TUNING.BEAVER_DAMAGE)
    inst.components.weapon:SetRange(TUNING.BOOMERANG_DISTANCE, TUNING.BOOMERANG_DISTANCE+3)
    -------
    
    inst:AddComponent("projectile")
    inst.components.projectile:SetSpeed(35)
    inst.components.projectile:SetCanCatch(true)
    inst.components.projectile:SetOnThrownFn(OnThrown)
    inst.components.projectile:SetOnHitFn(OnHit)
    inst.components.projectile:SetOnMissFn(ReturnToOwner)
    inst.components.projectile:SetOnCaughtFn(OnCaught)
	
	--
	local oldhit = inst.components.projectile.Hit
	function inst.components.projectile:Hit(target)
		if target == self.owner and target.components.catcher then
			target:PushEvent("catch", {projectile = self.inst}) 
			self.inst:PushEvent("caught", {catcher = target})
			self:Catch(target)
			target.components.catcher:StopWatching(self.inst)
		else
			oldhit(self, target)
		end
	end
--
	
	--[[---added by no_signal for gathering loot
	local oldOnUpdate = inst.components.projectile.OnUpdate
    function inst.components.projectile:OnUpdate(dt)
		oldOnUpdate(self,dt)
		local pos = self.inst:GetPosition()
		getLoot(self.owner,pos,1)
	end
	------]]
	
	 inst:AddComponent("inventoryitem")
	 inst.components.inventoryitem.atlasname = "images/inventoryimages/linkerang.xml"
    inst.components.inventoryitem:SetOnDroppedFn(OnDropped)
    
   	inst:AddComponent("inspectable")
   	
   	inst:AddTag("irreplaceable")
    
    inst:AddComponent("equippable")
    inst.components.equippable:SetOnEquip(OnEquip)
    inst.components.equippable:SetOnUnequip(OnUnequip)
    
    return inst
end

return Prefab( "common/inventory/linkerang", fn, assets)

