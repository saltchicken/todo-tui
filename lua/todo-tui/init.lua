local todo_tui = {}

local git = require("todo-tui.git")
local file = require("todo-tui.file")
local keep_popup = require("todo-tui.popup")

local repo_path
todo_tui.setup = function(opts)
	git.setup(opts)
	repo_path = opts.repo_path
	require("todo-tui.keymaps").set_keymaps()
end

local function write_current_to_file()
	local buf = vim.api.nvim_get_current_buf()
	local lines = vim.api.nvim_buf_get_lines(buf, 0, -1, false)

	file.write_file(git.repo_path .. "/" .. "todo.txt", table.concat(lines, "\n"))
end

function KeepTodo()
	local opts = {}
	opts.title = "TODO"
	local filepath = repo_path .. "/todo.txt"
	opts.contents = file.read_file(filepath)
	local cb = function(_, sel)
		write_current_to_file()
	end
	keep_popup.show_menu(opts, cb)
end

return todo_tui
