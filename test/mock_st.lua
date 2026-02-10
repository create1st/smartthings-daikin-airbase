local mock_st = {}

mock_st.capabilities = {
    switch = {
        ID = "switch",
        switch = {
            on = { NAME = "on" },
            off = { NAME = "off" }
        },
        commands = {
            on = { NAME = "on" },
            off = { NAME = "off" }
        }
    },
    thermostatMode = {
        ID = "thermostatMode",
        thermostatMode = {
            dryair = { NAME = "dryair" },
            cool = { NAME = "cool" },
            heat = { NAME = "heat" },
            fanonly = { NAME = "fanonly" }
        },
        commands = {
            setThermostatMode = { NAME = "setThermostatMode" },
            off = { NAME = "off" },
            cool = { NAME = "cool" },
            heat = { NAME = "heat" }
        }
    },
    thermostatHeatingSetpoint = {
        ID = "thermostatHeatingSetpoint",
        commands = {
            setHeatingSetpoint = { NAME = "setHeatingSetpoint" }
        }
    },
    thermostatCoolingSetpoint = {
        ID = "thermostatCoolingSetpoint",
        commands = {
            setCoolingSetpoint = { NAME = "setCoolingSetpoint" }
        }
    },
    airConditionerFanMode = {
        ID = "airConditionerFanMode",
        commands = {
            setFanMode = { NAME = "setFanMode" }
        }
    },
    thermostatOperatingState = {
        ID = "thermostatOperatingState",
        thermostatOperatingState = {
            idle = { NAME = "idle" },
            cooling = { NAME = "cooling" },
            heating = { NAME = "heating" },
            fan_only = { NAME = "fan_only" }
        }
    },
    temperatureMeasurement = {
        ID = "temperatureMeasurement"
    }
}

-- Add functions to simulate capability events
setmetatable(mock_st.capabilities.switch.switch.on, { __call = function() return { name = "switch", value = "on" } end })
setmetatable(mock_st.capabilities.switch.switch.off, { __call = function() return { name = "switch", value = "off" } end })
setmetatable(mock_st.capabilities.thermostatMode.thermostatMode.dryair, { __call = function() return { name = "thermostatMode", value = "dryair" } end })
setmetatable(mock_st.capabilities.thermostatMode.thermostatMode.cool, { __call = function() return { name = "thermostatMode", value = "cool" } end })
setmetatable(mock_st.capabilities.thermostatMode.thermostatMode.heat, { __call = function() return { name = "thermostatMode", value = "heat" } end })
setmetatable(mock_st.capabilities.thermostatMode.thermostatMode.fanonly, { __call = function() return { name = "thermostatMode", value = "fanonly" } end })

setmetatable(mock_st.capabilities.thermostatOperatingState.thermostatOperatingState.idle, { __call = function() return { name = "thermostatOperatingState", value = "idle" } end })
setmetatable(mock_st.capabilities.thermostatOperatingState.thermostatOperatingState.cooling, { __call = function() return { name = "thermostatOperatingState", value = "cooling" } end })
setmetatable(mock_st.capabilities.thermostatOperatingState.thermostatOperatingState.heating, { __call = function() return { name = "thermostatOperatingState", value = "heating" } end })
setmetatable(mock_st.capabilities.thermostatOperatingState.thermostatOperatingState.fan_only, { __call = function() return { name = "thermostatOperatingState", value = "fan_only" } end })

function mock_st.capabilities.airConditionerFanMode.fanMode(value)
    return { name = "fanMode", value = value }
end

function mock_st.capabilities.temperatureMeasurement.temperature(data)
    return { name = "temperature", value = data.value, unit = data.unit }
end

function mock_st.capabilities.thermostatHeatingSetpoint.heatingSetpoint(data)
    return { name = "heatingSetpoint", value = data.value, unit = data.unit }
end

function mock_st.capabilities.thermostatCoolingSetpoint.coolingSetpoint(data)
    return { name = "coolingSetpoint", value = data.value, unit = data.unit }
end

return mock_st
