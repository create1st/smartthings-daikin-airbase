local ui = require('ui')
local log = require('log')

local lifecycle_handler = {}

function lifecycle_handler.init(driver, device)
    log.debug('Initializing new Daikin AP device')
    if (driver.ap[device.device_network_id] == nil) then
        ui:update(device:get_parent_device())
        return
    end
    ui:update(device)
    ui:schedule_refresh(device)
end

function lifecycle_handler.added(driver, device)
    log.debug('Adding Daikin AP device')
    if (driver.ap[device.device_network_id] == nil) then
        ui:initialize_temperature_sensor(device)
        return
    end
    local api_host = driver.ap[device.device_network_id]
    ui:initialize(device, api_host)
end

function lifecycle_handler.removed(_, device)
    log.debug('Removing Daikin AP device')
    if (driver.ap[device.device_network_id] == nil) then
        return
    end
    ui:destroy(device)
end

return lifecycle_handler
