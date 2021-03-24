local function GetHeatFn(inst)
	return -200
end

function RedTunicDLCPostInit( inst )
    inst:AddComponent("heater")
    inst.components.heater.heatfn = GetHeatFn
    inst.components.heater.iscooler = true

end

function BlueTunicDLCPostInit( inst )
    inst:AddComponent("waterproofer")
end

    local is_rog_enabled = GLOBAL.IsDLCEnabled(1)
    
    if is_rog_enabled
      then
        AddPrefabPostInit("tunic_red", RedTunicDLCPostInit)
        AddPrefabPostInit("tunic_blue", BlueTunicDLCPostInit)
      else
    end