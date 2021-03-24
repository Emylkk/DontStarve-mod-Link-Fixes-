--[[
-- Disables the talk animation/sound for Link.
--
-- It works by only reacting to the "ontalk" event when the character's
-- prefab is different than "link".
--]]
AddStategraphPostInit("wilson", function(sg)
	local handlers = sg.events

	handlers.ontalk.fn = (function()
		local oldOntalk = handlers.ontalk.fn
		return function(inst, data)
			if inst.prefab ~= "link" then
				return oldOntalk(inst, data)
			end
		end
	end)()
end)
