-- エンコーディング
vim.opt.encoding = "utf-8"

-- 行番号を表示
vim.opt.number = true

-- カーソル行を強調
vim.opt.cursorline = true

-- マーカー文字で折りたたむ
-- vim.opt.foldmethod = "marker"

vim.opt.hidden = true

-- treesitterを使用して折りたたむ
vim.opt.foldmethod = "expr"
vim.opt.foldexpr = "nvim_treesitter#foldexpr()"
vim.opt.foldenable = false

-- 長い行が折り返されないようにする
vim.opt.wrap = true

-- スプリットが右側に表示されるようにする
vim.opt.splitright = true

-- インデント
vim.opt.autoindent = true
vim.opt.tabstop = 2
vim.opt.shiftwidth = 2
vim.opt.expandtab = true

-- ※などが重なって表示されないようにする．
vim.opt.ambiwidth = "double"

-- 保存していないファイルを閉じようとしたときに確認する
vim.opt.confirm = true

-- クリップボード共有
vim.opt.clipboard:append('unnamedplus')
