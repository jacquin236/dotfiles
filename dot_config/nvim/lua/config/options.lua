-- Options are automatically loaded before lazy.nvim startup
-- Default options that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/options.lua
-- Add any additional options here

-- Set up variable environment
vim.g.project_dir = vim.fn.expand("$HOME") .. "/projects"

vim.g.lazyvim_picker = "telescope"

-- Disable builtin providers
vim.g.loaded_python3_provider = 0
vim.g.loaded_perl_provider = 0
vim.g.loaded_ruby_provider = 0
vim.g.loaded_node_provider = 0

-- Add binaries installed by mason.nvim to path
local is_windows = vim.fn.has("win32") ~= 0
local sep = is_windows and "\\" or "/"
local delim = is_windows and ";" or ":"
vim.env.PATH = table.concat({ vim.fn.stdpath("data"), "mason", "bin" }, sep) .. delim .. vim.env.PATH

-- Terminal settings for windows
if vim.fn.has("win32") == 1 then
  LazyVim.terminal.setup("pwsh")
end

-- Clipboard settings for WSL
local is_wsl = vim.fn.has("wsl") == 1
if is_wsl then
  vim.g.clipboard = {
    name = "WslClipboard",
    copy = {
      ["+"] = "clip.exe",
      ["*"] = "clip.exe",
    },
    paste = {
      ["+"] = 'pwsh.exe -c [Console]::Out.Write($(Get-Clipboard -Raw).toString().replace("`r", ""))',
      ["*"] = 'pwsh.exe -c [Console]::Out.Write($(Get-Clipboard -Raw).tostring().replace("`r", ""))',
    },
    cache_enabled = 0,
  }
else
  vim.g.clipboard = false
  vim.opt.clipboard = "unnamedplus"
end

-- Popup view
vim.opt.pumblend = 0
vim.opt.pumheight = 10

-- Number
vim.opt.number = true
vim.opt.relativenumber = false
vim.opt.ruler = false
vim.opt.numberwidth = 3

-- Mouse
vim.opt.mouse = "a"
vim.opt.mousefocus = true
vim.opt.mousemoveevent = true
vim.opt.mousescroll = "ver:1,hor:6"
vim.opt.smoothscroll = true

-- Backup, undo and swap file options
vim.opt.backup = false
vim.opt.undofile = true
vim.opt.undodir = vim.fn.stdpath("cache") .. "/undo"
vim.opt.undolevels = 10000
vim.opt.swapfile = false

vim.opt.backspace = { "start", "eol", "indent" }
vim.opt.path:append("**")
vim.opt.list = true
vim.opt.listchars = "nbsp:⦸,tab:▷┅,extends:»,precedes:«,trail:•"
