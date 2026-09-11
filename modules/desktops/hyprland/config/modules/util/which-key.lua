---@type HyprModule
return {
	name = "Which Key",
	-- startup = function()
	-- 	hl.exec_cmd("eww --config $HOME/.config/eww-which-key daemon")
	-- end,
	binds = {
		{
			key = { "SUPER + H" },
			action = function()
				hl.dispatch(hl.dsp.exec_cmd("$HOME/.local/bin/which-key -b"))
			end,
			desc = "Toggle Binds Help",
			single_use = false,
		},
	},
	dynamics = function()
		local globals = require("globals")
		local which_key = require(globals.hyprlui_dir .. "/demos/which-key.lua")
		which_key.setup({
			yOffset = 0,
			buildPopup = function(columns)
				return hl.plugin.hyprlui.Component("WhichKeyPopup", {
					columns = columns,
					font = "JetBrainsMono Nerd Font",
					size = 14,
					padding = { top = 10, right = 30, bottom = 10, left = 30 },
				}, { key = "popup" })
			end,
		})
	end,
}
