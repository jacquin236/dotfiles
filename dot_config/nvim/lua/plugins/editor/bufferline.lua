return {
  {
    "akinsho/bufferline.nvim",
    opts = function(_, opts)
      opts.options.themable = true
      opts.options.separator_style = "slant"
      opts.options.diagnostics = false
      opts.options.truncate_names = false
      opts.options.offsets = {
        {
          filetype = "neo-tree",
          text = "  NEO-TREE EXPLORER",
          highlight = "PanelHeading",
          text_align = "left",
          separator = true,
        },
      }
      opts.options.color_icons = true
      opts.options.indicator = { style = "underline" }
      opts.options.hover = { enabled = true, reveal = { "close" } }
      opts.options.groups = {
        options = { toggle_hidden_on_enter = true },
        items = {
          require("bufferline").groups.builtin.pinned:with({ icon = "" }),
          require("bufferline").groups.builtin.ungrouped,
          -- stylua: ignore
          {
            name = "dependencies",
            icon = "",
            matcher = function(buf)
              return vim.startswith(buf.path, vim.env.VIMRUNTIME)
            end,
          },
          {
            name = "doc",
            matcher = function(buf)
              -- stylua: ignore
              if vim.bo[buf.id].filetype == "man" or buf.path:match("man://") then return true end
              for _, ext in ipairs({ "md", "txt", "org", "norg", "wiki" }) do
                if ext == vim.fn.fnamemodify(buf.path, ":e") then
                  return true
                end
              end
            end,
          },
          {
            name = "test",
            matcher = function(buf)
              -- stylua: ignore
              return buf.name:match("[_%.]spec") or buf.name:match("[_%.]test")
            end,
          },
          {
            name = "sql",
            matcher = function(buf)
              return buf.name:match("%.sql$")
            end,
          },
        },
      }
    end,
    -- stylua: ignore
    keys = function()
      local keys = {}
      for i = 1, 9 do
        table.insert(keys, { "<leader>b" .. i, "<cmd>BufferLineGoToBuffer " .. i .. "<cr>", desc = " Buffer " .. i })
      end
      vim.list_extend(keys, {
        { "<leader>bS", "<cmd>BufferLineSortByDirectory<cr>", desc = "Sort By Directory" },
        { "<leader>bs", "<cmd>BufferLineSortByExtension<cr>", desc = "Sort By Extensions" },
        { "<leader>.", "<cmd>BufferLinePick<cr>", desc = "Pick Buffer" },
      })
      return keys
    end,
  },
}
