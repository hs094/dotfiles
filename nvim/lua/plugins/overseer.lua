return {
  {
    "stevearc/overseer.nvim",
    opts = {
      templates = {
        "builtin",
      },
    },
    keys = {
      {
        "<leader>or",
        "<cmd>OverseerRun<cr>",
        desc = "Run task",
      },
      {
        "<leader>ot",
        "<cmd>OverseerToggle<cr>",
        desc = "Task list",
      },
    },
  },
}
