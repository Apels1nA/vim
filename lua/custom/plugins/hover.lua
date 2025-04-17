return {
  'lewis6991/hover.nvim',
  dependencies = {
    'neovim/nvim-lspconfig', -- Обязательно должен быть установлен LSP
  },
  config = function()
    -- Настройка LSP (пример для Python)
    require('lspconfig').pyright.setup {}

    -- Настройка hover.nvim
    require('hover').setup {
      init = function()
        require 'hover.providers.lsp'
      end,
      preview_opts = {
        border = 'single', -- Простая рамка
      },
      timer_opts = {
        enable = true,
        timeout = 400,
      },
    }

    -- Ручной вызов для проверки
    vim.keymap.set('n', 'K', require('hover').hover, { desc = 'Hover manual' })
  end,
}
