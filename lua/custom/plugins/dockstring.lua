return {
  -- Плагин vim-pydocstring
  {
    'heavenshell/vim-pydocstring',
    config = function()
      -- Добавляем путь до doq в переменную окружения PATH
      vim.env.PATH = vim.env.PATH .. ':/home/verner/.local/bin'

      -- Указываем путь до шаблонов
      vim.g.pydocstring_templates_path = vim.fn.expand '~/.config/nvim/doq/style'

      -- Указываем формат для генерации docstring (custom формат)
      vim.g.pydocstring_formatter = 'custom'

      -- Горячие клавиши для генерации docstring
      vim.api.nvim_set_keymap('n', '<leader>cf', ':Pydocstring<CR>', { noremap = true, silent = true })
    end,
  },
}
