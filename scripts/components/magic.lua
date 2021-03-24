local Magic = Class(function(self, inst)
    self.inst = inst
    self.max = TUNING.MAX_MAGIC
    self.min = 0
    self.current = self.max
    self.invincible = false	
end)

function Magic:OnSave()    
    return 
    {
		magic = self.current
	}
end

function Magic:OnLoad(data)
    if data.magic then
        self:SetVal(data.magic, "loading")
        self:DoDelta(0) --to update hud
	elseif data.percent then
		-- used for setpieces!
		self:SetPercent(data.percent, "loading")
        self:DoDelta(0) --to update hud
    end
end

function Magic:OnUpdate(dt)
	
end

function Magic:GetPercent()
    return self.current / self.max
end

function Magic:GetDebugString()
    local s = string.format("%2.2f / %2.2f", self.current, self.max)
    if self.regen then
        s = s .. string.format(", regen %.2f every %.2fs", self.regen.amount, self.regen.period)
    end
    return s
end


function Magic:SetMaxMagic(amount)
    self.max = amount
    self.current = amount
end

function Magic:SetMinMagic(amount)
    self.min = amount
end

function Magic:IsNotFull()
    return self.current < self.max
end

function Magic:GetMaxMagic()
    return self.max
end
local function destroy(inst)
	local time_to_erode = 1
	local tick_time = TheSim:GetTickTime()
	inst:StartThread( function()
		local ticks = 0
		while ticks * tick_time < time_to_erode do
			local erode_amount = ticks * tick_time / time_to_erode
			inst.AnimState:SetErosionParams( erode_amount, 0.1, 1.0 )
			ticks = ticks + 1
			Yield()
		end
		inst:Remove()
	end)
end

function Magic:SetPercent(percent, cause)
    self:SetVal(self.max*percent, cause)
    self:DoDelta(0)
end

function Magic:OnProgress()
	self.penalty = 0
end

function Magic:SetVal(val, cause)

    local old_percent = self:GetPercent()

    self.current = val
    if self.current > self:GetMaxMagic() then
        self.current = self:GetMaxMagic()
    end

    if self.min and self.current < self.min then
        self.current = self.min
        self.inst:PushEvent("minmagic", {cause=cause})
    end
    if self.current < 0 then
        self.current = 0
    end

    local new_percent = self:GetPercent()
end

function Magic:Consume(amount, cause)
	
	if amount > self.current then
		return false
	end
	self:DoDelta(-amount,nil,cause)
	return true
end

function Magic:DoDelta(amount, overtime, cause)

    if self.inst.is_teleporting == true then
        return
    end

    local old_percent = self:GetPercent()
    self:SetVal(self.current + amount, cause)
    local new_percent = self:GetPercent()

    self.inst:PushEvent("magicdelta", {oldpercent = old_percent, newpercent = self:GetPercent(), overtime=overtime, cause=cause})
end

return Magic
