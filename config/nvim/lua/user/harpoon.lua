local M = {
    "ThePrimeagen/harpoon",
    branch = "harpoon2",
    dependencies = { "nvim-lua/plenary.nvim" },
    keys = require('config.keymaps').harpoon
}

function M.config()
    require('harpoon'):setup()
end

return M
