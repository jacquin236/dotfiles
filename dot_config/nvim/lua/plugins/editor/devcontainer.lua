return {
  {
    "https://codeberg.org/esensar/nvim-dev-container",
    dependencies = "nvim-treesitter/nvim-treesitter",
    config = function(opts)
      require("devcontainer").setup(opts)
    end,
    opts = {
      attach_mounts = {
        neovim_config = { enable = true },
      },
      config_search_start = function()
        if vim.g.devcontainer_selected_config == nil or vim.g.devcontainer_selected_config == "" then
          local candidates =
            vim.split(vim.fn.glob(vim.uv.cwd() .. "/.devcontainer/**/devcontainer.jsoin"), "\n", { trimempty = true })
          if #candidates < 2 then
            vim.g.devcontainer_selected_config = vim.uv.cwd()
          else
            local choices = { "Select devcontainer config file to use: " }
            for idx, candidate in ipairs(candidates) do
              table.insert(choices, idx .. ". - " .. candidate)
            end
            local choice_idx = vim.fn.inputlist(choices)
            if choice_idx > #candidates then
              choice_idx = 1
            end
            vim.g.devcontainer_selected_config = string.gsub(candidates[choice_idx], "/devcontainer.jsoin", "")
          end
        end
        return vim.g.devcontainer_selected_config
      end,
    },
  },
  {
    "nvim-lualine/lualine.nvim",
    opts = function(_, opts)
      local devcontainer_status = function()
        local status = nil
        local build_status_last = require("devcontainer.status").find_build({ running = true })
        if build_status_last then
          status = status
            .. "["
            .. (build_status_last.current_step or "")
            .. "/"
            .. (build_status_last.step_count or "")
            .. "]"
            .. (build_status_last.progress and "(" .. build_status_last.progress .. "%%)" or "")
        end
        return status
      end
      -- stylua: ignore
      table.insert(opts.sections.lualine_x, 1, {
        devcontainer_status,
        color = function() return LazyVim.ui.fg("Constant") end,
        cond = function() return package.loaded["devcontainer"] end,
      })
    end,
  },
}
