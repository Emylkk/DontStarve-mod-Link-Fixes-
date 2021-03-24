--[[
-- Reroutes all link speech to the fairy.
--
-- Note that the strings used are still those in STRINGS.CHARACTERS.LINK
-- (i.e., those defined in speech_link.lua)
--]]
AddSimPostInit(function(player)
	if player.prefab ~= "link" then return end

	local function find_fairy()
		return GLOBAL.FindEntity(
			player,
			128,
			function(e)
				return e.components.follower and e.components.talker
			end,
			{"fairy"}
		)
	end

	local fairy = find_fairy()

	local function refresh_fairy()
		if not fairy or not fairy:IsValid() or fairy:IsInLimbo() then
			fairy = find_fairy()
		end
	end

	player.components.talker.Say = function(_, ...)
		refresh_fairy()
		if fairy and fairy.components.talker then
			print("fairy reroute")
			return fairy.components.talker:Say(...)
		end
	end

	player.components.talker.ShutUp = function(_, ...)
		refresh_fairy()
		if fairy and fairy.components.talker then
			return fairy.components.talker:ShutUp(...)
		end
	end
end)
