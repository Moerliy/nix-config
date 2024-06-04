return {
  {
    "williamboman/mason.nvim",
    opts = {
        registries = {
          "github:mason-org/mason-registry",
          "github:Moerliy/mason-registry",
        },
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
      })
  },
}
