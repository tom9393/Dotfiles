M = {}

M.harpoon = {
  {
    "<leader>a",
    function() harpoon:list():append() end
  },
  {
    "<leader>e",
    function() harpoon:ui():toggle_quick_menu(harpoon:list()) end
  },
  {
    "<leader>1",
    function() harpoon:list():select(1) end
  },
  {
    "<leader>2",
    function() harpoon:list():select(2) end
  },
  {
    "<leader>3",
    function() harpoon:list():select(3) end
  },
  {
    "<leader>4",
    function() harpoon:list():select(4) end
  }
}

return M
