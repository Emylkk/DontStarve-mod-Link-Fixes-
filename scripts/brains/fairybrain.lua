require "behaviours/follow"
--require "behaviours/wander"
require "behaviours/faceentity"
require "behaviours/leash"
 
--local LEASH_RETURN_DIST = 5
--local LEASH_MAX_DIST = 10

local MIN_FOLLOW_DIST = 2
local MAX_FOLLOW_DIST = 3
local TARGET_FOLLOW_DIST = 2

local MIN_FOLLOW_LEADER = 2
local MAX_FOLLOW_LEADER = 5
local TARGET_FOLLOW_LEADER = (MAX_FOLLOW_LEADER+MIN_FOLLOW_LEADER)/2

local LEASH_RETURN_DIST = 3.5
local LEASH_MAX_DIST = 5

local SIT_BOY_DIST = 5

--local MAX_WANDER_DIST = 2

local function GetFaceTargetFn(inst)
    return inst.components.follower.leader
end

local function KeepFaceTargetFn(inst, target)
    return inst.components.follower.leader == target
end

local function GetLeader(inst)
    return inst.components.follower and inst.components.follower.leader
end

local function GetHome(inst)
    return inst.components.homeseeker and inst.components.homeseeker.home
end

local function GetHomePos(inst)
    local home = GetHome(inst)
    return home and home:GetPosition()
end

local function GetNoLeaderLeashPos(inst)
    if GetLeader(inst) then
        return nil
    end
    return GetHomePos(inst)
end

local function GetNoLeaderLeashPos(inst)
    if GetLeader(inst) then
        return nil
    end
    return GetHomePos(inst)
end

--[[
local function GetWanderPoint(inst)
    local target = GetLeader(inst) or GetPlayer()

    if target then
        return target:GetPosition()
    end
end
--]]

local function ShouldStandStill(inst)
    return inst:HasTag("pet_hound") and not GetClock():IsDay() and not GetLeader(inst) and not inst.components.combat.target and inst:IsNear(GetHome(inst), SIT_BOY_DIST)
end

local FairyBrain = Class(Brain, function(self, inst)
    Brain._ctor(self, inst)
end)

function FairyBrain:OnStart()
    local root =
    PriorityNode({
--        WhileNode( function() return self.inst.components.health.takingfiredamage end, "OnFire", Panic(self.inst)),
        WhileNode(function() return not GetLeader(self.inst) end, "NoLeader", AttackWall(self.inst) ),

        Leash(self.inst, GetNoLeaderLeashPos, LEASH_MAX_DIST, LEASH_RETURN_DIST),
        Follow(self.inst, function() return self.inst.components.follower and self.inst.components.follower.leader end, MIN_FOLLOW_DIST, TARGET_FOLLOW_DIST, MAX_FOLLOW_DIST),
        --FaceEntity(self.inst, GetFaceTargetFn, KeepFaceTargetFn),
--        Wander(self.inst, function() return self.inst.components.knownlocations:GetLocation("home") end, MAX_WANDER_DIST),
        
        Follow(self.inst, GetLeader, MIN_FOLLOW_LEADER, TARGET_FOLLOW_LEADER, MAX_FOLLOW_LEADER),
        FaceEntity(self.inst, GetLeader, GetLeader),

        StandStill(self.inst, ShouldStandStill),

--        WhileNode(function() return GetHome(self.inst) end, "HasHome", Wander(self.inst, GetHomePos, 8) ),
--        Wander(self.inst, GetWanderPoint, 20),
    }, .25)
    
    self.bt = BT(self.inst, root)

end

return FairyBrain