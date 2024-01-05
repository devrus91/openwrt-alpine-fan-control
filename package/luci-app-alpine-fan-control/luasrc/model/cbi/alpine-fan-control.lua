-- Copyright 2008 Steven Barth <steven@midlink.org>
-- Copyright 2008 Jo-Philipp Wich <jow@openwrt.org>
-- Licensed to the public under the Apache License 2.0.

local fs  = require "nixio.fs" 
local sys = require "luci.sys"
local m, s, p

local service_running = (luci.sys.call("pgrep -f \"/alpine-fan-controller\" > /dev/null"))==0

local state_msg = " "

if service_running then
    state_msg="<span style=\"color:green;font-weight:bold\">" .. translate("Active")
else
    state_msg="<span style=\"color:red;font-weight:bold\">" .. translate("Inactive")  .. "</span>"
end

m = Map("alpine-fan-control", translate("Fan Control"),	translate("Service status: ") .. state_msg)

s = m:section(TypedSection, "alpine-fan-control", translate("Settings"))
s.addremove = false
s.anonymous = true

e = s:option(Flag, "enable", translate("Enabled"), translate("Enables or disables the fan control daemon."))
e.rmempty = false
function e.write(self, section, value)
    if value == "1" then
        luci.sys.call("/etc/init.d/alpine-fan-control start >/dev/null")
    else
        luci.sys.call("/etc/init.d/alpine-fan-control stop >/dev/null")
    end
    return Flag.write(self, section, value)
end

dbg = s:option(Flag, "debug", translate("Debug"), translate("Enables or disables debugging output."))
dbg.datatype = "uinteger"
dbg.default = "0"
dbg.rmempty = false
dbg.optional = false

min_temp = s:option(Value, "min_temp", translate("min_temp"), translate("Temperature for minimum fan state (Celsius)"))
min_temp.datatype = "uinteger"
min_temp.default = "40"
min_temp.rmempty = false
min_temp.optional = false

min_speed = s:option(Value, "min_speed", translate("min_speed"), translate("Fan speed at minimum fan state"))
min_speed.datatype = "uinteger"
min_speed.default = "1500"
min_speed.rmempty = false
min_speed.optional = false

med_temp = s:option(Value, "med_temp", translate("med_temp"), translate("Temperature for medium fan state (Celsius)"))
med_temp.datatype = "uinteger"
med_temp.default = "45"
med_temp.rmempty = false
med_temp.optional = false

med_speed = s:option(Value, "med_speed", translate("med_speed"), translate("Fan speed at medium fan state"))
med_speed.datatype = "uinteger"
med_speed.default = "2000"
med_speed.rmempty = false
med_speed.optional = false

max_temp = s:option(Value, "max_temp", translate("max_temp"), translate("Temperature for maximum fan state (Celsius)"))
max_temp.datatype = "uinteger"
max_temp.default = "50"
max_temp.rmempty = false
max_temp.optional = false

max_speed = s:option(Value, "max_speed", translate("max_speed"), translate("Fan speed at maximum fan state (default: 2500)"))
max_speed.datatype = "uinteger"
max_speed.default = "2500"
max_speed.rmempty = false
max_speed.optional = false

interval = s:option(Value, "interval", translate("interval"), translate("Interval for hysteresis adjustment"))
interval.datatype = "uinteger"
interval.default = "5"
interval.rmempty = false
interval.optional = false

return m
