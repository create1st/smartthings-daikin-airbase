local capabilities = require('st.capabilities')
local ui = require('ui')
local log = require('log')
local Fields = require('fields')
local Modes = require('modes')
local Daikin = require('daikin')
local State = require('state')

local lifecycle_handler = {}

function lifecycle_handler.init(driver, device)
    log.debug('Initializing new Daikin AP device')
    local api_host = device:get_field(Fields.API_HOST)
    local daikin = Daikin:new(api_host)
    local control_info = daikin:get_control_info()
    local sensor_info = daikin:get_sensor_info()
    local state = State:new(control_info, sensor_info)
    ui:update(device, {
        state:get_switch_state(),
        state:get_indoor_temperature(),
        capabilities.thermostatMode.thermostatMode.fanonly(),
        capabilities.thermostatHeatingSetpoint.heatingSetpoint({ value = 26, unit = 'C' }),
        capabilities.thermostatCoolingSetpoint.coolingSetpoint({ value = 24, unit = 'C' }),
        capabilities.thermostatOperatingState.thermostatOperatingState.fan_only(),
        capabilities.airConditionerFanMode.fanMode(Modes.AUTO),
    })
end

function lifecycle_handler.added(driver, device)
    log.debug('Adding Daikin AP device')
    local api_host = driver.ap[device.device_network_id]
    log.debug(string.format('Daikin AP device host: %s ', api_host))
    device:set_field(Fields.API_HOST, api_host, { persist = true })
    ui:initialize(device)
end

function lifecycle_handler.removed(_, device)
    log.debug('Removing Daikin AP device')
end

--[capabilities.thermostatMode.commands.auto.NAME] = thermostat_mode_setter(capabilities.thermostatMode.thermostatMode.auto.NAME),
--[capabilities.thermostatMode.commands.off.NAME] = thermostat_mode_setter(capabilities.thermostatMode.thermostatMode.off.NAME),
--[capabilities.thermostatMode.commands.cool.NAME] = thermostat_mode_setter(capabilities.thermostatMode.thermostatMode.cool.NAME),
--[capabilities.thermostatMode.commands.heat.NAME] = thermostat_mode_setter(capabilities.thermostatMode.thermostatMode.heat.NAME),
--[capabilities.thermostatMode.commands.emergencyHeat.NAME] = thermostat_mode_setter(capabilities.thermostatMode.thermostatMode.emergency_heat.NAME)


--local THERMOSTAT_MODE_MAP = {
--    [clusters.Thermostat.types.ThermostatSystemMode.OFF]            = capabilities.thermostatMode.thermostatMode.off,
--    [clusters.Thermostat.types.ThermostatSystemMode.AUTO]           = capabilities.thermostatMode.thermostatMode.auto,
--    [clusters.Thermostat.types.ThermostatSystemMode.COOL]           = capabilities.thermostatMode.thermostatMode.cool,
--    [clusters.Thermostat.types.ThermostatSystemMode.HEAT]           = capabilities.thermostatMode.thermostatMode.heat,
--    [clusters.Thermostat.types.ThermostatSystemMode.EMERGENCY_HEATING] = capabilities.thermostatMode.thermostatMode.emergency_heat,
--    [clusters.Thermostat.types.ThermostatSystemMode.PRECOOLING]     = capabilities.thermostatMode.thermostatMode.precooling,
--    [clusters.Thermostat.types.ThermostatSystemMode.FAN_ONLY]       = capabilities.thermostatMode.thermostatMode.fanonly,
--    [clusters.Thermostat.types.ThermostatSystemMode.DRY]            = capabilities.thermostatMode.thermostatMode.dryair,
--    [clusters.Thermostat.types.ThermostatSystemMode.SLEEP]          = capabilities.thermostatMode.thermostatMode.asleep
--}

--local THERMOSTAT_OPERATING_MODE_MAP = {
--    [0]		= capabilities.thermostatOperatingState.thermostatOperatingState.heating,
--    [1]		= capabilities.thermostatOperatingState.thermostatOperatingState.cooling,
--    [2]		= capabilities.thermostatOperatingState.thermostatOperatingState.fan_only,
--    [3]		= capabilities.thermostatOperatingState.thermostatOperatingState.heating,
--    [4]		= capabilities.thermostatOperatingState.thermostatOperatingState.cooling,
--    [5]		= capabilities.thermostatOperatingState.thermostatOperatingState.fan_only,
--    [6]		= capabilities.thermostatOperatingState.thermostatOperatingState.fan_only,
--}
return lifecycle_handler
