local icons = require("util.icons")

local formatter_status = function()
  local conform_ok, conform = pcall(require, "conform")
  if not conform_ok then
    return "Conform is not installed."
  end
  local lsp_format = require("conform.lsp_format")
  local formatters = conform.list_formatters_for_buffer()
  if formatters and #formatters > 0 then
    local formatter_names = {}
    for _, formatter in ipairs(formatters) do
      table.insert(formatter_names, formatter)
    end
    return " " .. table.concat(formatter_names, " ")
  end

  local bufnr = vim.api.nvim_get_current_buf()
  local lsp_clients = lsp_format.get_format_clients({ bufnr = bufnr })
  if not vim.tbl_isempty(lsp_clients) then
    return "  LSP Formatter"
  end
  return ""
end

local lsp_status = function()
  local buf_ft = vim.api.nvim_get_option_value("filetype", { scope = "local" })
  local lsp_clients = vim.lsp.get_clients()
  local lsp_lists = {}
  local available_servers = {}
  if next(lsp_clients) == nil then
    return icons.ui.LspInactive -- No server available
  end
  for _, client in ipairs(lsp_clients) do
    local filetypes = client.config.filetypes
    local client_name = client.name
    if filetypes and vim.fn.index(filetypes, buf_ft) ~= -1 then
      -- Avoid adding servers that already exists.
      if not lsp_lists[client_name] then
        lsp_lists[client_name] = true
        table.insert(available_servers, client_name)
      end
    end
  end
  return next(available_servers) == nil and icons.ui.LspInactive
    or string.format("%s [%s]", icons.ui.LspActive, table.concat(available_servers, ", "))
end

local linter_status = function()
  local linters = require("lint").linters_by_ft[vim.bo.filetype]
  if #linters == 0 then
    return ""
  end

  return "󰁨 "
end

local tabwidth = function()
  return icons.ui.Tab .. " " .. vim.api.nvim_get_option_value("tabstop", { scope = "local" })
end

local progress_bar = function()
  local current_line = vim.fn.line(".")
  local total_lines = vim.fn.line("$")
  local chars = { "__", "▁▁", "▂▂", "▃▃", "▄▄", "▅▅", "▆▆", "▇▇", "██" }
  local line_ratio = current_line / total_lines
  local index = math.ceil(line_ratio * #chars)
  return chars[index]
end

local python_venv = function()
  local venv = os.getenv("CONDA_DEFAULT_ENV") or os.getenv("VIRTUAL_ENV") or "No Env"
  return " " .. venv
end

local noice_search = function()
  return require("noice").api.status.search.get()
end

local yaml_schema = function()
  local schema = require("yaml-companion").get_buf_schema()
  if schema.result[1].name == "none" then
    return ""
  end
  return schema.result[1].name
end

return {
  formatter_status = formatter_status,
  lsp_status = lsp_status,
  linter_status = linter_status,
  tabwidth = tabwidth,
  progress_bar = progress_bar,
  python_venv = python_venv,
  noice_search = noice_search,
  yaml_schema = yaml_schema,
}
