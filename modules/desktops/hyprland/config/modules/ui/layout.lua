---@type HyprModule
return {
	name = "Layout Settings",
	setup = function()
		hl.config({
			dwindle = {
				force_split = 2,
				preserve_split = true,
				special_scale_factor = 0.8,
			},
		})
	end,
}
