return {
  'ellisonleao/glow.nvim',
  config = function()
    require('glow').setup {
      style = 'dark',
      width = 120,
    }
    vim.keymap.set('n', '<leader>mp', '<cmd>Glow<CR>', { desc = 'Markdown Preview' })
  end,
}
