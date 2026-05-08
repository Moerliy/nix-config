---@type HyprModule
return {
	name = "Sane defaults",
	startup = function()
		hl.exec_cmd(
			"dbus-update-activation-environment --systemd DISPLAY HYPRLAND_INSTANCE_SIGNATURE WAYLAND_DISPLAY XDG_CURRENT_DESKTOP XDG_SESSION_TYPE && systemctl --user stop hyprland-session.target && systemctl --user start hyprland-session.target"
		)
		-- hl.exec_cmd("ln -s $XDG_RUNTIME_DIR/hypr /tmp/hypr")
		hl.exec_cmd("$HOME/.local/bin/clipboard-sync")
		hl.exec_cmd("clipse -listen")
		hl.exec_cmd("waybar")
		hl.exec_cmd(require("globals").terminal, {
			workspace = "special:special silent",
		})
		hl.exec_cmd(require("globals").terminal, {
			workspace = "1",
		})
		hl.exec_cmd("firefox", {
			workspace = "2 silent",
		})
		hl.exec_cmd("vesktop", {
			workspace = "8 silent",
		})
	end,
	setup = function()
		hl.config({
			input = {
				kb_layout = "de,us",
				sensitivity = 0,
				accel_profile = "flat",
				follow_mouse = 1,
				numlock_by_default = true,
				repeat_delay = 250,
				repeat_rate = 75,
			},
			binds = {
				workspace_back_and_forth = true,
			},
			misc = {
				disable_hyprland_logo = true,
				disable_splash_rendering = true,
				mouse_move_enables_dpms = true,
				mouse_move_focuses_monitor = true,
				enable_swallow = true,
				key_press_enables_dpms = true,
				background_color = "0x111111",
			},
		})
		if require("globals").host == "asahi" then
			hl.config({
				input = {
					touchpad = {
						scroll_factor = 0.2,
						natural_scroll = false,
						tap_to_click = true,
						drag_lock = true,
						disable_while_typing = true,
						middle_button_emulation = true,
					},
				},
				gestures = {
					workspace_swipe_invert = false,
				},
			})
			hl.gesture({
				fingers = 3,
				direction = "horizontal",
				action = "workspace",
			})
			hl.gesture({
				fingers = 3,
				direction = "vertical",
				action = "special",
				workspace_name = "special",
			})
		end
	end,
}
