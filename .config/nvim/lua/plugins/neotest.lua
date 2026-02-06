return {
  "nvim-neotest/neotest",
  dependencies = {
    "nvim-neotest/nvim-nio",
    "nvim-lua/plenary.nvim",
    "antoinemadec/FixCursorHold.nvim",
    "nvim-treesitter/nvim-treesitter",
    "marilari88/neotest-vitest",
    "nvim-neotest/neotest-jest",
    "nvim-neotest/nvim-nio",
    "nvim-lua/plenary.nvim",
    "antoinemadec/FixCursorHold.nvim",
    {
      "nvim-treesitter/nvim-treesitter", -- Optional, but recommended
      branch = "main", -- NOTE; not the master branch!
      build = function()
        vim.cmd(":TSUpdate go")
      end,
    },
    {
      "fredrikaverpil/neotest-golang",
      version = "*", -- Optional, but recommended; track releases
      build = function()
        vim.system({ "go", "install", "gotest.tools/gotestsum@latest" }):wait() -- Optional, but recommended
      end,
    },
  },
  config = function()
    local config = {
      runner = "gotestsum", -- Optional, but recommended
    }
    require("neotest").setup({
      adapters = {
        require("neotest-vitest"),
        require("neotest-golang")(config),
        require("neotest-jest")({
          jestCommand = "yarn test --",
          jestArguments = function(defaultArguments, context)
            return defaultArguments
          end,
          jestConfigFile = "custom.jest.config.ts",
          env = { CI = true },
          cwd = function(path)
            return vim.fn.getcwd()
          end,
          isTestFile = require("neotest-jest.jest-util").defaultIsTestFile,
        }),
      },
    })
  end,
}
