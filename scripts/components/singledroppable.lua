local SingleDroppable = Class(function(self, inst)
    self.inst = inst
end)

function SingleDroppable:CollectInventoryActions(doer, actions)
	table.insert(actions, ACTIONS.DROPSINGLE)
end

return SingleDroppable