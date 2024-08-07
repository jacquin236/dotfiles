local icons = require("util.icons")
local cmp = require("cmp")

local formatting = {
  expandable_indicator = true,
  fields = { "abbr", "kind", "menu" },
  format = function(entry, vim_item)
    local lspkind_ok, lspkind = pcall(require, "lspkind")
    if not lspkind_ok then
      local lsp_icons = vim.tbl_deep_extend("force", icons.kind, icons.type, icons.cmp)
      vim_item.kind = string.format("%s %s", lsp_icons[vim_item.kind] or icons.cmp.undefined, vim_item.kind or "")
      vim_item.menu = setmetatable({
        buffer = "(Buffer)",
        codeium = "(Codeium)",
        copilot = "(Copilot)",
        orgmode = "(Org)",
        neorg = "(Neorg)",
        luasnip = "(Snippet)",
        snippets = "(Snippet)",
        git = "(Git)",
        async_path = "(Path)",
        emoji = "(Emoji)",
        nvim_lsp = "(Lsp)",
        nvim_lua = "(Lua)",
        spell = "(Spell)",
        treesitter = "(Treesitter)",
        dictionary = "(Dict)",
        calc = "(Calc)",
      }, {
        __index = function()
          return "(Builtin)"
        end,
      })[entry.source.name]

      local label = vim_item.abbr
      local truncated_label = vim.fn.strcharpart(label, 0, 80)
      if truncated_label ~= label then
        vim_item.abbr = truncated_label .. icons.ui.Ellipsis
      end

      return vim_item
    else
      local kind = lspkind.cmp_format({ mode = "symbol_text", maxwidth = 50 })(entry, vim_item)
      local strings = vim.split(kind.kind, "%s", { trimempty = true })
      kind.kind = " " .. (strings[1] or "") .. " "
      kind.menu = " (" .. (strings[2] or "") .. ")"
      return kind
    end
  end,
}

local performance = {
  async_budget = 1,
  max_view_entries = 120,
  debounce = 20,
  throttle = 20,
  fetching_timeout = 20,
  confirm_resolve_timeout = 20,
}

local window = {
  completion = cmp.config.window.bordered({
    border = border,
    col_offset = -3,
    side_padding = 1,
    scrollbar = false,
  }),
  documentation = cmp.config.window.bordered({
    border = border,
  }),
}

local sources = {
  { name = "lazydev", group_index = 0 },
  { name = "nvim_lsp" },
  { name = "nvim_lsp_signature_help" },
  { name = "async_path" },
  { name = "snippets" },
  { name = "nvim_lua" },
  { name = "treesitter" },
  {
    name = "buffer",
    option = {
      keyword_length = 3,
      get_bufnrs = function() -- from all buffers (less than 1MB)
        local bufs = {}
        for _, bufn in ipairs(vim.api.nvim_list_bufs()) do
          local buf_size = vim.api.nvim_buf_get_offset(bufn, vim.api.nvim_buf_line_count(bufn))
          if buf_size < 10 * 1024 then
            table.insert(bufs, bufn)
          end
        end
        return bufs
      end,
    },
  },
  { name = "calc" },
}

local dictionary_find = function()
  local dict_sources = {}
  local default = "/usr/share/dict/words"
  if vim.uv.fs_stat(default) then
    table.insert(dict_sources, default)
  end
  for filepath in vim.fn.glob(vim.fn.stdpath("config") .. "/spell/*.add"):gmatch("[^\n]+") do
    table.insert(dict_sources, filepath)
  end
  return dict_sources
end

local compare = require("cmp.config.compare")
local types = require("cmp.types")
---@type table<integer, integer>
local modified_priority = {
  [types.lsp.CompletionItemKind.Variable] = types.lsp.CompletionItemKind.Method,
  [types.lsp.CompletionItemKind.Snippet] = 0, -- top
  [types.lsp.CompletionItemKind.Keyword] = 0, -- top
  [types.lsp.CompletionItemKind.Text] = 100, -- bottom
}
---@param kind integer: kind of completion entry
local function modified_kind(kind)
  return modified_priority[kind] or kind
end

local sorting = {
  -- https://github.com/hrsh7th/nvim-cmp/blob/main/lua/cmp/config/compare.lua
  comparators = {
    compare.offset,
    compare.exact,
    compare.recently_used, ---@diagnostic disable-line
    function(entry1, entry2) -- sort by compare kind (Variable, Function etc)
      local kind1 = modified_kind(entry1:get_kind())
      local kind2 = modified_kind(entry2:get_kind())
      if kind1 ~= kind2 then
        return kind1 - kind2 < 0
      end
    end,
    function(entry1, entry2) -- sort by length ignoring "=~"
      local len1 = string.len(string.gsub(entry1.completion_item.label, "[=~()_]", ""))
      local len2 = string.len(string.gsub(entry2.completion_item.label, "[=~()_]", ""))
      if len1 ~= len2 then
        return len1 - len2 < 0
      end
    end,
    function(entry1, entry2) -- score by lsp, if available
      local t1 = entry1.completion_item.sortText
      local t2 = entry2.completion_item.sortText
      if t1 ~= nil and t2 ~= nil and t1 ~= t2 then
        return t1 < t2
      end
    end,
    compare.score,
    compare.order,
  },
  priority_weight = 2,
}

return {
  formatting = formatting,
  performance = performance,
  window = window,
  sources = sources,
  dictionary_find = dictionary_find,
  sorting = sorting,
}
