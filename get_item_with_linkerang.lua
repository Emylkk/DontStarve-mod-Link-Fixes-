--
-- by no_signal
--

-- call from modmain with  
-- modimport "get_item_with_linkerang.lua"

-- needed to throw linkerang at items
GLOBAL.STRINGS.ACTIONS.PICKUPWITHLINKERANG = "Collect"
local ACTIONS = GLOBAL.ACTIONS
ACTIONS.PICKUPWITHLINKERANG = GLOBAL.Action({mount_enabled=false}, 1, true)
ACTIONS.PICKUPWITHLINKERANG.id = "PICKUPWITHLINKERANG"
ACTIONS.PICKUPWITHLINKERANG.str = GLOBAL.STRINGS.ACTIONS.PICKUPWITHLINKERANG
ACTIONS.PICKUPWITHLINKERANG.fn = function(act)
	local linkerang = act.doer.components.inventory:GetEquippedItem(GLOBAL.EQUIPSLOTS.HANDS)
    act.doer.components.inventory:DropItem(linkerang, false)
    if linkerang then
        if not act.target.combat then
            act.target:AddComponent("combat")
            act.target.components.combat.hiteffectsymbol = "body"
        end
        linkerang.components.projectile:Throw(act.doer, act.target)

    end
	
end

-- new state to handle animation based on do short action 
local pickupwithlinkerang = GLOBAL.State{
    name = "pickupwithlinkerang",
    tags = {"doing", "busy"},
        
    onenter = function(inst)
        inst.components.locomotor:Stop()
        inst.AnimState:PlayAnimation("throw")
		inst.sg:SetTimeout(7*GLOBAL.FRAMES)
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

AddStategraphPostInit("wilson", function(sg)
	local actionHandler = GLOBAL.ActionHandler(ACTIONS.PICKUPWITHLINKERANG, pickupwithlinkerang.name)
	sg.actionhandlers[ACTIONS.PICKUPWITHLINKERANG] = actionHandler
	sg.states[pickupwithlinkerang.name] = pickupwithlinkerang
end)

-- mod CollectSceneAction
-- needed to throw linkerang at items
local function inventoryitemPostInit(inst)
	-- store old function
	local oldCollect = inst.CollectSceneActions
	-- make new function
	inst.CollectSceneActions = function (self, doer, actions)
		local item = doer.components.inventory:GetEquippedItem(GLOBAL.EQUIPSLOTS.HANDS)
		if doer.prefab == "link" and self.canbepickedup and
		item and item.prefab == "linkerang" then
			table.insert(actions, ACTIONS.PICKUPWITHLINKERANG)
		else
			oldCollect(self, doer, actions)
		end
	end
end

AddComponentPostInit("inventoryitem", inventoryitemPostInit)
