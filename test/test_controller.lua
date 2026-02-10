-- Setup package path to include src
package.path = package.path .. ";src/?.lua"

-- Mock st.capabilities
local mock_st = require("test.mock_st")
package.loaded["st.capabilities"] = mock_st.capabilities

-- Mock log
package.loaded["log"] = {
    debug = function(...) end,
    info = function(...) end,
    warn = function(...) end,
    error = function(...) end,
}

-- Mock st.json
package.loaded["st.json"] = {
    encode = function(t) return "json_encoded" end
}

local controller = require("controller")
local Attributes = require("attributes")
local Settings = require("settings")
local Modes = require("modes")
local capabilities = require("st.capabilities")

-- Assertion helper
local function assert_eq(actual, expected, message)
    if actual ~= expected then
        error(string.format("%s: expected %s, got %s", message, tostring(expected), tostring(actual)))
    end
end

print("Testing controller...")

-- Test 1: Power ON
local control_info = {
    [Attributes.POWER_STATUS] = Settings.OFF,
    [Attributes.AIRCON_MODE] = Settings.COOL,
    [Attributes.TEMPERATURE_SET] = "24",
    [Attributes.FAN_SPEED] = Settings.FAN_SPEED_AUTO,
}
local mode_update = { mode = capabilities.switch.commands.on.NAME }
local updated = controller:update(control_info, mode_update)
assert_eq(updated[Attributes.POWER_STATUS], Settings.ON, "Power should be ON")

-- Test 2: Mode Change to HEAT
mode_update = { mode = capabilities.thermostatMode.commands.heat.NAME }
updated = controller:update(control_info, mode_update)
assert_eq(updated[Attributes.AIRCON_MODE], Settings.HEAT, "Mode should be HEAT")

-- Test 3: Cooling Setpoint Change
mode_update = { 
    mode = capabilities.thermostatCoolingSetpoint.commands.setCoolingSetpoint.NAME,
    value = 22
}
updated = controller:update(control_info, mode_update)
assert_eq(updated[Attributes.TEMPERATURE_SET], 22, "Setpoint should be 22")
assert_eq(updated[Attributes.AIRCON_MODE], Settings.COOL, "Mode should be COOL when setting cooling setpoint")

-- Test 4: Fan Mode Change
mode_update = {
    mode = capabilities.airConditionerFanMode.commands.setFanMode.NAME,
    value = Modes.HIGH
}
updated = controller:update(control_info, mode_update)
assert_eq(updated[Attributes.FAN_SPEED], Settings.FAN_SPEED_3, "Fan speed should be 5 (HIGH)")

print("Controller tests passed!")
