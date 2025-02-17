return {
  -- {
  --   "hrsh7th/nvim-cmp",
  --   depends = {
  --     "catppuccin/nvim",
  --   },
  --   config = {
  --     window = {
  --       completion = {
  --         -- custom border
  --         border = {
  --           "󱐋",
  --           "─",
  --           "╮",
  --           "│",
  --           "╯",
  --           "─",
  --           "╰",
  --           "│",
  --         },
  --         scrollbar = false,
  --       },
  --       documentation = {
  --         border = {
  --           "",
  --           "─",
  --           "╮",
  --           "│",
  --           "╯",
  --           "─",
  --           "╰",
  --           "│",
  --         },
  --         scrollbar = false,
  --       },
  --     },
  --   },
  -- },
  {
    "saghen/blink.cmp",
    optional = true,
    dependencies = { "giuxtaposition/blink-cmp-copilot" },
    opts = {
      keymap = {
        preset = "enter",
        ["<C-y>"] = { "select_and_accept" },
        ["<C-c>"] = { "show", "show_documentation", "hide_documentation" },
      },
      completion = {
        menu = {
          border = {
            "󱐋",
            "─",
            "╮",
            "│",
            "╯",
            "─",
            "╰",
            "│",
          },
          draw = {
            treesitter = { "lsp" },
          },
        },
        documentation = {
          auto_show = true,
          auto_show_delay_ms = 200,
          window = {
            border = {
              "",
              "─",
              "╮",
              "│",
              "╯",
              "─",
              "╰",
              "│",
            },
          },
        },
        ghost_text = {
          enabled = vim.g.ai_cmp,
        },
      },
      sources = {
        default = { "copilot" },
        providers = {
          copilot = {
            name = "copilot",
            module = "blink-cmp-copilot",
            kind = "Copilot",
            score_offset = 300,
            async = true,
          },
        },
      },
    },
  },
  {
    "smjonas/inc-rename.nvim",
    cmd = "IncRename",
    config = true,
  },
  {
    "vuki656/package-info.nvim",
    depends = "MunifTanjim/nui.nvim",
    config = function()
      local colors = require("catppuccin.palettes").get_palette("mocha")
      require("package-info").setup({
        package_manager = "npm",
        colors = {
          outdated = colors.peach,
        },
        hide_up_to_date = true,
      })
    end,
  },
  {
    "mistweaverco/kulala.nvim",
    config = function()
      -- Setup is required, even if you don't pass any options
      require("kulala").setup({
        -- default_view, body or headers
        default_view = "body",
        -- dev, test, prod, can be anything
        -- see: https://learn.microsoft.com/en-us/aspnet/core/test/http-files?view=aspnetcore-8.0#environment-files
        default_env = "dev",
        debug = false,
        -- default formatters for different content types
        formatters = {
          json = { "jq", "." },
          xml = { "xmllint", "--format", "-" },
          html = { "xmllint", "--format", "--html", "-" },
        },
        -- default icons
        icons = {
          inlay = {
            loading = "⏳",
            done = "✅",
          },
          lualine = "🐼",
        },
        additional_curl_options = {},
      })
    end,
  },
}
