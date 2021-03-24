-- The following should state wilson regardless of the character's name!
-- (because it's the stategraph's name, which is wilson for every character)
AddStategraphPostInit("wilson", function(sg)
	local state = sg.states["play_flute"]
	
	GLOBAL.assert(state, "SGwilson has no play_flute state!")
	
	local old_onenter = state.onenter
	state.onenter = function(inst)
--		print "onenter!"

		local bufaction = inst:GetBufferedAction()

		local is_playing_ocarina =
			bufaction
			and bufaction.action == GLOBAL.ACTIONS.PLAY
			and bufaction.invobject
			and bufaction.invobject:HasTag("ocarina")

		if is_playing_ocarina then
--			print "ocarina!"
	            inst.components.locomotor:Stop()
        	    inst.AnimState:PlayAnimation("flute")
	            inst.AnimState:OverrideSymbol("pan_flute01", "ocarina", "pan_flute01")
	            inst.AnimState:Hide("ARM_carry") 
	            inst.AnimState:Show("ARM_normal")
        	    if inst.components.inventory.activeitem and inst.components.inventory.activeitem.components.instrument then
	                inst.components.inventory:ReturnActiveItem()
	            end
		else
--			print "not ocarina!"
			old_onenter(inst)
		end
	end
end)
