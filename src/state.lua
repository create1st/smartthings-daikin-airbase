local capabilities = require("st.capabilities")
local Attributes = require('attributes')
local Settings = require('settings')

local State = {}

local switch_mapping = {
    [Settings.ON] = capabilities.switch.switch.on(),
    [Settings.OFF] = capabilities.switch.switch.off(),
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

return State
