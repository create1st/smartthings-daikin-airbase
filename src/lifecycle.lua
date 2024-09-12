local capabilities = require('st.capabilities')
local ui = require('ui')
local log = require('log')
local Fields = require('fields')
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
    ui:update(device, state)
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

return lifecycle_handler
