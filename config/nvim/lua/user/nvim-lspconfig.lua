local M = {
    -- LSP Configuration & Plugins
    'neovim/nvim-lspconfig',
    dependencies = {
      -- Automatically install LSPs to stdpath for neovim
      { 'williamboman/mason.nvim', config = true },
      'williamboman/mason-lspconfig.nvim',

      -- Useful status updates for LSP
      -- NOTE: `opts = {}` is the same as calling `require('fidget').setup({})`
      { 'j-hui/fidget.nvim', opts = {} },

      -- Additional lua configuration, makes nvim stuff amazing!
      'folke/neodev.nvim',
    },
}

local keymap = vim.keymap.set
local lsp = vim.lsp
local opts = { silent = true }
local function opt(desc, others) return vim.tbl_extend("force", opts, { desc = desc }, others or {}) end

-- keymap("n", "<Leader>lF", lsp.buf.format, opt("Toggle AutoFormat")) // Broken, figure out formatting some other time
keymap("n", "<Leader>la", lsp.buf.code_action, opt("Code Action"))
keymap("n", "<Leader>r", lsp.buf.rename, opt("Rename"))
keymap("n", "gd", lsp.buf.definition, opt("Go to definition"))
keymap("n", "gD", lsp.buf.declaration, opt("Go to declaration"))
keymap("n", "gi", function() lsp.buf.implementation({ border = "single" })  end, opt("Go to implementation"))
keymap("n", "K", vim.diagnostic.open_float, opt("Open diagnostic in float"))

keymap("n", "<Leader>dq", vim.diagnostic.setloclist, opt("Set LocList"))
keymap("n", "<Leader>dv", function() vim.diagnostic.config({ virtual_lines = not vim.diagnostic.config().virtual_lines }) end, opt("Toggle diagnostic virtual_lines"))

keymap("v", "<C-j>", ":m '>+1<CR>gv=gv", opt("Move selection down"))
keymap("v", "<C-k>", ":m '<-2<CR>gv=gv", opt("Move selection up"))

keymap("i", "<C-s>", "<Esc>", opt("Exit to normal mode"))
keymap("v", "<C-s>", "<Esc>", opt("Exit to normal mode"))

return M
