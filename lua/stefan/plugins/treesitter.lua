return {
    {
        "nvim-treesitter/nvim-treesitter",
        branch = "main",
        lazy = false,
        build = ":TSUpdate",

        init = function()
            local group = vim.api.nvim_create_augroup("treesitter_setup", { clear = true })

            vim.api.nvim_create_autocmd("FileType", {
                group = group,
                callback = function()
                    -- Enable Treesitter highlighting when a parser is available.
                    local started = pcall(vim.treesitter.start)

                    -- Enable Treesitter indentation only for buffers where
                    -- Treesitter successfully attached.
                    if started then
                        vim.bo.indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
                    end
                end,
            })
        end,

        config = function()
            local treesitter = require("nvim-treesitter")

            -- Default setup is sufficient; this is included explicitly
            -- so that the new API is visible in your config.
            treesitter.setup({})

            local ensure_installed = {
                "json",
                "javascript",
                "typescript",
                "tsx",
                "go",
                "yaml",
                "html",
                "css",
                "python",
                "http",
                "prisma",
                "markdown",
                "markdown_inline",
                "svelte",
                "graphql",
                "bash",
                "lua",
                "vim",
                "dockerfile",
                "gitignore",
                "query",
                "vimdoc",
                "c",
                "java",
                "rust",
            }

            -- Replacement for the old ensure_installed option:
            -- install only parsers that are not already present.
            local already_installed =
                require("nvim-treesitter.config").get_installed()

            local parsers_to_install = vim.iter(ensure_installed)
                :filter(function(parser)
                    return not vim.tbl_contains(already_installed, parser)
                end)
                :totable()

            if #parsers_to_install > 0 then
                treesitter.install(parsers_to_install)
            end
        end,
    },

    -- JS / TS / JSX / TSX auto-close tags
    {
        "windwp/nvim-ts-autotag",
        ft = {
            "html",
            "xml",
            "javascript",
            "typescript",
            "javascriptreact",
            "typescriptreact",
            "svelte",
        },
        config = function()
            require("nvim-ts-autotag").setup({
                opts = {
                    enable_close = true,
                    enable_rename = true,
                    enable_close_on_slash = false,
                },
                per_filetype = {
                    html = {
                        enable_close = true,
                    },
                    typescriptreact = {
                        enable_close = true,
                    },
                },
            })
        end,
    },
}
