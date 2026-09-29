return {
    "doriancmore/practice.nvim",
    config = function()
        local practice = require('practice')
        practice.setup()
        vim.keymap.set("n", "<leader>pz", function()
            practice.open(10)
        end, { desc = "Practice" })
    end
}
