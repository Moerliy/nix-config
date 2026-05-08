---@type HyprModule
return {
	name = "Which Key",
	startup = function()
		hl.exec_cmd("eww --config $HOME/.config/eww-which-key daemon")
	end,
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
		hl.on("keybinds.submap", function(s)
			hl.exec_cmd(globals.scriptDir .. "/which-key " .. s)
		end)
	end,
}
