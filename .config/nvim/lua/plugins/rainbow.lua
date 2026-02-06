return {
  "nvim-treesitter/nvim-treesitter",
  dependencies = { "HiPhish/rainbow-delimiters.nvim" },
  opts = function(_, opts)
    opts.rainbow = {
      enable = true,
      query = {
        [""] = "rainbow-delimiters",
        lua = "rainbow-blocks",
      },
      strategy = {
        [""] = "rainbow-delimiters.strategy.global",
        vim = "rainbow-delimiters.strategy.local",
      },
    }
  end,
}
