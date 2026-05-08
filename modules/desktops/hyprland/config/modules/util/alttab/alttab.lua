local M = {}

function M.disable()
	hl.config({
		animations = {
			enabled = true,
		},
	})
end

return M
