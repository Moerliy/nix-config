local host = "HOST"
local monitor = {
	main = "MONITOR_MAIN",
	second = "MONITOR_SECOND",
	build_in = "MONITOR_BUILDIN",
}
local main_mod = "SUPER"
local scriptDir = "$HOME/.local/bin"
local terminal = "TERMINAL"

hl.monitor({
	output = "",
	mode = "preferred",
	position = "auto",
	scale = "auto",
})
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
	input = {
		kb_layout = "de,us",
		sensitivity = 0,
		accel_profile = "flat",
		follow_mouse = 1,
		numlock_by_default = true,
		repeat_delay = 250,
		repeat_rate = 75,
	},
	dwindle = {
		force_split = 2,
		preserve_split = true,
		special_scale_factor = 0.8,
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
	cursor = {
		enable_hyprcursor = true,
		sync_gsettings_theme = true,
		no_hardware_cursors = true,
		inactive_timeout = 3,
		hide_on_key_press = true,
	},
	debug = {
		damage_tracking = 2,
		disable_logs = false,
		-- overlay = true;
		-- damage_blink = true;
	},
})
if host == "asahi" then
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
hl.monitor({
	output = "",
	mode = "preferred",
	position = "auto",
	scale = "1",
	mirror = monitor.main,
})
if host == "asahi" then
	hl.monitor({
		output = monitor.build_in,
		mode = "preferred",
		position = "auto",
		scale = "1.6",
	})
	hl.monitor({
		output = monitor.main,
		mode = "preferred",
		position = "auto",
		scale = "1.6",
		mirror = monitor.build_in,
	})
	hl.monitor({
		output = monitor.second,
		mode = "3840x2160@60.00",
		position = "-3840x0",
		scale = "1",
	})
elseif host == "nvidia" then
	hl.monitor({
		output = monitor.main,
		mode = "2560x1440@164.80200",
		position = "0x0",
		scale = "1",
	})
	hl.monitor({
		output = monitor.second,
		mode = "2560x1440@60.00",
		position = "-2560x0",
		scale = "1",
	})
else
	hl.monitor({
		output = monitor.main,
		mode = "preferred",
		position = "auto",
		scale = "1",
	})
end

hl.workspace_rule({
	workspace = "1",
	monitor = monitor.main,
	default = true,
})
hl.workspace_rule({
	workspace = "2",
	monitor = monitor.main,
})
hl.workspace_rule({
	workspace = "8",
	monitor = monitor.second, -- TODO: check if default on two screens = true
	default = true,
})
hl.workspace_rule({
	workspace = "special:alttab",
	persistent = false,
	gaps_out = 0,
	gaps_in = 0,
	border_size = 0,
})
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
	bezier = "fade",
})
hl.animation({
	leaf = "workspaces",
	enabled = true,
	speed = 6,
	bezier = "fade",
	style = "slide",
})
hl.animation({
	leaf = "specialWorkspace",
	enabled = true,
	speed = 6,
	bezier = "fade",
	style = "fade",
})
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
hl.bind(main_mod .. " + return", hl.dsp.exec_cmd(terminal), { description = "Open Terminal" })
hl.bind(
	main_mod .. " + escape",
	hl.dsp.exec_cmd("$HOME/.config/rofi/bin/powermenu-large"),
	{ description = "Exit Manager" }
)
hl.bind(main_mod .. " + B", hl.dsp.exec_cmd("firefox"), { description = "Open Browser" })
hl.bind(main_mod .. " + Q", hl.dsp.window.close(), { description = "Close Window" })
hl.bind(main_mod .. " + C", hl.dsp.exec_cmd("rofi -show drun"), { description = "Open Control Center" })
hl.bind(main_mod .. " + F", hl.dsp.window.float({ action = "toggle" }), { description = "Toggle Floating" })
hl.bind(main_mod .. " + H", hl.dsp.exec_cmd("$HOME/.local/bin/which-key -b"), { description = "Toggle Binds Help" })

for i = 1, 10 do
	local key = i % 10
	hl.bind(main_mod .. " + " .. key, hl.dsp.focus({ workspace = i }), { description = "Focus Workspace " .. i })
	hl.bind(
		main_mod .. " + SHIFT + " .. key,
		hl.dsp.window.move({ workspace = i }),
		{ description = "Move Workspace " .. i }
	)
end
hl.bind("XF86AudioMute", hl.dsp.exec_cmd(scriptDir .. "/volume --toggle"), { description = "Deff Speakers" })
hl.bind("XF86AudioMicMute", hl.dsp.exec_cmd(scriptDir .. "/volume --toggle-mic"), { description = "Mute Mice" })
hl.bind(
	"XF86AudioLowerVolume",
	hl.dsp.exec_cmd(scriptDir .. "/volume --dec"),
	{ description = "Decrease Volume", release = true }
)
hl.bind(
	"XF86AudioRaiseVolume",
	hl.dsp.exec_cmd(scriptDir .. "/volume --inc"),
	{ description = "Increase Volume", release = true }
)
hl.bind(
	"XF86MonBrightnessDown",
	hl.dsp.exec_cmd(scriptDir .. "/brightness --dec"),
	{ description = "Decrease Screen Brightness", release = true }
)
hl.bind(
	"XF86MonBrightnessUP",
	hl.dsp.exec_cmd(scriptDir .. "/brightness --inc"),
	{ description = "Increase Screen Brightness", release = true }
)
hl.layer_rule({
	match = {
		class = "^(rofi)$",
	},
	no_anim = true,
})
hl.window_rule({
	match = {
		class = "(Rofi)",
		title = "(Rofi)",
	},
	float = true,
})
hl.window_rule({
	match = {
		class = "[Ss](team)",
	},
	workspace = "3",
	float = true,
})
hl.window_rule({
	match = {
		class = "(steam)",
		title = "(^[S]team)",
	},
	float = false,
})
hl.window_rule({
	match = {
		class = "(steam)",
		title = "(Friends List)",
	},
	float = true,
	center = true,
	size = { 500, 1000 },
})
hl.window_rule({
	match = {
		class = "(steam)",
		title = "(Steam Settings)",
	},
	float = true,
	center = true,
})
hl.window_rule({
	match = {
		class = "(steam)",
		title = "(Sign in to Steam)",
	},
	float = true,
	center = true,
})
hl.window_rule({
	match = {
		class = "(steam)",
		title = "(Shutdown)",
	},
	float = true,
	center = true,
})
hl.window_rule({
	match = {
		class = "^(steam_app)(.*)",
	},
	workspace = "4",
	fullscreen = true,
})
hl.window_rule({
	match = {
		class = "(osu!)",
		title = "(osu!)",
	},
	workspace = "4",
	fullscreen = true,
})
hl.window_rule({
	match = {
		class = "(cs2)",
	},
	workspace = "4",
	fullscreen = true,
})
hl.window_rule({
	match = {
		class = "(factorio)",
	},
	workspace = "4",
	fullscreen = true,
})
hl.window_rule({
	match = {
		title = "Picture-in-Picture",
	},
	float = true,
})
hl.window_rule({
	match = {
		title = "(Clipse)",
	},
	float = true,
	center = true,
	size = { 622, 652 },
})
hl.window_rule({
	match = {
		class = "(org.pulseaudio.pavucontrol)",
		title = "(Volume Control)",
	},
	float = true,
	center = true,
	size = { 1000, 800 },
})
hl.window_rule({
	match = {
		class = "proton.vpn.app.gtk",
	},
	float = true,
	center = true,
	size = { 800, 600 },
})
hl.window_rule({
	match = {
		title = "nmtui-session",
	},
	workspace = "1",
	float = true,
	center = true,
	size = { 800, 600 },
})
hl.window_rule({
	match = {
		class = "vesktop",
	},
	workspace = "8",
})
hl.window_rule({
	match = {
		class = "alttab",
	},
	no_anim = false,
	stay_focused = true,
	focus_on_activate = true,
	workspace = "special:alttab",
})
-- TODO: check what is still needed
hl.on("hyprland.start", function()
	hl.exec_cmd(
		"dbus-update-activation-environment --systemd DISPLAY HYPRLAND_INSTANCE_SIGNATURE WAYLAND_DISPLAY XDG_CURRENT_DESKTOP XDG_SESSION_TYPE && systemctl --user stop hyprland-session.target && systemctl --user start hyprland-session.target"
	)
	-- hl.exec_cmd("ln -s $XDG_RUNTIME_DIR/hypr /tmp/hypr")
	hl.exec_cmd("$HOME/.local/bin/clipboard-sync")
	hl.exec_cmd("clipse -listen")
	hl.exec_cmd("waybar")
	hl.exec_cmd("eww --config $HOME/.config/eww-which-key daemon")
	hl.exec_cmd(terminal, {
		workspace = "special:special silent",
	})
	hl.exec_cmd(terminal, {
		workspace = "1",
	})
	hl.exec_cmd("firefox", {
		workspace = "2 silent",
	})
	hl.exec_cmd("vesktop", {
		workspace = "8 silent",
	})
end)
hl.bind(main_mod .. " + mouse:273", hl.dsp.window.resize(), { mouse = true, description = "Resize Window" })
hl.bind(main_mod .. " + mouse:272", hl.dsp.window.drag(), { mouse = true, description = "Move Window" })
local mouse_drag_bind = hl.bind("mouse:274", hl.dsp.window.drag(), { mouse = true, description = "Move Window" })
hl.bind(main_mod .. " + Space", hl.dsp.submap("supmaper"), { description = "+submaps" })
hl.define_submap("supmaper", function()
	hl.bind("escape", hl.dsp.submap("reset"), { description = "Reset submap" })
	hl.bind("S", function()
		hl.dsp.workspace.toggle_special("special")
		hl.dsp.submap("reset")
	end, { description = "Special Workspace" })
	hl.bind("SHIFT + S", function()
		hl.dispatch(hl.dsp.window.move({ workspace = "special:special" }))
		hl.dispatch(hl.dsp.submap("reset"))
	end, { description = "Move To Special Workspace" })
	hl.bind("O", hl.dsp.submap("open"), { description = "+open" })
	hl.define_submap("open", "reset", function()
		hl.bind("escape", hl.dsp.submap("reset"))
		hl.bind("Q", hl.dsp.window.close(), { description = "Close Window" })
		hl.bind("T", hl.dsp.exec_cmd(terminal), { description = "Open Terminal" })
		hl.bind("F", hl.dsp.exec_cmd("pcmanfm"), { description = "Open Files" })
		hl.bind("B", function()
			hl.exec_cmd("firefox", { workspace = 2 })
		end, { description = "Open Browser" })
		hl.bind("D", function()
			hl.exec_cmd("vesktop", { workspace = 8 })
		end, { description = "Open Discord" })
		if host ~= "asahi" then
			hl.bind("S", function()
				hl.exec_cmd("steam", { workspace = 3 })
			end, { description = "Open Steam" })
		end
		hl.bind("C", hl.dsp.exec_cmd("rofi -show drun"), { description = "Open Controll Center" })
	end)
	-- // TODO: look into layouts
	--
	-- hl.bind("L", hl.dsp.submap("masterlayout"), { description = "+layout" })
	-- hl.define_submap("masterlayout", "reset", function()
	-- 	hl.bind("escape", hl.dsp.submap("reset"))
	-- end)
	hl.bind("C", hl.dsp.submap("clipbaord"), { description = "+clipbaord" })
	hl.define_submap("clipbaord", "reset", function()
		hl.bind("escape", hl.dsp.submap("reset"))
		hl.bind("C", hl.dsp.exec_cmd(terminal .. " --title 'Clipse' -e 'clipse';"), { description = "Clipse" })
	end)
	hl.bind("B", hl.dsp.submap("backlight"), { description = "+backlight" })
	hl.define_submap("backlight", function()
		hl.bind("escape", hl.dsp.submap("reset"))
		hl.bind("K", hl.dsp.exec_cmd(scriptDir .. "/brightness --inc"), { description = "Increase Screen Brightness" })
		hl.bind("J", hl.dsp.exec_cmd(scriptDir .. "/brightness --dec"), { description = "Decrease Screen Brightness" })
		hl.bind(
			"H",
			hl.dsp.exec_cmd(scriptDir .. "/kbd-brightness --dec"),
			{ description = "Decrease Keyboard Brightness" }
		)
		hl.bind(
			"L",
			hl.dsp.exec_cmd(scriptDir .. "/kbd-brightness --inc"),
			{ description = "Increase Keyboard Brightness" }
		)
		hl.bind("N", function()
			hl.dispatch(hl.dsp.exec_cmd(scriptDir .. "/brightness --toggle-night-mode"))
			hl.dispatch(hl.dsp.submap("reset"))
		end, { description = "Night Mode" })
		hl.bind("up", hl.dsp.exec_cmd(scriptDir .. "/brightness --inc"), { description = "Increase Screen Brightness" })
		hl.bind(
			"down",
			hl.dsp.exec_cmd(scriptDir .. "/brightness --dec"),
			{ description = "Decrease Screen Brightness" }
		)
		hl.bind(
			"left",
			hl.dsp.exec_cmd(scriptDir .. "/kbd-brightness --dec"),
			{ description = "Decrease Keyboard Brightness" }
		)
		hl.bind(
			"right",
			hl.dsp.exec_cmd(scriptDir .. "/kbd-brightness --inc"),
			{ description = "Increase Keyboard Brightness" }
		)
	end)
	hl.bind("V", hl.dsp.submap("volume"), { description = "+volume" })
	hl.define_submap("volume", function()
		hl.bind("escape", hl.dsp.submap("reset"))
		hl.bind("K", hl.dsp.exec_cmd(scriptDir .. "/volume --inc"), { description = "Increase Volume" })
		hl.bind("J", hl.dsp.exec_cmd(scriptDir .. "/volume --dec"), { description = "Decrease Volume" })
		hl.bind("up", hl.dsp.exec_cmd(scriptDir .. "/volume --inc"), { description = "Increase Volume" })
		hl.bind("down", hl.dsp.exec_cmd(scriptDir .. "/volume --dec"), { description = "Decrease Volume" })
		hl.bind("D", function()
			hl.dispatch(hl.dsp.exec_cmd(scriptDir .. "/volume --toggle"))
			hl.dispatch(hl.dsp.submap("reset"))
		end, { description = "Deff Speakers" })
		hl.bind("M", function()
			hl.dispatch(hl.dsp.exec_cmd(scriptDir .. "/volume --toggle-mic"))
			hl.dispatch(hl.dsp.submap("reset"))
		end, { description = "Mute Mice" })
	end)
	hl.bind("R", hl.dsp.submap("resize"), { description = "+resize" })
	hl.define_submap("resize", function()
		hl.bind("escape", hl.dsp.submap("reset"))
		hl.bind("H", hl.dsp.window.resize({ x = -50, y = 0 }), { description = "Resize Left" })
		hl.bind("L", hl.dsp.window.resize({ x = 50, y = 0 }), { description = "Resize Right" })
		hl.bind("K", hl.dsp.window.resize({ x = 0, y = -50 }), { description = "Resize Up" })
		hl.bind("J", hl.dsp.window.resize({ x = 0, y = 50 }), { description = "Resize Down" })
		hl.bind("left", hl.dsp.window.resize({ x = -50, y = 0 }), { description = "Resize Left" })
		hl.bind("right", hl.dsp.window.resize({ x = 50, y = 0 }), { description = "Resize Right" })
		hl.bind("up", hl.dsp.window.resize({ x = 0, y = -50 }), { description = "Resize Up" })
		hl.bind("down", hl.dsp.window.resize({ x = 0, y = 50 }), { description = "Resize Down" })
	end)
	hl.bind("M", hl.dsp.submap("move"), { description = "+move" })
	hl.define_submap("move", function()
		hl.bind("escape", hl.dsp.submap("reset"))
		hl.bind("F", hl.dsp.submap("focus"), { description = "+focus" })
		hl.bind("H", hl.dsp.window.move({ direction = "l" }), { description = "Move Left" })
		hl.bind("L", hl.dsp.window.move({ direction = "r" }), { description = "Move Right" })
		hl.bind("K", hl.dsp.window.move({ direction = "u" }), { description = "Move Up" })
		hl.bind("J", hl.dsp.window.move({ direction = "d" }), { description = "Move Down" })
		hl.bind("left", hl.dsp.window.move({ direction = "l" }), { description = "Move Left" })
		hl.bind("right", hl.dsp.window.move({ direction = "r" }), { description = "Move Right" })
		hl.bind("up", hl.dsp.window.move({ direction = "u" }), { description = "Move Up" })
		hl.bind("down", hl.dsp.window.move({ direction = "d" }), { description = "Move Down" })
		for i = 1, 10 do
			local key = i % 10
			hl.bind("" .. key, hl.dsp.window.move({ workspace = i }), { description = "Move Workspace " .. i })
		end
		hl.bind("SHIFT + H", hl.dsp.window.move({ workspace = "e-1" }), { description = "Move Workspace Left" })
		hl.bind("SHIFT + L", hl.dsp.window.move({ workspace = "e+1" }), { description = "Move Workspace Right" })
		hl.bind("SHIFT + left", hl.dsp.window.move({ workspace = "e-1" }), { description = "Move Workspace Left" })
		hl.bind("SHIFT + right", hl.dsp.window.move({ workspace = "e+1" }), { description = "Move Workspace Right" })
	end)
	hl.bind("F", hl.dsp.submap("focus"), { description = "+focus" })
	hl.define_submap("focus", function()
		hl.bind("escape", hl.dsp.submap("reset"))
		hl.bind("M", hl.dsp.submap("move"), { description = "+move" })
		hl.bind("H", hl.dsp.focus({ direction = "l" }), { description = "Focus Left" })
		hl.bind("L", hl.dsp.focus({ direction = "r" }), { description = "Focus Right" })
		hl.bind("K", hl.dsp.focus({ direction = "u" }), { description = "Focus Up" })
		hl.bind("J", hl.dsp.focus({ direction = "d" }), { description = "Focus Down" })
		hl.bind("left", hl.dsp.focus({ direction = "l" }), { description = "Focus Left" })
		hl.bind("right", hl.dsp.focus({ direction = "r" }), { description = "Focus Right" })
		hl.bind("up", hl.dsp.focus({ direction = "u" }), { description = "Focus Up" })
		hl.bind("down", hl.dsp.focus({ direction = "d" }), { description = "Focus Down" })
		for i = 1, 10 do
			local key = i % 10
			hl.bind("" .. key, hl.dsp.focus({ workspace = i }), { description = "Focus Workspace " .. i })
		end
		hl.bind("SHIFT + H", hl.dsp.focus({ workspace = "e-1" }), { description = "Focus Workspace Left" })
		hl.bind("SHIFT + L", hl.dsp.focus({ workspace = "e+1" }), { description = "Focus Workspace Right" })
		hl.bind("SHIFT + left", hl.dsp.focus({ workspace = "e-1" }), { description = "Focus Workspace Left" })
		hl.bind("SHIFT + right", hl.dsp.focus({ workspace = "e+1" }), { description = "Focus Workspace Right" })
	end)
	hl.bind("G", hl.dsp.submap("grimblast"), { description = "+screenshot" })
	hl.define_submap("grimblast", "reset", function()
		hl.bind("escape", hl.dsp.submap("reset"))
		hl.bind(
			"G",
			hl.dsp.exec_cmd("$HOME/.config/rofi/bin/screenshot --save=false"),
			{ description = "Screenshot Menu" }
		)
		hl.bind("A", hl.dsp.exec_cmd("grimblast --notify -n copy area"), { description = "Screenshot Area Clipboard" })
	end)
	hl.bind("K", hl.dsp.submap("keybinds"), { description = "+keybinds" })
	hl.define_submap("keybinds", "reset", function()
		hl.bind("escape", hl.dsp.submap("reset"))
		hl.bind("S", hl.dsp.exec_cmd("$HOME/.config/rofi/bin/search-keybind"), { description = "Search Keybinds" })
	end)
	hl.bind("T", hl.dsp.submap("toggle"), { description = "+toggle" })
	hl.define_submap("toggle", "reset", function()
		hl.bind("escape", hl.dsp.submap("reset"))
		hl.bind("F", hl.dsp.window.float(), { description = "Floating" })
		hl.bind("B", hl.dsp.window.fullscreen(), { description = "Fullscreen" })
		hl.bind("P", hl.dsp.window.pin(), { description = "Pin" })
		hl.bind("N", hl.dsp.exec_cmd(scriptDir .. "/brightness --toggle-night-mode"), { description = "Night Mode" })
	end)
end)
-- TODO: better module design
-- TODO: convert custom os scripts to lua
-- TODO: maybe render plugin to use with lua

hl.window_rule({
	match = {
		pin = true,
	},
	border_color = "rgb(cba6f7) rgb(89b4fa)",
})
hl.on("keybinds.submap", function(s)
	hl.exec_cmd(scriptDir .. "/which-key " .. s)
end)
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

hl.bind("ALT + tab", function()
	hl.dispatch(hl.dsp.exec_cmd("$HOME/.config/hypr/script/alttab/enable.sh 'down'"))
end, { description = "Alt Tab" })
hl.bind("ALT + SHIFT + tab", function()
	hl.dispatch(hl.dsp.exec_cmd("$HOME/.config/hypr/script/alttab/enable.sh 'up'"))
end, { description = "Alt Tab Reverse" })

function alttab_disable()
	hl.config({
		animations = {
			enabled = true,
		},
	})
end

hl.define_submap("alttab", function()
	hl.bind("ALT + tab", function()
		hl.dispatch(hl.dsp.send_key_state({ mods = "", key = "tab", state = "down", window = "class:alttab" }))
		hl.dispatch(hl.dsp.send_key_state({ mods = "", key = "tab", state = "up", window = "class:alttab" }))
	end, { description = "Alt Tab" }) -- :set_enabled(false)
	hl.bind("ALT + SHIFT + tab", function()
		hl.dispatch(hl.dsp.send_key_state({ mods = "shift", key = "tab", state = "down", window = "class:alttab" }))
		hl.dispatch(hl.dsp.send_key_state({ mods = "shift", key = "tab", state = "up", window = "class:alttab" }))
	end, { description = "Alt Tab Reverse" }) -- :set_enabled(false)
	hl.bind("ALT + ALT_L", function()
		alttab_disable()
		hl.dispatch(hl.dsp.send_key_state({ mods = "", key = "return", state = "down", window = "class:alttab" }))
	end, { release = true, transparent = true })
	hl.bind("ALT + SHIFT + ALT_L", function()
		alttab_disable()
		hl.dispatch(hl.dsp.send_key_state({ mods = "", key = "return", state = "down", window = "class:alttab" }))
	end, { release = true, transparent = true })
	hl.bind("ALT + Return", function()
		alttab_disable()
		hl.dispatch(hl.dsp.send_key_state({ mods = "", key = "return", state = "down", window = "class:alttab" }))
	end)
	hl.bind("ALT + SHIFT + Return", function()
		alttab_disable()
		hl.dispatch(hl.dsp.send_key_state({ mods = "", key = "return", state = "down", window = "class:alttab" }))
	end)
	hl.bind("ALT + escape", function()
		alttab_disable()
		hl.dispatch(hl.dsp.send_key_state({ mods = "", key = "escape", state = "down", window = "class:alttab" }))
	end)
	hl.bind("ALT + SHIFT + escape", function()
		alttab_disable()
		hl.dispatch(hl.dsp.send_key_state({ mods = "", key = "escape", state = "down", window = "class:alttab" }))
	end)
end)
