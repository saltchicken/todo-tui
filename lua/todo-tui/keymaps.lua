local keymaps = {}

local function test_function()
	print("testing")
end

keymaps.set_keymaps = function()
	-- TODO: Fix augroup naming
	local augroup = vim.api.nvim_create_augroup("Keep", { clear = true })
	vim.api.nvim_create_autocmd("VimEnter", {
		group = augroup,
		desc = "Set keymaps",
		once = true,
		callback = function()
			vim.keymap.set("n", "<leader>kt", KeepTodo, { noremap = false, silent = true })
			vim.keymap.set("n", "<leader>kc", KeepCommands, { noremap = false, silent = true })
		end,
	})
end

return keymaps
