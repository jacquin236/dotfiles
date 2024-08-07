-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here
local map = vim.keymap.set
local map_del = vim.keymap.del

------------------------------------------ LazyVim ------------------------------------------
local lazy = require("lazy")
map_del("n", "<leader>l")
map_del("n", "<leader>L")

-- stylua: ignore start
map("n", "<leader>ll", "<cmd>Lazy<cr>", { desc = "Lazy" })
map("n", "<leader>lx", "<cmd>LazyExtras<cr>", { desc = "Lazy Extras" })
map("n", "<leader>lr", "<cmd>LazyRoot<cr>", { desc = "Lazy Root" })
map("n", "<leader>lL", function() LazyVim.news.changelog() end, { desc = "LazyVim ChangeLog" })
map("n", "<leader>ld", function() vim.fn.system({ "xdg-open", "https://lazyvim.org" }) end, { desc = "LazyVim Docs" })
map("n", "<leader>lR", function() vim.fn.system({ "xdg-open", "https://github.com/LazyVim/LazyVim" }) end,
  { desc = "LazyVim Repo" })
map("n", "<leader>lu", function() lazy.update() end, { desc = "Lazy Update" })
map("n", "<leader>lc", function() lazy.check() end, { desc = "Lazy Check" })
map("n", "<leader>ls", function() lazy.sync() end, { desc = "Lazy Sync" })
-- stylua: ignore end

------------------------------------------ Plugin Info ---------------------------------------
map("n", "<leader>if", "<cmd>LazyFormatInfo<cr>", { desc = "Format" })
map("n", "<leader>ic", "<cmd>ConformInfo<cr>", { desc = "Conform" })
map("n", "<leader>ir", "<cmd>LazyRoot<cr>", { desc = "Root", remap = true })

local linters = function()
  local linters_attached = require("lint").linters_by_ft[vim.bo.filetype]
  local buf_linters = {}

  if not linters_attached then
    LazyVim.warn("No linters attached!", { title = "Linter Info" })
  end
  for _, linter in pairs(linters_attached) do
    table.insert(buf_linters, linter)
  end

  local unique_client_names = table.concat(buf_linters, ", ")
  local linters = string.format("%s", unique_client_names)
  LazyVim.notify(linters, { title = "Linter Info" })
end
map("n", "<leader>iL", linters, { desc = "Lint" })

--------------------------------------------- Tab ---------------------------------------------
map("n", "]<tab>", "<cmd>tabnext<cr>", { desc = "Next Tab" })
map("n", "[<tab>", "<cmd>tabprevious<cr>", { desc = "Previous Tab" })
map("n", "<tab>", "<cmd>tabnext<cr>", { desc = "Next Tab" })
map("n", "<s-tab>", "<cmd>tabprevious<cr>", { desc = "Previous Tab" })
for i = 1, 5 do
  map("n", "<leader><tab>" .. i, "<cmd>tabn " .. i .. "<cr>", { desc = "Tab " .. i })
end
map("n", "<leader><tab><tab>", function()
  vim.ui.select(vim.api.nvim_list_tabpages(), {
    prompt = "Select Tab:",
    format_item = function(tabid)
      local wins = vim.api.nvim_tabpage_list_wins(tabid)
      local not_floating_win = function(winid)
        return vim.api.nvim_win_get_config(winid).relative == ""
      end
      wins = vim.tbl_filter(not_floating_win, wins)
      local bufs = {}
      for _, win in ipairs(wins) do
        local buf = vim.api.nvim_win_get_buf(win)
        local buftype = vim.api.nvim_get_option_value("buftype", { buf = buf })
        if buftype ~= "nofile" then
          local fname = vim.api.nvim_buf_get_name(buf)
          table.insert(bufs, vim.fn.fnamemodify(fname, ":t"))
        end
      end
      local tabnr = vim.api.nvim_tabpage_get_number(tabid)
      local cwd = string.format(" %8s: ", vim.fn.fnamemodify(vim.fn.getcwd(-1, tabnr), ":t"))
      local is_current = vim.api.nvim_tabpage_get_number(0) == tabnr and "✸" or " "
      return tabnr .. is_current .. cwd .. table.concat(bufs, ", ")
    end,
  }, function(tabid)
    if tabid ~= nil then
      vim.cmd(tabid .. "tabnext")
    end
  end)
end, { desc = "Select Tabs" })

-- Buffer
map("n", "<leader>bf", "<cmd>bfirst<cr>", { desc = "First Buffer" })
map("n", "<leader>ba", "<cmd>blast<cr>", { desc = "Last Buffer" })
map("n", "<leader>b<tab>", "<cmd>tabnew %<cr>", { desc = "Current Buffer in New Tab" })

----------------------------------------- Windows --------------------------------------------
map("n", "<localleader>w", "", { desc = "Windows" })
map("n", "<localleader>wh", "<C-W>t <C-W>K", { desc = "Horizontal   Vertical Splits" })
map("n", "<localleader>wv", "<C-W>t <C-W>H", { desc = "Vertical   Horizontal Splits" })
map("n", "<c-w>f", "<C-W>vgf", { desc = "Open File in Vert Split" })
map("n", "<localleader>wd", "<C-W>c", { desc = "Delete Window", remap = true })
map("n", "<localleader>wq", "<cmd>bd!<cr>", { desc = "Close Current Buffer and Window" })

--------------------------------------------- LazyGit -----------------------------------------
map_del("n", "<leader>gg")
map_del("n", "<leader>gG")
map_del("n", "<leader>gb")
map_del("n", "<leader>gf")
map_del("n", "<leader>gL")

-- stylua: ignore start
map("n", "<leader>gl", "", { desc = "LazyGit" })
map("n", "<leader>glg", function() LazyVim.lazygit({ cwd = LazyVim.root.git() }) end, { desc = "Lazygit (Root Dir)" })
map("n", "<leader>glG", function() LazyVim.lazygit() end, { desc = "Lazygit (cwd)" })
map("n", "<leader>glb", LazyVim.lazygit.blame_line, { desc = "Git Blame Line" })
map("n", "<leader>glB", LazyVim.lazygit.browse, { desc = "Git Browse" })

map("n", "<leader>glf", function()
  local git_path = vim.api.nvim_buf_get_name(0)
  LazyVim.lazygit({ args = { "-f", vim.trim(git_path) } })
end, { desc = "Lazygit Current File History" })

map("n", "<leader>gll", function()
  LazyVim.lazygit({ args = { "log" }, cwd = LazyVim.root.git() })
end, { desc = "Lazygit Log" })

map("n", "<leader>glL", function()
  LazyVim.lazygit({ args = { "log" } })
end, { desc = "Lazygit Log (cwd)" })
-- stylua: ignore end

---------------------------------------------- Terminal ------------------------------------------
-- https://vi.stackexchange.com/questions/21260/how-to-clear-neovim-terminal-buffer

local clear_term = function(reset)
  vim.opt_local.scrollback = 1

  vim.api.nvim_command("startinsert")
  if reset == 1 then
    vim.api.nvim_feedkeys("reset", "t", false)
  else
    vim.api.nvim_feedkeys("clear", "t", false)
  end
  vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("<cr>", true, false, true), "t", true)
  vim.opt_local.scrollback = 10000
end
-- stylua: ignore start
map("t", "<C-l>", function() clear_term(0) end, { desc = "Clear Terminal", silent = true })
map("t", "<C-l><C-l>", function() clear_term(1) end, { desc = "Clear Terminal", silent = true })
-- stylua: ignore end

------------------------------------------- Editor -----------------------------------------------
-- Save without formatting
map("n", "<a-s>", "<cmd>noautocmd w<cr>", { desc = "Save Without Formatting" })
-- Spelling
map("n", "<leader>!", "zg", { desc = "Add Word to Dictionary" })
map("n", "<leader>@", "zug", { desc = "Remove Word from Dictionary" })
-- Select
map({ "n", "x" }, "<C-a>", "gg<S-V>G", { desc = "Select All Text", silent = true, noremap = true })
-- Copy
map({ "n", "x" }, "<C-c>", ":%y+<cr>", { desc = "Copy Whole Text to Clipboard", silent = true })
-- Paste
map("i", "<C-v>", '<C-r>"', { desc = "Paste on Insert Mode", silent = true })

--------------------------------------------- Tab ---------------------------------------------
map("n", "]<tab>", "<cmd>tabnext<cr>", { desc = "Next Tab" })
map("n", "[<tab>", "<cmd>tabprevious<cr>", { desc = "Previous Tab" })
map("n", "<tab>", "<cmd>tabnext<cr>", { desc = "Next Tab" })
map("n", "<s-tab>", "<cmd>tabprevious<cr>", { desc = "Previous Tab" })
for i = 1, 9 do
  map("n", "<leader><tab>" .. i, "<cmd>tabn " .. i .. "<cr>", { desc = "Tab " .. i })
end
map("n", "<leader><tab><tab>", function()
  vim.ui.select(vim.api.nvim_list_tabpages(), {
    prompt = "Select Tab:",
    format_item = function(tabid)
      local wins = vim.api.nvim_tabpage_list_wins(tabid)
      local not_floating_win = function(winid)
        return vim.api.nvim_win_get_config(winid).relative == ""
      end
      wins = vim.tbl_filter(not_floating_win, wins)
      local bufs = {}
      for _, win in ipairs(wins) do
        local buf = vim.api.nvim_win_get_buf(win)
        local buftype = vim.api.nvim_get_option_value("buftype", { buf = buf })
        if buftype ~= "nofile" then
          local fname = vim.api.nvim_buf_get_name(buf)
          table.insert(bufs, vim.fn.fnamemodify(fname, ":t"))
        end
      end
      local tabnr = vim.api.nvim_tabpage_get_number(tabid)
      local cwd = string.format(" %8s: ", vim.fn.fnamemodify(vim.fn.getcwd(-1, tabnr), ":t"))
      local is_current = vim.api.nvim_tabpage_get_number(0) == tabnr and "✸" or " "
      return tabnr .. is_current .. cwd .. table.concat(bufs, ", ")
    end,
  }, function(tabid)
    if tabid ~= nil then
      vim.cmd(tabid .. "tabnext")
    end
  end)
end, { desc = "Select Tabs" })

--------------------------------------------- Buffer --------------------------------------------
-- Buffers
map("n", "<leader>bf", "<cmd>bfirst<cr>", { desc = "First Buffer" })
map("n", "<leader>ba", "<cmd>blast<cr>", { desc = "Last Buffer" })
map("n", "<leader>b<tab>", "<cmd>tabnew %<cr>", { desc = "Current Buffer in New Tab" })

----------------------------------------- Windows ------------------------------------------------
map("n", "<localleader>w", "", { desc = "Windows" })
map("n", "<localleader>wh", "<C-W>t <C-W>K", { desc = "Horizontal   Vertical Splits" })
map("n", "<localleader>wv", "<C-W>t <C-W>H", { desc = "Vertical   Horizontal Splits" })
map("n", "<c-w>f", "<C-W>vgf", { desc = "Open File in Vert Split" })
map("n", "<localleader>wd", "<C-W>c", { desc = "Delete Window", remap = true })
map("n", "<localleader>wq", "<cmd>bd!<cr>", { desc = "Close Current Buffer and Window" })
