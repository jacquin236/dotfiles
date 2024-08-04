local dap_core_keymaps = function()
  ---@param config {args?:string[]|fun():string[]?}
  local function get_args(config)
    local args = type(config.args) == "function" and (config.args() or {}) or config.args or {}
    config = vim.deepcopy(config)
    ---@cast args string[]
    config.args = function()
      local new_args = vim.fn.input("Run with args: ", table.concat(args, " ")) --[[@as string]]
      return vim.split(vim.fn.expand(new_args) --[[@as string]], " ")
    end
    return config
  end

  local dap = require("dap")
  local widgets = require("dap.ui.widgets")
  --  stylua: ignore
  return {
    { "<leader>dbc", function() dap.set_breakpoint(vim.fn.input("Breakpoint Condition: ")) end, desc = "Breakpoint Condition" },
    { "<leader>dbt", function() dap.toggle_breakpoint() end, desc = "Toggle Breakpoint" },
    { "<leader>dbl", function() dap.list_breakpoints(true) end, desc = "List Breakpoints" },
    { "<leader>dbL", function() dap.set_breakpoint(nil, nil, vim.fn.input("Log Point Message: ")) end, desc = "Log Point Message" },

    { "<leader>dwh", mode = { "n", "v" } , function() widgets.hover() end, desc = "Widgets: Hover" },
    { "<leader>dwp", mode = { "n", "v" } , function() widgets.preview() end, desc = "Widgets: Preview" },
    { "<leader>dws", function() widgets.centered_float(widgets.scopes) end, desc = "Widgets: Scopes" },
    { "<leader>dwf", function() widgets.centered_float(widgets.frames) end, desc = "Widgets: Frames" },
    { "<leader>dwt", function() widgets.centered_float(widgets.threads) end, desc = "Widgets: Threads" },
    { "<leader>dwS", function() widgets.sidebar(widgets.scopes) end, desc = "Widgets: Sidebar Scopes" },
    { "<leader>dwF", function() widgets.sidebar(widgets.frames) end, desc = "Widgets: Sidebar Frames" },
    { "<leader>dwT", function() widgets.sidebar(widgets.threads) end, desc = "Widgets: Sidebar Threads" },

    { "<leader>drt", function() dap.repl.toggle({ }) end, desc = "Repl: Toggle" },
    { "<leader>dro", function() dap.repl.open() end, desc = "Repl: Open" },
    { "<leader>drc", function() dap.repl.close() end, desc = "Repl: Close" },

    { "<leader>da", function() dap.continue({ before = get_args }) end, desc = "Run with Args" },
    { "<leader>dA", function() dap.continue({ new = true }) end, desc = "Run New Dap" },
    { "<leader>dc", function() dap.continue() end, desc = "Continue" },
    { "<leader>dC", function() dap.run_to_cursor() end, desc = "Run to Cursor" },
    { "<leader>dF", function() dap.restart_frame() end, desc = "Restart Frame" },
    { "<leader>dg", function() dap.goto_() end, desc = "Go to Line (No Execute)" },
    { "<leader>di", function() dap.step_into() end, desc = "Step Into" },
    { "<leader>dj", function() dap.down() end, desc = "Down" },
    { "<leader>dk", function() dap.up() end, desc = "Up" },
    { "<leader>dl", function() dap.run_last() end, desc = "Run Last" },
    { "<leader>do", function() dap.step_out() end, desc = "Step Out" },
    { "<leader>dO", function() dap.step_over() end, desc = "Step Over" },
    { "<leader>dp", function() dap.pause() end, desc = "Pause" },
    { "<leader>ds", function() dap.session() end, desc = "Session" },
    { "<leader>dt", function() dap.terminate() end, desc = "Terminate" },

    { "<F3>", mode = { "n", "t" }, function() dap.terminate() end, desc = "Debug: Terminate" },
    { "<F5>", mode = { "n", "t" }, function() dap.continue() end, desc = "Debug: Continue" },
  }
end

local dap_core_cmds = function()
  local widgets = require("dap.ui.widgets")
  local sidebar = widgets.sidebar(widgets.scopes)
  local create_cmd = vim.api.nvim_create_user_command

  create_cmd("DapSidebar", sidebar.toggle, { nargs = 0 })

  create_cmd("DapDiff", function(cmd_args)
    local fargs = cmd_args.fargs
    local max_level = nil
    if #fargs == 3 then
      max_level = tonumber(fargs[3])
    elseif #fargs ~= 2 then
      error("Two or three arguments required")
    end
    require("dap.ui.widgets").diff_var(fargs[1], fargs[2], max_level)
  end, { nargs = "+" })

  local sessions_bar = widgets.sidebar(widgets.sessions, {}, "5 sp")
  create_cmd("DapSessions", sessions_bar.toggle, { nargs = 0 })
end

return {
  dap_core_keymaps = dap_core_keymaps,
  dap_core_cmds = dap_core_cmds,
}
