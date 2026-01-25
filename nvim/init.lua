-- Basic vim settings
vim.opt.expandtab = true
vim.opt.tabstop = 2
vim.opt.softtabstop = 2
vim.opt.shiftwidth = 2
vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.termguicolors = true                     -- Enable true colors
vim.opt.cursorline = true                        -- Highlight current line
vim.opt.wrap = false                             -- Disable line wrapping
vim.opt.scrolloff = 8                            -- Keep 8 lines above and below the cursor
vim.opt.sidescrolloff = 8                        -- Keep 8 columns to the left and right of the cursor
vim.opt.ignorecase = true                        -- Case insensitive searching
vim.opt.smartcase = true                         -- Case sensitive if uppercase letters are used
vim.opt.updatetime = 300                         -- Faster completion
vim.opt.signcolumn = "yes"                       -- Always show sign column
vim.opt.clipboard = "unnamedplus"                -- Use system clipboard

-- Load keymaps
require('config.keymaps')

-- Load lazy.nvim configuration
require('config.lazy')

local function add_trigger(trigger, body)
  vim.keymap.set("i", "<C-e>", function()
    local col = vim.fn.col(".") - 1
    local line = vim.api.nvim_get_current_line()
    local before = string.sub(line, col - #trigger + 1, col)
    if before == trigger then
      -- delete trigger then expand snippet
      vim.api.nvim_set_current_line(
        string.sub(line, 1, col - #trigger) .. string.sub(line, col + 1)
      )
      vim.snippet.expand(body)
    end
  end, { buffer = true })
end

add_trigger("::cpp-template", [[
#include <bits/stdc++.h>
using namespace std;

int main() {
    ios::sync_with_stdio(false);
    cin.tie(nullptr);

    return 0;
}
]])

