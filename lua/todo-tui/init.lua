local todo_tui = {}

local git = require("todo-tui.git")
local file = require("todo-tui.file")
local keep_popup = require("todo-tui.popup")
local keymaps = require("todo-tui.keymaps")

local Windows = require("windows"):new()

todo_tui.setup = function(opts)
	git.setup(opts)
	keymaps.set_keymaps()
	file.setup(opts)
end

function KeepTodo()
	local filename = "todo.txt"
	local contents = file.read_file(filename)

	local opts = {
		width = 40,
		height = 10,
		col = 0,
		row = 0,
		on_exit = function()
			file.write_current_to_file(filename)
			git.add_commit_push()
		end,
	}

	Windows:floating_window(opts, contents)
end

-- TODO: Repeated code with KeepTodo. Might be a better way
function KeepCommands()
	local filename = "commands.txt"
	local contents = file.read_file(filename)

	local opts = {
		width = 40,
		height = 10,
		col = 0,
		row = 0,
		on_exit = function()
			file.write_current_to_file(filename)
			git.add_commit_push()
		end,
	}

	Windows:floating_window(opts, contents)
end

function TestPopup()
	-- local question = "Would you like to continue"
	-- local cb = function(sel)
	-- 	print(sel)
	-- end
	-- keep_popup.show_yes_no_prompt(question, cb)
	local cb_yes = function()
		print("Yes")
	end
	local cb_no = function()
		print("No")
	end

	Windows:yes_no_prompt("Would you like to continue?", cb_yes, cb_no)
end

function TestSplit()
	-- keep_popup.create_split_popup()
	-- keep_popup.create_floating_window_test()
	local opts = {
		width = 40,
		height = 10,
		col = 0,
		row = 0,
		on_exit = function()
			print("Window exitted")
		end,
	}
	Windows:floating_window(opts, { "Hello there" })
end

return todo_tui
