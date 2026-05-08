return {
  {
    'mfussenegger/nvim-jdtls',
    ft = { 'java' },
    dependencies = { 'mfussenegger/nvim-dap' }, -- important so Java adapter can be registered【4】
    config = function()
      local jdtls = require 'jdtls'
      local jdtls_setup = require 'jdtls.setup'

      -- Pick ONE root strategy to avoid “two jdtls clients”
      -- If you want repo root always:
      local root_dir = jdtls_setup.find_root { '.git' }
      if not root_dir then
        return
      end

      local data = vim.fn.stdpath 'data'
      local project_name = vim.fn.fnamemodify(root_dir, ':p:h:t')
      local workspace_dir = data .. '/jdtls-workspace/' .. project_name
      local mason = data .. '/mason/packages'

      local cmd = {
        mason .. '/jdtls/bin/jdtls',
        '-data',
        workspace_dir,
      }

      -- Optional but recommended for DAP features:
      local bundles = {}
      local debug_jar = vim.fn.glob(mason .. '/java-debug-adapter/extension/server/com.microsoft.java.debug.plugin-*.jar')
      if debug_jar ~= '' then
        table.insert(bundles, debug_jar)
      end

      local capabilities = require('blink.cmp').get_lsp_capabilities()

      jdtls.start_or_attach {
        cmd = cmd,
        root_dir = root_dir,
        capabilities = capabilities,
        init_options = { bundles = bundles },
        settings = { java = {} },
      }

      -- Register Java DAP adapter with nvim-dap【5】
      require('jdtls.dap').setup_dap { hotcodereplace = 'auto' }

      -- Your attach config
      local dap = require 'dap'
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
