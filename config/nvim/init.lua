require('config')
vim.cmd[[colorscheme tokyonight-night]]

-- Normal line numbers
vim.api.nvim_set_hl(0, "LineNr", { fg = "#9ece6a" })

-- [[ Basic Keymaps ]]

-- Keymaps for better default experience
-- See `:help vim.keymap.set()`
vim.keymap.set({ 'n', 'v' }, '<Space>', '<Nop>', { silent = true })

-- for easier searching
vim.keymap.set({ 'n' }, '<C-d>', '?', { noremap = true })
vim.keymap.set({ 'n' }, '<C-f>', '/', { noremap = true })

-- map esc for easier access
vim.keymap.set({ 'i', 'v' }, '<C-j>', '<Esc>', { noremap = true })
vim.keymap.set({ 'i', 'v' }, '<C-k>', '<Esc>', { noremap = true })

-- Remap for dealing with word wrap
vim.keymap.set('n', 'k', "v:count == 0 ? 'gk' : 'k'", { expr = true, silent = true })
vim.keymap.set('n', 'j', "v:count == 0 ? 'gj' : 'j'", { expr = true, silent = true })

-- [[ Highlight on yank ]]
-- See `:help vim.highlight.on_yank()`
local highlight_group = vim.api.nvim_create_augroup('YankHighlight', { clear = true })
vim.api.nvim_create_autocmd('TextYankPost', {
  callback = function()
    vim.highlight.on_yank()
  end,
  group = highlight_group,
  pattern = '*',
})

-- Setup neovim lua configuration
require('neodev').setup()

-- nvim-cmp supports additional completion capabilities, so broadcast that to servers
local capabilities = vim.lsp.protocol.make_client_capabilities()
capabilities = require('cmp_nvim_lsp').default_capabilities(capabilities)

require("nvim-tree").setup()

require("lsp_signature").setup()
