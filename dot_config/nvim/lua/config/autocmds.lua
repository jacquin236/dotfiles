-- Autocmds are automatically loaded on the VeryLazy event
-- Default autocmds that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/autocmds.lua
-- Add any additional autocmds here
local function augroup(name)
  return vim.api.nvim_create_augroup("lazyvim_" .. name, { clear = true })
end
local autocmd = vim.api.nvim_create_autocmd

-- Plain terminals
autocmd("TermOpen", {
  pattern = "term://*",
  command = [[setlocal listchars= nonumber norelativenumber | startinsert]],
})

-- show cursorline only in active window
autocmd({ "InsertLeave", "WinEnter" }, {
  callback = function()
    local ok, cl = pcall(vim.api.nvim_win_get_var, 0, "auto-cursorline")
    if ok and cl then
      vim.wo.cursorline = true
      vim.api.nvim_win_del_var(0, "auto-cursorline")
    end
  end,
})
autocmd({ "InsertEnter", "WinLeave" }, {
  callback = function()
    local cl = vim.wo.cursorline
    if cl then
      vim.api.nvim_win_set_var(0, "auto-cursorline", cl)
      vim.wo.cursorline = false
    end
  end,
})

-- Disable next line comments
autocmd("BufEnter", {
  callback = function()
    vim.cmd("set formatoptions-=cro")
    vim.cmd("setlocal formatoptions-=cro")
  end,
})

-- Highlight on yank (don't execute silently in case of errors)
autocmd("TextYankPost", {
  group = augroup("highlight_yank"),
  callback = function()
    vim.highlight.on_yank({ timeout = 500, on_visual = false, higroup = "Visual" })
  end,
})

------------------------------------------ Whitespace ----------------------------------------------
---Reference: https://github.com/akinsho/dotfiles/blob/main/.config/nvim/plugin/whitespace.lua

local is_floating_win = function()
  return vim.fn.win_gettype() == "popup"
end

local is_invalid_buf = function()
  return vim.bo.filetype == "" or vim.bo.buftype ~= "" or not vim.bo.modifiable
end

local toggle_trailing = function(mode)
  if is_invalid_buf() or is_floating_win() then
    vim.wo.list = false
  end
  if not vim.wo.list then
    vim.wo.list = true
  end
  local pattern = mode == "i" and [[\s\+\%#\@<!$]] or [[\s\+$]]
  if vim.w.whitespace_match_number then
    vim.fn.matchdelete(vim.w.whitespace_match_number)
    vim.fn.matchadd("ExtraWhitespace", pattern, 10, vim.w.whitespace_match_number)
  else
    vim.w.whitespace_match_number = vim.fn.matchadd("ExtraWhitespace", pattern)
  end
end

vim.api.nvim_set_hl(0, "ExtraWhitespace", { fg = "red" })

autocmd({ "BufEnter", "FileType", "InsertLeave" }, {
  group = augroup("whitespaces"),
  pattern = { "*" },
  desc = "Show extra whitespace on Insert Leave, Buf Enter or FileType",
  callback = function()
    toggle_trailing("n")
  end,
})

autocmd("InsertEnter", {
  group = augroup("whitespaces"),
  pattern = { "*" },
  desc = "Show extra whitespace on Insert Enter",
  callback = function()
    toggle_trailing("i")
  end,
})
