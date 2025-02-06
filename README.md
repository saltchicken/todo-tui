  {
    "saltchicken/nvim-ollama-pilot",
    dependencies = { "nvim-lua/plenary.nvim" },
    config = function()
      require("nvim-ollama-pilot").setup({
        server_address = "localhost",
        port = 11434,
        debug = false,
      })
    end,
  },
