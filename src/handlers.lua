local capabilities = require("st.capabilities")
local ui = require('ui')
local json = require('st.json')
local log = require('log')

local handlers = {}

function handlers.set_switch_mode(_, device, command)
    log.debug(string.format("[%s] set_switch_mode(%s)", device.id, json.encode(command)))
    ui:update(device, command.args)
end

function handlers.set_thermostat_mode(_, device, command)
    log.debug(string.format("[%s] set_thermostat_mode(%s)", device.id, json.encode(command)))
    ui:update(device, command.args)
end

function handlers.set_cooling_setpoint(_, device, command)
    log.debug(string.format("[%s] set_cooling_setpoint(%s)", device.device_network_id), json.encode(command))
    ui:update(device, {
        mode = capabilities.thermostatCoolingSetpoint.commands.setCoolingSetpoint.NAME,
        value = command.args.setpoint
    })
end

function handlers.set_heating_setpoint(_, device, command)
    log.debug(string.format("[%s] set_heating_setpoint(%s)", device.id, json.encode(command)))
    ui:update(device, {
        mode = capabilities.thermostatHeatingSetpoint.commands.setHeatingSetpoint.NAME,
        value = command.args.setpoint
    })
end

function handlers.set_fan_mode(_, device, command)
    log.debug(string.format("[%s] set_fan_mode(%s)", device.id, json.encode(command)))
    ui:update(device, {
        mode = capabilities.airConditionerFanMode.commands.setFanMode.NAME,
        value = command.args.fanMode
    })
end

function handlers.refresh_handler(_, device, _)
    log.debug(string.format("[%s] refresh_handler()", device.id))
    ui:update(device)
end

return handlers
