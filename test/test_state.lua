-- Setup package path to include src
package.path = package.path .. ";src/?.lua"

-- Mock st.capabilities
local mock_st = require("test.mock_st")
package.loaded["st.capabilities"] = mock_st.capabilities

local State = require("state")
local Attributes = require("attributes")
local Settings = require("settings")
local capabilities = require("st.capabilities")

-- Assertion helper
local function assert_eq(actual, expected, message)
    if actual ~= expected then
        error(string.format("%s: expected %s, got %s", message, tostring(expected), tostring(actual)))
    end
end

print("Testing state...")

local control_info = {
    [Attributes.POWER_STATUS] = Settings.ON,
    [Attributes.AIRCON_MODE] = Settings.COOL,
    [Attributes.TEMPERATURE_SET] = "24",
    [Attributes.FAN_SPEED] = Settings.FAN_SPEED_AUTO,
    [Attributes.TEMPERATURE_HEAT_RO] = "26",
    [Attributes.TEMPERATURE_COOL_RO] = "24",
}
local sensor_info = {
    [Attributes.TEMPERATURE_HOME_RO] = "23",
    [Attributes.TEMPERATURE_OUTDOOR_RO] = "15",
}

local state = State:new(control_info, sensor_info)

-- Test 1: Switch state
local sw = state:get_switch_state()
assert_eq(sw.value, "on", "Switch should be on")

-- Test 2: Indoor temperature
local temp = state:get_indoor_temperature()
assert_eq(temp.value, 23, "Indoor temp should be 23")

-- Test 3: Thermostat Mode
local mode = state:get_aircon_mode()
assert_eq(mode.value, "cool", "Mode should be cool")

-- Test 4: Operating State
local op = state:get_aircon_state()
assert_eq(op.value, "cooling", "Operating state should be cooling")

print("State tests passed!")
