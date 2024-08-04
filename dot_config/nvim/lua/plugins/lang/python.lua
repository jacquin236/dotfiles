-- LSP Server to use for Python.
-- Set to "basedpyright" to use basedpyright instead of pyright.
vim.g.lazyvim_python_lsp = "pyright"
vim.g.lazyvim_python_ruff = "ruff"

return {
  { "Vimjas/vim-python-pep8-indent", ft = { "python" } },
  {
    "MeanderingProgrammer/py-requirements.nvim",
    event = { "BufRead requirements.txt" },
    dependencies = {
      { "nvim-lua/plenary.nvim" },
      {
        "hrsh7th/nvim-cmp",
        opts = function(_, opts)
          table.insert(opts.sources, { name = "py-requirements" })
        end,
      },
    },
    opts = {},
    -- stylua: ignore
    keys = {
      { "<leader>ppu", function() require("py-requirements").upgrade() end, desc = "Update Package" },
      { "<leader>ppU", function() require("py-requirements").upgrade_all() end, desc = "Update All Packages" },
      { "<leader>ppd", function() require("py-requirements").show_description() end, desc = "Show Description" },
    },
  },
  {
    "folke/which-key.nvim",
    opts = {
      spec = {
        { "<leader>p", group = "packages/dependencies", icon = " ", mode = { "n", "v" } },
        { "<leader>pp", group = "python: requirements.txt", icon = " " },
        { "<localleader>v", group = "VirtualEnv (python)", icon = " " },
      },
    },
  },
  {
    "neovim/nvim-lspconfig",
    opts = {
      servers = {
        basedpyright = {
          settings = {
            basedpyright = {
              analysis = {
                diagnosticSeverityOverrides = {
                  reportUnusedCallResult = "information",
                  reportUnusedExpression = "information",
                  reportUnknownMemberType = "none",
                  reportUnknownLambdaType = "none",
                  reportUnknownParameterType = "none",
                  reportMissingParameterType = "none",
                  reportUnknownVariableType = "none",
                  reportUnknownArgumentType = "none",
                  reportAny = "none",
                },
              },
            },
          },
        },
        pyright = {
          settings = {
            verboseOutput = true,
            autoImportCompletion = true,
            python = {
              analysis = {
                diagnosticSeverityOverrides = {
                  reportWildcardImportFromLibrary = "none",
                  reportUnusedImport = "information",
                  reportUnusedClass = "information",
                  reportUnusedFunction = "information",
                },
                typeCheckingMode = "strict",
                autoSearchPaths = true,
                useLibraryCodeForTypes = true,
                diagnosticMode = "openFilesOnly",
                indexing = true,
              },
            },
          },
        },
        [vim.g.lazyvim_python_ruff] = {
          handlers = {
            ["textDocument/publishDiagnostics"] = function() end,
          },
        },
      },
    },
  },
  {
    "linux-cultist/venv-selector.nvim",
    dependencies = {
      "neovim/nvim-lspconfig",
      "mfussenegger/nvim-dap",
      "mfussenegger/nvim-dap-python",
      "nvim-telescope/telescope.nvim",
    },
    lazy = false,
    branch = "regexp",
    keys = function()
      local vprefix = "<localleader>v"
      local venv = require("venv-selector")
      -- stylua: ignore
      return {
        { vprefix .. "p", function() venv.python() end, desc = "Path to Python or nil" },
        { vprefix .. "v", function() venv.venv() end, desc = "Path to Venv or nil" },
        { vprefix .. "s", function() venv.source() end, desc = "Source name of venv" },
        { vprefix .. "w", function() venv.workspace_paths() end, desc = "Workspace paths" },
        { vprefix .. "c", function() venv.cwd() end, desc = "Current working dir" },
        { vprefix .. "f", function() venv.file_dir() end, desc = "Current file dir" },
        { vprefix .. "d", function() venv.deactivate() end, desc = "Deactivate venv" },
        { vprefix .. "S", function() venv.stop_lsp_servers() end, desc = "Stop lsp server" },
      }
    end,
  },
  {
    "mfussenegger/nvim-dap-python",
    config = function()
      local dap_python = require("dap-python")
      local dap = require("dap")
      dap_python.setup("python")
      dap_python.test_runner = "pytest"

      table.insert(dap.configurations.python, {
        {
          name = "Python Debugger: Flask",
          type = "debugpy",
          request = "launch",
          module = "flask",
          env = {
            FLASK_APP = "app.py",
            FLASK_ENV = "development",
          },
          args = { "run" },
          jinja = true,
        },
        {
          name = "Python Debugger: Django",
          type = "debugpy",
          request = "launch",
          program = "${file}",
          console = "integratedTerminal",
          django = true,
          justMyCode = true,
          args = { "--port", "5000" },
          autoReload = { enable = true },
        },
        {
          name = "Python Debugger: Attach Process",
          type = "debugpy",
          request = "attach",
          processId = require("dap.utils").pick_process,
          connect = {
            host = "localhost",
            port = 5678,
          },
          pathMappings = { localRoot = "${workspaceFolder}" },
        },
      })
    end,
  },
}
