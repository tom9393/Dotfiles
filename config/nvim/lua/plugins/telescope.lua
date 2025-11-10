local M = {
    'nvim-telescope/telescope.nvim',
    branch = '0.1.x',
    dependencies = {
      'nvim-lua/plenary.nvim',
      -- Fuzzy Finder Algorithm which requires local dependencies to be built.
      -- Only load if `make` is available. Make sure you have the system
      -- requirements installed.
      {
        'nvim-telescope/telescope-fzf-native.nvim',
        -- NOTE: If you are having trouble with this installation,
        --       refer to the README for telescope-fzf-native for more instructions.
        build = 'make',
        cond = function()
          return vim.fn.executable 'make' == 1
        end,
      },
    },
}

local ignore_patterns = { "^node_modules/" }

M.config = function()
    require('telescope').setup {
    defaults = {
      file_ignore_patterns = ignore_patterns,
    mappings = {
      i = {
        ['<C-u>'] = false,
        ['<C-d>'] = false,
      },},},}

    require('telescope').load_extension('fzf')

    local function find_git_root()
      -- Use the current buffer's path as the starting point for the git search
      local current_file = vim.api.nvim_buf_get_name(0)
      local current_dir
      local cwd = vim.fn.getcwd()
      -- If the buffer is not associated with a file, return nil
      if current_file == '' then
        current_dir = cwd
      else
        -- Extract the directory from the current file's path
        current_dir = vim.fn.fnamemodify(current_file, ':h')
      end

      -- Find the Git root directory from the current file's path
      local git_root = vim.fn.systemlist('git -C ' .. vim.fn.escape(current_dir, ' ') .. ' rev-parse --show-toplevel')[1]
      if vim.v.shell_error ~= 0 then
        print 'Not a git repository. Searching on current working directory'
        return cwd
      end
      return git_root
    end

    local function live_grep_git_root()
        local git_root = find_git_root()
        if git_root then
            require('telescope.builtin').live_grep {
                search_dirs = { git_root },
            }
        end
    end

    local function telescope_live_grep_open_files()
      require('telescope.builtin').live_grep {
        grep_open_files = true,
        prompt_title = 'Live Grep in Open Files',
      }
    end

    local function telescope_search_current_buffer()
        require('telescope.builtin').current_buffer_fuzzy_find(require('telescope.themes').get_dropdown {
        winblend = 10,
        previewer = false,
        })
    end

vim.api.nvim_create_user_command('LiveGrepGitRoot', live_grep_git_root, {})
vim.api.nvim_create_user_command('LiveGrepOpenFiles', telescope_live_grep_open_files, {})
vim.api.nvim_create_user_command('LiveCurrentBuffer', telescope_search_current_buffer, {})

-- Files
vim.keymap.set('n', '<leader>sf', require('telescope.builtin').find_files, { desc = '[S]earch [F]iles' })
vim.keymap.set('n', '<leader>gf', require('telescope.builtin').git_files, { desc = 'Search [G]it [F]iles' })
vim.keymap.set('n', '<leader>?', require('telescope.builtin').oldfiles, { desc = '[?] Find recently opened files' })
vim.keymap.set('n', '<leader><space>', require('telescope.builtin').buffers, { desc = '[ ] Find existing buffers' })

-- Greps
vim.keymap.set('n', '<leader>sg', require('telescope.builtin').live_grep, { desc = '[S]earch by [G]rep' })
vim.keymap.set('n', '<leader>sG', ':LiveGrepGitRoot<cr>', { desc = '[S]earch by [G]rep on Git Root' })
vim.keymap.set('n', '<leader>s/', telescope_live_grep_open_files, { desc = '[S]earch [/] in Open Files' })
vim.keymap.set('n', '<leader>/', telescope_search_current_buffer, { desc = '[/] Fuzzily search in current buffer' })

-- Telescope stuff
vim.keymap.set('n', '<leader>ss', require('telescope.builtin').builtin, { desc = '[S]earch [S]elect Telescope' })
vim.keymap.set('n', '<leader>sh', require('telescope.builtin').help_tags, { desc = '[S]earch [H]elp' })

-- Other
vim.keymap.set("n", "<leader>sr", function()
  require('telescope.builtin').lsp_references({
    show_line = true,       -- preview line in picker
    include_declaration = true, -- include the symbol's declaration
    fname_width = 60,       -- optional: adjust filename width
    trim_text = true,       -- optional: remove extra whitespace
  })
end, { desc = "Telescope LSP References" })
vim.keymap.set('n', '<leader>sw', require('telescope.builtin').grep_string, { desc = '[S]earch current [W]ord' })
vim.keymap.set('n', '<leader>sd', require('telescope.builtin').diagnostics, { desc = '[S]earch [D]iagnostics' })

end

return M
