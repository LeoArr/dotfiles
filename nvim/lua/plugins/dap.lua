return {
  {
    'mfussenegger/nvim-dap',
    dependencies = {
      'rcarriga/nvim-dap-ui',
      'nvim-neotest/nvim-nio',
      'theHamsta/nvim-dap-virtual-text',
    },
    keys = {
      {
        '<F5>',
        function()
          require('dap').continue()
        end,
        desc = 'DAP: Continue/Start',
      },
      {
        '<F10>',
        function()
          require('dap').step_over()
        end,
        desc = 'DAP: Step Over',
      },
      {
        '<F11>',
        function()
          require('dap').step_into()
        end,
        desc = 'DAP: Step Into',
      },
      {
        '<F12>',
        function()
          require('dap').step_out()
        end,
        desc = 'DAP: Step Out',
      },
      {
        '<F7>',
        function()
          require('dapui').toggle()
        end,
        desc = 'DAP: Toggle UI',
      },
      {
        '<leader>db',
        function()
          require('dap').toggle_breakpoint()
        end,
        desc = 'DAP: Toggle Breakpoint',
      },
      {
        '<leader>dB',
        function()
          require('dap').set_breakpoint(vim.fn.input 'Breakpoint condition: ')
        end,
        desc = 'DAP: Conditional Breakpoint',
      },
      {
        '<leader>dr',
        function()
          require('dap').repl.open()
        end,
        desc = 'DAP: Open REPL',
      },
      {
        '<leader>dl',
        function()
          require('dap').run_last()
        end,
        desc = 'DAP: Run Last',
      },
      {
        '<leader>dq',
        function()
          require('dap').terminate()
        end,
        desc = 'DAP: Terminate',
      },
      {
        '<leader>dx',
        function()
          require('dap').disconnect()
        end,
        desc = 'DAP: Disconnect',
      },
      {
        '<leader>dQ',
        function()
          local dap, dapui = require 'dap', require 'dapui'
          pcall(dapui.close)
          pcall(function()
            require('dap.repl').close()
          end)
          pcall(dap.terminate)
          pcall(dap.disconnect)
          pcall(dap.close)
        end,
        desc = 'DAP: Stop + close UI',
      },
    },
    config = function()
      local dap, dapui = require 'dap', require 'dapui'

      dapui.setup {
        icons = { expanded = '▾', collapsed = '▸', current_frame = '*' },
        controls = {
          icons = {
            pause = '⏸',
            play = '▶',
            step_into = '⏎',
            step_over = '⏭',
            step_out = '⏮',
            step_back = 'b',
            run_last = '▶▶',
            terminate = '⏹',
            disconnect = '⏏',
          },
        },
      }

      require('nvim-dap-virtual-text').setup {}

      dap.listeners.after.event_initialized['dapui_config'] = function()
        dapui.open()
      end
      dap.listeners.before.event_terminated['dapui_config'] = function()
        dapui.close()
      end
      dap.listeners.before.event_exited['dapui_config'] = function()
        dapui.close()
      end

      dap.configurations.java = {
        {
          type = 'java',
          request = 'attach',
          name = 'Attach to Jetty (mvnDebug :8000)',
          hostName = '127.0.0.1',
          port = 8000,
        },
      }
    end,
  },
}
