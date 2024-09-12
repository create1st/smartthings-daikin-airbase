-- require st provided libraries
local capabilities = require("st.capabilities")
local Driver = require( "st.driver")

-- require custom handlers from driver package
local discovery = require("discovery")
local lifecycles = require("lifecycle")
local handlers = require("handlers")

-- create the driver object
local skyfi_driver = Driver("Daikin Skyfi", {
  discovery = discovery.handle_discovery,
  lifecycle_handlers = lifecycles,
  capability_handlers = {
    [capabilities.refresh.ID] = {
      [capabilities.refresh.commands.refresh.NAME] = handlers.refresh_handler
    },
  },
  ap = {}
})

-- run the driver
skyfi_driver:run()
