local icons = require("util.icons")

return {
  {
    "nvim-neo-tree/neo-tree.nvim",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "MunifTanjim/nui.nvim",
      "nvim-tree/nvim-web-devicons",
      "3rd/image.nvim",
      {
        "s1n7ax/nvim-window-picker",
        name = "window-picker",
        event = "VeryLazy",
        version = "2.*",
        config = function() require("window-picker").setup({ hint = "floating-big-letter", show_prompt = false }) end,
      }
    },
    cmd = "Neotree",
    opts = {
      open_files_do_not_replace_types = { "terminal", "Trouble", "trouble", "qf", "Outline" },
      sources = { "filesystem", "git_status", "document_symbols" },
      source_selector = {
        winbar = true,
        separator_active = "",
        sources = {
          { source = "filesystem" },
          { source = "git_status" },
          { source = "document_symbols" },
        },
      },
      nesting_rules = {
        ["go"] = {
          pattern = "(.*)%.go$",
          files = { "%1_test.go" },
        },
        ["docker"] = {
          pattern = "^dockerfile$",
          ignore_case = true,
          files = { '.dockerignore', 'docker-compose.*', 'dockerfile*' },
        },
      },
      filter_rules = {
        include_current_win = true,
        autoselect_one = true,
        bo = {
          filetype = { "neo-tree", "neo-tree-popup", "notify" },
          buftype = { "terminal", "quickfix" },
        },
      },
      filesystem = {
        bind_to_cwd = false,
        follow_current_file = { enabled = true, leave_dirs_open = true },
        use_libuv_file_watcher = true,
        group_empty_dirs = false,
        hijack_netrw_behavior = "open_current",
        filtered_items = {
          visible = true,
          hide_dotfiles = false,
          hide_gitignored = false,
          hide_hidden = true,
        },
      },
      default_component_configs = {
        container = { enabled_character_fade = true },
        icon = { folder_empty = icons.documents.FolderEmptyOpen },
        name = { highlight_opened_files = true },
        git_status = {
          symbols = {
            -- Change type
            added = "✚",
            modified = "",
            deleted = "", -- this can only be used in the git_status source
            renamed = "󰁕", -- this can only be used in the git_status source
            -- Status type
            untracked = "",
            ignored = "",
            unstaged = "󱥸",
            staged = "",
            conflict = "󰇸 ",
          },
        },
        file_size = { required_width = 50 },
        symlink_target = { enabled = true },
      },
      window = {
        mappings = {
          ["o"] = "toggle_node",
          ["l"] = "open",
          ["h"] = "close_node",
          ["Y"] = {
            function(state)
              local node = state.tree:get_node()
              local path = node:get_id()
              vim.fn.setreg("+", path, "c")
            end,
            desc = "Copy Path to Clipboard"
          },
          ["O"] = {
            function(state)
              require("lazy.util").open(state.tree:get_node().path, { system = true })
            end,
            desc = "Open with System Application",
          },
          ["P"] = { "toggle_preview", config = { use_float = false } },
          ["<CR>"] = "open_with_window_picker",
          ["<C-s>"] = "split_with_window_picker",
          ["<C-v>"] = "vsplit_with_window_picker",
          ["<esc>"] = "revert_preview",
        },
      },
    },
  },
}
