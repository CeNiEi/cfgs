vim.filetype.add({
	extension = {
		wgsl = "wgsl",
	},
})

vim.api.nvim_create_autocmd("FileType", {
	pattern = "wgsl",
	callback = function()
		vim.opt_local.expandtab = true
		vim.opt_local.shiftwidth = 4
		vim.opt_local.softtabstop = 4
		vim.opt_local.commentstring = "// %s"
	end,
})

vim.filetype.add({ extension = { slint = "slint" } })
