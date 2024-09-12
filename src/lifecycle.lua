local Fields = require("fields")
local log = require('log')

local lifecycle_handler = {}

function lifecycle_handler.init(driver, device)
    log.info("[" .. device.id .. "] Initializing new Daikin AP device")
    log.info("[" .. device.id .. "] Initializing Daikin AP device host " .. device:get_field(Fields.API_HOST))
end

function lifecycle_handler.added(driver, device)
    log.info("[" .. device.id .. "] Adding Daikin AP device")
    local apiHost = driver.ap[device.device_network_id]
    log.info("[" .. device.id .. "] Daikin AP device host " .. apiHost)
    device:set_field(Fields.API_HOST, apiHost, { persist = true })
    log.info("[" .. device.id .. "] Adding Daikin AP device host " .. device:get_field(Fields.API_HOST))

    -- mark device as online so it can be controlled from the app
    device:online()
end

function lifecycle_handler.removed(_, device)
    log.info("[" .. device.id .. "] Removing Daikin AP device ")
    --log.info("[" .. device.id .. "] Daikin AP device host " .. device:get_field(Fields.API_HOST))
end

return lifecycle_handler
