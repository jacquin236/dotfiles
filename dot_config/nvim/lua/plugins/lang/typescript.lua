return {
  {
    "dmmulroy/ts-error-translator.nvim",
    ft = { "typescript", "typescriptreact", "javascript", "javascriptreact" },
    opts = {},
  },
  {
    "dmmulroy/tsc.nvim",
    ft = { "typescriptreact", "typescript" },
    cmd = { "TSC", "TSCOpen", "TSCClose", "TSStop" },
    opts = {
      use_trouble_qflist = true,
    },
    keys = {
      { "<leader>ct", ft = { "typescriptreact", "typescript" }, "<cmd>TSC<cr>", desc = "Type Check" },
      { "<leader>xy", ft = { "typescriptreact", "typescript" }, "<cmd>TSCOpen<cr>", desc = "Type Check Quickfix" },
    },
  },
  {
    "pmizio/typescript-tools.nvim",
    lazy = false,
    dependencies = { "nvim-lua/plenary.nvim", "neovim/nvim-lspconfig" },
    opts = {
      handlers = {
        ["textDocument/publishDiagnostics"] = function(err, result, ctx, config)
          require("ts-error-translator").translate_diagnostics(err, result, ctx, config)
          vim.lsp.diagnostic.on_publish_diagnostics(err, result, ctx, config)
        end,
      },
      on_attach = function(_, bufnr)
        local map = vim.keymap.set
        -- stylua: ignore start
        map("n", "<leader>co", "<cmd>TSToolsOrganizeImports<cr>", { desc = "Organize Imports", buffer = bufnr })
        map("n", "<leader>cI", "<cmd>TSToolsSortImports<cr>", { desc = "Sort imports", buffer = bufnr })
        map("n", "<leader>cu", "<cmd>TSToolsRemoveUnusedImports<cr>", { desc = "Remove unused imports", buffer = bufnr })
        map("n", "<leader>cU", "<cmd>TSToolsRemoveUnused<cr>", { desc = "Remove unused statements", buffer = bufnr })
        map("n", "<leader>cM", "<cmd>TSToolsAddMissingImports<cr>", { desc = "Add missing imports", buffer = bufnr })
        map("n", "<leader>cD", "<cmd>TSToolsFixAll<cr>", { desc = "Fix all diagnostics", buffer = bufnr })
        map("n", "gD", "<cmd>TSToolsGoToSourceDefinition<cr>", { desc = "Goto Source Definiton", buffer = bufnr })
        map("n", "gR", "<cmd>TSToolsFileReferences<cr>", { desc = "File References", buffer = bufnr })
        -- stylua: ignore end
      end,
      settings = {
        tsserver_file_preferences = {
          includeInlayEnumMemberValueHints = true,
          includeInlayFunctionLikeReturnTypeHints = true,
          includeInlayParameterNameHints = "all",
          includeInlayParameterNameHintsWhenArgumentMatchesName = true,
          includeInlayFunctionParameterTypeHints = true,
          includeInlayPropertyDeclarationTypeHints = true,
          includeInlayVariableTypeHints = true,
          includeInlayVariableTypeHintsWhenTypeMatchesName = true,
          quotePreference = "auto",
          disableSuggestions = true,
        },
        complete_function_calls = true,
      },
    },
  },
  {
    "neovim/nvim-lspconfig",
    opts = {
      servers = {
        vtsls = {
          filetypes = {
            "javascript",
            "javascriptreact",
            "javascript.jsx",
            "typescript",
            "typescriptreact",
            "typescript.tsx",
          },
          enableMoveToFileCodeAction = true,
          autoUseWorkspaceTsdk = true,
          experimental = {
            completion = { enableServerSideFuzzyMatch = true },
          },
          settings = {
            typescript = {
              updateImportsOnFileMove = { enabled = "always" },
            },
          },
          keys = require("util.typescript").vtsls_keys,
        },
      },
      setup = {
        vtsls = require("util.typescript").vtsls_setup,
      },
    },
  },
  {
    "mxsdev/nvim-dap-vscode-js",
    dependencies = {
      "mfussenegger/nvim-dap",
      "microsoft/vscode-js-debug",
    },
    config = require("util.typescript").ts_debugger,
  },
}
