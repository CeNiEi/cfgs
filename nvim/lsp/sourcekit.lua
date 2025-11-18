---@brief
---
--- https://github.com/swiftlang/sourcekit-lsp
---
--- Language server for Swift and C/C++/Objective-C.

---@type vim.lsp.Config
return {
	cmd = { "sourcekit-lsp" },
	filetypes = { "swift", "objc", "objcpp", "c", "cpp" },
	root_dir = function(bufnr, on_dir)
		local filename = vim.api.nvim_buf_get_name(bufnr)

		local function try(patterns)
			local found = vim.fs.find(patterns, { path = filename, upward = true })[1]
			if found then
				on_dir(vim.fs.dirname(found))
				return true
			end
			return false
		end

		if try({ "buildServer.json", ".bsp" }) then
			return
		end
		if try({ "*.xcodeproj", "*.xcworkspace" }) then
			return
		end
		if try({ "compile_commands.json", "Package.swift" }) then
			return
		end
		if try({ ".git" }) then
			return
		end
	end,
	get_language_id = function(_, ftype)
		local t = { objc = "objective-c", objcpp = "objective-cpp" }
		return t[ftype] or ftype
	end,
	capabilities = {
		workspace = {
			didChangeWatchedFiles = {
				dynamicRegistration = true,
			},
		},
		textDocument = {
			diagnostic = {
				dynamicRegistration = true,
				relatedDocumentSupport = true,
			},
		},
	},
}
