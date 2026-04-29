return {
  {
    "windwp/nvim-autopairs",
    event = "InsertEnter",
    config = function()
      require("nvim-autopairs").setup({})
    end,
  },
  {
    "j-hui/fidget.nvim",
    event = "LspAttach",
    opts = {},
  },
  {
    "christoomey/vim-tmux-navigator",
    keys = {
      { "<C-h>",  "<cmd><C-U>TmuxNavigateLeft<cr>",     desc = "Navigate left (tmux/vim)" },
      { "<C-j>",  "<cmd><C-U>TmuxNavigateDown<cr>",     desc = "Navigate down (tmux/vim)" },
      { "<C-k>",  "<cmd><C-U>TmuxNavigateUp<cr>",       desc = "Navigate up (tmux/vim)" },
      { "<C-l>",  "<cmd><C-U>TmuxNavigateRight<cr>",    desc = "Navigate right (tmux/vim)" },
      { "<C-\\>", "<cmd><C-U>TmuxNavigatePrevious<cr>", desc = "Navigate to previous (tmux/vim)" },
    },
    cmd = {
      "TmuxNavigateLeft",
      "TmuxNavigateDown",
      "TmuxNavigateUp",
      "TmuxNavigateRight",
      "TmuxNavigatePrevious",
    },
  },
  {
    "vimpostor/vim-tpipeline",
    event = "VeryLazy",
  },
  {
    'MeanderingProgrammer/render-markdown.nvim',
    ft = { "markdown" },
    dependencies = { 'nvim-treesitter/nvim-treesitter', 'nvim-mini/mini.nvim' },
    ---@module 'render-markdown'
    ---@type render.md.UserConfig
    opts = {},
  },
}
