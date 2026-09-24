---@type HyprModule
return {
	name = "Notifications",
	dynamics = function()
		local globals = require("globals")
		local notification_manager = require(globals.hyprlui_dir .. "/demos/notification-manager/notification-manager.lua")
		notification_manager.setup()
	end,
}
