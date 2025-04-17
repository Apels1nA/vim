return {
  'SmiteshP/nvim-navic',
  dependencies = { 'neovim/nvim-lspconfig' },
  config = function()
    local navic = require 'nvim-navic'

    navic.setup {
      icons = {
        File = '📁 ',
        Function = '🛠️ ',
        Method = '🛠️ ',
        Class = '🧱 ',
      },
    }

    -- Автоподключение к LSP
    vim.api.nvim_create_autocmd('LspAttach', {
      callback = function(args)
        local client = vim.lsp.get_client_by_id(args.data.client_id)
        if client.server_capabilities.documentSymbolProvider then
          navic.attach(client, args.buf)
        end
      end,
    })

    -- Решение: обернуть логику в Lua-функцию
    vim.opt.winbar = "%{%v:lua.require('nvim-navic').get_location()%}"
  end,
}
