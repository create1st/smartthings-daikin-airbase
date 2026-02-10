-- Setup package path
package.path = package.path .. ";src/?.lua"

-- Mock libraries
local mock_st = require("test.mock_st")
package.loaded["st.capabilities"] = mock_st.capabilities
package.loaded["log"] = {
    debug = function(...) end,
    info = function(...) end,
    warn = function(...) end,
    error = function(...) end
}

-- Mock UI
local mock_ui = {} 
-- We define functions on the table, but they will be called with : so self is 1st arg.

-- Inject mock_ui into loaded modules BEFORE requiring lifecycle
package.loaded["ui"] = mock_ui

local lifecycle = require("lifecycle")

-- Assertion helper
local function assert_eq(actual, expected, message)
    if actual ~= expected then
        error(string.format("%s: expected %s, got %s", message, tostring(expected), tostring(actual)))
    end
end

print("Testing lifecycle...")

-- Mock Driver and Device
local driver = {
    ap = {}
}

local device = {
    device_network_id = "11:22:33:44:55:66",
    id = "device-id-1",
    get_parent_device = function() return { id = "parent-id" } end
}

-- Test 1: Added (New Device)
driver.ap[device.device_network_id] = "192.168.1.100"
local init_called = false
local update_called = false
local refresh_called = false

mock_ui.initialize = function(self, dev, host) 
    if dev == device and host == "192.168.1.100" then init_called = true end
end
mock_ui.update = function(self, dev) 
    -- Allow update for parent device too, but we mainly care about our device here
    if dev == device then update_called = true end
end
mock_ui.schedule_refresh = function(self, dev) 
    if dev == device then refresh_called = true end
end


lifecycle.added(driver, device)

assert_eq(init_called, true, "Should initialize new device")
assert_eq(update_called, true, "Should update new device")
assert_eq(refresh_called, true, "Should schedule refresh for new device")

-- Test 2: Added (Child Device - e.g. Sensor)
driver.ap[device.device_network_id] = nil
local sensor_init_called = false
mock_ui.initialize_temperature_sensor = function(self, dev)
    if dev == device then sensor_init_called = true end
end
-- Mock update for parent device
mock_ui.update = function(self, dev) end

lifecycle.added(driver, device)
assert_eq(sensor_init_called, true, "Should initialize sensor if not in driver.ap")

-- Test 3: Removed
driver.ap[device.device_network_id] = "192.168.1.100"
local destroy_called = false
mock_ui.destroy = function(self, dev)
    if dev == device then destroy_called = true end
end

lifecycle.removed(driver, device)
assert_eq(driver.ap[device.device_network_id], nil, "Should remove from driver.ap")
assert_eq(destroy_called, true, "Should call ui.destroy")

print("Lifecycle tests passed!")