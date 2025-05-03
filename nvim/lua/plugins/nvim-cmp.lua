return {
  {
    "hrsh7th/nvim-cmp",
    event="InsertEnter",
    dependencies = {
      'hrsh7th/cmp-buffer', -- source for text in buffer
      'hrsh7th/cmp-path', -- source for file system paths
      'L3MON4D3/LuaSnip',
      'saadparwaiz1/cmp_luasnip',
      'rafamadriz/friendly-snippets',
    },
    config = function()
      local cmp = require('cmp')
      local luasnip = require('luasnip')

      -- loads vs code style snippets from installed plugins (e.g. friendly snippets)
      require("luasnip.loaders.from_vscode").lazy_load()

      cmp.setup({
        completion = {
          completeopt = "menu,menuone,preview,noselect",
        },
        snippet = {
          expand = function(args)
            luasnip.lsp_expand(args.body)
          end,
        },
        mapping = cmp.mapping.preset.insert({
          ['<C-k'] = cmp.mapping.select_prev_item(), -- previous suggestion
          ['<C-j'] = cmp.mapping.select_next_item(), -- next suggestion
          ["<C-b>"] = cmp.mapping.scroll_docs(-4),
          ["<C-f>"] = cmp.mapping.scroll_docs(4),
          ["<C-Space>"] = cmp.mapping.complete(), -- show complete suggestion
          ["<C-e>"] = cmp.mapping.abort(), -- close complete window
          ["<CR>"] = cmp.mapping.confirm({ select = true }),
        }),
        -- sources for autocompletion
        sources = cmp.config.sources({
          { name = "luasnip" }, -- For luasnip users.
          { name = "buffer" }, -- text within current buffer
          { name = "path" } -- file system paths
        })
      })
    end,
  },
}
