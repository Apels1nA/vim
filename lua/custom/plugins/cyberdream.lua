return {
  'scottmckendry/cyberdream.nvim',
  lazy = false,
  priority = 1000,
  transparent = true,
  config = function()
    require('cyberdream').setup {} -- Пустые настройки = дефолтные
    vim.cmd.colorscheme 'cyberdream'
  end,
}
