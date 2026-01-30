vim.g.mapleader = " "

local keymap = vim.keymap.set

-- File explorer
keymap("n", "<leader>e", ":Neotree toggle<CR>")

-- Save / Quit
keymap("n", "<leader>w", ":w<CR>")
keymap("n", "<leader>q", ":q<CR>")

-- Better window navigation
keymap("n", "<C-h>", "<C-w>h")
keymap("n", "<C-l>", "<C-w>l")
keymap("n", "<C-j>", "<C-w>j")
keymap("n", "<C-k>", "<C-w>k")

-- Clear search
keymap("n", "<leader>nh", ":nohl<CR>")
