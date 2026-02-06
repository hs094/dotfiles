return {
    "nvim-treesitter/nvim-treesitter",
    build = ":TSUpdate",
    event = { "BufReadPost", "BufNewFile" },
    config = function()
      require("nvim-treesitter.config").setup {
        ensure_installed = { "cpp", "javascript", "python", "java", "lua", "markdown", "css", "html", "latex", "scss", "svelte", "tsx", "typst", "vue"},
        sync_install = false,
        auto_install = true,
        ignore_install = {},
        highlight = {
          enable = true,
          additional_vim_regex_highlighting = false,
        },
        indent = true
      }
    end,
}
