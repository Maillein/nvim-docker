-- True Colorが使えるようになるおまじない
vim.opt.termguicolors = true
vim.cmd [[autocmd ColorScheme * highlight LineNr guifg=Gray]]
vim.cmd [[autocmd ColorScheme * highlight CursorLineNr guifg=Orange]]
vim.cmd [[autocmd ColorScheme * highlight clear CursorLine]]
