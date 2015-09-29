--[[
LuCI - Lua Configuration Interface

Copyright 2008 Steven Barth <steven@midlink.org>
Copyright 2011 Manuel Munz <freifunk at somakoma de>
Copyright 2015 Dan Milon <i@danmilon.me>

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

	http://www.apache.org/licenses/LICENSE-2.0
]]

local ip = require "luci.ip"
local sys = require "luci.sys"

hwmn = Map("hwmn", "HWMN", translate("HWMN specific configuration"))
hwmn_generic = hwmn:section(TypedSection, "hwmn", "generic")
hwmn_generic.anonymous = true
enabled = hwmn_generic:option(
   Flag,
   "enabled",
   translate("Enable easy HWMN set up. If not checked, no further changes will be made to your device."))

hwmn_network = hwmn:section(TypedSection, "hwmn", "network")
hwmn_network.anonymous = true
ipv4_range = hwmn_network:option(
  Value,
  "ipv4_range",
  translate("The IPv4 range given to you in the form of 10.176.XXX.XXX/XX"))

function ipv4_range.validate(self, value)
   if not value then
     return nil
   end

   ipv4, prefix = value:match("(.+)/(.+)")
   if not (ipv4 and prefix) then
     return nil
   end

   ipv4 = ip.IPv4(ipv4)
   prefix = tonumber(prefix)
   if ipv4 and prefix and prefix >= 0 and prefix <= 32 then
     return value
   end
end

system = Map("system", translate("Basic system settings"))
system.anonymous = true
b = system:section(TypedSection, "system")
b.anonymous = true

hostname = b:option(Value, "hostname", translate("Name of this node"))
hostname.rmempty = false
hostname.datatype = "hostname"

function hostname.write(self, section, value)
   Value.write(self, section, value)
   sys.hostname(value)
end

return hwmn, system
