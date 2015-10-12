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
hwmn_generic = hwmn:section(TypedSection, "generic", "Generic")
hwmn_generic.anonymous = true
enabled = hwmn_generic:option(
   Flag,
   "enabled",
   translate("Enable easy HWMN set up. If not checked, no further changes will be made to your device."))

node_name = hwmn_generic:option(
   Value,
   "node_name",
   translate("The name of this HWMN node."))
node_name.datatype = "hostname"
function node_name.write(self, section, value)
   Value.write(self, section, value)
   sys.hostname("router." .. value .. ".node.her.wn")
end

hwmn_network = hwmn:section(TypedSection, "network", "Networking")
hwmn_network.anonymous = true
ipv4_subnet = hwmn_network:option(
  Value,
  "ipv4_subnet",
  translate("The IPv4 subnet given to you in the form of 10.176.XXX.XXX/XX. When you apply the settings, you will have to reconnect to the network and the router will be available under the IP address \"10.176.XXX.1\"."))
function ipv4_subnet.validate(self, value)
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

hwmn_links = hwmn:section(TypedSection, "link", "Links")
hwmn_links.anonymous = true
hwmn_links.addremove = true
hwmn_links:option(
   Value,
   "destination_node_name",
   translate("The name of the destination HWMN node."))

hwmn_links:option(
   Value,
   "ipv4_subnet",
   translate("The IPV4 subnet assigned to this link."))

hwmn_links:option(
   Value,
   "ifname",
   translate("Name of interface connecting to the antenna."))

return hwmn
