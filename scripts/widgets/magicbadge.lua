local Badge = require "widgets/badge"

local MagicBadge = Class(Badge, function(self, owner)
	Badge._ctor(self, "mana", owner)
end)

function MagicBadge:SetPercent(val, max)
	Badge.SetPercent(self, val, max)
end	

return MagicBadge