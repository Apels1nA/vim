return {
  'akinsho/bufferline.nvim',
  version = '*',
  dependencies = 'nvim-tree/nvim-web-devicons',
  config = function()
    require('bufferline').setup {
      options = {
        numbers = function(opts)
          return string.format('%s', opts.ordinal)
        end,
        close_command = 'bdelete! %d',
        right_mouse_command = 'bdelete! %d',
        left_mouse_command = 'buffer %d',
        indicator = {
          style = 'underline',
        },
        buffer_close_icon = '',
        modified_icon = '●',
        close_icon = '',
        max_name_length = 18,
        show_tab_indicators = true,
        separator_style = 'thin',
        always_show_bufferline = true,
      },
    }

    -- Горячие клавиши для переключения между буферами (1-9)
    for i = 1, 9 do
      vim.keymap.set('n', '<leader>' .. i, function()
        require('bufferline').go_to_buffer(i, true)
      end, { desc = 'Go to buffer ' .. i })
    end

    -- Закрыть текущий буфер
    vim.keymap.set('n', '<leader>qq', '<cmd>bdelete<CR>', { desc = 'Close buffer' })

    -- Закрыть все буферы кроме текущего
    vim.keymap.set('n', '<leader>qa', function()
      -- Получаем список всех буферов
      local buffers = vim.api.nvim_list_bufs()
      local current_buf = vim.api.nvim_get_current_buf()

      for _, buf in ipairs(buffers) do
        -- Проверяем, что буфер загружен и это не текущий буфер
        if vim.api.nvim_buf_is_loaded(buf) and buf ~= current_buf then
          vim.api.nvim_buf_delete(buf, { force = true })
        end
      end
    end, { desc = 'Close all buffers except current' })
  end,
}
