---@type HyprModule
return {
	name = "Ui tweaks",
	setup = function()
		hl.config({
			general = {
				border_size = 2,
				gaps_in = 5,
				gaps_out = 3,
				col = {
					active_border = "0xffcba6f7", -- mauve
					inactive_border = "0xff6c7086",
				},
				resize_on_border = true,
				hover_icon_on_border = false,
				layout = "dwindle",
			},
			decoration = {
				rounding = 5,
				active_opacity = 1,
				--inactive_opacity = 0.9;
				fullscreen_opacity = 1,
				blur = {
					enabled = true,
					size = 3,
					passes = 3,
					new_optimizations = true,
				},
				shadow = {
					enabled = false,
				},
			},
			animations = {
				enabled = true,
			},
		})
		hl.curve("simple", { type = "bezier", points = { { 0.16, 1 }, { 0.3, 1 } } })
		hl.curve("tehtarik", { type = "bezier", points = { { 0.68, -0.55 }, { 0.265, 1.55 } } })
		hl.curve("overshot", { type = "bezier", points = { { 0.05, 0.9 }, { 0.1, 1.05 } } })
		hl.curve("smoothOut", { type = "bezier", points = { { 0.36, 0 }, { 0.66, -0.56 } } })
		hl.curve("smoothIn", { type = "bezier", points = { { 0.25, 1 }, { 0.5, 1 } } })
		hl.curve("rotate", { type = "bezier", points = { { 0, 0 }, { 1, 1 } } })
		hl.curve("fade", { type = "bezier", points = { { 0.25, 0.1 }, { 0.25, 0.9 } } })
		hl.animation({
			leaf = "windows",
			enabled = true,
			speed = 5,
			bezier = "overshot",
			style = "popin",
		})
		hl.animation({
			leaf = "windowsOut",
			enabled = true,
			speed = 4,
			bezier = "tehtarik",
			style = "slide",
		})
		hl.animation({
			leaf = "fade",
			enabled = true,
			speed = 10,
			bezier = "simple",
		})
		hl.animation({
			leaf = "workspaces",
			enabled = true,
			speed = 6,
			bezier = "simple",
			style = "slide",
		})
		hl.animation({
			leaf = "specialWorkspace",
			enabled = true,
			speed = 6,
			bezier = "fade",
			style = "fade",
		})
	end,
	rules = {
		window = {
			{
				match = {
					pin = true,
				},
				border_color = "rgb(cba6f7) rgb(89b4fa)",
			},
		},
	},
	dynamics = function()
		local mouse_drag_bind =
			hl.bind("mouse:274", hl.dsp.window.drag(), { mouse = true, description = "Move Window" })
		hl.on("window.fullscreen", function(w)
			if w.fullscreen == 2 then
				mouse_drag_bind:set_enabled(false)
			else
				mouse_drag_bind:set_enabled(true)
			end
		end)
		hl.on("window.active", function(w)
			if w.fullscreen == 2 then
				mouse_drag_bind:set_enabled(false)
			else
				mouse_drag_bind:set_enabled(true)
			end
		end)
	end,
}
