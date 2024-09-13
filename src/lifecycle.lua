local ui = require('ui')
local log = require('log')

local lifecycle_handler = {}

function lifecycle_handler.init(_, device)
    log.debug('Initializing new Daikin AP device')
    ui:update(device)
    ui:schedule_refresh(device)
end

function lifecycle_handler.added(driver, device)
    log.debug('Adding Daikin AP device')
    local api_host = driver.ap[device.device_network_id]
    ui:initialize(device, api_host)
end

function lifecycle_handler.removed(_, device)
    log.debug('Removing Daikin AP device')
    ui:destroy(device)
end

return lifecycle_handler
