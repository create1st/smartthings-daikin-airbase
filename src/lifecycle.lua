local Fields = require("fields")
local log = require('log')
local Daikin = require('daikin')
local Attributes = require('attributes')

local lifecycle_handler = {}

function lifecycle_handler.init(driver, device)
    log.debug("Initializing new Daikin AP device")
    local api_host = device:get_field(Fields.API_HOST)
    local daikin = Daikin:new(api_host)
    local basic_info = daikin:basic_info()
    log.debug(string.format("Daikin AP device mac: %s", basic_info[Attributes.MAC]))
end

function lifecycle_handler.added(driver, device)
    log.debug("Adding Daikin AP device")
    local api_host = driver.ap[device.device_network_id]
    log.debug(string.format("Daikin AP device host: %s ", api_host))
    device:set_field(Fields.API_HOST, api_host, { persist = true })
    -- mark device as online so it can be controlled from the app
    device:online()
end

function lifecycle_handler.removed(_, device)
    log.debug("Removing Daikin AP device")
end

return lifecycle_handler
