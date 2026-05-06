local M = {}

local default_duration = 7000
local default_font_size = 13
local info_color = "rgb(89b4fa)"
local warning_color = "rgb(f9e2af)"
local error_color = "rgb(f38ba8)"

-- icon array: "[!]", "[i]", "[Hint]", "[Err]", "[?]", "[ok]", ""

function M.info(text)
	hl.notification.create({
		text = text,
		duration = default_duration,
		icon = 1,
		color = info_color,
		font_size = default_font_size,
	})
end

function M.warning(text)
	hl.notification.create({
		text = text,
		duration = default_duration,
		icon = 0,
		color = warning_color,
		font_size = default_font_size,
	})
end

function M.error(text)
	hl.notification.create({
		text = text,
		duration = default_duration,
		icon = 3,
		color = error_color,
		font_size = default_font_size,
	})
end

return M
