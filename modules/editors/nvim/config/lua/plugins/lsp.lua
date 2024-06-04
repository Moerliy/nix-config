return {
  {
    "williamboman/mason.nvim",
    opts = {
      ensure_installed = {
        "stylua",
        "selene",
        "luacheck",
        "shellcheck",
        "shfmt",
        "typescript-language-server",
        "css-lsp",
        "vue-language-server",
        "grammarly-languageserver",
        "kotlin-language-server",
        "kotlin-debug-adapter",
        "ktlint",
        "nil",
        "nixpkgs-fmt",
      },
      registries = {
        "github:mason-org/mason-registry",
        "github:moerliy/mason-registry",
      },
    },
  },
}
