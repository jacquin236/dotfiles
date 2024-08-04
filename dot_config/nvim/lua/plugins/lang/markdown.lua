LazyVim.on_very_lazy(function()
  vim.filetype.add({
    extension = { mdx = "markdown.mdx" },
  })
  -- Fix conceallevel for markdown files
  vim.api.nvim_create_autocmd({ "FileType" }, {
    group = vim.api.nvim_create_augroup("markdown_conceal", { clear = true }),
    pattern = { "markdown" },
    callback = function()
      vim.opt_local.conceallevel = 2
    end,
  })
end)

return {
  {
    "MeanderingProgrammer/markdown.nvim",
    opts = {
      file_types = { "markdown", "norg", "rmd", "org" },
      code = {
        sign = false,
        width = "block",
        right_pad = 1,
      },
      heading = {
        sign = false,
        icons = {},
      },
    },
    ft = { "markdown", "norg", "rmd", "org" },
    config = function(_, opts)
      require("render-markdown").setup(opts)
      LazyVim.toggle.map("<leader>um", {
        name = "Render Markdown",
        get = function()
          return require("render-markdown.state").enabled
        end,
        set = function(enabled)
          local m = require("render-markdown")
          if enabled then
            m.enable()
          else
            m.disable()
          end
        end,
      })
    end,
  },
  {
    "OXY2DEV/markview.nvim",
    dependencies = {
      "nvim-treesitter/nvim-treesitter",
      "nvim-tree/nvim-web-devicons",
    },
    ft = { "markdown", "norg", "rmd", "org" },
    cmd = { "Markview" },
    opts = {
      checkboxes = { enable = false },
      links = {
        inline_links = {
          hl = "@markup.link.label.markown_inline",
          icon = " ",
          icon_hl = "@markup.link",
        },
        images = {
          hl = "@markup.link.label.markown_inline",
          icon = " ",
          icon_hl = "@markup.link",
        },
      },
      code_blocks = {
        style = "language",
        hl = "CodeBlock",
        pad_amount = 0,
      },
      list_items = {
        shift_width = 2,
        marker_minus = { text = "󰍴", hl = "@markup.list.markdown" },
        marker_plus = { text = "", hl = "@markup.list.markdown" },
        marker_star = { text = "󰓎", hl = "@markup.list.markdown" },
        marker_dot = {},
      },
      inline_codes = { enable = false },
      headings = {
        heading_1 = { style = "simple", hl = "Headline1" },
        heading_2 = { style = "simple", hl = "Headline2" },
        heading_3 = { style = "simple", hl = "Headline3" },
        heading_4 = { style = "simple", hl = "Headline4" },
        heading_5 = { style = "simple", hl = "Headline5" },
        heading_6 = { style = "simple", hl = "Headline6" },
      },
    },
  },
  {
    "wallpants/github-preview.nvim",
    cmd = {
      "GithubPreviewToggle",
      "GithubPreviewStart",
    },
    keys = { "<leader>mg", "<cmd>GithubPreviewToggle<cr>", desc = "Github Preview", silent = true },
    opts = {
      cursor_line = { disable = true },
    },
  },
  {
    "iamcco/markdown-preview.nvim",
    cmd = { "MarkdownPreviewToggle", "MarkdownPreview", "MarkdownPreviewStop" },
    ft = { "markdown" },
    build = function()
      require("lazy").load({ plugins = { "markdown-preview.nvim" } })
      vim.fn["mkdp#util#install"]()
    end,
    keys = { "<leader>mp", "<cmd>MarkdownPreviewToggle<cr>", ft = "markdown", desc = "Markdown Preview" },
    config = function()
      vim.cmd([[do FileType]])
    end,
  },
  {
    "folke/which-key.nvim",
    opts = {
      spec = {
        { "<leader>m", group = "markdown", icon = " " },
      },
    },
  },
  {
    "williamboman/mason.nvim",
    opts = { ensure_installed = { "markdownlint-cli2", "markdown-toc" } },
  },
  {
    "stevearc/conform.nvim",
    optional = true,
    opts = function(_, opts)
      opts.formatters = {
        ["markdown-toc"] = {
          condition = function(_, ctx)
            for _, line in ipairs(vim.api.nvim_buf_get_lines(ctx.buf, 0, -1, false)) do
              if line:find("<!%-%- toc %-%->") then
                return true
              end
            end
          end,
        },
        ["markdownlint-cli2"] = {
          condition = function(_, ctx)
            local diag = vim.tbl_filter(function(d)
              return d.source == "markdownlint"
            end, vim.diagnostic.get(ctx.buf))
            return #diag > 0
          end,
        },
      }
      opts.formatters_by_ft = {
        ["markdown"] = { "prettier", "markdownlint-cli2", "markdown-toc" },
        ["markdown.mdx"] = { "prettier", "markdownlint-cli2", "markdown-toc" },
      }
    end,
  },
  {
    "mfussenegger/nvim-lint",
    optional = true,
    opts = {
      linters_by_ft = {
        markdown = { "markdownlint-cli2" },
      },
    },
  },
  {
    "neovim/nvim-lspconfig",
    opts = {
      servers = {
        marksman = {},
      },
    },
  },
}
