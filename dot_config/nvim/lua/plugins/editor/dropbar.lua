return {
  {
    "Bekaboo/dropbar.nvim",
    event = "VeryLazy",
    dependencies = {
      "nvim-telescope/telescope-fzf-native.nvim",
      "onsails/lspkind.nvim",
    },
    init = function()
      vim.api.nvim_set_hl(0, "DropBarIconUISeparator", { link = "Delimiter" })
      vim.api.nvim_set_hl(0, "DropBarMenuNormalFloat", { link = "Pmenu" })
    end,
    opts = function()
      local lspkind = require("lspkind")
      local menu_utils = require("dropbar.utils.menu")
      local function close()
        local menu = menu_utils.get_current()
        while menu and menu.prev_menu do
          menu = menu.prev_menu
        end

        if menu then
          menu:close()
        end
      end
      return {
        general = {
          update_interval = 50,
          attach_events = { "BufWinEnter", "BufWritePost" },
          update_events = {
            win = { "CursorMoved", "CursorMovedI", "WinResized" },
          },
          enable = function(buf, win)
            return vim.fn.win_gettype(win) == ""
              and vim.bo[buf].bt == ""
              and vim.wo[win].winbar == ""
              and not vim.wo[win].diff
              and not vim.api.nvim_win_get_config(win).zindex
              and vim.api.nvim_buf_get_name(buf) ~= ""
              and (
                vim.bo[buf].ft == "markdown"
                or (
                  buf and vim.api.nvim_buf_is_valid(buf) and (pcall(vim.treesitter.get_parser, buf)) and true or false
                )
              )
          end,
        },
        icons = {
          enable = true,
          ui = {
            bar = { separator = "  " },
            menu = { separator = "" },
          },
          kinds = {
            symbols = vim.tbl_map(function(symbol)
              return symbol .. " "
            end, lspkind.symbol_map),
            use_devicons = true,
          },
        },

        bar = {
          sources = function()
            local sources = require("dropbar.sources")
            local utils = require("dropbar.utils.source")
            return {
              {
                get_symbols = function(buf, win, cursor)
                  if vim.api.nvim_get_current_win() ~= win then
                    return {}
                  end

                  if vim.bo[buf].ft == "markdown" then
                    return sources.markdown.get_symbols(buf, win, cursor)
                  end
                  return utils.fallback({ sources.lsp, sources.treesitter }).get_symbols(buf, win, cursor)
                end,
              },
            }
          end,
        },

        menu = {
          scrollbar = { enable = false },
          win_configs = {
            border = border,
            style = "minimal",
            col = function(menu)
              return menu.prev_menu and menu.prev_menu._win_configs.width + 1 or 0
            end,
          },
          keymaps = {
            -- Jump and close
            ["o"] = function()
              local menu = menu_utils.get_current()
              if not menu then
                return
              end
              local cursor = vim.api.nvim_win_get_cursor(menu.win)
              local entry = menu.entries[cursor[1]]
              local component = entry:first_clickable(entry.padding.left + entry.components[1]:bytewidth())
              if component then
                menu:click_on(component, nil, 1, "l")
              end
            end,
            -- Expands entry if possible
            ["l"] = function()
              local menu = menu_utils.get_current()
              if not menu then
                return
              end
              local row = vim.api.nvim_win_get_cursor(menu.win)[1]
              local component = menu.entries[row]:first_clickable()
              if component then
                menu:click_on(component, nil, 1, "l")
              end
            end,
            ["q"] = close,
            ["<esc>"] = close,
          },
        },
      }
    end,
    keys = {
      {
        "<leader>wp",
        function()
          require("dropbar.api").pick()
        end,
        desc = "Winbar Pick",
      },
    },
    config = function(_, opts)
      local bar_utils = require("dropbar.utils.bar")

      require("dropbar").setup(opts)

      vim.api.nvim_create_autocmd("WinEnter", {
        desc = "Refresh Window Dropbars",
        callback = function()
          if vim.fn.getwininfo(vim.api.nvim_get_current_win())[1].winbar == 1 then
            bar_utils.exec("update")
          end
        end,
      })
    end,
  },
  {
    "nvim-lualine/lualine.nvim",
    opts = function(_, opts)
      opts.winbar = {
        lualine_a = {
          { "filename", separator = { left = "", right = "" }, color = { gui = "bold" } },
          { "%{%v:lua.dropbar.get_dropbar_str()%}", separator = { left = "", right = "" }, color = "nil" },
        },
      }
    end,
  },
}
