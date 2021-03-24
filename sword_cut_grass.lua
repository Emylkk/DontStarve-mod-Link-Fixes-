--
-- by no_signal
--

-- call from modmain with  
-- modimport "sword_cut_grass.lua"

-- new action to allow grass cutting
GLOBAL.STRINGS.ACTIONS.SWORDCUTGRASS = "Cut"
local ACTIONS = GLOBAL.ACTIONS
ACTIONS.SWORDCUTGRASS = GLOBAL.Action({mount_enabled=false})
ACTIONS.SWORDCUTGRASS.id = "SWORDCUTGRASS"
ACTIONS.SWORDCUTGRASS.str = GLOBAL.STRINGS.ACTIONS.SWORDCUTGRASS
ACTIONS.SWORDCUTGRASS.fn = function(act)
    if act.target.components.pickable then
        act.target.components.pickable:cutWithSword(act.doer)
        return true
    end
end

-- new state to handle animation based on do short action 
local swordCutGrass = GLOBAL.State{
    name = "swordcutgrass",
    tags = {"doing", "busy"},
        
    onenter = function(inst)
        inst.components.locomotor:Stop()
        inst.AnimState:PlayAnimation("atk")
		inst.SoundEmitter:PlaySound("dontstarve/wilson/attack_weapon")
		inst.sg:SetTimeout(6*GLOBAL.FRAMES)
    end,
        
    timeline=
    {
        GLOBAL.TimeEvent(4*GLOBAL.FRAMES, function( inst )
            inst.sg:RemoveStateTag("busy")
        end),
        GLOBAL.TimeEvent(10*GLOBAL.FRAMES, function( inst )
        inst.sg:RemoveStateTag("doing")
        inst.sg:AddStateTag("idle")
        end),
    },
        
    ontimeout = function(inst)
		inst:PerformBufferedAction()      
    end,
        
    events=
    {
        GLOBAL.EventHandler("animover", function(inst) if inst.AnimState:AnimDone() then inst.sg:GoToState("idle") end end ),
    },
}

-- add the new state and action handler to the stategraph
AddStategraphPostInit("wilson", function(sg)
	local actionHandler = GLOBAL.ActionHandler(ACTIONS.SWORDCUTGRASS, swordCutGrass.name)
	sg.actionhandlers[ACTIONS.SWORDCUTGRASS] = actionHandler
	sg.states[swordCutGrass.name] = swordCutGrass
end)

-- item drops go here
local function cutWithSwordFn(self,picker)
	if self.canbepicked and self.caninteractwith then
		
		local item = nil
		local randomNumber = math.random()
		if randomNumber <= 0.5 then -- 50%
			item = "rupee" 
		elseif randomNumber <= 0.7 then -- 20%
			item = nil -- magic jar
		elseif randomNumber <= 0.8 then -- 10%
			item = nil -- heart
		end		-- if randomNumber is greater then 0.8 do nothing
				-- 20% == nothing
				
		-- spawn the item
		if item then
			local heroloot = GLOBAL.SpawnPrefab(item)
			picker.components.inventory:GiveItem(heroloot, nil, GLOBAL.Vector3(TheSim:GetScreenPos(self.inst.Transform:GetWorldPosition())))
		end
		
		-- needed to give cut grass and to regrow the grass
		self:Pick(picker)
	end
end

-- used to mod CollectSceneAction
-- needed for the action to show up 
local function makeCollectSceneActionsFn(inst)
	-- store old function
	local oldCollect = inst.CollectSceneActions
	-- make new function
	inst.CollectSceneActions = function (self, doer, actions)
		-- get Equipped Item
		local item = doer.components.inventory:GetEquippedItem(GLOBAL.EQUIPSLOTS.HANDS)
		-- if using the sword cut the grass else use old function
		if self.canbepicked and self.caninteractwith and item and
		doer.prefab == "link" and item:HasTag("sharp") then
			table.insert(actions, ACTIONS.SWORDCUTGRASS)
		else
			oldCollect(self, doer, actions)
		end
	end
end

-- add new function and mod CollectSceneAction
local function grassPrefab(inst)
	local pick = inst.components.pickable
	pick.cutWithSword = cutWithSwordFn
	makeCollectSceneActionsFn(pick)
end

AddPrefabPostInit("grass", grassPrefab)

--fix for cutting grass with sword using action button
local function playerControllerPostInit(inst)
	inst.oldGABA = inst.GetActionButtonAction
	function inst:GetActionButtonAction()
		local ba = self:oldGABA()
		if ba and ba.doer and ba.doer.prefab == "link" and
			ba.target and ba.target.prefab == "grass" and
				ba.action == ACTIONS.PICK and
					ba.invobject and ba.invobject:HasTag("sharp") then
			ba.action = ACTIONS.SWORDCUTGRASS
		end
		return ba
	end
end

AddComponentPostInit("playercontroller", playerControllerPostInit)

