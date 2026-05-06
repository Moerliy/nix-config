---@class HyprModule
---@field name string
---@field setup? fun()
---@field startup? fun()  -- called in hyprland.on("hyprland.start")
---@field binds? HyprBind[]
---@field rules? HyprRule[]
---@field dynamics? fun(add_bind:fun(bind:HyprBind))
-- @field deps? string[] --overcooked?

---@class HyprBind
---@field key string[]
---@field action function
---@field desc string
---@field single_use boolean
---@field opts? HL.BindOptions

---@class HyprRule
---@field window? HL.WindowRuleSpec
---@field workspace? HL.WorkspaceRuleSpec
---@field layer? HL.LayerRuleSpec

return {}
