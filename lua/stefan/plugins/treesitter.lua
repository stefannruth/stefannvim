return {
    "nvim-treesitter/nvim-treesitter",
    branch = "main",
    lazy = false,
    build = ":TSUpdate",
    config = function()
        local languages = {
            ocaml = "ocaml",
            ocamlinterface = "ocaml_interface",
            haskell = "haskell",
        }

        local function highlight(bufnr)
            local ft = vim.bo[bufnr].filetype
            local lang = languages[ft]
            if not lang then
                return
            end

            if ft == "ocaml" then
                local ext = vim.fn.fnamemodify(vim.api.nvim_buf_get_name(bufnr), ":e")
                if ext == "mll" or ext == "mly" then
                    return
                end
                if ext == "mli" then
                    lang = "ocaml_interface"
                end
            end

            pcall(vim.treesitter.start, bufnr, lang)
        end

        vim.api.nvim_create_autocmd("FileType", {
            group = vim.api.nvim_create_augroup("UserTreesitter", { clear = true }),
            pattern = { "ocaml", "ocamlinterface", "haskell" },
            callback = function(event)
                highlight(event.buf)
            end,
        })

        require("nvim-treesitter").install({ "ocaml", "ocaml_interface", "haskell" }):await(vim.schedule_wrap(function()
            for _, bufnr in ipairs(vim.api.nvim_list_bufs()) do
                if vim.api.nvim_buf_is_loaded(bufnr) then
                    highlight(bufnr)
                end
            end
        end))
    end,
}
