return {
  {
    "williamboman/mason.nvim",
    opts = {
      ensure_installed = {
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
        taplo = {
          mason = false,
        },
        yamlls = {
          mason = false,
        },
      },
    },
  },
}
