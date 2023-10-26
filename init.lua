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

  { 'echasnovski/mini.nvim', version = false },

  {
    "nvim-neo-tree/neo-tree.nvim",
    branch = "v3.x",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "nvim-tree/nvim-web-devicons",
      "MunifTanjim/nui.nvim",
    }
  },

  -- { "catppuccin/nvim",       name = "catppuccin", priority = 1000 },
  {"nyoom-engineering/oxocarbon.nvim", },

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
            local nmap = function(keys, func, desc)
              if desc then
                desc = 'LSP: ' .. desc
              end

              vim.keymap.set('n', keys, func, { buffer = bufnr, desc = desc })
            end

            nmap('gd', vim.lsp.buf.definition, '[G]oto [D]efinition')
            nmap('<leader>D', vim.lsp.buf.type_definition, 'Type [D]efinition')

            nmap('K', vim.lsp.buf.hover, 'Hover Documentation')
            nmap('<C-k>', vim.lsp.buf.signature_help, 'Signature Documentation')

            nmap('gD', vim.lsp.buf.declaration, '[G]oto [D]eclaration')
            nmap('<leader>wa', vim.lsp.buf.add_workspace_folder, '[W]orkspace [A]dd Folder')
            nmap('<leader>wr', vim.lsp.buf.remove_workspace_folder, '[W]orkspace [R]emove Folder')
            nmap('<leader>wl', function()
              print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
            end, '[W]orkspace [L]ist Folders')

            vim.api.nvim_buf_create_user_command(bufnr, 'Format', function(_)
              vim.lsp.buf.format()
            end, { desc = 'Format current buffer with LSP' })
          end,

      settings = servers[server_name],
      filetypes = (servers[server_name] or {}).filetypes,
    }
  end
}

vim.opt.background = "dark" -- set this to dark or light
vim.cmd.colorscheme "oxocarbon"

local animate = require('mini.animate')
animate.setup {
  scroll = {
    -- Disable Scroll Animations, as the can interfer with mouse Scrolling
    enable = false,
  },
  cursor = {
    timing = animate.gen_timing.cubic({ duration = 150, unit = 'total' }),
    path = animate.gen_path.angle(),
  },
}
require("mini.comment").setup()
require("mini.surround").setup()
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
        border = 'single',
      }
    end,
  }
})
require("mini.starter").setup()
require('mini.pairs').setup()
require('mini.completion').setup({
  window = { info = { border = 'single' } }
})
require('mini.statusline').setup({
  use_icons = false
})
require('mini.indentscope').setup({
  symbol = "❗️"
})
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

    -- brackets
    { mode = 'n', keys = '[' },
    { mode = 'n', keys = ']' },
  },

  clues = {
    { mode = 'n', keys = '<Leader>f', desc = 'Find' },
    { mode = 'n', keys = '<Leader>s', desc = 'Switch' },
    { mode = 'n', keys = '<Leader>b', desc = 'Buffer' },
    { mode = 'n', keys = '<Leader>g', desc = 'Git' },
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

-- setup neotree
require("neo-tree").setup({
  close_if_last_window = true,
  filesystem = {
    follow_current_file = {
      enable = true
    }
  },
  buffer = {
    follow_current_file = {
      enable = true
    }
  }
})

vim.keymap.set("n", "<leader>o", "<CMD>Neotree toggle<CR>", { desc = "[O]pen file explorer" })

vim.keymap.set("n", "<leader>ff", "<cmd>lua MiniPick.builtin.files()<cr>",
  { noremap = true, silent = true, desc = 'Find File' })
vim.keymap.set("n", "<leader>fm", "<cmd>lua MiniFiles.open()<cr>",
  { noremap = true, silent = true, desc = 'Find Manualy' })
vim.keymap.set("n", "<leader>fb", "<cmd>lua MiniPick.builtin.buffers()<cr>",
  { noremap = true, silent = true, desc = 'Find Buffer' })
vim.keymap.set("n", "<leader>fs", "<cmd>lua MiniPick.builtin.grep_live()<cr>",
  { noremap = true, silent = true, desc = 'Find String' })
vim.keymap.set("n", "<leader>fh", "<cmd>lua MiniPick.builtin.help()<cr>",
  { noremap = true, silent = true, desc = 'Find Help' })

vim.keymap.set('n', '<leader>e', vim.diagnostic.open_float, { desc = 'Open floating diagnostic message' })
vim.keymap.set('n', '<leader>q', vim.diagnostic.setloclist, { desc = 'Open diagnostics list' })
