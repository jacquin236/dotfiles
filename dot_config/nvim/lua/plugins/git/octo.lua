return {
  {
    "pwntester/octo.nvim",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "nvim-telescope/telescope.nvim",
      "nvim-tree/nvim-web-devicons",
    },
    cmd = "Octo",
    event = { { event = "BufReadCmd", pattern = "octo://*" } },
    opts = {
      enable_builtin = true,
      default_to_projects_v2 = true,
      default_merge_method = "squash",
    },
    keys = require("util.octo"),
    config = function(_, opts)
      require("octo").setup(opts)

      vim.treesitter.language.register("markdown", "octo")

      if LazyVim.has("telescope.nvim") then
        opts.picker = "telescope"
      elseif LazyVim.has("fzf-lua") then
        opts.picker = "fzf-lua"
      else
        LazyVim.error("`octo.nvim` requires `telescope.nvim` or `fzf-lua`")
      end

      -- Keep some empty windows in sessions
      vim.api.nvim_create_autocmd("ExitPre", {
        group = vim.api.nvim_create_augroup("octo_exit_pre", { clear = true }),
        callback = function()
          local keep = { "octo" }
          for _, win in ipairs(vim.api.nvim_list_wins()) do
            local buf = vim.api.nvim_win_get_buf(win)
            if vim.tbl_contains(keep, vim.bo[buf].filetype) then
              vim.bo[buf].buftype = "" -- set buftype to empty to keep the window
            end
          end
        end,
      })
    end,
  },
  {
    "folke/which-key.nvim",
    opts = {
      spec = {
        { "<leader>go", group = "Octo", icon = " " },

        { "<leader>G", group = "github", icon = " " },

        { "<leader>Gc", group = "comments", icon = " " },
        { "<leader>Gt", group = "threads", icon = " " },
        { "<leader>Gi", group = "issues", icon = " " },
        { "<leader>Gp", group = "pull requests", icon = " " },
        { "<leader>Ga", group = "assignee/reviewer", icon = " " },
        { "<leader>Gl", group = "Label", icon = " " },
        { "<leader>Gr", group = "reaction", icon = " " },
        { "<leader>Gv", group = "re[v]iew", icon = " " },
        { "<leader>Gm", group = "PR Merge", icon = " " },
      },
    },
  },
}
