local json = require('st.json')
local socket = require('cosock.socket')
local daikin = require('daikin')
local log = require('log')
local Attributes = require('attributes')
local Sensor = require('sensor')

local discovery = { }
local MANUFACTURER = 'Daikin'
local AIRBASE_PROFILE = 'daikin.skyfi.v1'
local AIRBASE_MODE = 'BRP15B61'
local TEMPERATURE_SENSOR_PROFILE = 'daikin.skyfi.sensor.temperature.v1'
local MAX_DEVICE_FIND_ATTEMPTS = 10
local FIND_DEVICE_RETRY_PERIOD = 1 -- seconds

function discovery.handle_discovery(driver, _, should_continue)
    log.info('Starting Daikin Discovery')
    while should_continue() do
        local basic_info_ext = discovery.find_device()
        if basic_info_ext ~= nil then
            discovery.create_airbase_unit(driver, basic_info_ext)
        end
    end
end

function discovery.create_airbase_unit(driver, basic_info_ext)
    log.debug(string.format("create_airbase_unit: %s", json.encode(basic_info_ext)))
    local api_host = basic_info_ext[Attributes.API_HOST]
    local metadata = {
        type = 'LAN',
        device_network_id = basic_info_ext[Attributes.MAC],
        label = basic_info_ext[Attributes.DEVICE_NAME],
        profile = AIRBASE_PROFILE,
        manufacturer = MANUFACTURER,
        model = AIRBASE_MODE,
        vendor_provided_label = basic_info_ext[Attributes.SSID]
    }
    driver.ap[metadata.device_network_id] = api_host
    -- tell the cloud to create a new device record, will get synced back down
    -- and `device_added` and `device_init` callbacks will be called
    local root = driver:try_create_device(metadata)
    if (root ~= nil) then
        discovery.create_temperature_sensor(driver, metadata, Sensor.INDOOR)
        discovery.create_temperature_sensor(driver, metadata, Sensor.OUTDOOR)
    end
end

function discovery.create_temperature_sensor(driver, parent_metadata, sensor_id)
    log.debug(string.format("create_temperature_sensor: %s", json.encode(parent_metadata)))
    local parent_device = discovery.find_device_by_device_network_id(driver, parent_metadata.device_network_id)
    if (parent_device == nil) then
        log.error(string.format('Parent device not found: %s. Aborting...', parent_metadata.device_network_id))
        return
    end
    local metadata = {
        type = 'EDGE_CHILD',
        label = string.format('%s %s temperature sensor', parent_metadata.label, sensor_id),
        profile = TEMPERATURE_SENSOR_PROFILE,
        manufacturer = MANUFACTURER,
        model = string.format('%s_%s_temperature_sensor', parent_metadata.model, sensor_id),
        vendor_provided_label = string.format('%s_%s_temperature_sensor', parent_metadata.vendor_provided_label, sensor_id),
        parent_device_id = parent_device.id,
        parent_assigned_child_key = sensor_id,
    }
    return driver:try_create_device(metadata)
end

function discovery.find_device_by_device_network_id(driver, device_network_id)
    log.debug(string.format("find_device_by_device_network_id: %s", device_network_id))
    local retries = 0
    while retries < MAX_DEVICE_FIND_ATTEMPTS do
        for _, device in ipairs(driver:get_devices()) do
            log.debug(string.format("found existing device: %s", device.id))
            if (device.device_network_id == device_network_id) then
                return device
            end
        end
        socket.sleep(FIND_DEVICE_RETRY_PERIOD)
        retries = retries + 1
    end
    return nil
end

function discovery.find_device()
  local listen_ip = interface or "0.0.0.0"
  local listen_port = 30000

  local upnp = socket.udp()
  upnp:setsockname(listen_ip, listen_port)
  upnp:setoption('broadcast', true)
  upnp:settimeout(8)

  log.debug('Daikin Airbase network scan')
  local ap_message = 'DAIKIN_UDP/common/basic_info'
  local ap_address = '255.255.255.255'
  local ap_port = 30050
  upnp:sendto(ap_message, ap_address, ap_port)
  local body, ip, port = upnp:receivefrom()
  upnp:close()

  if body ~= nil then
    log.debug(string.format('Daikin Airbase found: %s:%s', ip, port))
    log.debug(string.format('Daikin Airbase response: %s', body))
  end

  if body ~= nil then
    local basic_info_ext = daikin:parse_body(body)
    basic_info_ext[Attributes.API_HOST] = ip
    return basic_info_ext
  end
  return nil
end
return discovery
