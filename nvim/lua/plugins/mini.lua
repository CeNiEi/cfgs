return {
	"echasnovski/mini.nvim",
	version = false,
	config = function()
		require("mini.surround").setup({
			n_lines = 200,
		})
		require("mini.ai").setup({})
	end,
}
