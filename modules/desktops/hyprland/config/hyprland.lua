local globals = require("globals")

hl.bind(globals.main_mod .. " + return", hl.dsp.exec_cmd(globals.terminal), { description = "Open Terminal" })
hl.bind(
	globals.main_mod .. " + escape",
	hl.dsp.exec_cmd("$HOME/.config/rofi/bin/powermenu-large"),
	{ description = "Exit Manager" }
)
hl.bind(globals.main_mod .. " + B", hl.dsp.exec_cmd("firefox"), { description = "Open Browser" })
hl.bind(globals.main_mod .. " + Q", hl.dsp.window.close(), { description = "Close Window" })
hl.bind(globals.main_mod .. " + C", hl.dsp.exec_cmd("rofi -show drun"), { description = "Open Control Center" })
hl.bind(globals.main_mod .. " + F", hl.dsp.window.float({ action = "toggle" }), { description = "Toggle Floating" })

for i = 1, 10 do
	local key = i % 10
	hl.bind(
		globals.main_mod .. " + " .. key,
		hl.dsp.focus({ workspace = i }),
		{ description = "Focus Workspace " .. i }
	)
	hl.bind(
		globals.main_mod .. " + SHIFT + " .. key,
		hl.dsp.window.move({ workspace = i }),
		{ description = "Move Workspace " .. i }
	)
end
hl.bind("XF86AudioMute", hl.dsp.exec_cmd(globals.scriptDir .. "/volume --toggle"), { description = "Deff Speakers" })
hl.bind("XF86AudioMicMute", hl.dsp.exec_cmd(globals.scriptDir .. "/volume --toggle-mic"), { description = "Mute Mice" })
hl.bind(
	"XF86AudioLowerVolume",
	hl.dsp.exec_cmd(globals.scriptDir .. "/volume --dec"),
	{ description = "Decrease Volume", release = true }
)
hl.bind(
	"XF86AudioRaiseVolume",
	hl.dsp.exec_cmd(globals.scriptDir .. "/volume --inc"),
	{ description = "Increase Volume", release = true }
)
hl.bind(
	"XF86MonBrightnessDown",
	hl.dsp.exec_cmd(globals.scriptDir .. "/brightness --dec"),
	{ description = "Decrease Screen Brightness", release = true }
)
hl.bind(
	"XF86MonBrightnessUP",
	hl.dsp.exec_cmd(globals.scriptDir .. "/brightness --inc"),
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
hl.bind(globals.main_mod .. " + mouse:273", hl.dsp.window.resize(), { mouse = true, description = "Resize Window" })
hl.bind(globals.main_mod .. " + mouse:272", hl.dsp.window.drag(), { mouse = true, description = "Move Window" })
hl.bind(globals.main_mod .. " + Space", hl.dsp.submap("supmaper"), { description = "+submaps" })
hl.define_submap("supmaper", function()
	hl.bind("escape", hl.dsp.submap("reset"), { description = "Reset submap" })
	hl.bind("S", function()
		hl.dispatch(hl.dsp.workspace.toggle_special("special"))
		hl.dispatch(hl.dsp.submap("reset"))
	end, { description = "Special Workspace" })
	hl.bind("SHIFT + S", function()
		hl.dispatch(hl.dsp.window.move({ workspace = "special:special" }))
		hl.dispatch(hl.dsp.submap("reset"))
	end, { description = "Move To Special Workspace" })
	-- // TODO: look into layouts
	--
	-- hl.bind("L", hl.dsp.submap("masterlayout"), { description = "+layout" })
	-- hl.define_submap("masterlayout", "reset", function()
	-- 	hl.bind("escape", hl.dsp.submap("reset"))
	-- end)
	hl.bind("C", hl.dsp.submap("clipbaord"), { description = "+clipbaord" })
	hl.define_submap("clipbaord", "reset", function()
		hl.bind("escape", hl.dsp.submap("reset"))
		hl.bind("C", hl.dsp.exec_cmd(globals.terminal .. " --title 'Clipse' -e 'clipse';"), { description = "Clipse" })
	end)
	hl.bind("B", hl.dsp.submap("backlight"), { description = "+backlight" })
	hl.define_submap("backlight", function()
		hl.bind("escape", hl.dsp.submap("reset"))
		hl.bind(
			"K",
			hl.dsp.exec_cmd(globals.scriptDir .. "/brightness --inc"),
			{ description = "Increase Screen Brightness" }
		)
		hl.bind(
			"J",
			hl.dsp.exec_cmd(globals.scriptDir .. "/brightness --dec"),
			{ description = "Decrease Screen Brightness" }
		)
		hl.bind(
			"H",
			hl.dsp.exec_cmd(globals.scriptDir .. "/kbd-brightness --dec"),
			{ description = "Decrease Keyboard Brightness" }
		)
		hl.bind(
			"L",
			hl.dsp.exec_cmd(globals.scriptDir .. "/kbd-brightness --inc"),
			{ description = "Increase Keyboard Brightness" }
		)
		hl.bind("N", function()
			hl.dispatch(hl.dsp.exec_cmd(globals.scriptDir .. "/brightness --toggle-night-mode"))
			hl.dispatch(hl.dsp.submap("reset"))
		end, { description = "Night Mode" })
		hl.bind(
			"up",
			hl.dsp.exec_cmd(globals.scriptDir .. "/brightness --inc"),
			{ description = "Increase Screen Brightness" }
		)
		hl.bind(
			"down",
			hl.dsp.exec_cmd(globals.scriptDir .. "/brightness --dec"),
			{ description = "Decrease Screen Brightness" }
		)
		hl.bind(
			"left",
			hl.dsp.exec_cmd(globals.scriptDir .. "/kbd-brightness --dec"),
			{ description = "Decrease Keyboard Brightness" }
		)
		hl.bind(
			"right",
			hl.dsp.exec_cmd(globals.scriptDir .. "/kbd-brightness --inc"),
			{ description = "Increase Keyboard Brightness" }
		)
	end)
	hl.bind("V", hl.dsp.submap("volume"), { description = "+volume" })
	hl.define_submap("volume", function()
		hl.bind("escape", hl.dsp.submap("reset"))
		hl.bind("K", hl.dsp.exec_cmd(globals.scriptDir .. "/volume --inc"), { description = "Increase Volume" })
		hl.bind("J", hl.dsp.exec_cmd(globals.scriptDir .. "/volume --dec"), { description = "Decrease Volume" })
		hl.bind("up", hl.dsp.exec_cmd(globals.scriptDir .. "/volume --inc"), { description = "Increase Volume" })
		hl.bind("down", hl.dsp.exec_cmd(globals.scriptDir .. "/volume --dec"), { description = "Decrease Volume" })
		hl.bind("D", function()
			hl.dispatch(hl.dsp.exec_cmd(globals.scriptDir .. "/volume --toggle"))
			hl.dispatch(hl.dsp.submap("reset"))
		end, { description = "Deff Speakers" })
		hl.bind("M", function()
			hl.dispatch(hl.dsp.exec_cmd(globals.scriptDir .. "/volume --toggle-mic"))
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
		hl.bind(
			"N",
			hl.dsp.exec_cmd(globals.scriptDir .. "/brightness --toggle-night-mode"),
			{ description = "Night Mode" }
		)
	end)
end)
-- TODO: better module design
-- TODO: convert custom os scripts to lua
-- TODO: maybe render plugin to use with lua

local loader = require("core.loader")
local bindings = require("core.keybind")

loader.load_modules({
	"modules.sane-defaults",
	"modules.io",
	-- "modules.debug",

	-- ui
	"modules.ui.layout",
	"modules.ui.tweaks",
	"modules.ui.cursor",

	-- util
	"modules.util.alttab",
	"modules.util.which-key",

	-- binds
	"modules.binds.key",

	-- apps
	"modules.apps.games",
})

if globals.host ~= "asahi" then
	loader.load_modules({
		"modules.apps.games",
	})
end

-- bindings.change_submap_desc_bulk({ { keys = { "SUPER + Space" }, desc = "+submaps" } })
bindings.change_submap_desc_bulk({
	{ keys = { "SUPER + Space" }, desc = "supmaper" },
	{ keys = { "SUPER + Space", "O" }, desc = "+open" },
})

loader.setup()
