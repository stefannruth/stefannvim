return {
    "mason-org/mason.nvim",
    lazy = false,
    dependencies = {
        "mason-org/mason-lspconfig.nvim",
        "WhoIsSethDaniel/mason-tool-installer.nvim",
        "hrsh7th/cmp-nvim-lsp",
        "neovim/nvim-lspconfig",
    },

    config = function()
        local mason = require("mason")
        local mason_lspconfig = require("mason-lspconfig")
        local mason_tool_installer = require("mason-tool-installer")
        local capabilities = require("cmp_nvim_lsp").default_capabilities()

        mason.setup({
            ui = {
                icons = {
                    package_installed = "✓",
                    package_pending = "➜",
                    package_uninstalled = "✗",
                },
            },
        })

        -- Apply completion capabilities to every LSP server.
        vim.lsp.config("*", {
            capabilities = capabilities,
        })

        -- Lua language server configuration.
        vim.lsp.config("lua_ls", {
            settings = {
                Lua = {
                    diagnostics = {
                        globals = { "vim" },
                    },
                    completion = {
                        callSnippet = "Replace",
                    },
                    workspace = {
                        library = {
                            [vim.env.VIMRUNTIME] = true,
                            [vim.fn.stdpath("config") .. "/lua"] = true,
                        },
                    },
                },
            },
        })

        -- Emmet configuration.
        -- Use one Emmet server to avoid duplicate completions.
        vim.lsp.config("emmet_language_server", {
            filetypes = {
                "css",
                "eruby",
                "html",
                "javascript",
                "javascriptreact",
                "less",
                "sass",
                "scss",
                "pug",
                "svelte",
                "typescriptreact",
            },
            init_options = {
                includeLanguages = {},
                excludeLanguages = {},
                extensionsPath = {},
                preferences = {},
                showAbbreviationSuggestions = true,
                showExpandedAbbreviation = "always",
                showSuggestionsAsSnippets = false,
                syntaxProfiles = {},
                variables = {},
            },
        })

        -- Only start Deno in projects containing Deno config files.
        vim.lsp.config("denols", {
            root_markers = { "deno.json", "deno.jsonc" },
        })

        mason_lspconfig.setup({
            ensure_installed = {
                "lua_ls",
                "html",
                "cssls",
                "tailwindcss",
                "gopls",
                "emmet_language_server",
                "marksman",
                "pyright",
                "clangd",
                "rust_analyzer",
                "denols",
            },

            -- This is enabled by default in mason-lspconfig v2,
            -- but stated explicitly here for clarity.
            automatic_enable = true,
        })

        -- Non-LSP tools only.
        mason_tool_installer.setup({
            ensure_installed = {
                "prettier",
                "stylua",
                "isort",
                "pylint",
                { "eslint_d", version = "13.1.2" },
            },
        })
    end,
}



