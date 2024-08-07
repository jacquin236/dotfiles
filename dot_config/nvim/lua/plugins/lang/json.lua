LazyVim.on_very_lazy(function()
  vim.filetype.add({
    filename = { ["launch.json"] = "jsonc" },
  })
end)

return {
  {
    "vuki656/package-info.nvim",
    dependencies = { "MunifTanjim/nui.nvim" },
    event = {
      "BufRead package.json",
      "BufRead package-lock.json",
    },
    keys = {
      -- stylua: ignore start
      { "<leader>pjv", function() require("package-info").show({ force = true }) end, desc = "Show Dependencies Versions" },
      { "<leader>pjV", function() require("package-info").hide() end,                 desc = "Hide Dependencies Versions" },
      { "<leader>pju", function() require("package-info").update() end,               desc = "Update Package" },
      { "<leader>pjr", function() require("package-info").delete() end,               desc = "Remove Package" },
      { "<leader>pjc", function() require("package-info").change_version() end,       desc = "Change Package Version" },
      { "<leader>pji", function() require("package-info").install() end,              desc = "Install New Dependency" },
      { "<leader>pjp", function() require("package-info").toggle() end,               desc = "Toggle Package-Info" },
      { "<leader>pjt", "<cmd>Telescope package_info<cr>",                             desc = "Package Info" },
      -- stylua: ignore end
    },
    config = function()
      LazyVim.on_load("telescope.nvim", function()
        require("telescope").setup({
          extensions = { package_info = { theme = "ivy" } },
        })
        require("telescope").load_extension("package_info")
      end)
    end,
  },
  {
    "folke/which-key.nvim",
    opts = {
      spec = {
        { "<leader>p", group = "packages/dependencies", icon = " ", mode = { "n", "v" } },
        { "<leader>pj", name = "js/ts: package.json", icon = "🧰" },
      },
    },
  },
  -- Quickfix with json entries (requires `jq` for json and `yq` for yaml)
  {
    "gennaro-tedesco/nvim-jqx",
    cmd = { "JqxList", "JqxQuery" },
    ft = { "json", "yaml" },
    event = { "BufReadPost" },
    init = function()
      local jqx = require("nvim-jqx.config")
      jqx.geometry.border = border
      jqx.geometry.width = 0.6
      jqx.use_quickfix = true
      jqx.sort = true
    end,
    config = function()
      local jqx = vim.api.nvim_create_augroup("Jqx", {})
      vim.api.nvim_clear_autocmds({ group = jqx })
      vim.api.nvim_create_autocmd("BufWinEnter", {
        pattern = { "*.json", "*.yaml" },
        desc = "Preview json and yaml files on open.",
        group = jqx,
        callback = function()
          vim.cmd.JqxList()
        end,
      })
    end,
  },
}
