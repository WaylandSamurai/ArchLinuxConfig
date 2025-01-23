-- Налаштування основних параметрів
vim.opt.number = true            -- Показувати номери рядків
vim.opt.relativenumber = false   -- Показувати відносні номери рядків
vim.opt.tabstop = 4              -- Кількість пробілів для табуляції
vim.opt.shiftwidth = 4           -- Кількість пробілів для авто-відступів
vim.opt.expandtab = true         -- Використовувати пробіли замість табуляцій
vim.opt.smartindent = true       -- Розумний відступ
vim.opt.hlsearch = true          -- Підсвітка знайдених слів
vim.opt.incsearch = true         -- Інкрементальний пошук
vim.opt.termguicolors = true     -- Підтримка 24-бітних кольорів

vim.opt.guifont = "MesloLGS Nerd Font:h12"

vim.cmd('highlight Normal ctermbg=none guibg=none')  -- Це робить фон прозорим у Neovim
vim.cmd('highlight StatusLine ctermbg=none guibg=none')  -- Прозорість для лінії стану
vim.cmd('highlight VertSplit ctermbg=none guibg=none')  -- Прозорість для вертикальних поділів

-- Функція для перевірки наявності Packer і його встановлення
local ensure_packer = function()
  local fn = vim.fn
  local install_path = fn.stdpath('data')..'/site/pack/packer/start/packer.nvim'
  if fn.empty(fn.glob(install_path)) > 0 then
    fn.system({
      'git', 'clone', '--depth', '1',
      'https://github.com/wbthomason/packer.nvim', install_path
    })
    vim.cmd [[packadd packer.nvim]]
  end
end

ensure_packer()

-- Завантаження Packer
require('packer').startup(function(use)
  -- Менеджер плагінів
  use 'wbthomason/packer.nvim'

  -- Кольорова схема
  use 'gruvbox-community/gruvbox'

  -- Плагіни для синтаксичного аналізу та підсвітки
  use {
    'nvim-treesitter/nvim-treesitter',
    run = ':TSUpdate' -- автоматичне оновлення парсерів після встановлення
  }

  -- Плагін для автодоповнення
  use 'hrsh7th/nvim-cmp'            -- основне автодоповнення
  use 'hrsh7th/cmp-nvim-lsp'        -- для LSP
  use 'hrsh7th/cmp-buffer'          -- для буферів
  use 'hrsh7th/cmp-path'            -- для шляхів
  use 'saadparwaiz1/cmp_luasnip'    -- для шаблонів

  -- LSP налаштування
  use 'neovim/nvim-lspconfig'

  -- Лінія стану
  use 'hoob3rt/lualine.nvim'

  -- Вкладки
  use 'akinsho/bufferline.nvim'

  -- Пошук
  use 'preservim/nerdtree'  -- Встановлюємо NERDTree
  use 'nvim-telescope/telescope.nvim'
  
  -- Додавання залежності для Telescope
  use 'nvim-lua/plenary.nvim'       -- Перше додавання plenary для Telescope

  -- Інші корисні плагіни
  use 'windwp/nvim-autopairs'       -- Автозакриття дужок
  use 'lewis6991/gitsigns.nvim'     -- Підсвітка змін в Git
end)

-- Налаштування nvim-treesitter для синтаксичного аналізу
require'nvim-treesitter.configs'.setup {
  ensure_installed = "all",  -- Встановлює парсери для всіх мов
  highlight = {
    enable = true,                  -- Включаємо підсвітку
    additional_vim_regex_highlighting = false,
  },
}

-- Налаштування автодоповнення з nvim-cmp
local cmp = require'cmp'
cmp.setup({
  snippet = {
    expand = function(args)
      vim.fn["vsnip#anonymous"](args.body)  -- використання шаблонів
    end,
  },
  mapping = {
    ['<C-p>'] = cmp.mapping.select_prev_item(),
    ['<C-n>'] = cmp.mapping.select_next_item(),
    ['<C-y>'] = cmp.mapping.confirm({ select = true }),
  },
  sources = {
    { name = 'nvim_lsp' },
    { name = 'vsnip' },
    { name = 'buffer' },
    { name = 'path' },
  },
})

-- Налаштування лінії стану (Lualine)
require('lualine').setup {
  options = {
    theme = 'gruvbox',  -- Вибір теми для лінії стану
  },
}

-- Налаштування вкладок (Bufferline)
require'bufferline'.setup {
  options = {
    numbers = "none",
    close_command = "bdelete! %", -- команда для закриття вкладки
    right_mouse_command = "bdelete! %", -- для правої кнопки
    offsets = {{ filetype = "NvimTree", text = "File Explorer", text_align = "left" }},
  }
}

-- Налаштування пошуку з Telescope
require('telescope').setup {
  defaults = {
    prompt_prefix = "❯ ",  -- Префікс підказки
    sorting_strategy = "ascending",
  }
}

-- Гарячі клавіші для відкриття пошуку
vim.api.nvim_set_keymap('n', '<Leader>ff', ':Telescope find_files<CR>', { noremap = true })
vim.api.nvim_set_keymap('n', '<Leader>fg', ':Telescope live_grep<CR>', { noremap = true })
vim.api.nvim_set_keymap('n', '<Leader>fb', ':Telescope buffers<CR>', { noremap = true })

-- Налаштування автозакриття дужок
require('nvim-autopairs').setup()

-- Налаштування Git signs для підсвітки змін в Git
require('gitsigns').setup()

vim.api.nvim_set_keymap('n', '<Leader>n', ':NERDTreeToggle<CR>', { noremap = true, silent = true })

vim.g.NERDTreeWinSize = 25  -- Встановлюємо ширину вікна для дерева
vim.g.NERDTreeShowHidden = 1 -- Показувати приховані файли

