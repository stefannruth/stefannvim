
-- ~/.config/nvim/lua/stefan/plugins/kanagawa.lua
return {
  "rebelot/kanagawa.nvim",
  lazy     = false,   -- load at startup
  priority = 1000,    -- early, so colors are ready
  config = function()
    -- 1) turn on true‐color
    vim.opt.termguicolors = true
    vim.opt.background     = "dark"   -- or "light"

    -- 2) configure Kanagawa
    require("kanagawa").setup({
      background  = { dark = "wave", light = "lotus" },
      transparent = false,
      -- commentStyle = { italic = true },
      -- keywordStyle = { italic = true, bold = true },
    })

    -- 3) activate it
    vim.cmd("colorscheme kanagawa")
  end,
}
