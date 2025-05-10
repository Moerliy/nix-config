return {
  { "mason-org/mason.nvim", version = "1.11.0" },
  { "mason-org/mason-lspconfig.nvim", version = "1.32.0" },
  {
    "williamboman/mason.nvim",
    opts_extend = {},
    opts = {
      ensure_installed = {
        "debugpy",
        "js-debug-adapter",
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
    opts = function(_, opts)
      table.insert(opts.servers.vtsls.filetypes, "vue")
      LazyVim.extend(opts.servers.vtsls, "settings.vtsls.tsserver.globalPlugins", {
        {
          name = "@vue/typescript-plugin",
          location = "/etc/profiles/per-user/moritzgleissner/lib/node_modules/@vue/language-server",
          languages = { "vue" },
          configNamespace = "typescript",
          enableForWorkspaceTypeScriptVersions = true,
        },
      })
    end,
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
        volar = {
          mason = false,
          init_options = {
            vue = {
              hybridMode = true,
            },
          },
        },
        vls = {
          mason = false,
        },
        vtsls = {
          mason = false,
        },
        denols = {
          mason = false,
        },
        tsserver = {
          mason = false,
          init_options = {
            plugins = {
              {
                name = "@vue/typescript-plugin",
                location = "/etc/profiles/per-user/moritzgleissner/lib/node_modules/@vue/language-server",
                languages = { "vue" },
                configNamespace = "typescript",
                enableForWorkspaceTypeScriptVersions = true,
              },
            },
          },
          filetypes = {
            "vue",
          },
        },
        nil_ls = {
          mason = false,
        },
        texlab = {
          mason = false,
        },
        dartls = {
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
