return {
    'akinsho/bufferline.nvim', 
    version = "*",
    dependencies = 'nvim-tree/nvim-web-devicons',
    keys = {
        { "<S-h>", "<cmd>BufferLineCyclePrev<cr>", desc = "Prev Buffer" },
        { "<S-l>", "<cmd>BufferLineCycleNext<cr>", desc = "Next Buffer" },
    },
    config = function()
        vim.opt.termguicolors = true
        require("bufferline").setup{
            options = {
                always_show_bufferline = true,
                offsets = {
                    {
                        filetype = "neo-tree",
                        text = "File Explorer",
                        highlight = "Directory",
                        separator = true,
                    },
                },
            },
        }
    end,
}
