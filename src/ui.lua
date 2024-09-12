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
    self:notify(device, {
        capabilities.switch.switch.off(),
        capabilities.temperatureMeasurement.temperature({ value = 25, unit = 'C' }),
        capabilities.thermostatMode.thermostatMode.fanonly(),
        capabilities.airConditionerFanMode.fanMode(Modes.AUTO),
        capabilities.thermostatOperatingState.thermostatOperatingState.fan_only(),
        capabilities.thermostatHeatingSetpoint.heatingSetpoint({ value = 26, unit = 'C' }),
        capabilities.thermostatCoolingSetpoint.coolingSetpoint({ value = 24, unit = 'C' }),
    })
end

function ui:update(device, state)
    self:notify(device, {
        state:get_switch_state(),
        state:get_indoor_temperature(),
        state:get_aircon_state(),
        state:get_fan_speed(),
        state:get_aircon_mode(),
        state:get_heating_temperature(),
        state:get_cooling_temperature(),
    })
end

function ui:notify(device, controls)
    for _, v in ipairs(controls) do
        device:emit_event(v)
    end
end

return ui
