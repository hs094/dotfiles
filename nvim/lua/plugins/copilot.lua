return {
  {
    "CopilotC-Nvim/CopilotChat.nvim",
    dependencies = {
      { "nvim-lua/plenary.nvim", branch = "master" },
    },
    build = "make tiktoken",
    opts = {
      model = 'gpt-4o',
      temperature = 0.1,
      window = {
        layout = 'vertical',
        width = 0.5,
      },
      auto_insert_mode = true,
      show_help = false,
      show_folds = true,
      highlight_selection = true,
      question_header = '  User ',
      answer_header = '烙  Copilot ',
      error_header = '  Error ',
      separator = '───',
    },
    keys = {
      { '<leader>ac', ':CopilotChatToggle<CR>', desc = 'Toggle Copilot Chat', mode = 'n' },
      { '<leader>ae', ':CopilotChatExplain<CR>', desc = 'Explain with Copilot', mode = 'v' },
      { '<leader>ar', ':CopilotChatReview<CR>', desc = 'Review with Copilot', mode = 'v' },
      { '<leader>af', ':CopilotChatFix<CR>', desc = 'Fix with Copilot', mode = 'v' },
    },
  },
}
