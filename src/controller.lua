local capabilities = require("st.capabilities")
local Attributes = require('attributes')
local Settings = require('settings')
local Modes = require('modes')
local json = require('st.json')
local log = require('log')

local control = {}

local switch_mapping = {
    [capabilities.switch.switch.on.NAME] = Settings.ON,
    [capabilities.switch.switch.off.NAME] = Settings.OFF,
}

local aircon_mode_mapping = {
    [capabilities.thermostatMode.thermostatMode.dryair.NAME] = Settings.DRY,
    [capabilities.thermostatMode.thermostatMode.cool.NAME] = Settings.COOL,
    [capabilities.thermostatMode.thermostatMode.heat.NAME] = Settings.HEAT,
    [capabilities.thermostatMode.thermostatMode.fanonly.NAME] = Settings.FAN_ONLY,
}

local fan_speed_mapping = {
    [Modes.LOW] = Settings.FAN_SPEED_1,
    [Modes.MEDIUM] = Settings.FAN_SPEED_2,
    [Modes.HIGH] = Settings.FAN_SPEED_3,
    [Modes.AUTO] = Settings.FAN_SPEED_AUTO,
}

function control:update(control_info, mode_update)
    log.debug(string.format("update: %s, %s", json.encode(control_info), json.encode(mode_update)))
    local aircon_mode = self:get_aircon_mode(mode_update) or control_info[Attributes.AIRCON_MODE];
    local updated_control = {
        [Attributes.POWER_STATUS] = (switch_mapping[mode_update.mode] or control_info[Attributes.POWER_STATUS]),
        [Attributes.AIRCON_MODE] = aircon_mode,
        [Attributes.TEMPERATURE_SET] = (self:get_temperature(mode_update) or control_info[self:get_current_temperature_attribute(aircon_mode)]),
        [Attributes.FAN_SPEED] = (self:get_fan_speed(mode_update) or control_info[self:get_fan_speed_attribute(aircon_mode)]),
        [Attributes.FAN_DIRECTION] = control_info[self:get_fan_direction_attribute(aircon_mode)],
    }
    log.debug(string.format("update response: %s", json.encode(updated_control)))
    return updated_control
end

function control:get_current_temperature_attribute(aircon_mode)
    if (aircon_mode == Settings.HEAT) then
        return Attributes.TEMPERATURE_HEAT_RO
    end
    return Attributes.TEMPERATURE_COOL_RO
end

function control:get_fan_speed_attribute(aircon_mode)
    if (aircon_mode == Settings.HEAT) then
        return Attributes.FAN_SPEED_HEAT_RO
    end
    return Attributes.FAN_SPEED_COOL_RO
end

function control:get_fan_direction_attribute(aircon_mode)
    if (aircon_mode == Settings.HEAT) then
        return Attributes.FAN_DIRECTION_HEAT_RO
    end
    return Attributes.FAN_DIRECTION_COOL_RO
end

function control:get_aircon_mode(mode_update)
    if (mode_update.mode == capabilities.thermostatCoolingSetpoint.commands.setCoolingSetpoint.NAME) then
        return Settings.COOL
    end
    if (mode_update.mode == capabilities.thermostatHeatingSetpoint.commands.setHeatingSetpoint.NAME) then
        return Settings.HEAT
    end
    return aircon_mode_mapping[mode_update.mode]
end


function control:get_temperature(mode_update)
    if (mode_update.mode == capabilities.thermostatCoolingSetpoint.commands.setCoolingSetpoint.NAME
            or mode_update.mode == capabilities.thermostatHeatingSetpoint.commands.setHeatingSetpoint.NAME) then
        return mode_update.value
    end
    return nil
end

function control:get_fan_speed(mode_update)
    if (mode_update.mode == capabilities.airConditionerFanMode.commands.setFanMode.NAME) then
        return fan_speed_mapping[mode_update.value]
    end
    return nil
end

return control
