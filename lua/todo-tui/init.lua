local todo_tui = {}

local popup = require("plenary.popup")

local Win_id

function ShowMenu(opts, cb)
	local height = 40
	local width = 60
	local borderchars = { "─", "│", "─", "│", "╭", "╮", "╯", "╰" }

	Win_id = popup.create(opts, {
		title = "TODO",
		highlight = "TODO HIGHLIGHT",
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

-- Function to write to a file
local function write_file(filepath, content)
	local file = io.open(filepath, "w") -- open the file in write mode ("w" overwrites the file)
	if not file then
		vim.api.nvim_err_writeln("Could not open file: " .. filepath)
		return false
	end
	file:write(content) -- write the content to the file
	file:close() -- close the file
	return true
end

-- Example usage in your plugin

local success = write_file(filepath, content)

function MyMenu()
	local success = write_file("temp", "hello there")

	if success then
		print("File written successfully!")
	else
		print("Failed to write the file.")
	end
	-- local file = io.open("~/todo", "r")
	-- local file = { "hello", "there" }
	-- local opts = {}
	-- if file then
	-- 	for line in file:lines() do
	-- 		table.insert(opts, line)
	-- 	end
	-- else
	-- 	opts = { "Need file" }
	-- end
	-- Hardcorded opts
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
