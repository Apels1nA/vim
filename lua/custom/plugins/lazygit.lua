return {
  'kdheepak/lazygit.nvim',
  cmd = 'LazyGit', -- Ленивая загрузка только при вызове :LazyGit
  dependencies = {
    'nvim-lua/plenary.nvim', -- Обязательная зависимость
  },
  keys = { -- Опционально: хоткеи для быстрого доступа
    { '<leader>gg', '<cmd>LazyGit<cr>', desc = 'Open LazyGit' },
  },
  config = function()
    -- Настройки окна LazyGit
    vim.g.lazygit_floating_window_winblend = 0 -- Прозрачность окна (0-100)
    vim.g.lazygit_floating_window_scaling_factor = 0.9 -- Масштаб окна
    vim.g.lazygit_floating_window_border_chars = { '╭', '─', '╮', '│', '╯', '─', '╰', '│' } -- Границы окна
    vim.g.lazygit_use_neovim_remote = false -- Если true, требует neovim-remote
  end,
}
