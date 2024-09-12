local Fields = require("fields")
local log = require("log")

local handlers = {}

function handlers.refresh_handler(driver, device, command)
    log.debug(string.format("[%s] calling refresh_handler()", device.device_network_id))
end

return handlers
