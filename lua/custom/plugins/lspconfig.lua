return {
  {
    'Vimjas/vim-python-pep8-indent',
    ft = 'python',
  },
  {
    'nvim-treesitter/nvim-treesitter',
    opts = function(_, opts)
      -- Инициализируем ensure_installed, если он nil
      opts.ensure_installed = opts.ensure_installed or {}
      vim.list_extend(opts.ensure_installed, { 'ninja', 'python', 'rst', 'toml' })

      -- Добавляем кастомные настройки для подсветки
      opts.highlight = {
        enable = true,
        additional_vim_regex_highlighting = false,
        custom_captures = {
          ['fstring.content'] = 'Identifier',
        },
      }
      opts.indent = {
        enable = true,
      }
    end,
    config = function(_, opts)
      require('nvim-treesitter.configs').setup(opts)
    end,
  },
  {
    'neovim/nvim-lspconfig',
    opts = function(_, opts)
      -- Determine which Python LSP to use based on config (defaults to pyright)
      local lsp = vim.g.lazyvim_python_lsp or 'basedpyright'
      -- Determine which Ruff implementation to use (defaults to new "ruff")
      local ruff = vim.g.lazyvim_python_ruff or 'ruff'

      -- Инициализируем opts.servers если не существует
      opts.servers = opts.servers or {}

      -- Configure servers
      if lsp == 'pyright' then
        opts.servers.pyright = {
          settings = {
            pyright = {
              -- Let Ruff handle imports
              disableOrganizeImports = true,
            },
            python = {
              analysis = {
                typeCheckingMode = 'basic',
                autoSearchPaths = true,
                useLibraryCodeForTypes = true,
                diagnosticMode = 'workspace',
              },
            },
          },
        }
      elseif lsp == 'basedpyright' then
        opts.servers.basedpyright = {
          settings = {
            basedpyright = {
              disableOrganizeImports = true,
              -- Enable docstring support
              docstringSupport = true,
            },
            python = {
              analysis = {
                autoSearchPaths = true,
                diagnosticMode = 'workspace',
                useLibraryCodeForTypes = true,
              },
            },
          },
        }
      end

      -- Configure Ruff
      if ruff == 'ruff' then
        opts.servers.ruff = {
          cmd_env = { RUFF_TRACE = 'messages' },
          init_options = {
            settings = {
              logLevel = 'error',
            },
          },
          keys = {
            {
              '<leader>co',
              function()
                vim.lsp.buf.code_action {
                  apply = true,
                  context = {
                    only = { 'source.organizeImports' },
                    diagnostics = {},
                  },
                }
              end,
              desc = 'Organize Imports',
            },
          },
        }
      elseif ruff == 'ruff_lsp' then
        opts.servers.ruff_lsp = {
          keys = {
            {
              '<leader>co',
              function()
                vim.lsp.buf.code_action {
                  apply = true,
                  context = {
                    only = { 'source.organizeImports' },
                    diagnostics = {},
                  },
                }
              end,
              desc = 'Organize Imports',
            },
          },
        }
      end

      -- Enable/disable servers
      local servers = { 'pyright', 'basedpyright', 'ruff', 'ruff_lsp' }
      for _, server in ipairs(servers) do
        opts.servers[server] = opts.servers[server] or {}
        opts.servers[server].enabled = (server == lsp) or (server == ruff)
      end

      -- Set up handlers
      opts.setup = opts.setup or {}
      opts.setup.basedpyright = function()
        -- Explicitly enable hover support
        require('lazyvim.util').lsp.on_attach(function(client, buffer)
          -- Force enable hover support for BasedPyright
          if client.name == 'basedpyright' then
            client.server_capabilities.hoverProvider = true
            -- Configure hover to show docstrings
            vim.lsp.handlers['textDocument/hover'] = vim.lsp.with(vim.lsp.handlers.hover, {
              border = 'rounded',
              -- Add this to show docstrings in hover
              focusable = true,
              max_width = 80,
              max_height = 30,
            })
          end
        end)
        return false -- Continue with default setup
      end

      -- Configure Ruff LSP to defer to Pyright for certain capabilities
      opts.setup[ruff] = function()
        require('lazyvim.util').lsp.on_attach(function(client, _)
          -- Disable hover in favor of Pyright
          client.server_capabilities.hoverProvider = false
        end)
        return false -- Return false to allow the default setup to proceed
      end

      return opts
    end,
  },
  {
    'mfussenegger/nvim-dap',
    optional = true,
    dependencies = {
      'mfussenegger/nvim-dap-python',
      -- stylua: ignore
      keys = {
        { "<leader>dPt", function() require('dap-python').test_method() end, desc = "Debug Method", ft = "python" },
        { "<leader>dPc", function() require('dap-python').test_class() end, desc = "Debug Class", ft = "python" },
      },
      config = function()
        require('dap-python').setup 'python'
        table.insert(require('dap').configurations.python, {
          type = 'python',
          request = 'launch',
          name = 'My custom launch configuration',
          program = '${file}',
          justMyCode = false,
        })
      end,
    },
  },
  {
    'mfussenegger/nvim-dap-python',
    dependencies = {
      'mfussenegger/nvim-dap',
    },
    ft = { 'python' },
    config = function()
      -- Get DAP Python adapter
      local dap_python = require 'dap-python'

      -- Configure DAP Python to work with your virtual environment
      local python_path = vim.fn.exepath 'python'
      dap_python.setup(python_path)

      -- Add Python testing configurations
      dap_python.test_runner = 'pytest'

      -- Add a command to debug the current Python test file
      vim.api.nvim_create_user_command('PytestDebug', function(opts)
        local file = opts.args ~= '' and opts.args or vim.fn.expand '%'

        -- Run test with DAP
        require('neotest').run.run {
          file,
          strategy = 'dap',
        }
      end, { nargs = '?', complete = 'file' })
    end,
  },
  {
    'williamboman/mason-nvim-dap.nvim',
    optional = true,
    opts = {
      -- Don't mess up DAP adapters provided by nvim-dap-python
      handlers = {
        python = function() end,
      },
    },
  },
  {
    'hrsh7th/nvim-cmp',
    optional = true,
    opts = function(_, opts)
      opts.auto_brackets = opts.auto_brackets or {}
      table.insert(opts.auto_brackets, 'python')
    end,
  },
}
