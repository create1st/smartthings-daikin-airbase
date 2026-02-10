local Attributes = {
  API_HOST = 'host',
  RETURN_CODE = 'ret', -- OK, PARAM NG
  MESSAGE = 'msg', -- 404 Not Found
  MAC = 'mac',
  SSID = 'ssid',
  DEVICE_NAME = 'name',
  DEVICE_TYPE = 'type', -- aircon
  REGION = 'reg', -- au
  DST = 'dst', -- 0 ??
  FIRMWARE_VERSION = 'ver', -- 1_2_1
  FIRMWARE_REVISION = 'rev', -- 23
  ERROR = 'err', -- 0
  LOCATION = 'location', -- 0 ??
  ICON = 'icon', -- 0 ??
  DISCOVERY_PORT = 'port', -- 30050
  USER_ID = 'id',
  PASSWORD = 'pw',
  LPW_FLAG = 'lpw_flag', -- 0 ??
  ADP_KIND = 'adp_kind', -- 3 ??
  ADP_MODE = 'adp_mode', -- run
  LED = 'led', -- 1 ??
  EN_SET_ZONE = 'en_setzone', -- 1 ??
  EN_CHANNEL = 'en_ch', -- 1 ??
  HOLIDAY = 'holiday', -- 0 ??
  EN_HOL = 'en_hol', -- 0 ??
  SYNC_TIME = 'sync_time', -- 0 ??
  ERROR_TYPE = 'err_type', -- 0
  ERROR_CODE = 'err_code', -- 0

  OPERATE = 'operate', -- 2=DRY, 2=COLD, 1=HOT, 0=FAN, ???=AUTO
  BK_AUTO = 'bk_auto', -- 2=DRY, 2=COLD, 1=HOT, 1=FAN, ???=AUTO

  -- MODE
  POWER_STATUS = 'pow', -- 0=OFF, 1=ON
  AIRCON_MODE = 'mode', -- 7=DRY, 2=COLD, 1=HOT, 0=FAN, ???=AUTO

  -- REMOTE CONTROL
  REMOTE_METHOD = 'method', -- polling
  NOTICE_IP = 'notice_ip_int', -- 3600 sec
  NOTICE_SYNC = 'notice_sync_int', -- 6 sec

  -- TEMPERATURE
  TEMPERATURE_SET = 'stemp', --AUTO=18-31, HOT=10-31, COLD=18-33
  TEMPERATURE_HEAT_RO = 'dt1',
  TEMPERATURE_COOL_RO = 'dt2',
  TEMPERATURE_HOME_RO = 'htemp', -- inside temperature
  TEMPERATURE_OUTDOOR_RO = 'otemp', -- outside temperature

  -- FAN
  FAN_SPEED = 'f_rate', -- 1=lvl1, 2=lvl3, 5=lvl3, 0=lvl_auto
  FAN_SPEED_HEAT_RO = 'dfr1',
  FAN_SPEED_COOL_RO = 'dfr2',
  FAN_DIRECTION = 'f_dir', -- 0 for ducted system without control
  FAN_DIRECTION_HEAT_RO = 'dfd1',
  FAN_DIRECTION_COOL_RO = 'dfd2',
}

return Attributes
