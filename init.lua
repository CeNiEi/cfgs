vim.g.mapleader = ' '
vim.g.maplocalleader = ' '

local lazypath = vim.fn.stdpath 'data' .. '/lazy/lazy.nvim'
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system {
    'git',
    'clone',
    '--filter=blob:none',
    'https://github.com/folke/lazy.nvim.git',
    '--branch=stable', -- latest stable release
    lazypath,
  }
end

vim.opt.rtp:prepend(lazypath)


require('lazy').setup({
  'tpope/vim-sleuth',

  {
    'neovim/nvim-lspconfig',
    dependencies = {
      { 'williamboman/mason.nvim', config = true },
      'williamboman/mason-lspconfig.nvim',

      { 'j-hui/fidget.nvim',       tag = 'legacy', opts = {} },
    },
  },

  { 'echasnovski/mini.nvim',      version = false },

  { "nvim-tree/nvim-web-devicons" },

  { "EdenEast/nightfox.nvim" },

  {
    'nvim-treesitter/nvim-treesitter',
    dependencies = {
      'nvim-treesitter/nvim-treesitter-textobjects',
    },
    build = ':TSUpdate',
  },

}, {})

vim.o.hlsearch = false

vim.wo.number = true

vim.o.mouse = 'a'

vim.o.clipboard = 'unnamedplus'

vim.o.breakindent = true

vim.o.undofile = true

vim.o.ignorecase = true
vim.o.smartcase = true

vim.wo.signcolumn = 'yes'

vim.o.updatetime = 250
vim.o.timeoutlen = 300

vim.o.completeopt = 'menuone,noselect'

vim.wo.relativenumber = true

vim.o.termguicolors = true

-- [[ Configure Treesitter ]]
-- See `:help nvim-treesitter`
-- Defer Treesitter setup after first render to improve startup time of 'nvim {filename}'
vim.defer_fn(function()
  require('nvim-treesitter.configs').setup {
    -- Add languages to be installed here that you want installed for treesitter
    ensure_installed = { 'c', 'cpp', 'lua', 'python', 'rust', 'vim', 'toml', 'haskell' },

    -- Autoinstall languages that are not installed. Defaults to false (but you can change for yourself!)
    auto_install = false,

    highlight = { enable = true },
    indent = { enable = true },
    incremental_selection = {
      enable = true,
      keymaps = {
        init_selection = '<c-space>',
        node_incremental = '<c-space>',
        scope_incremental = '<c-s>',
        node_decremental = '<M-space>',
      },
    },
  }
end, 0)

local servers = {
  rust_analyzer = {},
  hls = {},
  lua_ls = {
    Lua = {
      workspace = { checkThirdParty = false },
      telemetry = { enable = false },
    },
  },
}

-- Ensure the servers above are installed
local mason_lspconfig = require 'mason-lspconfig'

mason_lspconfig.setup {
  ensure_installed = vim.tbl_keys(servers),
}

mason_lspconfig.setup_handlers {
  function(server_name)
    require('lspconfig')[server_name].setup {
      on_attach =
          function(_, bufnr)
            vim.cmd [[autocmd BufWritePre <buffer> lua vim.lsp.buf.format()]]
          end,

      settings = servers[server_name],
      filetypes = (servers[server_name] or {}).filetypes,
    }
  end
}

vim.cmd("colorscheme nightfox")
require('nightfox').setup({
  options = {
    styles = {
      comments = "italic",
      keywords = "bold",
      types = "italic,bold",
    }
  }
})

local animate = require('mini.animate')
animate.setup {
  scroll = {
    enable = false,
  },
  cursor = {
    timing = animate.gen_timing.cubic({ duration = 150, unit = 'total' }),
    path = animate.gen_path.angle(),
  },
}
require("mini.comment").setup()
require("mini.surround").setup()
require("mini.extra").setup()
require('mini.pick').setup({
  mappings = {
    choose_in_vsplit = '<C-CR>',
  },
  options = {
    use_cache = true
  },
  window = {
    config = function()
      height = math.floor(0.618 * vim.o.lines)
      width = math.floor(0.618 * vim.o.columns)
      return {
        anchor = 'NW',
        height = height,
        width = width,
        row = math.floor(0.5 * (vim.o.lines - height)),
        col = math.floor(0.5 * (vim.o.columns - width)),
        border = 'double',
      }
    end,
  }
})
require("mini.starter").setup()
require('mini.pairs').setup({
  mappings = {
    ['('] = { action = 'open', pair = '()', neigh_pattern = '[^\\].' },
    ['['] = { action = 'open', pair = '[]', neigh_pattern = '[^\\].' },
    ['{'] = { action = 'open', pair = '{}', neigh_pattern = '[^\\].' },

    [')'] = { action = 'close', pair = '()', neigh_pattern = '[^\\].' },
    [']'] = { action = 'close', pair = '[]', neigh_pattern = '[^\\].' },
    ['}'] = { action = 'close', pair = '{}', neigh_pattern = '[^\\].' },

    ['"'] = { action = 'closeopen', pair = '""', neigh_pattern = '[^\\].', register = { cr = false } },
    ["'"] = false,
    ['`'] = { action = 'closeopen', pair = '``', neigh_pattern = '[^\\].', register = { cr = false } },
  },
})

require('mini.completion').setup({
  window = { info = { border = 'double' } }
})
require('mini.statusline').setup({
})
require('mini.files').setup({})
require('mini.indentscope').setup({
  symbol = "❗️"
})
require('mini.move').setup({})
require('mini.tabline').setup()
require('mini.bracketed').setup()
require('mini.clue').setup({
  triggers = {
    -- Leader triggers
    { mode = 'n', keys = '<Leader>' },
    { mode = 'x', keys = '<Leader>' },
    -- Built-in completion
    { mode = 'i', keys = '<C-x>' },

    -- `g` key
    { mode = 'n', keys = 'g' },
    { mode = 'x', keys = 'g' },

    -- Marks
    { mode = 'n', keys = "'" },
    { mode = 'n', keys = '`' },
    { mode = 'x', keys = "'" },
    { mode = 'x', keys = '`' },

    -- Registers
    { mode = 'n', keys = '"' },
    { mode = 'x', keys = '"' },
    { mode = 'i', keys = '<C-r>' },
    { mode = 'c', keys = '<C-r>' },

    -- Window commands
    { mode = 'n', keys = '<C-w>' },

    -- `z` key
    { mode = 'n', keys = 'z' },
    { mode = 'x', keys = 'z' },

    -- pairs
    { mode = 'n', keys = 's' },

    -- brackets
    { mode = 'n', keys = '[' },
    { mode = 'n', keys = ']' },
  },

  clues = {
    function() MiniClue.gen_clues.g() end,
    function() MiniClue.gen_clues.builtin_completion() end,
    function() MiniClue.gen_clues.marks() end,
    function() MiniClue.gen_clues.registers() end,
    function() MiniClue.gen_clues.windows() end,
    function() MiniClue.gen_clues.z() end,
  },
  window = {
    delay = 300
  }
})

vim.keymap.set("n", "<leader>ff", "<cmd>Pick files<cr>",
  { noremap = true, silent = true, desc = 'Find File' })
vim.keymap.set("n", "<leader>bb", "<cmd>Pick buffers<cr>",
  { noremap = true, silent = true, desc = 'Find Buffer' })
vim.keymap.set("n", "<leader>gg", "<cmd>Pick grep_live<cr>",
  { noremap = true, silent = true, desc = 'Find String' })
vim.keymap.set("n", "<leader>hh", "<cmd>Pick help<cr>",
  { noremap = true, silent = true, desc = 'Find Help' })
vim.keymap.set("n", "<leader>dd", "<cmd>Pick diagnostic<cr>",
  { noremap = true, silent = true, desc = 'Find Refs' })

vim.keymap.set("n", "<leader>gr", "<cmd>Pick lsp scope=\"references\"<cr>",
  { noremap = true, silent = true, desc = 'Find Refs' })
vim.keymap.set("n", "<leader>gd", "<cmd>Pick lsp scope=\"definition\"<cr>",
  { noremap = true, silent = true, desc = 'Find Definition' })
vim.keymap.set("n", "<leader>gi", "<cmd>Pick lsp scope=\"implementation\"<cr>",
  { noremap = true, silent = true, desc = 'Find Implementation' })
vim.keymap.set("n", "<leader>gD", "<cmd>Pick lsp scope=\"declaration\"<cr>",
  { noremap = true, silent = true, desc = 'Find Declaration' })

vim.keymap.set("n", "<leader>gs", "<cmd>Pick lsp scope=\"document_symbol\"<cr>",
  { noremap = true, silent = true, desc = 'Find Document Symbols' })
vim.keymap.set("n", "<leader>gS", "<cmd>Pick lsp scope=\"workspace_symbol\"<cr>",
  { noremap = true, silent = true, desc = 'Find Workspace Symbols' })

vim.keymap.set("n", "K", "<cmd>lua vim.lsp.buf.hover()<cr>",
  { noremap = true, silent = true, desc = 'Hover' })

vim.keymap.set("n", "<leader>o", "<cmd>lua MiniFiles.open()<cr>",
  { noremap = true, silent = true, desc = 'Open File Tree' })

vim.keymap.set('n', '<leader>e', vim.diagnostic.open_float, { desc = 'Open floating diagnostic message' })
