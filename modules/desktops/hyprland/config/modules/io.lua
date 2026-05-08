---@type HyprModule
return {
	name = "Monitor/Devices",
	setup = function()
		local globals = require("globals")

		hl.monitor({
			output = "",
			mode = "preferred",
			position = "auto",
			scale = "auto",
		})
		hl.monitor({
			output = "",
			mode = "preferred",
			position = "auto",
			scale = "1",
			mirror = globals.monitor.main,
		})
		if globals.host == "asahi" then
			hl.monitor({
				output = globals.monitor.build_in,
				mode = "preferred",
				position = "auto",
				scale = "1.6",
			})
			hl.monitor({
				output = globals.monitor.main,
				mode = "preferred",
				position = "auto",
				scale = "1.6",
				mirror = globals.monitor.build_in,
			})
			hl.monitor({
				output = globals.monitor.second,
				mode = "3840x2160@60.00",
				position = "-3840x0",
				scale = "1",
			})
		elseif globals.host == "nvidia" then
			hl.monitor({
				output = globals.monitor.main,
				mode = "2560x1440@164.80200",
				position = "0x0",
				scale = "1",
			})
			hl.monitor({
				output = globals.monitor.second,
				mode = "2560x1440@60.00",
				position = "-2560x0",
				scale = "1",
			})
		else
			hl.monitor({
				output = globals.monitor.main,
				mode = "preferred",
				position = "auto",
				scale = "1",
			})
		end

		hl.device({
			name = "urchin-keyboard",
			kb_layout = "us",
		})
		hl.device({
			name = "-------akko-2.4g-wireless-keyboard",
			kb_layout = "us",
		})
		hl.device({
			name = "royuan-akko-keyboard",
			kb_layout = "us",
		})
		hl.device({
			name = "royuan-akko-keyboard-1",
			kb_layout = "us",
		})
	end,
	rules = {
		workspace = {
			{
				workspace = "1",
				monitor = require("globals").monitor.main,
				default = true,
			},
			{
				workspace = "2",
				monitor = require("globals").monitor.main,
			},
			{
				workspace = "4",
				monitor = require("globals").monitor.main,
			},
			{
				workspace = "8",
				monitor = require("globals").monitor.second, -- TODO: check if default on two screens = true
				default = true,
			},
		},
	},
}
