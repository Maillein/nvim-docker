-- カーソルを表示行で移動する。物理行移動は<C-n>,<C-p>
vim.keymap.set('n', 'j', 'gj')
vim.keymap.set('n', 'k', 'gk')
vim.keymap.set('v', 'j', 'gj')
vim.keymap.set('v', 'k', 'gk')
vim.keymap.set('n', '<Down>', 'gj')
vim.keymap.set('n', '<Up>', 'gk')

-- leaderキーを変更
vim.cmd([[let mapleader = "\<space>"]])

-- Escでターミナルを抜ける
vim.keymap.set('t', '<Esc>', '<C-\\><C-n>')

-- set ESC+ESC Clear Search hilight
-- vim.keymap.set('n', '<ESC><ESC>', ':<C-u>set nohlsearch!<CR>')

--新規タブでターミナルを起動
vim.keymap.set('n', 'tt', ':tabe<CR>:terminal<CR>', { noremap = true, silent = true })
vim.keymap.set('n', 'tv', ':vs<CR>:terminal<CR>', { noremap = true, silent = true })

-- ターミナルを開いたら常にinsertモードに入る
vim.cmd([[autocmd TermOpen * :startinsert]])

-- ターミナルで行番号を非表示
-- vim.cmd([[autocmd TermOpen * setlocal norelativenumber]])
-- vim.cmd([[autocmd TermOpen * setlocal nonumber]])
