local M = {}

---@class BindNode
---@field children table<string, BindNode>
---@field action? function
---@field desc? string
---@field single_use? boolean
---@field opts? HL.BindOptions

---@type BindNode
local root = {
	---@type table<string, BindNode>
	children = {},
}

---@param keys string[]
---@param action function
---@param desc string
---@param single_use boolean
---@param opts? HL.BindOptions
local function insert_bind(keys, action, desc, single_use, opts)
	local node = root

	for _, key in ipairs(keys) do
		if not node.children[key] then
			node.children[key] = { children = {} }
		end
		node = node.children[key]
	end
	node.action = action
	node.desc = desc
	node.single_use = single_use
	node.opts = opts
end

---@param bind HyprBind
function M.add(bind)
	insert_bind(bind.key, bind.action, bind.desc, bind.single_use, bind.opts)
end

---@param keys string[]
---@param desc string
function M.change_submap_desc(keys, desc)
	local node = root

	for _, key in ipairs(keys) do
		if not node.children[key] then
			node.children[key] = { children = {} }
		end
		node = node.children[key]
	end
	node.desc = desc
end

---@param changes { keys:string[], desc:string }[]
function M.change_submap_desc_bulk(changes)
	for _, change in ipairs(changes) do
		M.change_submap_desc(change.keys, change.desc)
	end
end

---@param nodes table<string, BindNode>
local function register_bind(nodes)
	for key, node in pairs(nodes) do
		if next(node.children) == nil then
			if node.action == nil then
				hl.notification.create({ text = "action nil for '" .. key .. "'. Why?", duration = 3000 }) --TODO: notify
				goto continue
			end
			if node.opts == nil then
				node.opts = {}
			end
			node.opts.description = node.desc
			if node.single_use then
				hl.bind(key, function()
					node.action() -- TODO: maybe issues if not dispatcher func
					hl.dispatch(hl.dsp.exec_cmd("sleep 0.02; hyprctl dispatch 'hl.dsp.submap(\"reset\")'")) -- FIX: hacky sleep because some key for submap enter and bind will trigger at the same time
				end, node.opts)
			else
				hl.bind(key, function()
					node.action()
				end, node.opts)
			end
			::continue::
		else
			local description = ""
			if node.desc ~= nil and node.desc ~= "" then
				description = node.desc
			else
				description = "" .. math.randomseed(os.time())
			end
			hl.bind(key, function()
				hl.dispatch(hl.dsp.exec_cmd("sleep 0.02; hyprctl dispatch 'hl.dsp.submap(\"" .. description .. "\")'"))
			end, { description = node.desc })
			hl.define_submap("" .. description, function()
				hl.bind("escape", hl.dsp.submap("reset"), { description = "Reset submap" })
				register_bind(node.children)
			end)
		end
	end
end

function M.setup()
	register_bind(root.children)
end

return M
