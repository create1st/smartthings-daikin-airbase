local socket = require('cosock.socket')
local cosock = require('cosock')
local http = cosock.asyncify('socket.http')
local ltn12 = require('ltn12')
local log = require('log')

local MAX_RECONNECT_ATTEMPTS = 10
local RECONNECT_PERIOD = 2 -- seconds
local Daikin = {}

function Daikin:new(api_host)
    o = {}
    setmetatable(o, self)
    self.__index = self
    o.api_host = api_host
    return o;
end

function Daikin:basic_info()
    log.debug(string.format("basic_info (%s)", self.api_host))
    return self:send_command( '/common/basic_info')
end

function Daikin:send_command(command_url, data)
    log.debug(string.format("sendCommand (%s)", self.api_host, command_url))
    local api_call = string.format("http://%s/skyfi%s%s", self.api_host, command_url, (data or ""))
    log.debug(string.format("sendCommand (%s)", api_call))
    local retries = 0
    while retries < MAX_RECONNECT_ATTEMPTS do
        local res = {}
        local _, status = http.request({
            method="GET",
            url=api_call,
            sink=ltn12.sink.table(res)
        })
        if (status == 200) then
            return self:parse_body(table.concat(res))
        end
        socket.sleep(RECONNECT_PERIOD)
    end

    log.debug(string.format("sendCommand (%s) failed (%s) status=%s", api_call, (body or ""), (status or "")))
    return nil
end

function Daikin:parse_body(body)
    local response = {}
    if(body == nil or body == false) then
        return response
    end
    for pair in body:gmatch"[^,]+" do
        local key, value = pair:match"([^=]*)=(.*)"
        key = self:decode(key)
        value = self:decode(value)
        log.debug(string.format("parse_body: key=%s, value=%s", (key or "") , (value or "")))
        response[key] = value
    end
    return response
end

function Daikin:decode(s)
    s = (s == nil) and "" or s:gsub("^%s*(.-)%s*$", "%1")
    return (string.gsub (string.gsub (s, "+", " "),"%%(%x%x)", function (str)
        return string.char (tonumber (str, 16)) end ))
end

return Daikin
