local capabilities = require('st.capabilities')
local json = require('st.json')
local controller = require('controller')
local log = require('log')
local Modes = require('modes')
local Daikin = require('daikin')
local State = require('state')
local Fields = require('fields')
local Profile = require('profile')
local Sensor = require('sensor')

local SCHEDULE_PERIOD = 300

local ui = {}

local DEFAULT_TEMPERATURE_MEASUREMENT = {
    value = 20,
    unit = 'C'
}

local DEFAULT_COOLING_SET_POINT = {
    value = 24,
    unit = 'C'
}

local DEFAULT_HEATING_SET_POINT = {
    value = 26,
    unit = 'C'
}

function ui:initialize(device, api_host)
    log.debug(string.format('[%s] initialize (%s)', device.id, api_host))
    device:set_field(Fields.API_HOST, api_host, { persist = true })
    local supported_fan_modes = {}
    for _, v in pairs(Modes) do
        table.insert(supported_fan_modes, v)
    end
    self:notify(device, Profile.UNIT,{
        capabilities.airConditionerFanMode.supportedAcFanModes(supported_fan_modes),
        capabilities.thermostatMode.supportedThermostatModes({
            capabilities.thermostatMode.thermostatMode.heat.NAME,
            capabilities.thermostatMode.thermostatMode.cool.NAME,
            capabilities.thermostatMode.thermostatMode.fanonly.NAME,
            capabilities.thermostatMode.thermostatMode.dryair.NAME,
        }, { visibility = { displayed = false } })
    })
    self:notify(device, Profile.MAIN,{
        capabilities.switch.switch.off(),
    })
    self:notify(device, Profile.UNIT,{
        capabilities.temperatureMeasurement.temperature(DEFAULT_COOLING_SET_POINT),
        capabilities.thermostatMode.thermostatMode.fanonly(),
        capabilities.airConditionerFanMode.fanMode(Modes.AUTO),
        capabilities.thermostatOperatingState.thermostatOperatingState.fan_only(),
        capabilities.thermostatHeatingSetpoint.heatingSetpoint(DEFAULT_HEATING_SET_POINT),
        capabilities.thermostatCoolingSetpoint.coolingSetpoint(DEFAULT_COOLING_SET_POINT),
    })
    self:notify(device, Profile.INDOOR, {
        capabilities.temperatureMeasurement.temperature(DEFAULT_TEMPERATURE_MEASUREMENT),
    })
    self:notify(device, Profile.OUTDOOR, {
        capabilities.temperatureMeasurement.temperature(DEFAULT_TEMPERATURE_MEASUREMENT),
    })
end

function ui:initialize_temperature_sensor(device)
    log.debug(string.format('[%s] initialize temperature sensor', device.id))
    self:notify(device, Profile.MAIN, {
        capabilities.temperatureMeasurement.temperature(DEFAULT_TEMPERATURE_MEASUREMENT),
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
    self:notify(device, Profile.MAIN, {
        state:get_switch_state(),
    })
    self:notify(device, Profile.UNIT, {
        state:get_set_temperature(),
        state:get_aircon_state(),
        state:get_fan_speed(),
        state:get_aircon_mode(),
        state:get_heating_temperature(),
        state:get_cooling_temperature(),
    })
    self:notify(device, Profile.INDOOR, {
        state:get_indoor_temperature(),
    })
    self:notify(device, Profile.OUTDOOR, {
        state:get_outdoor_temperature(),
    })
    local indoor_temperature_sensor = device:get_child_by_parent_assigned_key(Sensor.INDOOR)
    if (indoor_temperature_sensor ~= nil) then
        self:notify(indoor_temperature_sensor, Profile.MAIN, {
            state:get_indoor_temperature(),
        })

    end
    local outdoor_temperature_sensor = device:get_child_by_parent_assigned_key(Sensor.OUTDOOR)
    if (outdoor_temperature_sensor ~= nil) then
        self:notify(outdoor_temperature_sensor, Profile.MAIN, {
            state:get_outdoor_temperature(),
        })
    end
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

function ui:notify(device, profile, controls)
    log.debug(string.format('[%s] notify [%s]', device.id, profile))
    local component = device.profile.components[profile]
    device:online()
    for _, v in ipairs(controls) do
        device:emit_component_event(component, v)
    end
end

return ui
