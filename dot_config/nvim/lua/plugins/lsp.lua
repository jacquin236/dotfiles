return {
  {
    "folke/which-key.nvim",
    opts = {
      spec = {
        { "<leader>cl", group = "Lsp", icon = " " },
      },
    },
  },
  {
    "neovim/nvim-lspconfig",
    init = function()
      local keys = require("lazyvim.plugins.lsp.keymaps").get()
      -- stylua: ignore start
      keys[#keys + 1] = { "<leader>cl", false }
      keys[#keys + 1] = { "<leader>il", "<cmd>LspInfo<cr>", desc = "Lsp" }
      keys[#keys + 1] = { "<leader>clr", "<cmd>LspRestart<cr>", desc = "Restart Lsp" }
      keys[#keys + 1] = { "<leader>cls", "<cmd>LspStart<cr>", desc = "Start Lsp" }
      keys[#keys + 1] = { "<leader>clS", "<cmd>LspStop<cr>", desc = "Stop Lsp" }
      keys[#keys + 1] = { "<leader>clW", function() vim.lsp.buf.remove_workspace_folder() end, desc = "Remove Workspace" }
      keys[#keys + 1] = { "<leader>clw", function() vim.lsp.buf.add_workspace_folder() end, desc = "Add Workspace" }
      keys[#keys + 1] = { "<leader>clL", function() print(vim.inspect(vim.lsp.buf.list_workspace_folders())) end, desc =
      "List Workspace" }
      -- stylua: ignore end
    end,
    ---@class PluginLspOpts
    opts = {
      ---@type lspconfig.options
      servers = {
        -- lua
        lua_ls = {
          settings = {
            Lua = {
              type = { castNumbertoInteger = true },
              workspace = {
                didChangeWatchedFiles = { dynamicRegistration = false },
                maxPreload = 100000,
                preloadFileSize = 10000,
              },
              diagnostics = {
                virtual_text = { prefix = "icons" },
                disable = { "incomplete-signature-doc", "trailing-space" },
                unusedLocalExclude = { "_*" },
              },
              completion = {
                keywordSnippet = "Replace",
                callSnippet = "Replace",
                showWord = "Disable",
                workspaceWord = false,
              },
            },
          },
        },
        graphql = {
          filetypes = { "graphql", "javascript", "javascriptreact", "typescript", "typescriptreact" },
          on_attach = function(client)
            -- Disable workspaceSymbolProvider because this prevents searching
            -- for symbols in typescript files which this server is also enabled for.
            -- @see: https://github.com/nvim-telescope/telescope.nvim/issues/964
            client.server_capabilities.workspaceSymbolProvider = false
          end,
        },
        vimls = {},
        bashls = {},
        emmet_language_server = {},
        html = {},
        cssmodules_ls = {},
        css_variables = {},
        cssls = {
          lint = {
            compatibleVendorPrefixes = "ignore",
            vendorPrefix = "ignore",
            unknownVendorSpecificProperties = "ignore",

            -- unknownProperties = "ignore", -- duplicate with stylelint

            duplicateProperties = "warning",
            emptyRules = "warning",
            importStatement = "warning",
            zeroUnits = "warning",
            fontFaceProperties = "warning",
            hexColorLength = "warning",
            argumentsInColorFunction = "warning",
            unknownAtRules = "warning",
            ieHack = "warning",
            propertyIgnoredDueToDisplay = "warning",
          },
        },
        lemminx = {},
      },
    },
  },
  {
    "williamboman/mason.nvim",
    opts = {
      ensure_installed = {
        "bash-language-server",
        "graphql-language-service-cli",
        "html-lsp",
        "cssmodules-language-server",
        "css-variables-language-server",
        "css-lsp",
        "lemminx",
      },
    },
  },
}
