local socket = require('cosock.socket')
local cosock = require('cosock')
local http = cosock.asyncify('socket.http')
local neturl = require('net.url')
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

-- Status info
-- ret=OK,type=aircon,reg=au,dst=0,ver=1_2_1,rev=23,pow=1,err=0,location=0,name=%41%69%72%63%6f%6e,icon=0,method=polling,port=30050,id=user,pw=password,lpw_flag=0,adp_kind=3,led=1,en_setzone=1,mac=111111111111,adp_mode=run,ssid=DaikinAPxxxxx,err_type=0,err_code=0,en_ch=1,holiday=0,en_hol=0,sync_time=0
function Daikin:basic_info()
    log.debug(string.format("basic_info (%s)", self.api_host))
    return self:send_command('/common/basic_info')
end

-- Indoor/outdoor temperature sensor
-- ret=OK,err=0,htemp=23,otemp=20
function Daikin:get_sensor_info()
    log.debug(string.format("get_sensor_info (%s)", self.api_host))
    return self:send_command('/aircon/get_sensor_info')
end

-- Model information
-- ret=OK,err=0,model=NOTSUPPORT,type=N,humd=0,s_humd=7,en_zone=0,en_linear_zone=0,en_filter_sign=1,acled=1,land=0,elec=0,temp=1,m_dtct=0,ac_dst=au,dmnd=0,en_temp_setting=1,en_frate=1,en_fdir=0,en_rtemp_a=0,en_spmode=0,en_ipw_sep=0,en_scdltmr=0,en_mompow=0,en_patrol=0,en_airside=0,en_quick_timer=1,en_auto=0,en_dry=1,en_common_zone=0,cool_l=16,cool_h=32,heat_l=16,heat_h=32,frate_steps=3,en_frate_auto=1
function Daikin:get_model_info()
    log.debug(string.format("get_model_info (%s)", self.api_host))
    return self:send_command('/aircon/get_model_info')
end

-- Pooling information
-- ret=OK,method=polling,notice_ip_int=3600,notice_sync_int=6
function Daikin:get_model_info()
    log.debug(string.format("get_model_info (%s)", self.api_host))
    return self:send_command('/aircon/get_model_info')
end

-- Get all aircon parameters
-- ret=OK,pow=0,mode=7,operate=2,bk_auto=2,stemp=25,dt1=25,dt2=25,f_rate=1,dfr1=1,dfr2=1,f_airside=0,airside1=0,airside2=0,f_auto=0,auto1=0,auto2=0,f_dir=0,dfd1=0,dfd2=0,filter_sign_info=0,cent=0,en_cent=0,remo=2
function Daikin:get_control_info()
    log.debug(string.format("get_control_info (%s)", self.api_host))
    return self:send_command('/aircon/get_control_info')
end

-- Set all aircon parameters
-- ret=OK
function Daikin:set_control_info(data)
    log.debug(string.format("set_control_info (%s), (%s)", self.api_host, (data or "")))
    return self:send_command('/aircon/set_control_info', data)
end

-- Reboot controller
-- ret=OK
function Daikin:reboot()
    log.debug(string.format("reboot (%s)", self.api_host))
    return self:send_command('/common/reboot')
end

function Daikin:send_command(command_url, data)
    log.debug(string.format("send_command (%s), (%s)", self.api_host, command_url, (data or "")))
    local query = neturl.buildQuery(body or {})
    local api_call = string.format("http://%s/skyfi%s?%s", self.api_host, command_url, query)
    log.debug(string.format("send_command (%s)", api_call))
    local retries = 0
    while retries < MAX_RECONNECT_ATTEMPTS do
        local res = {}
        local _, status = http.request({
            url = api_call,
            method = 'GET',
            sink = ltn12.sink.table(res)
        })
        if (status == 200) then
            return self:parse_body(table.concat(res))
        end
        socket.sleep(RECONNECT_PERIOD)
    end

    log.debug(string.format("send_command (%s) failed (%s) status=%s", api_call, (body or ""), (status or "")))
    return nil
end

function Daikin:to_body(data)
    local response = ""
    if (data == nil or data == false) then
        return response
    end
    for k, v in pairs(tbl) do
        if type(k) == "string" then
            response = string.format("%s,%s=%s", response, k, v);
        end
    end
    if response ~= "" then
        response = response:sub(2)
    end
    log.debug(string.format("parse_body: key=%s, value=%s", (key or ""), (value or "")))
    return response
end

function Daikin:parse_body(body)
    local response = {}
    if (body == nil or body == false) then
        return response
    end
    for pair in body:gmatch "[^,]+" do
        local key, value = pair:match "([^=]*)=(.*)"
        key = self:decode(key)
        value = self:decode(value)
        log.debug(string.format("parse_body: key=%s, value=%s", (key or ""), (value or "")))
        response[key] = value
    end
    return response
end

function Daikin:decode(s)
    s = (s == nil) and "" or s:gsub("^%s*(.-)%s*$", "%1")
    return (string.gsub(string.gsub(s, "+", " "), "%%(%x%x)", function(str)
        return string.char(tonumber(str, 16))
    end))
end

return Daikin
