return {
  {
    "hrsh7th/nvim-cmp",
    depends = {
      "catppuccin/nvim",
    },
    config = {
      window = {
        completion = {
          -- custom border
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
          scrollbar = false,
        },
        documentation = {
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
          scrollbar = false,
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
    "jackMort/ChatGPT.nvim",
    event = "VeryLazy",
    config = function()
      local home = vim.fn.expand("$HOME")
      require("chatgpt").setup({
        api_key_cmd = "gpg --decrypt " .. home .. "/.config/nvim/secrets/chatgpt_api_key.txt.gpg",
      })
    end,
    dependencies = {
      "MunifTanjim/nui.nvim",
      "nvim-lua/plenary.nvim",
      "nvim-telescope/telescope.nvim",
    },
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
            done = "✅ ",
          },
          lualine = "🐼",
        },
        additional_curl_options = {},
      })
    end,
  },
}
