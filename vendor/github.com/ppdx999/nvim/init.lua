-- /------------------------------
-- | Editor
-- -------------------------------/
vim.opt.number = true
vim.opt.tabstop = 2
vim.opt.shiftwidth = 2
vim.opt.ignorecase = true
vim.opt.smartcase = true
vim.opt.hlsearch = true

vim.opt.clipboard = 'unnamed'

-- Some plugins display signcolumn only when needed
-- that shakes the screen when the signcolumn appears
-- so I always display signcolumn to avoid the shaking
vim.opt.signcolumn = 'yes'

-- /------------------------------
-- | Keymaps
-- -------------------------------/

vim.g.mapleader = ';'
vim.keymap.set('n', '<Esc><Esc>', '<Cmd>nohlsearch<CR>')
vim.keymap.set('n', '<leader>w', ':w<CR>')
vim.keymap.set('n', '<leader>q', ':q<CR>')
vim.keymap.set('n', '<leader>v', ':<C-u>vs<CR>')
vim.keymap.set('n', '<leader>j', ':<C-u>Explore<CR>')
vim.keymap.set('n', '<C-j>', ':bnext<CR>')
vim.keymap.set('n', '<C-k>', ':bprevious<CR>')
vim.keymap.set('n', '[b', ':bprevious<CR>')
vim.keymap.set('n', ']b', ':bnext<CR>')
vim.keymap.set('n', '[c', ':cprevious<CR>')
vim.keymap.set('n', ']c', ':cnext<CR>')
vim.keymap.set('n', 'tt', ':tabnew<CR>')
vim.keymap.set('n', '[t', ':tabprevious<CR>')
vim.keymap.set('n', ']t', ':tabnext<CR>')
vim.keymap.set('t', '<Esc>', '<C-\\><C-n>')

-- /------------------------------
-- | Plugins
-- -------------------------------/

local lazypath = vim.fn.stdpath('data') .. '/lazy/lazy.nvim'
-- print(lazypath)
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    'git',
    'clone',
    '--filter=blob:none',
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable", -- latest stable release
    lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)

require("lazy").setup({
  -- /------------------------------
  -- | MISC
  -- -------------------------------/
  {
    'github/copilot.vim'
  },
  {
   'tpope/vim-commentary'
  },
  {
    'vim-denops/denops.vim'
  },
  -- /------------------------------
  -- | DDU
  -- -------------------------------/
  {
    'Shougo/ddu.vim',
    dependencies = {
      'vim-denops/denops.vim',
      'Shougo/ddu-ui-ff',
      'Shougo/ddu-kind-file',
      'Shougo/ddu-filter-matcher_substring',
      'Shougo/ddu-source-file_rec',
      'Shougo/ddu-source-file_external',
      'shun/ddu-source-buffer',
      'lambdalisue/mr.vim',
      'kuuote/ddu-source-mr',
      'Shougo/ddu-source-register',
      'shun/ddu-source-rg',
    },
    config = function()
      vim.fn['ddu#custom#patch_global']({
        ui = 'ff',
        sourceOptions = {
          _ = {
            matchers = {'matcher_substring'},
          },
        },
        kindOptions = {
          file = {
            defaultAction = 'open',
          },
        },
      })

      vim.api.nvim_create_autocmd("FileType", {
        pattern = 'ddu-ff',
        callback = function()
          vim.keymap.set('n', '<CR>', '<Cmd>call ddu#ui#ff#do_action("itemAction")<CR>', { buffer = true })
          vim.keymap.set('n', 'i', '<Cmd>call ddu#ui#ff#do_action("openFilterWindow")<CR>', { buffer = true })
          vim.keymap.set('n', 'q', '<Cmd>call ddu#ui#ff#do_action("quit")<CR>', { buffer = true })
        end
      })

      vim.api.nvim_create_autocmd("FileType", {
        pattern = 'ddu-ff-filter',
        callback = function()
          vim.keymap.set('i', '<CR>', '<Cmd>call ddu#ui#ff#do_action("closeFilterWindow")<CR>', { buffer = true })
        end
      })

      local function launch_ddu_file()
        local git_dir = vim.fn.finddir('.git', '.;')
        if git_dir ~= '' then
          vim.fn['ddu#start']({
            sources = {
              {
                name = 'file_external',
              },
            },
            sourceParams = {
              file_external = {
                cmd = {'git', 'ls-files'},
              },
            },
          })
        else
          vim.fn['ddu#start']({
            sources = {
              {
                name = 'file_rec',
              },
            },
          })
        end
      end

      local function launch_ddu_buffer()
        vim.fn['ddu#start']({
          sources = {
            {
              name = 'buffer',
            },
          },
        })
      end

      local function launch_ddu_mr()
        vim.fn['ddu#start']({
          sources = {
            {
              name = 'mr',
            },
          },
        })
      end

      local function launch_ddu_register()
        vim.fn['ddu#start']({
          sources = {
            {
              name = 'register',
            },
          },
        })
      end

      local function launch_ddu_rg_live()
        vim.fn['ddu#start']({
          sources = {
            {
              name = 'rg',
              options = {
                matchers = {},
                volatile = true,
              },
            },
          },
          uiParams = {
            ff = {
              ignoreEmpty = false,
              autoResize = false,
            },
          },
        })
      end

      vim.keymap.set('n', '<leader>f', launch_ddu_file)
      vim.keymap.set('n', '<leader>b', launch_ddu_buffer)
      vim.keymap.set('n', '<leader>m', launch_ddu_mr)
      vim.keymap.set('n', '<leader>r', launch_ddu_register)
      vim.keymap.set('n', '<leader>g', launch_ddu_rg_live)
    end
  },
  -- /------------------------------
  -- | LSP
  -- -------------------------------/
  {
    'williamboman/mason.nvim',
    build = ':MasonUpdate',
    opts = {},
  },
  {
    'williamboman/mason-lspconfig.nvim',
    dependencies = {
      { "williamboman/mason.nvim" },
      { "neovim/nvim-lspconfig" },
      { "hrsh7th/nvim-cmp" },
      { "hrsh7th/cmp-nvim-lsp" },
      { "hrsh7th/vim-vsnip" },
    },
    config = function()
      local lspconfig = require("lspconfig")
      require('mason').setup({})

      require("mason-lspconfig").setup_handlers({
        function(server_name)
          lspconfig[server_name].setup {
            capabilities = require('cmp_nvim_lsp').default_capabilities(),
          }
        end,
      })

      vim.api.nvim_create_autocmd("LspAttach", {
        callback = function(_)
          vim.keymap.set('n', 'gh',  '<cmd>lua vim.lsp.buf.hover()<CR>')
          vim.keymap.set('n', 'gf', '<cmd>lua vim.lsp.buf.formatting()<CR>')
          vim.keymap.set('n', 'gr', '<cmd>lua vim.lsp.buf.references()<CR>')
          vim.keymap.set('n', 'gd', '<cmd>lua vim.lsp.buf.definition()<CR>')
          vim.keymap.set('n', 'gD', '<cmd>lua vim.lsp.buf.declaration()<CR>')
          vim.keymap.set('n', 'gi', '<cmd>lua vim.lsp.buf.implementation()<CR>')
          vim.keymap.set('n', 'gt', '<cmd>lua vim.lsp.buf.type_definition()<CR>')
          vim.keymap.set('n', 'gn', '<cmd>lua vim.lsp.buf.rename()<CR>')
          vim.keymap.set('n', 'ga', '<cmd>lua vim.lsp.buf.code_action()<CR>')
          vim.keymap.set('n', 'ge', '<cmd>lua vim.diagnostic.open_float()<CR>')
          vim.keymap.set('n', 'g]', '<cmd>lua vim.diagnostic.goto_next()<CR>')
          vim.keymap.set('n', 'g[', '<cmd>lua vim.diagnostic.goto_prev()<CR>')
        end
      })

      vim.lsp.handlers["textDocument/publishDiagnostics"] = vim.lsp.with(
        vim.lsp.diagnostic.on_publish_diagnostics, { virtual_text = false }
      )

      local cmp = require('cmp')
      cmp.setup({
        snippet = {
          expand = function(args)
            vim.fn["vsnip#anonymous"](args.body)
          end,
        },
        mapping = cmp.mapping.preset.insert({
          ['<C-p>'] = cmp.mapping.select_prev_item(),
          ['<C-n>'] = cmp.mapping.select_next_item(),
          ['<C-d>'] = cmp.mapping.scroll_docs(-4),
          ['<C-f>'] = cmp.mapping.scroll_docs(4),
          ['<C-Space>'] = cmp.mapping.complete(),
          ['<C-e>'] = cmp.mapping.close(),
          ['<CR>'] = cmp.mapping.confirm({
            behavior = cmp.ConfirmBehavior.Replace,
            select = true,
          }),
        }),
        sources = {
          { name = 'nvim_lsp' },
          { name = 'vsnip' },
        },
      })
    end
  },
  -- /------------------------------
  -- | Filer
  -- -------------------------------/
  {
    'lambdalisue/fern.vim',
    config = function()
      local init_fern = function()
        vim.g['fern#default_hidden'] = 1
        vim.keymap.set('n', 'D', '<Plug>(fern-action-remove)', {noremap = false, buffer = true})
      end

      vim.api.nvim_create_autocmd("FileType", {
        pattern = 'fern',
        callback = init_fern
      })

      vim.keymap.set('n', '<leader>j', ':<C-u>Fern . -reveal=%<CR>')
    end
  },
  -- /------------------------------
  -- | Color
  -- -------------------------------/
  {
     'sainnhe/everforest',
     config = function()
       if vim.fn.has('termguicolors') == 1 then
         vim.opt.termguicolors = true
       end

       local current_hour = tonumber(os.date('%H'))
       if current_hour >= 6 and current_hour <= 13 then
         vim.opt.background = 'light'
       else
         vim.opt.background = 'dark'
       end

       vim.g.everforest_background = 'hard'

       vim.g.everforest_better_performance = 1

       vim.cmd('colorscheme everforest')
     end
  },
  -- /------------------------------
  -- | git
  -- ------------------------------/
  {
    'tpope/vim-fugitive',
  },
  {
    'airblade/vim-gitgutter',
  },
  -- /------------------------------
  -- | MISC
  -- -------------------------------/
  {
    'tpope/vim-surround',
  },
  {
    'mattn/vim-maketable',
  },
})
