local capabilities = require("st.capabilities")
local Modes = require('modes')
local Attributes = require('attributes')
local Settings = require('settings')

local State = {}

local switch_mapping = {
    [Settings.ON] = capabilities.switch.switch.on(),
    [Settings.OFF] = capabilities.switch.switch.off(),
}

local aircon_state_mapping = {
    [Settings.DRY] = capabilities.thermostatOperatingState.thermostatOperatingState.idle(),
    [Settings.COOL] = capabilities.thermostatOperatingState.thermostatOperatingState.cooling(),
    [Settings.HEAT] = capabilities.thermostatOperatingState.thermostatOperatingState.heating(),
    [Settings.FAN_ONLY] = capabilities.thermostatOperatingState.thermostatOperatingState.fan_only(),
}

local aircon_mode_mapping = {
    [Settings.DRY] = capabilities.thermostatMode.thermostatMode.dryair(),
    [Settings.COOL] = capabilities.thermostatMode.thermostatMode.cool(),
    [Settings.HEAT] = capabilities.thermostatMode.thermostatMode.heat(),
    [Settings.FAN_ONLY] = capabilities.thermostatMode.thermostatMode.fanonly(),
}

local fan_speed_mapping = {
    [Settings.FAN_SPEED_1] = capabilities.airConditionerFanMode.fanMode(Modes.LOW),
    [Settings.FAN_SPEED_2] = capabilities.airConditionerFanMode.fanMode(Modes.MEDIUM),
    [Settings.FAN_SPEED_3] = capabilities.airConditionerFanMode.fanMode(Modes.HIGH),
    [Settings.FAN_SPEED_AUTO] = capabilities.airConditionerFanMode.fanMode(Modes.AUTO),
}

function State:new(control_info, sensor_info)
    o = {}
    setmetatable(o, self)
    self.__index = self
    o.control_info = control_info
    o.sensor_info = sensor_info
    return o;
end

function State:get_switch_state()
    return switch_mapping[self.control_info[Attributes.POWER_STATUS]]
end

function State:get_indoor_temperature()
    local temperature = self.sensor_info[Attributes.TEMPERATURE_HOME_RO]
    return capabilities.temperatureMeasurement.temperature({ value = tonumber(temperature), unit = 'C' })
end

function State:get_outdoor_temperature()
    local temperature = self.sensor_info[Attributes.TEMPERATURE_OUTDOOR_RO]
    return capabilities.temperatureMeasurement.temperature({ value = tonumber(temperature), unit = 'C' })
end

function State:get_set_temperature()
    local temperature = self.control_info[Attributes.TEMPERATURE_SET]
    return capabilities.temperatureMeasurement.temperature({ value = tonumber(temperature), unit = 'C' })
end

function State:get_aircon_state()
    return aircon_state_mapping[self.control_info[Attributes.AIRCON_MODE]]
end

function State:get_aircon_mode()
    return aircon_mode_mapping[self.control_info[Attributes.AIRCON_MODE]]
end

function State:get_fan_speed()
    return fan_speed_mapping[self.control_info[Attributes.FAN_SPEED]]
end

function State:get_heating_temperature()
    local temperature = self.control_info[Attributes.TEMPERATURE_HEAT_RO]
    return capabilities.thermostatHeatingSetpoint.heatingSetpoint({ value = tonumber(temperature), unit = 'C' })
end

function State:get_cooling_temperature()
    local temperature = self.control_info[Attributes.TEMPERATURE_COOL_RO]
    return capabilities.thermostatCoolingSetpoint.coolingSetpoint({ value = tonumber(temperature), unit = 'C' })
end
return State
