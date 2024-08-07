local actions = require("telescope.actions")

return {
  {
    "nvim-telescope/telescope.nvim",
    opts = {
      defaults = {
        layout_strategy = "flex",
        layout_config = {
          prompt_position = "top",
          horizontal = { preview_width = { 0.7, max = 100, min = 30 } },
          vertical = { preview_cutoff = 20, preview_height = 0.85 },
          cursor = { height = 0.5, width = 0.8 },
        },
        sorting_strategy = "ascending",
        path_display = { filename_first = { reverse_directories = false } },
        dynamic_preview_title = true,
        winblend = 0,
        mappings = {
          i = {
            ["<C-k>"] = actions.move_selection_previous,
            ["<C-j>"] = actions.move_selection_next,
            ["<S-esc>"] = actions.close,
            ["<C-p>"] = require("telescope.actions.layout").toggle_preview,
            ["<c-l>"] = require("telescope.actions.layout").cycle_layout_next,
            ["<a-l>"] = require("telescope.actions.layout").cycle_layout_prev,
            ["<C-Down>"] = actions.cycle_history_next,
            ["<C-Up>"] = actions.cycle_history_prev,
            ["<M-h>"] = actions.results_scrolling_left,
            ["<M-l>"] = actions.results_scrolling_right,
          },
        },
        file_ignore_patterns = {
          ".gitignore",
          "node_modules",
          "build",
          "dist",
          "yarn.lock",
          "*.git/*",
          "*/tmp/*",
        },
      },
      pickers = {
        find_files = {
          hidden = false,
        },
        buffers = {
          layout_config = {
            prompt_position = "top",
            height = 0.5,
            width = 0.6,
          },
          sorting_strategy = "ascending",
          mappings = {
            i = {
              ["<c-r>"] = require("telescope.actions").delete_buffer,
            },
          },
        },
        spell_suggest = {
          layout_config = {
            prompt_position = "top",
            height = 0.3,
            width = 0.25,
          },
          sorting_strategy = "ascending",
        },
      },
      extensions = {
        fzf = {
          fuzzy = true,
          override_generic_sorter = true,
          override_file_sorter = true,
          case_mode = "smart_case",
        },
        ["ui-select"] = {
          require("telescope.themes").get_dropdown({}),
        },
      },
    },
    -- stylua: ignore
    keys = {
      { "<leader>ssa", function() require("telescope.builtin").lsp_document_symbols({ symbols = LazyVim.config.get_kind_filter() }) end,                                                                                                                desc = "All" },
      { "<leader>ssc", LazyVim.pick("lsp_document_symbols", { symbols = { "Class" } }),                                                           desc = "Class" },
      { "<leader>ssf", LazyVim.pick("lsp_document_symbols", { symbols = { "Function" } }),                                                        desc = "Function" },
      { "<leader>ssm", LazyVim.pick("lsp_document_symbols", { symbols = { "Method" } }),                                                          desc = "Method" },
      { "<leader>ssC", LazyVim.pick("lsp_document_symbols", { symbols = { "Constructor" } }),                                                     desc = "Constructor" },
      { "<leader>sse", LazyVim.pick("lsp_document_symbols", { symbols = { "Enum" } }),                                                            desc = "Enum" },
      { "<leader>ssi", LazyVim.pick("lsp_document_symbols", { symbols = { "Interface" } }),                                                       desc = "Interface" },
      { "<leader>ssM", LazyVim.pick("lsp_document_symbols", { symbols = { "Module" } }),                                                          desc = "Module" },
      { "<leader>sss", LazyVim.pick("lsp_document_symbols", { symbols = { "Struct" } }),                                                          desc = "Struct" },
      { "<leader>sst", LazyVim.pick("lsp_document_symbols", { symbols = { "Trait" } }),                                                           desc = "Trait" },
      { "<leader>ssF", LazyVim.pick("lsp_document_symbols", { symbols = { "Field" } }),                                                           desc = "Field" },
      { "<leader>ssp", LazyVim.pick("lsp_document_symbols", { symbols = { "Property" } }),                                                        desc = "Property" },
      { "<leader>ssv", LazyVim.pick("lsp_document_symbols", { symbols = { "Variable", "Parameter" } }),                                           desc = "Variable" },

      { "<leader>sSa", function() require("telescope.builtin").lsp_dynamic_workspace_symbols({ synbols = LazyVim.config.get_kind_filter() }) end,                                                                                                                desc = "All" },
      { "<leader>sSc", LazyVim.pick("lsp_dynamic_workspace_symbols", { symbols = { "Class" } }),                                                  desc = "Class" },
      { "<leader>sSf", LazyVim.pick("lsp_dynamic_workspace_symbols", { symbols = { "Function" } }),                                               desc = "Function" },
      { "<leader>sSm", LazyVim.pick("lsp_dynamic_workspace_symbols", { symbols = { "Method" } }),                                                 desc = "Method" },
      { "<leader>sSC", LazyVim.pick("lsp_dynamic_workspace_symbols", { symbols = { "Constructor" } }),                                            desc = "Constructor" },
      { "<leader>sSe", LazyVim.pick("lsp_dynamic_workspace_symbols", { symbols = { "Enum" } }),                                                   desc = "Enum" },
      { "<leader>sSi", LazyVim.pick("lsp_dynamic_workspace_symbols", { symbols = { "Interface" } }),                                              desc = "Interface" },
      { "<leader>sSM", LazyVim.pick("lsp_dynamic_workspace_symbols", { symbols = { "Module" } }),                                                 desc = "Module" },
      { "<leader>sSs", LazyVim.pick("lsp_dynamic_workspace_symbols", { symbols = { "Struct" } }),                                                 desc = "Struct" },
      { "<leader>sSt", LazyVim.pick("lsp_dynamic_workspace_symbols", { symbols = { "Trait" } }),                                                  desc = "Trait" },
      { "<leader>sSF", LazyVim.pick("lsp_dynamic_workspace_symbols", { symbols = { "Field" } }),                                                  desc = "Field" },
      { "<leader>sSp", LazyVim.pick("lsp_dynamic_workspace_symbols", { symbols = { "Property" } }),                                               desc = "Property" },
      { "<leader>sSv", LazyVim.pick("lsp_dynamic_workspace_symbols", { symbols = { "Variable", "Parameter" } }),                                  desc = "Variable" },
      { "<leader>sA",  LazyVim.pick("treesitter"),                                                                                                desc = "Treesitter Symbols" },
      { "<leader>sP",  "<cmd>Telescope builtin<cr>",                                                                                              desc = "Pickers (Telescope)" },
    },
  },
}
