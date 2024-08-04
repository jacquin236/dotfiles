local vtsls_setup = function(_, opts)
  LazyVim.lsp.on_attach(function(client, buffer)
    client.commands["_typescript.moveToFileRefactoring"] = function(command, ctx)
      ---@type string, string, lsp.Range
      local action, uri, range = unpack(command.arguments)

      local function move(newf)
        client.request("workspace/executeCommand", {
          command = command.command,
          arguments = { action, uri, range, newf },
        })
      end

      local fname = vim.uri_to_fname(uri)
      client.request("workspace/executeCommand", {
        command = "typescript.tsserverRequest",
        arguments = {
          "getMoveToRefactoringFileSuggestions",
          {
            file = fname,
            startLine = range.start.line + 1,
            startOffset = range.start.character + 1,
            endLine = range["end"].line + 1,
            endOffset = range["end"].character + 1,
          },
        },
      }, function(_, result)
        ---@type string[]
        local files = result.body.files
        table.insert(files, 1, "Enter new path...")
        vim.ui.select(files, {
          prompt = "Select move destination:",
          format_item = function(f)
            return vim.fn.fnamemodify(f, ":~:.")
          end,
        }, function(f)
          if f and f:find("^Enter new path") then
            vim.ui.input({
              prompt = "Enter move destination:",
              default = vim.fn.fnamemodify(fname, ":h") .. "/",
              completion = "file",
            }, function(newf)
              return newf and move(newf)
            end)
          elseif f then
            move(f)
          end
        end)
      end)
    end
  end, "vtsls")
  -- copy typescript settings to javascript
  opts.settings.javascript = vim.tbl_deep_extend("force", {}, opts.settings.typescript, opts.settings.javascript or {})
end

local vtsls_keys = function()
  return {
    -- stylua: ignore start
    {
      "gD", function() 
        local params = vim.lsp.util.make_position_params()
        LazyVim.lsp.execute({
          command = "typescript.goToSourceDefinition",
          arguments = { params.textDocument.uri, params.position },
          open = true,
        })
      end, desc = "Goto Source Definition",
    },
    {
      "gR", function()
        LazyVim.lsp.execute({
          command = "typescript.findAllFileReferences",
          arguments = { vim.uri_from_bufnr(0) },
          open = true,
        })
      end, desc = "File References",
    },
    { "<leader>co", LazyVim.lsp.action["source.organizeImports"], desc = "Organize Imports" },
    { "<leader>cM", LazyVim.lsp.action["source.addMissingImports.ts"], desc = "Add missing imports" },
    { "<leader>cu", LazyVim.lsp.action["source.removeUnused.ts"], desc = "Remove unused imports" },
    { "<leader>cD", LazyVim.lsp.action["source.fixAll.ts"], desc = "Fix all diagnostics" },
    { 
      "<leader>cV", function() 
        LazyVim.lsp.execute({ command = "typescript.selectTypeScriptVersion" }) 
      end, desc = "Select TS workspace version" 
    },
    -- stylua: ignore end
  }
end

local ts_debugger = function()
  local dap = require("dap")
  local dap_vscode = require("dap-vscode-js")
  dap_vscode.setup({
    node_path = "node",
    debugger_path = vim.fn.stdpath("data") .. "/lazy/vscode-js-debug",
    debugger_cmd = { "js-debug-adapter" },
    adapters = { "node", "chrome", "pwa-node", "pwa-chrome", "pwa-extensionHost", "node-terminal" },
    log_file_path = vim.fn.stdpath("cache") .. "/dap_vscode_js.log",
    log_file_level = 10000,
    log_console_level = vim.log.levels.WARN,
  })

  local js_based_languages = { "typescript", "javascript", "typescriptreact", "javascriptreact" }
  for _, language in ipairs(js_based_languages) do
    dap.configurations[language] = {
      {
        type = "pwa-node",
        request = "launch",
        name = "Launch file",
        program = "${file}",
        cwd = "${workspaceFolder}",
      },
      {
        type = "pwa-node",
        request = "attach",
        name = "Attach process",
        processId = require("dap.utils").pick_process,
        cwd = "${workspaceFolder}",
      },
      {
        type = "pwa-chrome",
        request = "launch",
        name = "Start Chrome in localhost",
        url = "http://localhost:3000",
        webRoot = "${workspaceFolder}",
        userDataDir = "${workspaceFolder}/.vscode/vscode-chrome-debug-userdatadir",
      },
      {
        type = "pwa-node",
        request = "launch",
        name = "Debug Jest Tests",
        -- trace = true, -- include debugger info
        runtimeExecutable = "node",
        runtimeArgs = {
          "./node_modules/jest/bin/jest.js",
          "--runInBand",
        },
        rootPath = "${workspaceFolder}",
        cwd = "${workspaceFolder}",
        console = "integratedTerminal",
        internalConsoleOptions = "neverOpen",
      },
      {
        type = "pwa-node",
        request = "launch",
        name = "Debug Mocha Tests",
        -- trace = true, -- include debugger info
        runtimeExecutable = "node",
        runtimeArgs = {
          "./node_modules/mocha/bin/mocha.js",
        },
        rootPath = "${workspaceFolder}",
        cwd = "${workspaceFolder}",
        console = "integratedTerminal",
        internalConsoleOptions = "neverOpen",
      },
    }
  end
end

return {
  vtsls_setup = vtsls_setup,
  vtsls_keys = vtsls_keys,
  ts_debugger = ts_debugger,
}
