return {
  {
    "rcarriga/nvim-dap-ui",
    keys = function()
      return {
        {
          "<F4>",
          function()
            require("dapui").toggle()
          end,
          desc = "Open debug interface",
        },
        {
          "<F9>",
          function()
            require("dap").toggle_breakpoint()
          end,
          desc = "Toggle breakpoint",
        },
        {
          "<F21>", -- SHIFT+F9
          function()
            local Input = require("nui.input")
            local event = require("nui.utils.autocmd").event
            local popup_options = {
              relative = "cursor",
              position = {
                row = -2,
                col = 1,
              },
              size = 50,
              border = {
                style = require("config.icons").borders.empty,
                text = {
                  top = "Condition",
                  title_pos = "center",
                },
              },
              win_options = {
                winhighlight = "PopupNormal:FloatBorder",
              },
            }
            local input = Input(popup_options, {
              on_submit = function(value)
                require("dap").set_breakpoint(value)
              end,
            })
            input:map("n", "<Esc>", function()
              input:unmount()
            end, { noremap = true })
            input:on(event.BufLeave, function()
              input:unmount()
            end)
            input:mount()
          end,
          desc = "Set conditional breakpoint",
        },
        {
          "<F29>", -- CTRL+F5
          function()
            require("dap").run_last()
          end,
          desc = "Run last debug",
        },
        {
          "<F17>", -- SHIFT+F5
          function()
            require("dap").close()
          end,
          desc = "Stop debugging",
        },
        {
          "<F5>",
          function()
            require("dap").continue()
          end,
          desc = "Continue debugging",
        },
        {
          "<F10>",
          function()
            require("dap").step_over()
          end,
          desc = "Step over",
        },
        {
          "<F11>",
          function()
            require("dap").step_into()
          end,
          desc = "Step into",
        },
        {
          "<F23>", --SHIFT+F11
          function()
            require("dap").step_out()
          end,
          desc = "Step out",
        },
      }
    end,
    dependencies = {
      "nvim-neotest/nvim-nio",
      {
        "mfussenegger/nvim-dap",
        opts = function()
          return {
            languages = {
              adapters = {
                lldb = {
                  type = "executable",
                  command = "lldb-dap",
                  name = "lldb",
                },
              },
              configurations = {
                cpp = {
                  {
                    name = "Launch",
                    type = "lldb",
                    request = "launch",
                    program = function()
                      return vim.fn.input("Path to executable: ", vim.fn.getcwd() .. "/", "file")
                    end,
                    cwd = "${workspaceFolder}",
                    stopOnEntry = false,
                    args = {},
                  },
                },
                c = {
                  {
                    name = "Launch",
                    type = "lldb",
                    request = "launch",
                    program = function()
                      return vim.fn.input("Path to executable: ", vim.fn.getcwd() .. "/", "file")
                    end,
                    cwd = "${workspaceFolder}",
                    stopOnEntry = false,
                    args = {},
                  },
                },
              },
            },
          }
        end,
        config = function(_, opts)
          local dap = require("dap")
          for key, options in pairs(opts.languages) do
            for language, language_config in pairs(options) do
              dap[key][language] = language_config
            end
          end
          local debug = require("config.icons").debug
          vim.fn.sign_define("DapBreakpoint", {
            text = debug.breakpoint,
            texthl = "DebugBreakpoint",
            numhl = "DebugBreakpointLine",
          })
          vim.fn.sign_define("DapBreakpointCondition", {
            text = debug.condition,
            texthl = "DebugBreakpoint",
            numhl = "DebugBreakpointLine",
          })
          vim.fn.sign_define("DapStopped", {
            text = debug.stopped,
            texthl = "DebugStopped",
            numhl = "DebugStoppedLine",
          })
          vim.fn.sign_define("DapBreakpointRejected", {
            text = debug.rejected,
            texthl = "DebugLogPoint",
            numhl = "DebugLogPointLine",
          })
          vim.fn.sign_define("DapLogPoint", {
            text = debug.log,
            texthl = "DebugLogPoint",
            numhl = "DebugLogPointLine",
          })
        end,
      },
    },
    opts = function()
      local icons = require("config.icons")
      return {
        controls = {
          element = "repl",
          enabled = true,
          icons = {
            disconnect = icons.debug.disconnect,
            pause = icons.debug.pause,
            play = icons.debug.play,
            run_last = icons.debug.run_last,
            step_back = icons.debug.step_back,
            step_into = icons.debug.step_into,
            step_out = icons.debug.step_out,
            step_over = icons.debug.step_over,
            terminate = icons.debug.terminate,
          },
        },
        element_mappings = {},
        expand_lines = true,
        floating = {
          border = icons.borders.outer.all,
          mappings = {
            close = { "<F4>", "<Esc>", "q" },
          },
        },
        force_buffers = true,
        icons = {
          collapsed = icons.folder.collapsed,
          current_frame = icons.folder.collapsed,
          expanded = icons.folder.expanded,
        },
        mappings = {
          edit = "e",
          expand = { "<CR>", "<2-LeftMouse>" },
          open = "o",
          remove = "d",
          repl = "r",
          toggle = "t",
        },
        render = {
          indent = 1,
          max_value_lines = 100,
        },
      }
    end,
    config = function(_, opts)
      local dapui = require("dapui")
      dapui.setup(opts)
    end,
  },
}
