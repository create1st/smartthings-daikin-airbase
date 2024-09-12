local socket = require('cosock.socket')
local daikin = require('daikin')
local log = require('log')
local Attributes = require('attributes')

local discovery = { }

function discovery.handle_discovery(driver, _, should_continue)
    log.info('Starting Daikin Discovery')
    while should_continue() do
        local basic_info_ext = discovery.find_device()
        if basic_info_ext ~= nil then
            local api_host = basic_info_ext[Attributes.API_HOST]
            local metadata = {
                type = 'LAN',
                device_network_id = basic_info_ext[Attributes.MAC],
                label = basic_info_ext[Attributes.DEVICE_NAME],
                profile = 'daikin.skyfi.v1',
                manufacturer = 'Daikin',
                model = 'BRP15B61',
                vendor_provided_label = basic_info_ext[Attributes.SSID]
            }
            driver.ap[metadata.device_network_id] = api_host
            -- tell the cloud to create a new device record, will get synced back down
            -- and `device_added` and `device_init` callbacks will be called
            return driver:try_create_device(metadata)
        end
    end
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
