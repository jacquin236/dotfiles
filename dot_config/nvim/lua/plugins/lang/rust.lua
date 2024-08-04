return {
  {
    "mrcjkb/rustaceanvim",
    version = "^4", -- Recommended
    ft = { "rust" },
    lazy = false,
    config = function()
      vim.g.rustaceanvim = {
        tools = {
          autoSetHints = true,
          inlay_hints = {
            show_parameter_hints = true,
            parameter_hints_prefix = "<- ",
            other_hints_prefix = "=> ",
          },
        },
        server = {
          on_attach = function(_, bufnr)
            local map = vim.keymap.set
            -- stylua: ignore start
            map("n", "K", function() vim.cmd.RustLsp({ "hover", "actions" }) end, { desc = "Hover", buffer = bufnr })
            map({ "n", "v" }, "<localleader>ra", function() vim.cmd.RustLsp("codeAction") end, { desc = "Code Action", buffer = bufnr })
            map("n", "<localleader>rd", function() vim.cmd.RustLsp("debuggables") end, { desc = "Debuggables", buffer = bufnr })
            map("n", "<localleader>rD", function() vim.cmd.RustLsp("debug") end, { desc = "Debug", buffer = bufnr })
            map("n", "<localleader>rr", function() vim.cmd.RustLsp("runnables") end, { desc = "Runnables", buffer = bufnr })
            map("n", "<localleader>rR", function() vim.cmd.RustLsp("run") end, { desc = "Run", buffer = bufnr })
            map("n", "<localleader>rt", function() vim.cmd.RustLsp("testables") end, { desc = "Testables", buffer = bufnr })
            map("n", "<localleader>rm", function() vim.cmd.RustLsp("expandMacro") end, { desc = "Expand Macro", buffer = bufnr })
            map("n", "<localleader>rM", function() vim.cmd.RustLsp("rebuildProcMacros") end, { desc = "Rebuild Proc Macros", buffer = bufnr })
            map("n", "<localleader>re", function() vim.cmd.RustLsp("explainError") end, { desc = "Explain Error (cycle)", buffer = bufnr })
            map("n", "<localleader>rE", function() vim.cmd.RustLsp({ "explainError", "current" }) end, { desc = "Explain Error (current)", buffer = bufnr })
            map("n", "<localleader>rg", function() vim.cmd.RustLsp("renderDiagnostic") end, { desc = "Render Diagnostic (cycle)", buffer = bufnr })
            map("n", "<localleader>rG", function() vim.cmd.RustLsp({ "renderDiagnostic", "current" }) end, { desc = "Render Diagnostic (current)", buffer = bufnr })
            map("n", "<localleader>ro", function() vim.cmd.RustLsp("openCargo") end, { desc = "Open Cargo.toml", buffer = bufnr })
            map("n", "<localleader>rO", function() vim.cmd.RustLsp("openDocs") end, { desc = "Open docs.rs", buffer = bufnr })
            map("n", "<localleader>rp", function() vim.cmd.RustLsp("parentModule") end, { desc = "Parent Module", buffer = bufnr })
            map("n", "<localleader>rw", function() vim.cmd.RustLsp("workspaceSymbol") end, { desc = "Workspace Symbol", buffer = bufnr })
            map({ "n", "v" }, "<localleader>rj", function() vim.cmd.RustLsp("joinLines") end, { desc = "Join Lines", buffer = bufnr })
            map({ "n", "v" }, "<localleader>rs", function() vim.cmd.RustLsp("ssr") end, { desc = "Structual Search Replace", buffer = bufnr })
            map("n", "<localleader>rS", function() vim.cmd.RustLsp("syntaxTree") end, { desc = "Syntax Tree", buffer = bufnr })
            map("n", "<localleader>rC", function() vim.cmd.RustLsp({ "flyCheck", "cancel" }) end, { desc = "Cargo Check (cancel)", buffer = bufnr })
            map("n", "<localleader>rc", function() vim.cmd.RustLsp({ "flyCheck", "clear" }) end, { desc = "Cargo Check (clear)", buffer = bufnr })
            map("n", "<localleader>rf", function() vim.cmd.RustLsp("flycheck") end, { desc = "Cargo Check (run)", buffer = bufnr })
            map("n", "<localleader>rv", function() vim.cmd.RustLsp({ "view", "hir" }) end, { desc = "View HIR", buffer = bufnr })
            map("n", "<localleader>rV", function() vim.cmd.RustLsp({ "view", "mir" }) end, { desc = "View MIR", buffer = bufnr })
            map("n", "<localleader>ru", function() vim.cmd.Rustc({ "unpretty", "hir" }) end, { desc = "Unpretty HIR", buffer = bufnr })
            map("n", "<localleader>rU", function() vim.cmd.Rustc({ "unpretty", "mir" }) end, { desc = "Unpretty MIR", buffer = bufnr })
            map("n", "<C-space>", '<cmd>lua require("tree_climber_rust").init_selection()<cr>', { desc = "Incremental Selection", buffer = bufnr })
            map("x", "<CR>", '<cmd>lua require("tree_climber_rust").select_incremental()<cr>', { desc = "Select Incremental", buffer = bufnr })
            map("x", "<BS>", '<cmd>lua require("tree_climber_rust").select_previous()<cr>', { desc = "Select Previous", buffer = bufnr })
            -- stylua: ignore end
          end,

          default_settings = {
            ["rust-analyzer"] = {
              checkOnSave = {
                command = "clippy",
                allFeatures = true,
              },
              assist = {
                importEnforceGranularity = true,
                importPrefix = "crate",
              },
              completion = {
                postfix = { enable = false },
              },
              cargo = {
                allFeatures = true,
                loadOutDirsFromCheck = true,
                buildScripts = { enable = true },
              },
              inlayHints = {
                lifetimeElisionHints = { enable = true, useParameterNames = true },
              },
              procMacro = {
                enable = true,
                ignored = {
                  ["async-trait"] = { "async_trait" },
                  ["napi-derive"] = { "napi" },
                  ["async-recursion"] = { "async_recursion" },
                },
              },
            },
          },
        },
      }
    end,
  },
  {
    "neovim/nvim-lspconfig",
    opts = {
      setup = {
        rust_analyzer = function()
          return true
        end,
      },
    },
  },
  {
    "williamboman/mason.nvim",
    opts = { ensure_installed = { "rust-analyzer" } },
  },
  {
    "folke/which-key.nvim",
    opts = {
      spec = {
        { "<localleader>r", group = "Rust", icon = "🦀", mode = { "n", "v" } },
      },
    },
  },
}
