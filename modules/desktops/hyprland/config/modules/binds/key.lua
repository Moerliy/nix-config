---@type HyprModule
return {
	name = "Keyboard Keybinds",
	-- setup = function() end,
	binds = {
		{
			key = { require("globals").main_mod .. " + Space", "O", "Q" },
			action = function()
				hl.dispatch(hl.dsp.window.close())
			end,
			desc = "Close Window",
			single_use = true,
		},
		{
			key = { require("globals").main_mod .. " + Space", "O", "T" },
			action = function()
				hl.dispatch(hl.dsp.exec_cmd(require("globals").terminal))
			end,
			desc = "Open Terminal",
			single_use = true,
		},
		{
			key = { require("globals").main_mod .. " + Space", "O", "F" },
			action = function()
				hl.dispatch(hl.dsp.exec_cmd("pcmanfm"))
			end,
			desc = "Open Files",
			single_use = true,
		},
		{
			key = { require("globals").main_mod .. " + Space", "O", "B" },
			action = function()
				hl.exec_cmd("firefox", { workspace = 2 })
			end,
			desc = "Open Browser",
			single_use = true,
		},
		{
			key = { require("globals").main_mod .. " + Space", "O", "D" },
			action = function()
				hl.exec_cmd("vesktop", { workspace = 8 })
			end,
			desc = "Open Discord",
			single_use = true,
		},
		{
			key = { require("globals").main_mod .. " + Space", "O", "C" },
			action = function()
				hl.dispatch(hl.dsp.exec_cmd("rofi -show drun"))
			end,
			desc = "Open Controll Center",
			single_use = true,
		},
	},
}
