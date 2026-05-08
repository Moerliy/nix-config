---@type HyprModule
return {
	name = "Debug",
	setup = function()
		hl.config({
			debug = {
				damage_tracking = 2,
				disable_logs = false,
				-- overlay = true;
				-- damage_blink = true;
			},
		})
	end,
}
