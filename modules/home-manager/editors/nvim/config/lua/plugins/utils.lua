return {
  {
    "ahmedkhalf/project.nvim",
    opts = {
      manual_mode = false,
      detection_methods = { "lsp", "pattern" },
      patterns = { ".git", "_darcs", ".hg", ".bzr", ".svn", "Makefile", "package.json" },
      show_hidden = true,
      silent_chdir = false,
    },
    keys = {
      { "<leader>fp", false },
      { "<leader>pp", pick, desc = "Open projects" },
    },
  },
  {
    "wintermute-cell/gitignore.nvim",
    dependencies = {
      "fzf-lua",
    },
    config = function()
      local gitignore = require("gitignore")
      local fzf = require("fzf-lua")

      gitignore.generate = function(opts)
        local picker_opts = {
          -- the content of opts.args may also be displayed here for example.
          prompt = "Select templates for gitignore file> ",
          winopts = {
            width = 0.4,
            height = 0.3,
          },
          actions = {
            default = function(selected, _)
              -- as stated in point (3) of the contract above, opts.args and
              -- a list of selected templateNames are passed.
              gitignore.createGitignoreBuffer(opts.args, selected)
            end,
          },
        }
        fzf.fzf_exec(function(fzf_cb)
          for _, prefix in ipairs(gitignore.templateNames) do
            fzf_cb(prefix)
          end
          fzf_cb()
        end, picker_opts)
      end
      vim.api.nvim_create_user_command("Gitignore", gitignore.generate, { nargs = "?", complete = "file" })
    end,
    keys = {
      { "<leader>gi", ":Gitignore<CR>", desc = "Generate Gitignore" },
    },
  },
  {
    "numToStr/Comment.nvim",
    lazy = false,
    config = function()
      local ft = require("Comment.ft")
      ft.set("kt", "// %s")
    end,
    opts = {},
  },
  {
    "tris203/precognition.nvim",
    config = {
      startVisible = false,
    },
  },
  { "elkowar/yuck.vim" },
}
