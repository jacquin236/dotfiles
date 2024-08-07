_G.border = require("util.icons").border.rounded

if vim.loader then
  vim.loader.enable()
end

-- bootstrap lazy.nvim, LazyVim and your plugins
require("config.lazy")

vim.cmd([[colorscheme tokyonight]])
