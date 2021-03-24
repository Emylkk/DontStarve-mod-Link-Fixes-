local Fuse = Class(function(self, inst)
	self.inst = inst
	self.fuselength = 0
	self.fusesound = nil

	self.fusetime = nil
	self.fusetask = nil

	self.default_anim = nil
	self.animtiming = nil
	self.animtask = nil

	self.onfuseendfn = nil
end)

function Fuse:SetLength( length )
	if self:Lit() then
		-- if it's already lit, then modify the fuselength
		self:StartFuse( length )
	end

	self.fuselength = length
end

function Fuse:SetSound( soundname )
	self.fusesound = soundname
end

function Fuse:SetAnimTiming( default_anim, timingtable )
	self.default_anim = default_anim
	self.animtiming = timingtable
end

function Fuse:SetOnFuseEndFn( fn )
	self.onfuseendfn = fn
end

function Fuse:Lit()
	return self.fusetime ~= nil
end

-- alias of StartFuse, without the option to set the length to something different
function Fuse:Light()
	if not self:Lit() then
		self:StartFuse()
	end
end

function Fuse:StartFuse( length )
	self:StopFuse()

	if self.fusesound then
		self.inst.SoundEmitter:PlaySound(self.fusesound, "fusesound")
	end

	if length == nil then length = self.fuselength end
	length = math.max(0, length)

	self.fusetime = GetTime() + length
	self.fusetask = self.inst:DoTaskInTime( length, function() self:OnFuseEnd() end )

	self:StartAnimChain()
end

function Fuse:StopFuse()
	if self.fusesound then
		self.inst.SoundEmitter:KillSound("fusesound")
	end

	if self.fusetask then
		self.fusetask:Cancel()
		self.fusetask = nil
	end
	self.fusetime = nil

	self:StopAnimChain()
end

function Fuse:OnFuseEnd()
	self:StopFuse()

	if self.onfuseendfn then
		self.onfuseendfn( self.inst )
	end
end

function Fuse:TimeLeft()
	return self:Lit() and (self.fusetime - GetTime()) or self.fuselength
end

function Fuse:TimeElapsed()
	return self.fuselength - self:TimeLeft()
end

function Fuse:StartAnimChain()
	self:StopAnimChain()

	local percent_expired = self:TimeElapsed() / self.fuselength

	for i,anim in ipairs( self.animtiming ) do
		if percent_expired < anim[1] then
			local time_till_anim = (anim[1] - percent_expired) * self.fuselength
			self.animtask = self.inst:DoTaskInTime( time_till_anim, function() self:GoToAnimInChain( i, anim[2] ) end )
			break
		end
	end
end

function Fuse:GoToAnimInChain( index, anim_name )
	self.inst.AnimState:PlayAnimation( anim_name )

	local next_index = index+1
	if #self.animtiming >= next_index then
		local next_anim = self.animtiming[next_index]
		local next_anim_time = math.max( 0, next_anim[1] * self.fuselength - self:TimeElapsed() )
		self.animtask = self.inst:DoTaskInTime( next_anim_time, function() self:GoToAnimInChain( next_index, next_anim[2] ) end )
	end
end

function Fuse:StopAnimChain()
	if self.animtask then
		self.animtask:Cancel()
		self.animtask = nil
	end

	if self.default_anim then
		self.inst.AnimState:PlayAnimation( self.default_anim )
	end
end

function Fuse:OnSave()
	local data = { fuselength = self.fuselength }
	if self:Lit() then
		data.fusetimeleft = self:TimeLeft()
	end
	return data
end

function Fuse:OnLoad( data )
	if data then
		self:SetLength( data.fuselength )
		if data.fusetimeleft then
			self:StartFuse( data.fusetimeleft )
		end
	end
end

function Fuse:LongUpdate( dt )
	if self:Lit() then
		self:StartFuse( self:TimeLeft() - dt )
	end
end

function Fuse:GetDebugString()
	local str = "fuselength="..tostring(self.fuselength)
	if self:Lit() then str = str.." lit, time left: "..tostring(self:TimeLeft()) end
	return str
end

return Fuse