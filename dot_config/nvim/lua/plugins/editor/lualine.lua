local component = require("util.lualine")
local icons = require("util.icons")

return {
  {
    "nvim-lualine/lualine.nvim",
    opts = function(_, opts)
      opts.options = {
        theme = "auto",
        component_separators = "",
        section_separators = { left = "", right = "" },
        disabled_filetypes = {
          statusline = { "dashboard", "alpha", "starter" },
          winbar = { "dashboard", "neo-tree", "toggleterm", "Trouble", "noice", "spectre_panel", "qf", "dbui" },
        },
        refresh = {
          statusline = 1000,
          tabline = 1000,
          winbar = 1000,
        },
      }
      opts.sections.lualine_a = {
        { "mode", icon = icons.ui.Target, color = { gui = "bold" }, separator = { left = "" }, right_padding = 2 },
      }
      opts.sections.lualine_b[1] = {
        "diagnostics",
        sections = { "error", "warn", "info", "hint" },
        colored = true,
        update_in_insert = false,
        always_visible = true,
        symbols = {
          error = icons.diagnostics.Error .. " ",
          warn = icons.diagnostics.Warning .. " ",
          info = icons.diagnostics.Information .. " ",
          hint = icons.diagnostics.Hint .. " ",
        },
      }
      opts.sections.lualine_c[2] = ""
      opts.sections.lualine_c[4] = {
        LazyVim.lualine.pretty_path({
          filename_hl = "Bold",
          modified_hl = "MatchParen",
          directory_hl = "Conceal",
        }),
      }
      vim.list_extend(opts.sections.lualine_x, {
        -- stylua: ignore start
        {
          component.noice_search,
          cond = function() return package.loaded["noice"] and require("noice").api.status.search.has() end,
          color = function() return LazyVim.ui.fg("DiagnosticOk") end,
        },
        { component.tabwidth },
        { component.lsp_status, color = function() return LazyVim.ui.fg("DiagnosticOk") end },
        { component.formatter_status, color = function() return LazyVim.ui.fg("Function") end },
        { component.linter_status, color = function() return LazyVim.ui.fg("Label") end },
        { component.python_venv, color = function() return LazyVim.ui.fg("Debug") end },
        {
          component.yaml_schema,
          cond = function() return LazyVim.has("yaml-companion") and package.loaded["yaml-companion"] end,
          color = function() return LazyVim.ui.fg("Statement") end,
        }
,
        -- stylua: ignore end
      })
      opts.sections.lualine_z = {
        -- stylua: ignore
        {
          function() return " " .. os.date("%I:%M %p") end,
          color = { gui = "bold" },
        },
        { component.progress_bar, separator = { right = "" }, left_padding = 2 },
      }
      opts.extensions = { "lazy", "mason", "nvim-dap-ui", "trouble" }
    end,
  },
}
