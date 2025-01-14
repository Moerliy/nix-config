-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here

local keymap = vim.keymap

-- Diagnostics
keymap.set("n", "<Leader>xn", function()
  vim.diagnostic.goto_next()
end, { desc = "Next Vim diagnostic" })

-- precognition
keymap.set("n", "<Leader>tp", "<cmd>lua require('precognition').toggle()<CR>", { desc = "Toggle precognition" })

-- Window management
keymap.set("n", "<Leader>wk", "<cmd>close<CR>", { desc = "Delete window" })
keymap.set("n", "<Leader>ws", "<cmd>split<CR>", { noremap = true, silent = true, desc = "Horizontal split window" })
keymap.set("n", "<Leader>wv", "<cmd>vsplit<CR>", { noremap = true, silent = true, desc = "Vertical split window" })
keymap.set("n", "<Leader>f<left>", "<cmd>TmuxNavigateLeft<CR>", { desc = "Focus window left" })
keymap.set("n", "<Leader>f<up>", "<cmd>TmuxNavigateUp<CR>", { desc = "Focus window up" })
keymap.set("n", "<Leader>f<down>", "<cmd>TmuxNavigateDown<CR>", { desc = "Focus window down" })
keymap.set("n", "<Leader>f<right>", "<cmd>TmuxNavigateRight<CR>", { desc = "Focus window right" })
keymap.set("n", "<Leader>mm", "<cmd>WinShift<CR>", { desc = "Move mode" })
keymap.set("n", "<Leader>r<left>", "<C-w><")
keymap.set("n", "<Leader>r<right>", "<C-w>>")
keymap.set("n", "<Leader>r<up>", "<C-w>+")
keymap.set("n", "<Leader>r<down>", "<C-w>-")

-- -- Transparency
-- keymap.set("n", "<Leader>tb", "<cmd>TransparentToggle<CR>", { desc = "Toggle background transparency" })

-- mini-files
keymap.set("n", "<Leader>ff", function()
  require("mini.files").open(vim.api.nvim_buf_get_name(0), true)
end, { desc = "Open mini-files" })

-- better movement
keymap.set("n", "gp", "<C-o>", { desc = "Return to last cursor position" })

-- Notificon with snacks
keymap.set("n", "<Leader>uN", function()
  Snacks.notifier.show_history()
end, { desc = "Show all notifications" })

-- Toggleterm
keymap.set("n", "<Leader>T", "<cmd>ToggleTerm<CR>", { desc = "Toggle terminal" })

-- Copilot toggle
keymap.set("n", "<Leader>tp", "<cmd>Copilot suggestion toggle_auto_trigger<CR>", { desc = "Toggle Copilot" })

-- Dotfiles lazygit with toggleterm
local Terminal = require("toggleterm.terminal").Terminal
local lazygit = Terminal:new({ cmd = "lazygit --git-dir=$HOME/dotfiles --work-tree=$HOME", hidden = true })
function _lazygit_toggle()
  lazygit:toggle()
end
keymap.set("n", "<leader>fC", "<cmd>lua _lazygit_toggle()<CR>", { noremap = true, silent = true })

-- Package info
keymap.set(
  "n",
  "<Leader>cps",
  require("package-info").show,
  { silent = true, noremap = true, desc = "Show package info" }
)
keymap.set(
  "n",
  "<Leader>cph",
  require("package-info").hide,
  { silent = true, noremap = true, desc = "Hide package info" }
)
keymap.set(
  "n",
  "<Leader>cpt",
  require("package-info").toggle,
  { silent = true, noremap = true, desc = "Toggle package info" }
)
keymap.set(
  "n",
  "<Leader>cpu",
  require("package-info").update,
  { silent = true, noremap = true, desc = "Update package info" }
)
keymap.set(
  "n",
  "<Leader>cpd",
  require("package-info").delete,
  { silent = true, noremap = true, desc = "Delete package" }
)
keymap.set(
  "n",
  "<Leader>cpi",
  require("package-info").install,
  { silent = true, noremap = true, desc = "Install package" }
)
keymap.set(
  "n",
  "<Leader>cpc",
  require("package-info").change_version,
  { silent = true, noremap = true, desc = "Change package version" }
)

-- Git blame
keymap.set("n", "<Leader>gb", "<cmd>GitBlameToggle<CR>", { desc = "Toggle git blame" })

-- Telescope theme switcher
keymap.set("n", "<leader>tc", ":Telescope themes<CR>", { noremap = true, silent = true, desc = "Theme Changer" })

-- kulala
keymap.set(
  "n",
  "<leader>chp",
  ":lua require('kulala').jump_prev()<CR>",
  { noremap = true, silent = true, desc = "Jump to previous" }
)
keymap.set(
  "n",
  "<leader>chn",
  ":lua require('kulala').jump_next()<CR>",
  { noremap = true, silent = true, desc = "Jump to next" }
)
keymap.set("n", "<leader>chh", ":lua require('kulala').run()<CR>", { noremap = true, silent = true, desc = "Run" })
