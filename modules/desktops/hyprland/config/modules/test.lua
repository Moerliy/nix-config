---@type HyprModule
return {
	name = "Test module",
	binds = {
		{
			key = { "SUPER + X" },
			action = function()
				hl.notification.create({ text = "X bind", duration = 3000 })
			end,
			desc = "test",
			single_use = true,
		},
		{
			key = { "SUPER + T", "SUPER + T" },
			action = function()
				hl.notification.create({ text = "test", duration = 3000 })
			end,
			desc = "Test notification",
			single_use = true,
		},
		{
			key = { "SUPER + T", "SUPER + X" },
			action = function()
				hl.notification.create({ text = "multi", duration = 3000 })
			end,
			desc = "Test multi",
			single_use = false,
			opts = { repeating = true },
		},
	},
}
