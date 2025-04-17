return {
  'windwp/nvim-autopairs',
  event = 'InsertEnter',
  dependencies = {
    'hrsh7th/nvim-cmp', -- Явно указываем зависимость от cmp
  },
  config = function()
    local autopairs = require 'nvim-autopairs'
    autopairs.setup {
      disable_filetype = { 'TelescopePrompt', 'spectre_panel' },
      disable_in_macro = true,
      enable_check_bracket_line = false,
      ignored_next_char = '[%w%.]',
      fast_wrap = {
        map = '<M-e>',
        offset = 1,
      },
    }

    -- Отложенная интеграция с cmp после его загрузки
    local cmp_autopairs = require 'nvim-autopairs.completion.cmp'
    local cmp = require 'cmp'
    cmp.event:on('confirm_done', cmp_autopairs.on_confirm_done())
  end,
}
