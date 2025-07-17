return {
  {
    "echasnovski/mini.bufremove",

    keys = {
      { "<leader>bd", false },
      { "<leader>bD", false },
      {
        "<leader>bk",
        function()
          local bd = require("mini.bufremove").delete
          if vim.bo.modified then
            local choice = vim.fn.confirm(("Save changes to %q?"):format(vim.fn.bufname()), "&Yes\n&No\n&Cancel")
            if choice == 1 then -- Yes
              vim.cmd.write()
              bd(0)
            elseif choice == 2 then -- No
              bd(0, true)
            end
          else
            bd(0)
          end
        end,
        desc = "Delete Buffer",
      },
      -- stylua: ignore
      { "<leader>bK", function() require("mini.bufremove").delete(0, true) end, desc = "Delete Buffer (Force)" },
    },
  },
  {
    "folke/which-key.nvim",
    opts = {
      -- plugins = { spelling = true },
      preset = "classic",
      spec = {
        {
          mode = { "n", "v" },
          { "<leader>f", group = "file/find/focus" },
          { "<leader>m", group = "move" },
          { "<leader>r", group = "resize" },
          { "<leader>h", group = "help" },
          { "<leader>p", group = "project" },
          { "<leader>cp", group = "package" },
          { "<leader>c", group = "http" },
          { "<leader>a", group = "ai" },
          { "<leader>t", group = "test/theme" },
        },
      },
    },
  },
  {
    "sindrets/winshift.nvim",
    opts = {
      highlight_moving_win = true, -- Highlight the window being moved
      focused_hl_group = "Visual", -- The highlight group used for the moving window
      moving_win_options = {
        -- These are local options applied to the moving window while it's
        -- being moved. They are unset when you leave Win-Move mode.
        wrap = false,
        cursorline = false,
        cursorcolumn = false,
        colorcolumn = "",
      },
      keymaps = {
        disable_defaults = false, -- Disable the default keymaps
        win_move_mode = {
          ["h"] = "left",
          ["j"] = "down",
          ["k"] = "up",
          ["l"] = "right",
          ["H"] = "far_left",
          ["J"] = "far_down",
          ["K"] = "far_up",
          ["L"] = "far_right",
          ["<left>"] = "left",
          ["<down>"] = "down",
          ["<up>"] = "up",
          ["<right>"] = "right",
          ["<S-left>"] = "far_left",
          ["<S-down>"] = "far_down",
          ["<S-up>"] = "far_up",
          ["<S-right>"] = "far_right",
        },
      },
    },
  },
  {
    "christoomey/vim-tmux-navigator",
    cmd = {
      "TmuxNavigateLeft",
      "TmuxNavigateDown",
      "TmuxNavigateUp",
      "TmuxNavigateRight",
      "TmuxNavigatePrevious",
    },
    keys = {
      { "<c-h>", "<cmd><C-U>TmuxNavigateLeft<cr>" },
      { "<c-j>", "<cmd><C-U>TmuxNavigateDown<cr>" },
      { "<c-k>", "<cmd><C-U>TmuxNavigateUp<cr>" },
      { "<c-l>", "<cmd><C-U>TmuxNavigateRight<cr>" },
      { "<c-\\>", "<cmd><C-U>TmuxNavigatePrevious<cr>" },
    },
  },
  {
    "echasnovski/mini.files",
    opts = {
      -- Module mappings created only inside explorer.
      -- Use `''` (empty string) to not create one.
      mappings = {
        close = "q",
        go_in = "<Right>",
        go_in_plus = "<CR>",
        go_out = "<Left>",
        go_out_plus = "H",
        mark_goto = "'",
        mark_set = "m",
        reset = "<BS>",
        reveal_cwd = "@",
        show_help = "?",
        synchronize = "=",
        trim_left = "<",
        trim_right = ">",
      },
      windows = {
        preview = true,
        width_focus = 30,
        width_preview = 30,
      },
      options = {
        -- Whether to use for editing directories
        -- Disabled by default in LazyVim because neo-tree is used for that
        use_as_default_explorer = true,
      },
    },
    keys = {
      {
        "<Leader>ff",
        function()
          require("mini.files").open(vim.api.nvim_buf_get_name(0), true)
        end,
        desc = "Open file browser",
      },
    },
  },
  {
    "ibhagwan/fzf-lua",
    keys = {
      { "<leader>.", LazyVim.pick("files", { root = false }), desc = "Find Files (cwd No Hidden)" },
      { "<leader>fF", LazyVim.pick("files"), desc = "Find Files (Root No Hidden)" },
      { "<leader>fG", "<cmd>FzfLua git_files<cr>", desc = "Find Files (git-files)" },
      { "<leader>fg", LazyVim.pick("live_grep", { root = false }), desc = "Grep files (cwd)" },
      { "<leader>bi", "<cmd>FzfLua buffers sort_mru=true sort_lastused=true<cr>", desc = "Lists open buffers" },
      { "<leader>hh", "<cmd>FzfLua help_tags<cr>", desc = "Find help tags" },
      { "<leader>ff", false },
    },
  },
  {
    "HiPhish/rainbow-delimiters.nvim",
    lazy = false,
  },
  {
    "NvChad/nvim-colorizer.lua",
    lazy = false,
    config = function()
      require("colorizer").setup()
    end,
  },
}
