local capabilities = require("st.capabilities")
local Modes = require("modes")

local ui = {}

function ui:initialize(device)
    device:online()
    local supported_fan_modes = {}
    for _, v in pairs(Modes) do
        table.insert(supported_fan_modes, v)
    end
    device:emit_event(capabilities.airConditionerFanMode.supportedAcFanModes(supported_fan_modes))
    device:emit_event(capabilities.thermostatMode.supportedThermostatModes({
        capabilities.thermostatMode.thermostatMode.heat.NAME,
        capabilities.thermostatMode.thermostatMode.cool.NAME,
        capabilities.thermostatMode.thermostatMode.auto.NAME,
        capabilities.thermostatMode.thermostatMode.fanonly.NAME,
        capabilities.thermostatMode.thermostatMode.dryair.NAME,
    }, { visibility = { displayed = false } }))
    self:update(device, {
        capabilities.switch.switch.off(),
        capabilities.temperatureMeasurement.temperature({ value = 25, unit = 'C' }),
        capabilities.thermostatMode.thermostatMode.fanonly(),
        capabilities.thermostatHeatingSetpoint.heatingSetpoint({ value = 26, unit = 'C' }),
        capabilities.thermostatCoolingSetpoint.coolingSetpoint({ value = 24, unit = 'C' }),
        capabilities.thermostatOperatingState.thermostatOperatingState.fan_only(),
        capabilities.airConditionerFanMode.fanMode(Modes.AUTO),
    })
end

function ui:update(device, new_state)
    for _, v in ipairs(new_state) do
        device:emit_event(v)
    end
end

return ui
