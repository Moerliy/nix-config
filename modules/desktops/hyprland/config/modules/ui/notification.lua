---@type HyprModule
return {
	name = "Notifications",
	dynamics = function()
		local globals = require("globals")
		local notification_manager =
			require(globals.hyprlui_dir .. "/demos/notification-manager/notification-manager.lua")

		-- A bouncy spring (real overshoot, not just a smooth ease) instead
		-- of the demo's own default of no animation at all - deliberately
		-- more aggressive than a typical toast stack, since this is also
		-- what caught the reflow-ghosting bug during development (see
		-- HyprLUI's demos/notification-manager/TASKS.md task 2).
		hl.curve("hyprlui_notification_bounce", { type = "spring", stiffness = 120, dampening = 8, mass = 1 })
		hl.curve("hyprlui_notification_bounce_soft", { type = "spring", stiffness = 80, dampening = 16, mass = 1 })

		notification_manager.setup({
			animationIn = { speed = 3, spring = "hyprlui_notification_bounce_soft", style = "slide right" },
			animationOut = { speed = 6, spring = "hyprlui_notification_bounce", style = "slide right" },
			animationLayout = { speed = 8, spring = "hyprlui_notification_bounce" },
		})
	end,
}
