local capabilities = require("st.capabilities")
local Fields = require("fields")
local log = require("log")

local handlers = {}

function handlers.handle_on(driver, device, command)
    log.info("switch on", device.id)
    --
    --local client = assert(get_thing_client(device))
    --if client:setattr{power = "on"} then
    --    device:emit_event(capabilities.switch.switch.on())
    --else
    --    log.error("failed to set power on")
    --end
end

function handlers.handle_off(driver, device, command)
    log.info("switch off", device.id)
    --
    --local client = assert(get_thing_client(device))
    --if client:setattr{power = "off"} then
    --    device:emit_event(capabilities.switch.switch.off())
    --else
    --    log.error("failed to set power on")
    --end
end

function handlers.set_thermostat_mode(driver, device, command)
    log.debug(string.format("[%s] calling refresh_handler()", device.device_network_id))
    --local mode_id = nil
    --for value, mode in pairs(THERMOSTAT_MODE_MAP) do
    --    if mode.NAME == cmd.args.mode then
    --        mode_id = value
    --        break
    --    end
    --end
    --if mode_id then
    --    device:send(clusters.Thermostat.attributes.SystemMode:write(device, device:component_to_endpoint(command.component), mode_id))
    --end
end

function handlers.set_cooling_setpoint(driver, device, command)
    log.debug(string.format("[%s] calling set_cooling_setpoint()", device.device_network_id))
    --device:emit_event(capabilities.thermostatCoolingSetpoint.coolingSetpoint({value = command.args.setpoint*1.0, unit = "C"}))
    --device:send_to_component(command.component, Thermostat.attributes.OccupiedCoolingSetpoint:write(device, math.floor(command.args.setpoint*100)))
end

function handlers.set_heating_setpoint(driver, device, command)
    --device:emit_event(capabilities.thermostatHeatingSetpoint.heatingSetpoint({value = command.args.setpoint*1.0, unit = "C"}))
    --device:send_to_component(command.component, Thermostat.attributes.OccupiedHeatingSetpoint:write(device, math.floor(command.args.setpoint*100)))
end

function handlers.set_fan_mode(driver, device, command)
    log.debug(string.format("[%s] calling set_fan_mode()", device.device_network_id))
    --local fan_mode_id
    --if command.args.fanMode == "off" then
    --    fan_mode_id = clusters.FanControl.attributes.FanMode.OFF
    --elseif command.args.fanMode == "low" then
    --    fan_mode_id = clusters.FanControl.attributes.FanMode.LOW
    --elseif command.args.fanMode == "medium" then
    --    fan_mode_id = clusters.FanControl.attributes.FanMode.MEDIUM
    --elseif command.args.fanMode == "high" then
    --    fan_mode_id = clusters.FanControl.attributes.FanMode.HIGH
    --elseif command.args.fanMode == "auto" then
    --    fan_mode_id = clusters.FanControl.attributes.FanMode.AUTO
    --else
    --    fan_mode_id = clusters.FanControl.attributes.FanMode.OFF
    --end
    --if fan_mode_id then
    --    device:send(clusters.FanControl.attributes.FanMode:write(device, device:component_to_endpoint(command.component), fan_mode_id))
    --end
end

function handlers.set_fan_speed_percent(driver, device, command)
    log.debug(string.format("[%s] calling set_fan_mode()", device.device_network_id))
    --local speed = math.floor(cmd.args.percent)
    --device:send(clusters.FanControl.attributes.PercentSetting:write(device, device:component_to_endpoint(command.component), speed))
end

function handlers.refresh_handler(driver, device, command)
    log.debug(string.format("[%s] calling set_heating_setpoint()", device.device_network_id))
    --device:send(clusters.Level.attributes.CurrentLevel:read(device))
    --device:send(clusters.OnOff.attributes.OnOff:read(device))
    --device:send(clusters.TemperatureMeasurement.attributes.MeasuredValue:read(device))
    --device:send(clusters.PowerConfiguration.attributes.BatteryPercentageRemaining:read(device))
    --
    --local pressure_read = cluster_base.read_manufacturer_specific_attribute(device, clusters.PressureMeasurement.ID, KEEN_PRESSURE_ATTRIBUTE, KEEN_MFG_CODE)
    --device:send(pressure_read)
end

return handlers
