return {
  {
    "williamboman/mason.nvim",
    config = {
      registries = {
        "github:mason-org/mason-registry",
        "github:Moerliy/mason-registry",
    },},
    opts = function(_, opts)
      vim.list_extend(opts.ensure_installed, {
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
    end,
  },
}
