local todo_tui = {}

local popup = require("plenary.popup")

local Win_id

function ShowMenu(opts, cb)
	local height = 20
	local width = 30
	local borderchars = { "─", "│", "─", "│", "╭", "╮", "╯", "╰" }

	Win_id = popup.create(opts, {
		title = "MyProjects",
		highlight = "MyProjectWindow",
		line = math.floor(((vim.o.lines - height) / 2) - 1),
		col = math.floor((vim.o.columns - width) / 2),
		minwidth = width,
		minheight = height,
		borderchars = borderchars,
		callback = cb,
	})
	local bufnr = vim.api.nvim_win_get_buf(Win_id)
	vim.api.nvim_buf_set_keymap(bufnr, "n", "q", "<cmd>lua CloseMenu()<CR>", { silent = false })
end

function MyMenu()
	local opts = {
		"First line",
		"Second line",
		"Third line",
	}
	local cb = function(_, sel)
		-- vim.cmd("cd " .. sel)
		vim.cmd("echo " .. sel)
	end
	ShowMenu(opts, cb)
end

todo_tui.setup = function(opts) end

return todo_tui
