local capabilities = require("st.capabilities")
local Attributes = require('attributes')
local Settings = require('settings')
local Modes = require('modes')
local json = require('st.json')
local log = require('log')

local control = {}

local switch_mapping = {
    [capabilities.switch.commands.on.NAME] = Settings.ON,
    [capabilities.switch.commands.off.NAME] = Settings.OFF,
}

local aircon_mode_mapping = {
    -- capabilities.thermostatMode.commands.auto.NAME
    --[] = Settings.DRY,
    [capabilities.thermostatMode.commands.cool.NAME] = Settings.COOL,
    [capabilities.thermostatMode.commands.heat.NAME] = Settings.HEAT,
    [capabilities.thermostatMode.commands.off.NAME] = Settings.FAN_ONLY,
}

local fan_speed_mapping = {
    [Modes.LOW] = Settings.FAN_SPEED_1,
    [Modes.MEDIUM] = Settings.FAN_SPEED_2,
    [Modes.HIGH] = Settings.FAN_SPEED_3,
    [Modes.AUTO] = Settings.FAN_SPEED_AUTO,
}

function control:update(control_info, mode_update)
    log.debug(string.format("update response: %s, %s", json.encode(control_info), json.encode(mode_update)))
    local updated_control = {
        [Attributes.POWER_STATUS] = (switch_mapping[mode_update.mode] or control_info[Attributes.POWER_STATUS]),
        [Attributes.AIRCON_MODE] = (aircon_mode_mapping[mode_update.mode] or control_info[Attributes.AIRCON_MODE]), -- change of the setpoint should change the mode!!!
        [Attributes.TEMPERATURE_SET] = (self:get_temperature(mode_update) or control_info[Attributes.TEMPERATURE_SET]), -- depending on mode!!!! and capabilities.thermostatCoolingSetpoint.commands.setCoolingSetpoint.NAME
        [Attributes.FAN_SPEED] = (self:get_fan_speed(mode_update) or control_info[Attributes.FAN_SPEED]), -- depending on mode!!!!
        [Attributes.FAN_DIRECTION] = control_info[Attributes.FAN_DIRECTION], -- depending on mode!!!!
    }
    log.debug(string.format("update response: %s", json.encode(updated_control)))
    return updated_control
end

-- 2024-09-13T08:04:29.468721007+10:00 DEBUG Daikin Airbase BRP15B61  parse_body: key=mode, value=2
-- resetting mode to fan

-- 2024-09-13T08:04:29.825964375+10:00 DEBUG Daikin Airbase BRP15B61  send_command (192.168.50.158),(/aircon/set_control_info),(table: 0x23ec6b0)
--2024-09-13T08:04:29.827098856+10:00 DEBUG Daikin Airbase BRP15B61  send_command (http://192.168.50.158/skyfi/aircon/set_control_info?f_dir=0&f_rate=5&mode=0&pow=0&stemp=26)

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
