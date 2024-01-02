-- /------------------------------
-- | Editor
-- -------------------------------/
vim.opt.number = true
vim.opt.ignorecase = true
vim.opt.smartcase = true
vim.opt.hlsearch = true


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
          vim.keymap.set('n', '<CR>', '<Cmd>call ddu#ui#ff#do_action("itemAction")<CR>')
          vim.keymap.set('n', 'i', '<Cmd>call ddu#ui#ff#do_action("openFilterWindow")<CR>')
          vim.keymap.set('n', 'q', '<Cmd>call ddu#ui#ff#do_action("quit")<CR>')
        end
      })

      vim.api.nvim_create_autocmd("FileType", {
        pattern = 'ddu-ff-filter',
        callback = function()
          vim.keymap.set('n', '<CR>', '<Cmd>call ddu#ui#ff#do_action("closeFilterWindow")<CR>')
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
      { "echasnovski/mini.completion", version = false },
    },
    config = function()
      local lspconfig = require("lspconfig")
      require('mini.completion').setup({})
      require('mason').setup({})
      require("mason-lspconfig").setup_handlers({
        function(server_name)
          lspconfig[server_name].setup {}
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
        vim.keymap.set('n', 'D', '<Plug>(fern-action-remove)', {noremap = false})
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

       vim.opt.background = 'dark'

       vim.g.everforest_background = 'hard'

       vim.g.everforest_better_performance = 1

       vim.cmd('colorscheme everforest')
     end
  }
})
