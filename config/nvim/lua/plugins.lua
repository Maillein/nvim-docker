return {
  -- カラースキーム
  {
    "folke/tokyonight.nvim",
    lazy = false,    -- make sure we load this during startup if it is your main colorscheme
    priority = 1000, -- make sure to load this before all the other start plugins
    config = function()
      require("tokyonight").setup({
        style = "night",
        transparent = true,
        on_colors = function(colors)
          -- コメントの色を変更
          colors.comment = colors.green2
        end
      })
      -- load the colorscheme here
      vim.cmd([[colorscheme tokyonight]])
    end,
  },

  -- 括弧の補完
  -- "jiangmiao/auto-pairs",
  {
    "windwp/nvim-autopairs",
    config = function()
      require("nvim-autopairs").setup {}
      local npairs   = require 'nvim-autopairs'
      local Rule     = require 'nvim-autopairs.rule'

      local brackets = { { '(', ')' }, { '[', ']' }, { '{', '}' } }
      npairs.add_rules {
        Rule(' ', ' ')
            :with_pair(function(opts)
              local pair = opts.line:sub(opts.col - 1, opts.col)
              return vim.tbl_contains({
                brackets[1][1] .. brackets[1][2],
                brackets[2][1] .. brackets[2][2],
                brackets[3][1] .. brackets[3][2],
              }, pair)
            end)
      }
      for _, bracket in pairs(brackets) do
        npairs.add_rules {
          Rule(bracket[1] .. ' ', ' ' .. bracket[2])
              :with_pair(function() return false end)
              :with_move(function(opts)
                return opts.prev_char:match('.%' .. bracket[2]) ~= nil
              end)
              :use_key(bracket[2])
        }
      end
    end
  },

  -- lua等で"end"を補完
  "RRethy/nvim-treesitter-endwise",

  -- コメントアウト
  {
    "numToStr/Comment.nvim",
    event = "BufEnter",
    config = function()
      require("Comment").setup()
    end
  },

  -- ステータスライン
  {
    "nvim-lualine/lualine.nvim",
    dependencies = {
      "nvim-tree/nvim-web-devicons"
    },
    config = function()
      require("lualine").setup({
        options = {
          icons_enabled = true,
          theme = 'auto',
          component_separators = { left = '', right = '' },
          section_separators = { left = '', right = '' },
          disabled_filetypes = {},
          always_divide_middle = true,
        },
        sections = {
          lualine_a = { 'mode' },
          lualine_b = { 'branch', 'diff', 'diagnostics' },
          lualine_c = { 'filename' },
          lualine_x = { 'encoding', 'fileformat', 'filetype' },
          lualine_y = { 'progress' },
          lualine_z = { 'location' }
        },
        inactive_sections = {
          lualine_a = {},
          lualine_b = {},
          lualine_c = { 'filename' },
          lualine_x = { 'location' },
          lualine_y = {},
          lualine_z = {}
        },
        tabline = {},
        extensions = {}
      })
    end
  },

  -- Treesitter
  {
    "nvim-treesitter/nvim-treesitter",
    dependencies = {
      'JoosepAlviste/nvim-ts-context-commentstring',
    },
    config = function()
      require("nvim-treesitter.configs").setup({
        ensure_installed = { "c", "lua", "rust", "markdown", "python" },
        sync_install = "false",
        auto_install = true,
        highlight = {
          enable = true,
        },
        indent = {
          enable = false,
        },
        endwise = {
          enable = true,
        },
        -- treesitterを使用してコメントのトグル
        -- context_commentstring = {
        --   enable = true,
        -- },
      })
    end
  },

  -- ファジーファインダー
  {
    "nvim-telescope/telescope-file-browser.nvim",
    dependencies = { { "nvim-telescope/telescope.nvim" }, "nvim-lua/plenary.nvim" },
    config = function()
      require("telescope").load_extension "file_browser"

      vim.keymap.set('n', '<leader>ff', '<cmd>lua require("telescope.builtin").find_files()<cr>')
      vim.keymap.set('n', '<leader>fg', '<cmd>lua require("telescope.builtin").live_grep()<cr>')
      vim.keymap.set('n', '<leader>fb', '<cmd>lua require("telescope.builtin").buffers()<cr>')
      vim.keymap.set('n', '<leader>fv', '<cmd>lua require("telescope").extensions.file_browser.file_browser()<cr>')
      vim.keymap.set('n', '<leader>fh', '<cmd>lua require("telescope.builtin").help_tags()<cr>')
    end,
  },

  {
    "williamboman/mason-lspconfig.nvim",
    dependencies = {
      "neovim/nvim-lspconfig",
      "williamboman/mason.nvim"
    },
    config = function()
      local opts = { noremap = true, silent = true }
      vim.keymap.set('n', '<space>e', vim.diagnostic.open_float, opts)
      vim.keymap.set('n', '[d', vim.diagnostic.goto_prev, opts)
      vim.keymap.set('n', ']d', vim.diagnostic.goto_next, opts)

      local on_attach = function(client, bufnr)
        -- Enable completion triggered by <c-x><c-o>
        vim.api.nvim_buf_set_option(bufnr, 'omnifunc', 'v:lua.vim.lsp.omnifunc')

        local bufopts = { noremap = true, silent = true, buffer = bufnr }
        vim.keymap.set('n', 'K', vim.lsp.buf.hover, bufopts)
        vim.keymap.set('n', 'gf', function() vim.lsp.buf.format { async = true } end, bufopts)
        vim.keymap.set('n', 'gr', vim.lsp.buf.references, bufopts)
        vim.keymap.set('n', 'gd', vim.lsp.buf.definition, bufopts)
        vim.keymap.set('n', 'gD', vim.lsp.buf.declaration, bufopts)
        vim.keymap.set('n', 'gi', vim.lsp.buf.implementation, bufopts)
        vim.keymap.set('n', 'gy', vim.lsp.buf.type_definition, bufopts)
        vim.keymap.set('n', 'gn', vim.lsp.buf.rename, bufopts)
        vim.keymap.set('n', 'ga', vim.lsp.buf.code_action, bufopts)
      end

      require("mason").setup()
      require("mason-lspconfig").setup({
        function(server)
          require("lspconfig")[server].setup({
            capabilities = require('cmp_nvim_lsp').default_capabilities(),
            on_attach = on_attach,
          })
        end,

        ["lua_ls"] = function()
          require("lspconfig").lua_ls.setup {
            settings = {
              Lua = {
                diagnostics = {
                  globals = { "vim" }
                }
              }
            },

            on_attach = on_attach,
          }
        end,
      })
    end
  },

  {
    "hrsh7th/nvim-cmp",
    dependencies = {
      "hrsh7th/cmp-nvim-lsp",
      "hrsh7th/vim-vsnip",
      "hrsh7th/cmp-vsnip",
      "hrsh7th/cmp-buffer",
    },
    config = function()
      local feedkey = function(key, mode)
        vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes(key, true, true, true), mode, true)
      end
      local cmp = require('cmp')
      cmp.setup({
        snippet = {
          expand = function(args)
            vim.fn["vsnip#anonymous"](args.body)
          end
        },
        window = {},
        mapping = cmp.mapping.preset.insert({
          ['<C-b>'] = cmp.mapping.scroll_docs(-4),
          ['<C-f>'] = cmp.mapping.scroll_docs(4),
          ['<C-Space>'] = cmp.mapping.complete(),
          ['<C-e>'] = cmp.mapping.abort(),
          ['<CR>'] = cmp.mapping.confirm({ select = false }), -- Accept currently selected item. Set `select` to `false` to only confirm explicitly selected items.
          ["<Tab>"] = cmp.mapping(function(fallback)          -- https://github.com/hrsh7th/nvim-cmp/wiki/Example-mappings for other snippet plugins
            if vim.fn["vsnip#available"](1) == 1 then
              feedkey("<Plug>(vsnip-expand-or-jump)", "")
            else
              fallback() -- The fallback function sends a already mapped key. In this case, it's probably `<Tab>`.
            end
          end, { "i", "s" }),
          ["<S-Tab>"] = cmp.mapping(function()
            if vim.fn["vsnip#jumpable"](-1) == 1 then
              feedkey("<Plug>(vsnip-jump-prev)", "")
            end
          end, { "i", "s" }),
        }),
        sources = cmp.config.sources({
          { name = "nvim_lsp" },
          { name = "vsnip" },
          { name = "buffer" },
        })
      })

      -- snippetディレクトリ
      vim.g.vsnip_snippet_dirs = {
        vim.fn.expand('~/dotfiles/snippets'),
      }
    end
  },

  -- ターミナルを便利に
  {
    "akinsho/toggleterm.nvim", 
    config = function()
      require("toggleterm").setup({
        open_mapping = [[<c-\>]],
        direction = 'float',
      })
    end
  },

  -- LSPの稼働状況を通知
  {
    "j-hui/fidget.nvim",
    tag = "legacy",
    config = function()
      require("fidget").setup()
    end
  },

  -- diagnosticをいい感じにする
  {
    "Maan2003/lsp_lines.nvim",
    event = "BufEnter",
    config = function()
      require("lsp_lines").setup()
      -- デフォルトのdiagnosticsを消す
      vim.diagnostic.config({
        virtual_text = false,
      })
      -- keymap
      vim.keymap.set(
        "",
        "<Leader>l",
        require("lsp_lines").toggle,
        { desc = "Toggle lsp_lines" }
      )
    end
  },

  -- ウィンドウのリサイズを簡単にする
  {
    "simeji/winresizer"
  },

  -- markdown
  {
    "iamcco/markdown-preview.nvim",
    ft = { "markdown", "pandoc.markdown", "rmd" },
    build = "sh -c 'cd app && npm install'",
    config = function()
      vim.g.mkdp_echo_preview_url = 1
    end
  },
}
