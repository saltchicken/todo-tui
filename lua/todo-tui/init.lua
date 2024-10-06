local todo_tui = {}

local git = require("todo-tui.git")
local file = require("todo-tui.file")
local keep_popup = require("todo-tui.popup")
local keymaps = require("todo-tui.keymaps")

local repo_path
todo_tui.setup = function(opts)
	git.setup(opts)
	keymaps.set_keymaps()
	repo_path = opts.repo_path
end

function KeepTodo()
	local opts = {}
	opts.title = "TODO"
	local filepath = repo_path .. "/todo.txt"
	opts.contents = file.read_file(filepath)
	local cb = function(_, sel)
		file.write_current_to_file(filepath)
	end
	keep_popup.show_menu(opts, cb)
end

return todo_tui
