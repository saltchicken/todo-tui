local todo_tui = {}

local popup = require("plenary.popup")
local git = require("todo-tui.git")

local Win_id

function ShowMenu(opts, cb)
	local screen_width = vim.o.columns
	local screen_height = vim.o.lines
	local popup_width = math.floor(screen_width * 0.9)
	local popup_height = math.floor(screen_height * 0.4)
	-- local popup_height = 40
	-- local popup_width = 60
	local borderchars = { "─", "│", "─", "│", "╭", "╮", "╯", "╰" }

	Win_id = popup.create(opts, {
		title = "TODO",
		highlight = "TODOHIGHLIGHT",
		line = math.floor(((vim.o.lines - popup_height) / 2) - 1),
		col = math.floor((vim.o.columns - popup_width) / 2),
		minwidth = popup_width,
		minheight = popup_height,
		borderchars = borderchars,
		callback = cb,
		wrap = true,
	})
	local bufnr = vim.api.nvim_win_get_buf(Win_id)
	vim.api.nvim_buf_set_keymap(bufnr, "n", "q", "<cmd>lua CloseMenu()<CR>", { silent = false })

	vim.api.nvim_create_autocmd({ "BufWipeout", "BufDelete" }, {
		buffer = bufnr,
		callback = function()
			git.add()
			git.commit()
			git.push()
		end,
	})

	git.pull()
end

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

local function write_current_to_file()
	local buf = vim.api.nvim_get_current_buf()
	local lines = vim.api.nvim_buf_get_lines(buf, 0, -1, false)

	write_file(git.repo_path .. "/" .. "todo.txt", table.concat(lines, "\n"))
end

function MyMenu()
	local file = io.open("/home/saltchicken/.local/share/keep/todo.txt", "r")
	local opts = {}
	if file then
		for line in file:lines() do
			table.insert(opts, line)
		end
	else
		opts = { "Need file" }
	end
	-- Hardcorded opts
	-- local opts = {
	-- 	"First line",
	-- 	"Second line",
	-- 	"Third line",
	-- }
	local cb = function(_, sel)
		-- vim.cmd("cd " .. sel)
		-- print(sel)
		write_current_to_file()
	end
	ShowMenu(opts, cb)
end

todo_tui.setup = function(opts) end

return todo_tui
