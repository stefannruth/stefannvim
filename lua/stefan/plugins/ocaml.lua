return {
    "tarides/ocaml.nvim",
    lazy = false,
    dependencies = {
        "neovim/nvim-lspconfig",
        {
            "jpalardy/vim-slime",
            init = function()
                vim.g.slime_no_mappings = 1
            end,
        },
    },
    opts = {
        keymaps = {
            type_enclosing_grow = "<Up>",
            type_enclosing_shrink = "<Down>",
            type_enclosing_increase = "<Right>",
            type_enclosing_decrease = "<Left>",
        },
    },
    config = function(_, opts)
        require("ocaml").setup(opts)

        vim.api.nvim_create_autocmd("FileType", {
            group = vim.api.nvim_create_augroup("OcamlKeymaps", { clear = true }),
            pattern = "ocaml",
            callback = function(event)
                local function open_repl(arguments)
                    if not vim.env.ZELLIJ then
                        vim.notify("Open Neovim inside Zellij to create a REPL pane", vim.log.levels.WARN)
                        return
                    end
                    local root = vim.fs.root(event.buf, { "dune-project", "dune-workspace", ".git" })
                        or vim.fs.dirname(vim.api.nvim_buf_get_name(event.buf))
                        or vim.fn.getcwd()
                    local command = {
                        "zellij", "action", "new-pane", "--direction", "right", "--name", "OCaml REPL",
                        "--cwd", root, "--", "opam", "exec", "--",
                    }
                    vim.list_extend(command, arguments)
                    local result = vim.system(command, { text = true }):wait()
                    if result.code ~= 0 then
                        vim.notify(result.stderr, vim.log.levels.ERROR)
                        return
                    end
                    vim.system({ "zellij", "action", "move-focus", "left" }):wait()
                end

                vim.b[event.buf].slime_target = "zellij"
                vim.b[event.buf].slime_bracketed_paste = 1
                vim.b[event.buf].slime_config = {
                    session_id = "current",
                    relative_pane = "right",
                    relative_move_back = "left",
                }

                vim.api.nvim_buf_create_user_command(event.buf, "OCamlUtop", function()
                    open_repl({ "utop" })
                end, {})
                vim.api.nvim_buf_create_user_command(event.buf, "OCamlDuneUtop", function(args)
                    open_repl({ "dune", "utop", args.args ~= "" and args.args or "lib" })
                end, { nargs = "?", complete = "dir" })

                local mappings = {
                    mt = { "OCamlTypeEnclosing", "OCaml: Inspect type" },
                    mn = { "OCamlJumpNextHole", "OCaml: Next typed hole" },
                    mN = { "OCamlJumpPrevHole", "OCaml: Previous typed hole" },
                    mc = { "OCamlConstruct", "OCaml: Construct expression" },
                    mj = { "OCamlJump", "OCaml: Jump to expression" },
                    mi = { "OCamlInferIntf", "OCaml: Infer interface" },
                    ms = { "OCamlSwitchIntfImpl", "OCaml: Switch implementation/interface" },
                    mu = { "OCamlUtop", "OCaml: Open utop in Zellij" },
                    mU = { "OCamlDuneUtop", "OCaml: Open Dune library REPL in Zellij" },
                    mv = { "SlimeConfig", "OCaml: Configure REPL target" },
                }

                for key, mapping in pairs(mappings) do
                    vim.keymap.set("n", "<localleader>" .. key, "<cmd>" .. mapping[1] .. "<CR>", {
                        buffer = event.buf,
                        silent = true,
                        desc = mapping[2],
                    })
                end
                vim.keymap.set("n", "<localleader>me", "<Plug>SlimeParagraphSend", {
                    buffer = event.buf, remap = true, desc = "OCaml: Send phrase to REPL",
                })
                vim.keymap.set("x", "<localleader>me", "<Plug>SlimeRegionSend", {
                    buffer = event.buf, remap = true, desc = "OCaml: Send selection to REPL",
                })
                vim.keymap.set("n", "<localleader>ml", "<Plug>SlimeLineSend", {
                    buffer = event.buf, remap = true, desc = "OCaml: Send line to REPL",
                })
            end,
        })
    end,
}
