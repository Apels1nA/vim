return {
  {
    'ray-x/lsp_signature.nvim',
    event = 'VeryLazy',
    config = function()
      require('lsp_signature').setup {
        bind = true,
        handler_opts = {
          border = 'rounded',
        },
        hint_enable = true,
        hi_parameter = 'Visual', -- Подсветка текущего параметра
        floating_window = false, -- Лучше работает с inline-подсказками
      }
    end,
  },
}
