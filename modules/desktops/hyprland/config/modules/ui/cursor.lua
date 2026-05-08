---@type HyprModule
return {
	name = "Cursor",
	setup = function()
		hl.config({
			cursor = {
				enable_hyprcursor = true,
				sync_gsettings_theme = true,
				no_hardware_cursors = true,
				inactive_timeout = 3,
				hide_on_key_press = true,
			},
		})
	end,
}
