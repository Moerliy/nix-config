local M = {}

---@type HyprModule[]
M.modules = {}

local notification = require("core.notification")
local bindings = require("core.keybind")

function M.load_modules(path)
	for _, mod in ipairs(path) do
		local ok, m = pcall(require, mod)
		if ok then
			table.insert(M.modules, m)
		else
			notification.error("Failed loading module: " .. mod)
		end
	end
end

function M.setup()
	for _, mod in ipairs(M.modules) do
		if mod.setup then
			mod.setup()
		end
	end

	local startups = {}
	local dynamics = {}

	for _, mod in ipairs(M.modules) do
		if mod.rules then
			for _, rule in ipairs(M.rules) do
				if rule.window then
					hl.window_rule(rule.window)
				end
				if rule.workspace then
					hl.workspace_rule(rule.workspace)
				end
				if rule.layer then
					hl.layer_rule(rule.layer)
				end
			end
		end

		if mod.startup then
			table.insert(startups, mod.startup)
		end

		if mod.dynamics then
			table.insert(dynamics, mod.dynamics)
		end

		if mod.binds then
			for _, bind in ipairs(mod.binds) do
				bindings.add(bind)
			end
		end
	end

	hl.on("hyprland.start", function()
		for _, startup in ipairs(startups) do
			startup()
		end
	end)

	bindings.setup()

	for _, dynamic in ipairs(dynamics) do
		dynamic()
	end
end

return M
