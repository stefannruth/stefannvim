return {
    "mfussenegger/nvim-dap",
    ft = { "ocaml" },
    config = function()
        local dap = require("dap")
        local function root()
            return vim.fs.root(0, { "dune-project", "dune-workspace", ".git" }) or vim.fn.getcwd()
        end

        dap.adapters.ocaml_earlybird = function(callback, configuration)
            local available = vim.system({ "opam", "exec", "--", "which", "ocamlearlybird" }, {
                cwd = configuration.cwd, text = true,
            }):wait()
            if available.code ~= 0 then
                error("Earlybird is not installed in the selected opam switch")
            end
            callback({
                type = "executable",
                command = "opam",
                args = { "exec", "--", "ocamlearlybird", "debug" },
                options = { cwd = configuration.cwd },
            })
        end

        dap.configurations.ocaml = {
            {
                name = "OCaml bytecode (Earlybird)",
                type = "ocaml_earlybird",
                request = "launch",
                program = function()
                    return vim.fn.input("Bytecode (.bc): ", root() .. "/_build/default/bin/main.bc", "file")
                end,
                cwd = root,
                stopOnEntry = true,
                source_dirs = { ".", "lib", "bin" },
            },
        }

        local function mappings(bufnr)
            local actions = {
                md = { dap.continue, "OCaml: Start/continue debugger" },
                mb = { dap.toggle_breakpoint, "OCaml: Toggle breakpoint" },
                mo = { dap.step_over, "OCaml: Debug step over" },
                mI = { dap.step_into, "OCaml: Debug step into" },
                mO = { dap.step_out, "OCaml: Debug step out" },
                mq = { dap.terminate, "OCaml: Stop debugger" },
            }
            for key, action in pairs(actions) do
                vim.keymap.set("n", "<localleader>" .. key, action[1], {
                    buffer = bufnr, silent = true, desc = action[2],
                })
            end
        end
        vim.api.nvim_create_autocmd("FileType", {
            group = vim.api.nvim_create_augroup("OcamlDebugKeymaps", { clear = true }),
            pattern = "ocaml",
            callback = function(event)
                mappings(event.buf)
            end,
        })
        if vim.bo.filetype == "ocaml" then
            mappings(vim.api.nvim_get_current_buf())
        end
    end,
}
