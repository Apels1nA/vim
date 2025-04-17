return {
  'akinsho/toggleterm.nvim',
  version = '*',
  config = function()
    local toggleterm = require 'toggleterm'

    toggleterm.setup {
      open_mapping = [[<C-\>]],
      direction = 'horizontal',
      shade_terminals = true,
    }

    _G.terminals = {}
    _G.terminals.initialized = false

    function _G.open_two_terminals()
      local Terminal = require('toggleterm.terminal').Terminal
      local current_dir = vim.fn.getcwd()

      if not _G.terminals.initialized then
        _G.terminals[1] = Terminal:new {
          id = 1,
          direction = 'horizontal',
          size = 15,
          -- Добавляем флаг для отслеживания отправки команд
          commands_sent = false,
          on_open = function(term)
            vim.schedule(function()
              -- Проверяем, были ли команды уже отправлены
              if not term.commands_sent then
                vim.api.nvim_chan_send(term.job_id, 'cd ' .. current_dir .. '\n')
                vim.api.nvim_chan_send(term.job_id, 'ss\n')
                vim.api.nvim_chan_send(term.job_id, 'clear\n')
                term.commands_sent = true -- Обновляем флаг
              end
            end)
          end,
        }

        _G.terminals[2] = Terminal:new {
          id = 2,
          direction = 'horizontal',
          size = 15,
          commands_sent = false,
          on_open = function(term)
            vim.schedule(function()
              if not term.commands_sent then
                vim.api.nvim_chan_send(term.job_id, 'cd ' .. current_dir .. '\n')
                vim.api.nvim_chan_send(term.job_id, 'ss\n')
                vim.api.nvim_chan_send(term.job_id, 'clear\n')
                term.commands_sent = true
              end
            end)
          end,
        }

        _G.terminals.initialized = true
      end

      _G.terminals[1]:toggle()
      _G.terminals[2]:toggle()

      -- Фокусируемся на первом терминале
      vim.schedule(function()
        if _G.terminals[1] and _G.terminals[1]:is_open() then
          vim.api.nvim_set_current_win(_G.terminals[1].window)
        end
      end)
    end

    vim.api.nvim_set_keymap('n', '<C-\\>', '<cmd>lua open_two_terminals()<CR>', { noremap = true, silent = true })

    function _G.focus_terminal(index)
      if _G.terminals[index] and _G.terminals[index]:is_open() then
        vim.api.nvim_set_current_win(_G.terminals[index].window)
      else
        _G.terminals[index]:toggle()
      end
    end

    vim.api.nvim_set_keymap('n', '<A-1>', [[<cmd>lua focus_terminal(1)<CR>]], { noremap = true, silent = true })
    vim.api.nvim_set_keymap('n', '<A-2>', [[<cmd>lua focus_terminal(2)<CR>]], { noremap = true, silent = true })
  end,
}
