local ts = require("util.treesitter")

return {
  {
    "nvim-treesitter/nvim-treesitter",
    dependencies = {
      "RRethy/nvim-treesitter-endwise",
      "andymass/vim-matchup",
    },
    opts = {
      ts.treesitter_core,
      ts.treesitter_textobjs,
      indent = { enable = true },
      endwise = { enable = true },
      matchup = { enable = true, include_match_words = true, disable_virtual_text = true },
    },
  },
  {
    "nvim-treesitter/nvim-treesitter",
    opt = function(_, opts)
      -- stylua: ignore
      vim.list_extend(opts.ensure_installed, {
        "c_sharp", "csv", "embedded_template", "gotmpl",
        "jq", "jsdoc" , "norg", "powershell", "readline",
        "tsv", "requirements", "css", "scss", "xml",
      })
    end,
    config = function(_, opts)
      ts.treesitter_parsers()
      require("nvim-treesitter.configs").setup(opts)

      vim.g.skip_ts_context_commentstring_module = true
      vim.g.matchup_matchparen_offscreen = { method = "popup" }
    end,
  },
  {
    "nvim-treesitter/nvim-treesitter-context",
    event = "VeryLazy",
    init = function()
      vim.api.nvim_set_hl(0, "TreesitterContextSeparator", { link = "Dim" })
      vim.api.nvim_set_hl(0, "TreesitterContext", { link = "Normal" })
      vim.api.nvim_set_hl(0, "TreesitterContextLineNumber", { link = "LineNr" })
    end,
    opts = {
      multiline_threshold = 4,
      separator = "─",
      mode = "cursor",
    },
  },
  {
    "chrisgrieser/nvim-various-textobjs",
    keys = ts.treesitter_various_text_objs_keys,
    opts = { useDefaultKeymaps = false },
  },
  {
    "windwp/nvim-ts-autotag",
    event = "LazyFile",
    ft = { "typescriptreact", "javascript", "javascriptreact", "html", "vue", "svelte" },
    opts = {},
  },
  {
    "vidocqh/auto-indent.nvim",
    event = "LazyFile",
    opts = {
      ---@param lnum: number
      ---@return number
      indentexpr = function(lnum)
        return require("nvim-treesitter.indent").get_indent(lnum)
      end,
    },
  },
  {
    "hiphish/rainbow-delimiters.nvim",
    event = "VeryLazy",
    config = function()
      local rainbow_delimiters = require("rainbow-delimiters")
      require("rainbow-delimiters.setup").setup({
        strategy = {
          [""] = rainbow_delimiters.strategy["global"],
          vim = rainbow_delimiters.strategy["local"],
        },
        query = {
          [""] = "rainbow-delimiters",
          lua = "rainbow-blocks",
        },
        highlight = {
          "RainbowDelimiterRed",
          "RainbowDelimiterYellow",
          "RainbowDelimiterBlue",
          "RainbowDelimiterOrange",
          "RainbowDelimiterGreen",
          "RainbowDelimiterViolet",
          "RainbowDelimiterCyan",
        },
        blacklist = { "markdown", "help" },
      })
      vim.api.nvim_create_user_command("RainbowToggle", function()
        local bufnr = vim.api.nvim_get_current_buf()
        require("rainbow-delimiters").toggle(bufnr)
      end, { bar = true, nargs = 0 })
    end,
  },
  {
    "Wansmer/treesj",
    -- stylua: ignore
    keys = {
      { "<leader>cb", function() require("treesj").toggle() end, desc = "Split/Join Block" },
    },
    config = function()
      local tsj = require("treesj")
      tsj.setup({
        use_default_keymaps = false,
        check_syntax_error = true,
        max_join_length = 120,
        cursor_behavior = "hold",
        notify = true,
        langs = {},
      })
    end,
  },
  {
    "m-demare/hlargs.nvim",
    opts = {
      disable = function()
        local excluded_filetype = {
          "TelescopePrompt",
          "guihua",
          "lua",
          "rust",
          "typescript",
          "typescriptreact",
          "javascript",
          "javascriptreact",
        }
        if vim.tbl_contains(excluded_filetype, vim.bo.filetype) then
          return true
        end
        local bufnr = vim.api.nvim_get_current_buf()
        local filetype = vim.fn.getbufvar(bufnr, "&filetype")
        if filetype == "" then
          return true
        end
        local parsers = require("nvim-treesitter.parsers")
        local buflang = parsers.ft_to_lang(filetype)
        return vim.tbl_contains(excluded_filetype, buflang)
      end,
    },
  },
  -- Folding
  {
    "chrisgrieser/nvim-origami",
    event = "BufReadPost",
    opts = {},
  },
  { "fei6409/log-highlight.nvim", event = "BufRead *.log", opts = {} },
  {
    "mechatroner/rainbow_csv",
    ft = { "csv", "tsv", "dat", "csv_pipe", "dbout" },
    cmd = { "RainbowDelim", "RainbowMultiDelim", "Select", "CSVLint" },
  },
}
