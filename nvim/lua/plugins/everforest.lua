return {
	"sainnhe/everforest",
	lazy = false,
	priority = 1000,
	config = function()
		vim.g.everforest_background = "medium" -- Choose 'hard', 'medium', or 'soft'
		vim.g.everforest_enable_italic = 1
		vim.g.everforest_disable_italic_comment = 0
		vim.g.everforest_diagnostic_text_highlight = 1
		vim.g.everforest_diagnostic_line_highlight = 1
		vim.g.everforest_diagnostic_virtual_text = "colored"

		vim.cmd("colorscheme everforest") -- Apply the colorscheme
	end,
}
