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

-- vim.wo.number = true
-- vim.o.mouse = 'a'
vim.o.clipboard = 'unnamedplus'
-- vim.o.breakindent = true
-- vim.o.undofile = true
-- vim.o.ignorecase = true
-- vim.o.smartcase = true
-- vim.wo.signcolumn = 'yes'
-- vim.o.updatetime = 250
-- vim.o.timeoutlen = 300
-- vim.o.completeopt = 'menuone,noselect'

vim.wo.relativenumber = true

vim.defer_fn(function()
  require('nvim-treesitter.configs').setup {
    ensure_installed = { 'c', 'cpp', 'lua', 'python', 'rust', 'vim', 'toml', 'haskell' },

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
        border = 'rounded',
      }
    end,
  }
})
require("mini.basics").setup({
  options = {
    extra_ui = true,
    win_borders = 'rounded',
  },
})
require("mini.starter").setup({
  header = [[
 ▄████████    ▄████████ ███▄▄▄▄    ▄█     ▄████████  ▄█
███    ███   ███    ███ ███▀▀▀██▄ ███    ███    ███ ███
███    █▀    ███    █▀  ███   ███ ███▌   ███    █▀  ███▌
███         ▄███▄▄▄     ███   ███ ███▌  ▄███▄▄▄     ███▌
███        ▀▀███▀▀▀     ███   ███ ███▌ ▀▀███▀▀▀     ███▌
███    █▄    ███    █▄  ███   ███ ███    ███    █▄  ███
███    ███   ███    ███ ███   ███ ███    ███    ███ ███
████████▀    ██████████  ▀█   █▀  █▀     ██████████ █▀
  ]],
  footer = [[
  LIFETIME MAY NOT LIVE LONG ENOUGH
  ]]
})
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
  window = { info = { border = 'rounded' } }
})
require('mini.statusline').setup({
})
require('mini.files').setup({})
require('mini.indentscope').setup({
  symbol = "⌠"
})
require('mini.move').setup({})
require('mini.tabline').setup()
require('mini.bracketed').setup()
require('mini.clue').setup({
  triggers = {
    { mode = 'n', keys = '<Leader>' },
    { mode = 'x', keys = '<Leader>' },

    { mode = 'i', keys = '<C-x>' },

    { mode = 'n', keys = 'g' },
    { mode = 'x', keys = 'g' },

    { mode = 'n', keys = "'" },
    { mode = 'n', keys = '`' },
    { mode = 'x', keys = "'" },
    { mode = 'x', keys = '`' },

    { mode = 'n', keys = '"' },
    { mode = 'x', keys = '"' },
    { mode = 'i', keys = '<C-r>' },
    { mode = 'c', keys = '<C-r>' },

    { mode = 'n', keys = '<C-w>' },

    { mode = 'n', keys = 'z' },
    { mode = 'x', keys = 'z' },

    { mode = 'n', keys = 's' },

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
  { noremap = true, silent = true, desc = 'Find diagnostics' })

vim.keymap.set("n", "gr", "<cmd>Pick lsp scope=\"references\"<cr>",
  { noremap = true, silent = true, desc = 'Find Refs' })
vim.keymap.set("n", "gd", "<cmd>Pick lsp scope=\"definition\"<cr>",
  { noremap = true, silent = true, desc = 'Find Definition' })
vim.keymap.set("n", "gi", "<cmd>Pick lsp scope=\"implementation\"<cr>",
  { noremap = true, silent = true, desc = 'Find Implementation' })
vim.keymap.set("n", "gD", "<cmd>Pick lsp scope=\"declaration\"<cr>",
  { noremap = true, silent = true, desc = 'Find Declaration' })

vim.keymap.set("n", "gs", "<cmd>Pick lsp scope=\"document_symbol\"<cr>",
  { noremap = true, silent = true, desc = 'Find Document Symbols' })
vim.keymap.set("n", "gS", "<cmd>Pick lsp scope=\"workspace_symbol\"<cr>",
  { noremap = true, silent = true, desc = 'Find Workspace Symbols' })

vim.keymap.set("n", "K", "<cmd>lua vim.lsp.buf.hover()<cr>",
  { noremap = true, silent = true, desc = 'Hover' })

local show_dotfiles = false

local filter_show = function(fs_entry) return true end

local filter_hide = function(fs_entry)
  return not vim.startswith(fs_entry.name, '.')
end

local toggle_dotfiles = function()
  show_dotfiles = not show_dotfiles
  local new_filter = show_dotfiles and filter_show or filter_hide
  MiniFiles.refresh({ content = { filter = new_filter } })
end

vim.api.nvim_create_autocmd('User', {
  pattern = 'MiniFilesBufferCreate',
  callback = function(args)
    local buf_id = args.data.buf_id
    vim.keymap.set('n', 'H', toggle_dotfiles, { buffer = buf_id })
  end,
})

vim.keymap.set("n", "<leader>o", function(...)
    if not MiniFiles.close() then
      MiniFiles.open(...)
      MiniFiles.refresh({ content = { filter = filter_hide } })
    end
  end,
  { noremap = true, silent = true, desc = 'Toggle File Tree' })

vim.keymap.set('n', '<leader>e', vim.diagnostic.open_float, { desc = 'Open floating diagnostic message' })
