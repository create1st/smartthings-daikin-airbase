local ui = require('ui')
local log = require('log')

local lifecycle_handler = {}

function lifecycle_handler.init(_, device)
    log.debug(string.format('Initializing new Daikin AP device: %s', device.device_network_id))
end

function lifecycle_handler.added(driver, device)
    log.debug(string.format('Adding Daikin AP device: %s', device.device_network_id))
    if (driver.ap[device.device_network_id] == nil) then
        ui:initialize_temperature_sensor(device)
        ui:update(device:get_parent_device())
        return
    end
    local api_host = driver.ap[device.device_network_id]
    ui:initialize(device, api_host)
    ui:update(device)
    ui:schedule_refresh(device)
end

function lifecycle_handler.removed(driver, device)
    log.debug(string.format('Removing Daikin AP device: %s', device.device_network_id))
    if (driver.ap[device.device_network_id] == nil) then
        return
    end
    driver.ap[device.device_network_id] = nil
    ui:destroy(device)
end

return lifecycle_handler
