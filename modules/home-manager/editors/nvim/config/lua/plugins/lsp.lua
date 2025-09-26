return {
  {
    "mason-org/mason.nvim",
    opts_extend = {},
    opts = {
      ensure_installed = {
        -- "debugpy",
        "js-debug-adapter",
        "codelldb",
        exclude = {
          "tree-sitter-lsp",
          "shfmt",
          "shellcheck",
          "prettier",
        },
      },
      registries = {
        "github:mason-org/mason-registry",
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
        omnisharp = {
          mason = false,
          cmd = {
            "omnisharp",
            "-z",
            "--hostPID",
            tostring(vim.fn.getpid()),
            "DotNet:enablePackageRestore=false",
            "--encoding",
            "utf-8",
            "--languageserver",
            "FormattingOptions:EnableEditorConfigSupport=true",
            "Sdk:IncludePrereleases=true",
          },
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
        stylua = {
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
