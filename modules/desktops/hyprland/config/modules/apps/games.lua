---@type HyprModule
return {
	name = "Gaming Settings",
	binds = {
		{
			key = { require("globals").main_mod .. " + Space", "O", "S" },
			action = function()
				hl.exec_cmd("steam", { workspace = 3 })
			end,
			desc = "Open Steam",
			single_use = true,
		},
	},
	rules = {
		window = {
			{
				match = {
					class = "[Ss](team)",
				},
				workspace = "3",
				float = true,
			},
			{
				match = {
					class = "(steam)",
					title = "(^[S]team)",
				},
				float = false,
			},
			{
				match = {
					class = "(steam)",
					title = "(Friends List)",
				},
				float = true,
				center = true,
				size = { 500, 1000 },
			},
			{
				match = {
					class = "(steam)",
					title = "(Steam Settings)",
				},
				float = true,
				center = true,
			},
			{
				match = {
					class = "(steam)",
					title = "(Sign in to Steam)",
				},
				float = true,
				center = true,
			},
			{
				match = {
					class = "(steam)",
					title = "(Shutdown)",
				},
				float = true,
				center = true,
			},
			{
				match = {
					class = "^(steam_app)(.*)",
				},
				workspace = "4",
				fullscreen = true,
			},
			{
				match = {
					class = "(osu!)",
					title = "(osu!)",
				},
				workspace = "4",
				fullscreen = true,
			},
			{
				match = {
					class = "(cs2)",
				},
				workspace = "4",
				fullscreen = true,
			},
			{
				match = {
					class = "(factorio)",
				},
				workspace = "4",
				fullscreen = true,
			},
		},
	},
}
