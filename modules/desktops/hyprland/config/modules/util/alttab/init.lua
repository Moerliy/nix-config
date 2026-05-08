---@type HyprModule
return {
	name = "AltTab",
	rules = {
		window = {
			{
				match = {
					class = "alttab",
				},
				no_anim = false,
				stay_focused = true,
				focus_on_activate = true,
				workspace = "special:alttab",
			},
		},
		workspace = {
			{
				workspace = "special:alttab",
				monitor = require("globals").monitor.main,
				persistent = false,
				gaps_out = 0,
				gaps_in = 0,
				border_size = 0,
			},
		},
	},
	binds = {
		{
			key = { "ALT + tab" },
			action = function()
				hl.dispatch(hl.dsp.exec_cmd("$HOME/.config/hypr/script/alttab/enable.sh 'down'"))
			end,
			desc = "Alt Tab",
			single_use = false,
		},
		{
			key = { "ALT + SHIFT + tab" },
			action = function()
				hl.dispatch(hl.dsp.exec_cmd("$HOME/.config/hypr/script/alttab/enable.sh 'up'"))
			end,
			desc = "Alt Tab Reverse",
			single_use = false,
		},
	},
	dynamics = function()
		local disable = require("modules.util.alttab.alttab").disable

		hl.define_submap("alttab", function()
			hl.bind("ALT + tab", function()
				hl.dispatch(hl.dsp.send_key_state({ mods = "", key = "tab", state = "down", window = "class:alttab" }))
				hl.dispatch(hl.dsp.send_key_state({ mods = "", key = "tab", state = "up", window = "class:alttab" }))
			end, { description = "Alt Tab" }) -- :set_enabled(false)
			hl.bind("ALT + SHIFT + tab", function()
				hl.dispatch(
					hl.dsp.send_key_state({ mods = "shift", key = "tab", state = "down", window = "class:alttab" })
				)
				hl.dispatch(
					hl.dsp.send_key_state({ mods = "shift", key = "tab", state = "up", window = "class:alttab" })
				)
			end, { description = "Alt Tab Reverse" })
			hl.bind("ALT + ALT_L", function()
				disable()
				hl.dispatch(
					hl.dsp.send_key_state({ mods = "", key = "return", state = "down", window = "class:alttab" })
				)
			end, { release = true, transparent = true })
			hl.bind("ALT + SHIFT + ALT_L", function()
				disable()
				hl.dispatch(
					hl.dsp.send_key_state({ mods = "", key = "return", state = "down", window = "class:alttab" })
				)
			end, { release = true, transparent = true })
			hl.bind("ALT + Return", function()
				disable()
				hl.dispatch(
					hl.dsp.send_key_state({ mods = "", key = "return", state = "down", window = "class:alttab" })
				)
			end)
			hl.bind("ALT + SHIFT + Return", function()
				disable()
				hl.dispatch(
					hl.dsp.send_key_state({ mods = "", key = "return", state = "down", window = "class:alttab" })
				)
			end)
			hl.bind("ALT + escape", function()
				disable()
				hl.dispatch(
					hl.dsp.send_key_state({ mods = "", key = "escape", state = "down", window = "class:alttab" })
				)
			end)
			hl.bind("ALT + SHIFT + escape", function()
				disable()
				hl.dispatch(
					hl.dsp.send_key_state({ mods = "", key = "escape", state = "down", window = "class:alttab" })
				)
			end)
		end)
	end,
}
