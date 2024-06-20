return {
  {
    "williamboman/mason.nvim",
    opts_extend = {},
    opts = {
      ensure_installed = {
        "debugpy",
        "js-debug-adapter",
        "vtsls",
        "codelldb",
        -- "stylua",
        -- "selene",
        -- "luacheck",
        -- "shellcheck",
        -- "shfmt",
        -- "typescript-language-server",
        -- "css-lsp",
        -- "vue-language-server",
        -- "grammarly-languageserver",
        -- "kotlin-language-server",
        -- "kotlin-debug-adapter",
        -- "ktlint",
        -- "nil",
        -- "nixpkgs-fmt",
      },
      registries = {
        "github:mason-org/mason-registry",
        -- "file:~/dev/mason-registry",
      },
    },
  },
  {
    "neovim/nvim-lspconfig",
    opts = {
      servers = {
        lua_ls = {
          mason = false,
        },
        luau_lsp = {
          mason = false,
        },
        bashls = {
          mason = false,
        },
        docker_compose_language_service = {
          mason = false,
        },
        dockerls = {
          mason = false,
        },
        eslint = {
          mason = false,
        },
        jsonls = {
          mason = false,
        },
        marksman = {
          mason = false,
        },
        neocmake = {
          mason = false,
        },
        pyright = {
          mason = false,
        },
        ruff = {
          mason = false,
        },
        ruff_lsp = {
          mason = false,
        },
        taplo = {
          mason = false,
        },
        yamlls = {
          mason = false,
        },
        clangd = {
          mason = false,
        },
      },
    },
  },
  {
    "mfussenegger/nvim-lint",
    optional = true,
    opts = {
      linters_by_ft = {
        cmake = { "cmakelint" },
      },
      linters = {
        cmakelint = {
          cmd = is_windows and "cmake-lint.cmd" or "cmake-lint",
        },
      },
    },
  },
}
