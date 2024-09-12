--ret=OK,err=0,model=NOTSUPPORT,type=N,humd=0,s_humd=7,en_zone=0,en_linear_zone=0,en_filter_sign=1,acled=1,land=0,elec=0,temp=1,m_dtct=0,ac_dst=au,dmnd=0,en_temp_setting=1,en_frate=1,en_fdir=0,en_rtemp_a=0,en_spmode=0,en_ipw_sep=0,en_scdltmr=0,en_mompow=0,en_patrol=0,en_airside=0,en_quick_timer=1,en_auto=0,en_dry=1,en_common_zone=0,cool_l=16,cool_h=32,heat_l=16,heat_h=32,frate_steps=3,en_frate_auto=1

local Attributes = {
  API_HOST = 'host',
  STATUS = 'ret', -- OK, PARAM NG
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
  FAN_SPEED_HEAT_RO = 'dfr2',
  FAN_SPEED_COOL_RO = 'dfr2',
  FAN_DIRECTION = 'f_dir', -- 0 for ducted system without control
  FAN_DIRECTION_HEAT_RO = 'dfd1',
  FAN_DIRECTION_COOL_RO = 'dfd1',
}

--DRY
--ret=OK,pow=0,mode=7,operate=2,bk_auto=2,stemp=25,dt1=25,dt2=25,f_rate=1,dfr1=1,dfr2=1,f_airside=0,airside1=0,airside2=0,f_auto=0,auto1=0,auto2=0,f_dir=0,dfd1=0,dfd2=0,filter_sign_info=0,cent=0,en_cent=0,remo=2
--HEAT 25
--ret=OK,pow=0,mode=1,operate=1,bk_auto=1,stemp=25,dt1=25,dt2=25,f_rate=1,dfr1=1,dfr2=1,f_airside=0,airside1=0,airside2=0,f_auto=0,auto1=0,auto2=0,f_dir=0,dfd1=0,dfd2=0,filter_sign_info=0,cent=0,en_cent=0,remo=2
--FAN
--ret=OK,pow=0,mode=0,operate=0,bk_auto=1,stemp=25,dt1=25,dt2=25,f_rate=1,dfr1=1,dfr2=1,f_airside=0,airside1=0,airside2=0,f_auto=0,auto1=0,auto2=0,f_dir=0,dfd1=0,dfd2=0,filter_sign_info=0,cent=0,en_cent=0,remo=2
--COOL 25
--ret=OK,pow=0,mode=2,operate=2,bk_auto=2,stemp=25,dt1=25,dt2=25,f_rate=1,dfr1=1,dfr2=1,f_airside=0,airside1=0,airside2=0,f_auto=0,auto1=0,auto2=0,f_dir=0,dfd1=0,dfd2=0,filter_sign_info=0,cent=0,en_cent=0,remo=2
--AUTO cool
--ret=OK,pow=0,mode=2,operate=2,bk_auto=2,stemp=25,dt1=25,dt2=25,f_rate=1,dfr1=1,dfr2=1,f_airside=0,airside1=0,airside2=0,f_auto=0,auto1=0,auto2=0,f_dir=0,dfd1=0,dfd2=0,filter_sign_info=0,cent=0,en_cent=0,remo=2

-- FAN 1
-- ret=OK,pow=0,mode=0,operate=0,bk_auto=2,stemp=25,dt1=25,dt2=24,f_rate=1,dfr1=1,dfr2=1,f_airside=0,airside1=0,airside2=0,f_auto=0,auto1=0,auto2=0,f_dir=0,dfd1=0,dfd2=0,filter_sign_info=0,cent=0,en_cent=0,remo=2
-- FAN 2
-- ret=OK,pow=0,mode=0,operate=0,bk_auto=2,stemp=25,dt1=25,dt2=25,f_rate=3,dfr1=1,dfr2=3,f_airside=0,airside1=0,airside2=0,f_auto=0,auto1=0,auto2=0,f_dir=0,dfd1=0,dfd2=0,filter_sign_info=0,cent=0,en_cent=0,remo=2
-- FAN 3
-- ret=OK,pow=0,mode=0,operate=0,bk_auto=2,stemp=25,dt1=25,dt2=25,f_rate=5,dfr1=1,dfr2=5,f_airside=0,airside1=0,airside2=0,f_auto=0,auto1=0,auto2=0,f_dir=0,dfd1=0,dfd2=0,filter_sign_info=0,cent=0,en_cent=0,remo=2
-- FAN AUTO
-- ret=OK,pow=0,mode=0,operate=0,bk_auto=2,stemp=25,dt1=25,dt2=25,f_rate=0,dfr1=1,dfr2=0,f_airside=0,airside1=0,airside2=0,f_auto=0,auto1=0,auto2=0,f_dir=0,dfd1=0,dfd2=0,filter_sign_info=0,cent=0,en_cent=0,remo=2
return Attributes
