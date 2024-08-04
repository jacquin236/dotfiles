local list_workspaces = function(dirs)
  local res = {}
  for _, w in ipairs(dirs) do
    res[w] = "~/Neorg/" .. w
  end
  return res
end

local goto_headline = function(which)
  local ts_utils = require("nvim-treesitter.ts_utils")
  local tsparser = vim.treeesitter.get_parser()
  local tstree = tsparser:parse()
  local root = tstree[1]:root()
  local cursor = vim.api.nvim_win_get_cursor(0)
  local cursor_range = { cursor[1] - 1, cursor[2] }

  -- Query all headings (from 1 to 6)
  local query = vim.treesitter.query.parse(
    "norg",
    [[
    (heading1) @h1 
    (heading2) @h2 
    (heading3) @h3 
    (heading4) @h4 
    (heading5) @h5 
    (heading6) @h6 
    ]]
  )
  local previous_headline = nil
  local next_headline = nil

  -- Find the previous and next heading from the captures
  ---@diagnostic disable-next-line
  for _, captures, metadata in query:iter_matches(root) do
    for _, node in pairs(captures) do
      local row = node:start()
      if row < cursor_range[1] then
        previous_headline = node
      elseif row > cursor_range[1] and next_headline == nil then
        next_headline = node
        break
      end
    end
  end

  if which == "previous" then
    ts_utils.goto_node(previous_headline)
  elseif which == "next" then
    ts_utils.goto_node(next_headline)
  end
end

local index_popup = function()
  local Popup = require("nui.popup")
  local autocmd = vim.api.nvim_create_autocmd
  local augroup = vim.api.nvim_create_augroup("NorgFile", { clear = true })
  local map = vim.keymap.set

  local popup = Popup({
    enter = true,
    focusable = true,
    border = { style = border },
    position = "50%",
    size = { width = "80%", height = "90%" },
    relative = "editor",
    win_options = { winhighlight = "Normal:Normal,FloatBorder:FloatBorder" },
  })

  autocmd("WinEnter", {
    group = augroup,
    pattern = "*.norg",
    callback = function()
      if vim.api.nvim_get_current_win() == popup.winid then
        map({ "n", "v", "i" }, "<C-q>", function()
          vim.cmd.write()
          popup:hide()
        end, { buffer = popup.bufnr, remap = false })
      end
    end,
  })
  autocmd("WinLeave", {
    group = augroup,
    callback = function(args)
      if vim.api.nvim_get_current_win() == popup.winid then
        bufnr = args.buf
        popup:hide()
      end
    end,
  })
  if bufnr and vim.api.nvim_buf_is_valid(bufnr) then
    popup.bufnr = bufnr
  end

  popup:mount()
  popup:show()
  if vim.bo[vim.api.nvim_win_get_buf(popup.winid)].filetype ~= "norg" then
    vim.cmd.edit("index.norg")
  end
end

local keybinds = function()
  local prefix = "<leader>n"
  local lprefix = "<localleader>n"

  -- stylua: ignore
  return {
    { "[L", function() goto_headline("previous") end, desc = "Previous Headline (norg)" },
    { "]L", function() goto_headline("next") end, desc = "Next Headline (norg)" },
    
    { prefix .. "o", "<cmd>Neorg<cr>", desc = "Options" },
    { prefix .. "q", "<cmd>Neorg return<cr>", desc = "Return" },
    { prefix .. "i", "<cmd>Neorg index<cr>", desc = "Open Index" },
    { prefix .. "I", index_popup, desc = "Open Index in Popup" },

    { prefix .. "n", "<Plug>(neorg.dirman.new-note)", desc = "New note" },
    { prefix .. "s", "<Plug>(neorg.telescope.search_headings)", desc = "Search Headings" },
    { prefix .. "S", "<Plug>(neorg.telescope.switch_workspace)", desc = "Switch Workspace" },
    { prefix .. "f", "<Plug>(neorg.telescope.find_linkable)", desc = "Find Linkable" },
    { prefix .. "F", "<Plug>(neorg.telescope.find_norg_files)", desc = "Find Files" },
    { prefix .. "b", "<Plug>(neorg.telescope.backlinks.file_backlinks)", desc = "File Backlinks" },
    { prefix .. "B", "<Plug>(neorg.telescope.backlinks.header_backlinks)", desc = "Header Backlinks" },

    { lprefix .. "n", "<Plug>(neorg.dirman.new-note)", desc = "New note", remap = true },
    { lprefix .. "m", "<Plug>(neorg.looking-glass.magnify-code-block)", desc = "Magnify code block" },
    { lprefix .. "d", "<Plug>(neorg.tempus.insert-date)", desc = "Insert date" },
    { lprefix .. "L", "<Plug>(neorg.pivot.list.invert)", desc = "Invert list" },
    { lprefix .. "l", "<Plug>(neorg.pivot.list.toggle)", desc = "Toggle list" },

    { lprefix .. "a", "<Plug>(neorg.qol.todo-items.todo.task-ambiguous)", desc = "Task Ambigous" },
    { lprefix .. "c", "<Plug>(neorg.qol.todo-items.todo.task-cancelled)", desc = "Task Cancelled" },
    { lprefix .. "d", "<Plug>(neorg.qol.todo-items.todo.task-done)", desc = "Task Done" },
    { lprefix .. "h", "<Plug>(neorg.qol.todo-items.todo.task-on-hold)", desc = "Task On Hold" },
    { lprefix .. "i", "<Plug>(neorg.qol.todo-items.todo.task-important)", desc = "Task Important" },
    { lprefix .. "p", "<Plug>(neorg.qol.todo-items.todo.task-pending)", desc = "Task Pending" },
    { lprefix .. "r", "<Plug>(neorg.qol.todo-items.todo.tesk-recurring)", desc = "Task Recurring" },
    { lprefix .. "u", "<Plug>(neorg.qol.todo-items.todo.task-undone)", desc = "Task Undone" },
  }
end

return {
  list_workspaces = list_workspaces,
  keybinds = keybinds,
}
