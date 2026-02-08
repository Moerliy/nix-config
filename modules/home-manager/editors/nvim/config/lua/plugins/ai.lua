return {
  {
    "yetone/avante.nvim",
    opts = {
      provider = "copilot",
      selection = {
        hint_display = "none",
      },
      behaviour = {
        auto_set_keymaps = false,
      },
    },
    keys = {
      { "<leader>aa", "<cmd>AvanteAsk<CR>", mode = { "v" }, desc = "Ask Avante" },
      { "<leader>ac", "<cmd>AvanteChat<CR>", mode = { "v" }, desc = "Chat with Avante" },
      { "<leader>ae", "<cmd>AvanteEdit<CR>", mode = { "v" }, desc = "Edit Avante" },
      { "<leader>af", "<cmd>AvanteFocus<CR>", mode = { "v" }, desc = "Focus Avante" },
      { "<leader>an", "<cmd>AvanteChatNew<CR>", mode = { "v" }, desc = "New Avante Chat" },
    },
  },
}
