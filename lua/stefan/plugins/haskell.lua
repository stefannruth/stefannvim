return {
    "mrcjkb/haskell-tools.nvim",
    version = "^10",
    lazy = false,
    dependencies = {
        "nvim-telescope/telescope.nvim",
        "hrsh7th/cmp-nvim-lsp",
    },
    init = function()
        vim.g.haskell_tools = {
            hls = {
                default_settings = {
                    haskell = {
                        formattingProvider = "fourmolu",
                    },
                },
            },
        }
    end,
    config = function()
        vim.api.nvim_create_autocmd("FileType", {
            group = vim.api.nvim_create_augroup("HaskellKeymaps", { clear = true }),
            pattern = { "haskell", "lhaskell", "cabal" },
            callback = function(event)
                vim.keymap.set("n", "<localleader>hc", vim.lsp.codelens.run, {
                    buffer = event.buf,
                    silent = true,
                    desc = "Haskell: Run code lens",
                })

                if vim.bo[event.buf].filetype == "cabal" then
                    return
                end

                local mappings = {
                    hr = { "<cmd>Haskell repl toggle<CR>", "Haskell: Toggle GHCi" },
                    hl = { "<cmd>Haskell repl load<CR>", "Haskell: Load file in GHCi" },
                    hR = { "<cmd>Haskell repl reload<CR>", "Haskell: Reload GHCi" },
                    hq = { "<cmd>Haskell repl quit<CR>", "Haskell: Quit GHCi" },
                    he = { "<cmd>Haskell hls evalAll<CR>", "Haskell: Evaluate snippets" },
                    hs = {
                        function()
                            require("haskell-tools").hoogle.hoogle_signature()
                        end,
                        "Haskell: Search Hoogle by type",
                    },
                }

                for key, mapping in pairs(mappings) do
                    vim.keymap.set("n", "<localleader>" .. key, mapping[1], {
                        buffer = event.buf,
                        silent = true,
                        desc = mapping[2],
                    })
                end
            end,
        })
    end,
}
