return {
  {
    "ray-x/go.nvim",
    dependencies = {
      "ray-x/guihua.lua",
      "neovim/nvim-lspconfig",
      "nvim-treesitter/nvim-treesitter",
    },
    build = function() require("go.install").update_all_sync() end,
    ft = { "go", "gomod", "gowork", "gotmpl", "gohtmltmpl", "gotexttmpl" },
    opts = {
      lsp_cfg = true,
    },
    config = function(_, opts)
      require("go").setup(opts)
    end,
    keys = require("util.go").go_keys,
  },
  {
    "echasnovski/mini.icons",
    opts = {
      file = {
        [".go-version"] = { glyph = "", hl = "MiniIconsBlue" },
      },
      filetype = {
        gotmpl = { glyph = "󰟓", hl = "MiniIconsGrey" },
      },
    },
  },
  {
    "nvim-treesitter/nvim-treesitter",
    opts = function(_, opts)
      vim.list_extend(opts.ensure_installed, {
        "go",
        "gomod",
        "gowork",
        "gosum",
        "gotmpl",
      })
    end,
  },
  {
    "williamboman/mason.nvim",
    opts = {
      ensure_installed = { "gofumpt", "goimports", "gci", "golines", "golangci-lint", "delve" },
    },
  },
  {
    "leoluz/nvim-dap-go",
    dependencies = { "mfussenegger/nvim-dap" },
    config = function()
      require("dap-go").setup({
        dap_configurations = {
          {
            type = "go",
            name = "Debug (Build Flags & Arguments)",
            request = "launch",
            program = "${file}",
            buildFlags = require("dap-go").get_build_flags,
            args = require("dap-go").get_arguments,
          },
          {
            type = "go",
            name = "Attach remote",
            mode = "remote",
            request = "attach",
          },
        },
      })
    end,
    keys = {
      { "<leader>dT", function() require("dap-go").debug_test() end, desc = "Debug Test (go)" },
    },
  },
  {
    "stevearc/conform.nvim",
    optional = true,
    opts = {
      formatters_by_ft = {
        go = { "gofumpt", "goimports", "gci", "golines" },
      },
      formatters = {
        gofumpt = { prepend_args = { "-extra" } },
        gci = {
          args = { "write", "--skip-generated", "-s", "standard", "-s", "default", "--skip-vendor", "$FILENAME" },
        },
        goimports = { args = { "-srcdir", "$FILENAME" } },
        golines = {
          prepend_args = { "--base-formatter=gofumpt", "--ignore-generated", "--tab-len=1", "--max-len=120" },
        },
      },
    },
  },
  {
    "mfussenegger/nvim-lint",
    opts = function(_, opts)
      local args = require("lint").linters.golangcilint.args
      local function add_linters(tbl)
        for ft, linters in pairs(tbl) do
          if opts.linters_by_ft[ft] == nil then
            opts.linters_by_ft[ft] = linters
          else
            vim.list_extend(opts.linters_by_ft[ft], linters)
          end
        end
      end

      add_linters({
        ["go"] = { "golangcilint" },
        ["gomod"] = { "golangcilint" },
        ["gowork"] = { "golangcilint" },
      })

      opts.linters["golangcilint"] = { args = args }
      return opts
    end,
  },
  {
    "folke/which-key.nvim",
    opts = {
      spec = {
        { "<localleader>g", group = "Go", icon = " " },
        { "<localleader>gd", group = "Debug", icon = " " },
        { "<localleader>gt", group = "Test", icon = "🧪" },
        { "<localleader>ga", group = "Alternate switch", icon = "󰔡 " },
        { "<localleader>gm", group = "Mod", icon = "󰕳 " },
        { "<localleader>gT", group = "Tag", icon = " " },
        { "<leader>pg", group = "go: packages", icon = " " },
      },
    },
  },
}
