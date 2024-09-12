local cosock = require "cosock"
local http = cosock.asyncify "socket.http"
local ltn12 = require('ltn12')
local log = require('log')

local daikin = {}

function daikin:basic_info(apiHost)
    log.debug(string.format("basic_info (%s)", apiHost))

    return self:send_command(apiHost, '/common/basic_info')
end

function daikin:send_command(apiHost, command_url, data)
    log.debug(string.format("sendCommand (%s)", apiHost, command_url))

    local api_call = string.format("http://%s/skyfi%s%s", apiHost, command_url, (data or ""))
    -- local api_call = "https://github.com/ael-code/daikin-control"
    log.debug(string.format("sendCommand (%s)", api_call))

    --local body, status, headers, statusText = http.request(api_call)


    local res = {}
    local _, status = http.request({
        method="GET",
        url=api_call,
        sink=ltn12.sink.table(res)
    })
    --failed () status=403 -- retry
    if (status == 200) then
        return self:parse_body(table.concat(res))
        --return self:parse_body(body)
    end

    --log.debug(string.format("sendCommand (%s) failed (%s) status=%s,%s,%s", api_call, (body or ""), (status or ""), (headers or ""), (statusText or "")))
    log.debug(string.format("sendCommand (%s) failed (%s) status=%s", api_call, (body or ""), (status or "")))
    return nil
end

function daikin:parse_body(body)
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

function daikin:decode(s)
    s = (s == nil) and "" or s:gsub("^%s*(.-)%s*$", "%1")
    return (string.gsub (string.gsub (s, "+", " "),"%%(%x%x)", function (str)
        return string.char (tonumber (str, 16)) end ))
end

return daikin
