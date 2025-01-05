local local_plugins = {
    {
        "git_worktree",
        dir = "~/projects/git-worktree.nvim/master",
        dependencies = {
            'nvim-lua/plenary.nvim'
        },

        config = function ()
            -- Defaults
            require("git-worktree").setup({
                change_directory_command = "cd", -- default: "cd", alt "tcd".
                update_on_change = true, -- default: true,
                update_on_change_command = "e .", -- default: "e .",
                confirm_telescope_deletions = true, -- Default: true. Don't accidentally delete a branch
                clearjumps_on_change = true, -- default: true,
                autopush = true -- default: false,
            })
        end

    },
}

return local_plugins
