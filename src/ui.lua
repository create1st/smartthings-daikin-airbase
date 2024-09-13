local capabilities = require('st.capabilities')
local json = require('st.json')
local controller = require('controller')
local Modes = require('modes')
local Daikin = require('daikin')
local State = require('state')
local Fields = require('fields')
local log = require('log')

local SCHEDULE_PERIOD = 300

local ui = {}

function ui:initialize(device, api_host)
    log.debug(string.format('[%s] initialize (%s)', device.id, api_host))
    device:set_field(Fields.API_HOST, api_host, { persist = true })
    local supported_fan_modes = {}
    for _, v in pairs(Modes) do
        table.insert(supported_fan_modes, v)
    end
    self:notify(device, {
        capabilities.airConditionerFanMode.supportedAcFanModes(supported_fan_modes),
        capabilities.thermostatMode.supportedThermostatModes({
            capabilities.thermostatMode.thermostatMode.heat.NAME,
            capabilities.thermostatMode.thermostatMode.cool.NAME,
            capabilities.thermostatMode.thermostatMode.auto.NAME,
            capabilities.thermostatMode.thermostatMode.fanonly.NAME,
            capabilities.thermostatMode.thermostatMode.dryair.NAME,
        }, { visibility = { displayed = false } })
    })
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

function ui:update(device, mode_update)
    log.debug(string.format('[%s] update', device.id))
    local api_host = device:get_field(Fields.API_HOST)
    local daikin = Daikin:new(api_host)
    local control_info = daikin:get_control_info()
    local sensor_info = daikin:get_sensor_info()
    if (control_info == nil or sensor_info == nil) then
        device:offline()
        return
    end
    if (mode_update ~= nil) then
        local control_update = controller:update(control_info, mode_update)
        local status = daikin:set_control_info(control_update)
        if (status == nil) then
            device:offline()
            return
        end
        log.debug(string.format('[%s] best effort update: %s, %s', device.id, json.encode(control_info), json.encode(control_update)))
        for k, v in pairs(control_update) do
            control_info[k] = v
        end
        log.debug(string.format('[%s] best effort update result: %s', device.id, json.encode(control_info)))
    end
    local state = State:new(control_info, sensor_info)
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

function ui:schedule_refresh(device)
    log.debug(string.format('[%s] schedule_refresh', device.id))
    device.thread:call_on_schedule(
            SCHEDULE_PERIOD,
            function()
                return self:update(device)
            end,
            'Refresh schedule')
end

function ui:destroy(device)
    log.debug(string.format('[%s] device', device.id))
    for timer in pairs(device.thread.timers) do
        device.thread:cancel_timer(timer)
    end
end

function ui:notify(device, controls)
    log.debug(string.format('[%s] notify', device.id))
    device:online()
    for _, v in ipairs(controls) do
        device:emit_event(v)
    end
end

return ui
