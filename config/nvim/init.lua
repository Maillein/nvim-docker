local vars = {
  python3_host_prog = "~/.nvim-python3/bin/python3",
  -- loaded_matchparen = 1, -- 1: 対応する括弧を強調表示しない
}

for var, val in pairs(vars) do
  vim.api.nvim_set_var(var, val)
end

require("core")
require("keymap")
require("color")
require("lazy_nvim")
