-- require st provided libraries
local capabilities = require("st.capabilities")
local Driver = require("st.driver")

-- require custom handlers from driver package
local discovery = require("discovery")
local lifecycles = require("lifecycle")
local handlers = require("handlers")

local thermostat_mode_setter = function(mode_name)
    return function(driver, device, cmd)
        return handlers.set_thermostat_mode(driver, device, {component = cmd.component, args = {mode = mode_name}})
    end
end

-- create the driver object
local skyfi_driver = Driver("Daikin Skyfi", {
    discovery = discovery.handle_discovery,
    lifecycle_handlers = lifecycles,
    capability_handlers = {
        [capabilities.switch.ID] = {
            [capabilities.switch.commands.on.NAME] = handlers.handle_on,
            [capabilities.switch.commands.off.NAME] = handlers.handle_off
        },
        --[capabilities.temperatureMeasurement.ID] = {
        --    [clusters.TemperatureMeasurement.attributes.MeasuredValue.ID] = temp_event_handler(capabilities.temperatureMeasurement.temperature),
        --},
        [capabilities.thermostatMode.ID] = {
            [capabilities.thermostatMode.commands.setThermostatMode.NAME] = handlers.set_thermostat_mode,
            [capabilities.thermostatMode.commands.auto.NAME] = thermostat_mode_setter(capabilities.thermostatMode.thermostatMode.auto.NAME),
            [capabilities.thermostatMode.commands.off.NAME] = thermostat_mode_setter(capabilities.thermostatMode.thermostatMode.off.NAME),
            [capabilities.thermostatMode.commands.cool.NAME] = thermostat_mode_setter(capabilities.thermostatMode.thermostatMode.cool.NAME),
            [capabilities.thermostatMode.commands.heat.NAME] = thermostat_mode_setter(capabilities.thermostatMode.thermostatMode.heat.NAME),
            [capabilities.thermostatMode.commands.emergencyHeat.NAME] = thermostat_mode_setter(capabilities.thermostatMode.thermostatMode.emergency_heat.NAME)
        },
        [capabilities.thermostatHeatingSetpoint.ID] = {
            [capabilities.thermostatHeatingSetpoint.commands.setHeatingSetpoint.NAME] = handlers.set_heating_setpoint,
        },
        [capabilities.thermostatCoolingSetpoint.ID] = {
            [capabilities.thermostatCoolingSetpoint.commands.setCoolingSetpoint.NAME] = handlers.set_cooling_setpoint,
        },
        --[capabilities.thermostatOperatingState.ID] = {
        --    clusters.Thermostat.attributes.ThermostatRunningState
        --},
        [capabilities.airConditionerFanMode.ID] = {
            [capabilities.airConditionerFanMode.commands.setFanMode.NAME] = handlers.set_fan_mode,
        },
        [capabilities.refresh.ID] = {
            [capabilities.refresh.commands.refresh.NAME] = handlers.refresh_handler
        },
    },
    supported_capabilities = {
        capabilities.switch,
        capabilities.temperatureMeasurement,
        capabilities.thermostatOperatingState,
        capabilities.airConditionerFanMode,
        capabilities.thermostatMode,
        capabilities.thermostatHeatingSetpoint,
        capabilities.thermostatCoolingSetpoint,
        capabilities.refresh,
    },
    ap = {}
})

-- run the driver
skyfi_driver:run()
