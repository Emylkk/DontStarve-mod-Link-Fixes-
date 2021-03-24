local DropFire = Class(function(self, inst)
    self.inst = inst
end)

function DropFire:CollectInventoryActions(doer, actions)
	table.insert(actions, ACTIONS.DROPFIRE)
end

return DropFire