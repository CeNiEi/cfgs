return {
	"nvim-neorg/neorg",
	lazy = false, -- Disable lazy loading as some `lazy.nvim` distributions set `lazy = true` by default
	version = "*", -- Pin Neorg to the latest stable release
	config = function()
		require("neorg").setup({
			load = {
				["core.defaults"] = {},
				["core.concealer"] = {},
				["core.dirman"] = {
					config = {
						workspaces = {
							conlang = "~/Documents/conlang/",
						},
					},
				},
				["core.keybinds"] = {},
				["core.journal"] = {
					config = {
						workspace = "~/Documents/journal",
					},
				},
			},
		})
	end,
}
