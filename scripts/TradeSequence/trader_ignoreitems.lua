
-------------------------------------------------------------
-- Trader component ignoreitems/tradeto support
--  Usage: 
--   inst.components.trader:IsItemIgnored( item )
--   inst.components.trader:AddIgnoredItem( name, [isignoredfn], [duration] )
--   inst.components.trader:RemoveIgnoredItem( name )
-------------------------------------------------------------

local trader = require("components/trader")
trader.IsItemIgnored = function(self, item)
	if self.ignoreditems then
		for name,v in pairs(self.ignoreditems) do
			if v.isignoredfn and v.isignoredfn(item) then
				return true
			elseif name == item.prefab then
				return true
			end
		end
	end
end

trader.AddIgnoredItem = function(self, name, isignoredfn, duration)
	if not self.ignoreditems then self.ignoreditems = {} end
	if self.ignoreditems[name] then
		print("ignored item "..name.." already exists!")
	end
	local targettime = duration and (GetTime()+duration) or nil
	local task = nil
	if targettime then task = self.inst:DoTaskInTime( duration, function() self:RemoveIgnoredItem(name) end ) end
	self.ignoreditems[name] = { isignoredfn=isignoredfn, targettime=targettime, task=task }
end

trader.RemoveIgnoredItem = function(self, name)
	if self.ignoreditems and self.ignoreditems[name] then
		if self.ignoreditems[name].task then
			self.ignoreditems[name].task:Cancel()
		end
		self.ignoreditems[name] = nil
	end
end

local trader_OnSave_base = trader.OnSave or function() end
trader.OnSave = function(self)
	local data = trader_OnSave_base(self) or {}
	if self.ignoreditems then
		data.ignoreditems = {}
		for name,v in pairs(self.ignoreditems) do
			local saved_ignoreditem = {
				name=name,
				isignoredfn=v.isignoredfn
			}
			if v.targettime then
				saved_ignoreditem.duration = v.targettime - GetTime()
			end
			table.insert(data.ignoreditems, saved_ignoreditem)
		end
	end
	return data
end

local trader_OnLoad_base = trader.OnLoad or function() end
trader.OnLoad = function(self, data)
	trader_OnLoad_base(self, data)
	if data and data.ignoreditems then
		--print(table.inspect(data.ignoreditems))
		for _, v in ipairs(data.ignoreditems) do
			self:AddIgnoredItem(v.name, v.isignoredfn, v.duration)
		end
	end
end

local trader_CanAccept_base = trader.CanAccept
trader.CanAccept = function(self, item)
	local canaccept = trader_CanAccept_base(self, item)

	if canaccept then
		if self.ignoreditems and self:IsItemIgnored( item ) then
			canaccept = false
		elseif item.components.tradable.tradeto and not table.contains( item.components.tradable.tradeto, self.inst.prefab ) then
			canaccept = false
		end
	end

	return canaccept
end

local trader_AcceptGift_base = trader.AcceptGift
trader.AcceptGift = function(self, giver, item)
	local accepted = trader_AcceptGift_base(self, giver, item)

	if accepted then
		if item.components.tradable.ignoreaftertrade then
			for i,v in ipairs(item.components.tradable.ignoreaftertrade) do
				self:AddIgnoredItem( v.name, v.test, v.time )
			end
		end
	end

	return accepted
end
