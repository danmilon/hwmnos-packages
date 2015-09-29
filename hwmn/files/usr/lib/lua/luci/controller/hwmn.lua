--[[
LuCI - Lua Configuration Interface

Copyright 2008 Steven Barth <steven@midlink.org>
Copyright 2015 Dan Milon <i@danmilon.me>

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

	http://www.apache.org/licenses/LICENSE-2.0

$Id$
]]--

module("luci.controller.hwmn", package.seeall)

function index()
	local uci = require "luci.model.uci".cursor()
	local page

	-- Frontend
	page          = node()
	page.lock     = true
	page.target   = alias("HWMN")
	page.subindex = true
	page.index    = false

	page          = node("HWMN")
	page.title    = _("HWMN")
	page.target   = alias("HWMN", "index")
	page.order    = 5
	page.setuser  = "nobody"
	page.setgroup = "nogroup"
	page.i18n     = "freifunk"
	page.index    = true

	page          = node("HWMN", "index")
	page.target   = template("hwmn/index")
	page.title    = _("Overview")
	page.order    = 10
	page.indexignore = true

	page          = node("HWMN", "contact")
	page.target   = template("hwmn/contact")
	page.title    = _("Contact")
	page.order    = 15

	if nixio.fs.access("/usr/sbin/luci-splash") then
		assign({"hwmn", "status", "splash"}, {"splash", "publicstatus"}, _("Splash"), 40)
	end

	page = assign({"hwmn", "olsr"}, {"admin", "status", "olsr"}, _("OLSR"), 30)
	page.setuser = false
	page.setgroup = false

	if nixio.fs.access("/etc/config/luci_statistics") then
		assign({"hwmn", "graph"}, {"admin", "statistics", "graph"}, _("Statistics"), 40)
	end

	-- backend
	assign({"mini", "hwmn"}, {"admin", "hwmn"}, _("HWMN"), 5)
	entry({"admin", "hwmn"}, alias("admin", "hwmn", "index"), _("HWMN"), 5)

	page        = node("admin", "hwmn")
	page.target = template("hwmn/adminindex")
	page.title  = _("HWMN")
	page.order  = 5

	page        = node("admin", "hwmn", "basics")
	page.target = cbi("hwmn/basics")
	page.title  = _("Basic Settings")
	page.order  = 5

	page        = node("admin", "hwmn", "contact")
	page.target = cbi("hwmn/contact")
	page.title  = _("Contact")
	page.order  = 15
end
