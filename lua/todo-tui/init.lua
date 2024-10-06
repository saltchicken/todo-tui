local todo_tui = {}

local git = require("todo-tui.git")
local file = require("todo-tui.file")
local keep_popup = require("todo-tui.popup")
local keymaps = require("todo-tui.keymaps")

todo_tui.setup = function(opts)
	git.setup(opts)
	keymaps.set_keymaps()
	file.setup(opts)
end

function KeepTodo()
	local opts = {}
	opts.title = "TODO"
	local filename = "todo.txt"
	opts.contents = file.read_file(filename)
	local cb = function(_, sel)
		file.write_current_to_file(filename)
	end
	keep_popup.show_menu(opts, cb)
end

-- TODO: Repeated code with KeepTodo. Might be a better way
function KeepCommands()
	local opts = {}
	opts.title = "COMMANDS"
	local filename = "commands.txt"
	opts.contents = file.read_file(filename)
	local cb = function(_, sel)
		file.write_current_to_file(filename)
	end
	keep_popup.show_menu(opts, cb)
end

return todo_tui
