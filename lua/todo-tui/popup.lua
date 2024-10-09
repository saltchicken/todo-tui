local keep_popup = {}

local popup = require("plenary.popup")
local git = require("todo-tui.git")

local Win_id

function CloseMenu()
	-- print("Closing :" .. Win_id)
	vim.api.nvim_win_close(Win_id, true)
end

keep_popup.show_menu = function(opts, cb)
	local screen_width = vim.o.columns
	local screen_height = vim.o.lines
	local popup_width = math.floor(screen_width * 0.9)
	local popup_height = math.floor(screen_height * 0.4)
	-- local popup_height = 40
	-- local popup_width = 60
	local borderchars = { "─", "│", "─", "│", "╭", "╮", "╯", "╰" }

	Win_id = popup.create(opts.contents, {
		title = opts.title,
		highlight = "TODOHIGHLIGHT",
		line = math.floor(((vim.o.lines - popup_height) / 2) - 1),
		col = math.floor((vim.o.columns - popup_width) / 2),
		minwidth = popup_width,
		minheight = popup_height,
		borderchars = borderchars,
		callback = cb,
		wrap = true,
	})
	-- print("Opening: " .. Win_id)
	local bufnr = vim.api.nvim_win_get_buf(Win_id)

	-- TODO: Actually set this to something that kills the window. Not implemented
	vim.api.nvim_buf_set_keymap(bufnr, "n", "q", "<cmd>lua CloseMenu()<CR>", { silent = false })
	-- TODO: Add a function that does pull

	vim.api.nvim_create_autocmd({ "BufWipeout", "BufDelete" }, {
		buffer = bufnr,
		callback = function()
			git.add_commit_push()
		end,
	})
end

keep_popup.pull_then_show_menu = function(opts, cb)
	git.pull:after(function()
		keep_popup.wrapped_insert_show_menu(opts, cb)
	end)
	git.pull:start()
end

keep_popup.wrapped_insert_show_menu = function(opts, cb)
	vim.schedule_wrap(function()
		keep_popup.show_menu(opts, cb)
	end)()
end

-- TESTING TESTING TESTING
--
-- TESTING TESTING TESTING

keep_popup.show_yes_no_prompt = function(question, cb)
	local width = 40
	local height = 10
	local bufnr = vim.api.nvim_create_buf(false, true)

	local win_id = popup.create(bufnr, {
		title = "Prompt",
		highlight = "Normal",
		line = math.floor((vim.o.lines - height) / 2),
		col = math.floor((vim.o.columns - width) / 2),
		minwidth = width,
		minheight = height,
		border = true,
	})

	vim.api.nvim_buf_set_lines(bufnr, 0, -1, false, { question })
	vim.api.nvim_buf_set_lines(bufnr, 2, -1, false, { "Press 'y' for yes, 'n' for no" })

	local function handle_input(char)
		vim.api.nvim_win_close(win_id, true)
		if char == "y" then
			cb(true)
		elseif char == "n" then
			cb(false)
		else
			print("Invalid input, try again")
		end
	end

	vim.api.nvim_buf_set_keymap(bufnr, "n", "y", "", {
		callback = function()
			handle_input("y")
		end,
	})
	vim.api.nvim_buf_set_keymap(bufnr, "n", "n", "", {
		callback = function()
			handle_input("n")
		end,
	})
end

keep_popup.create_split_popup = function()
	local width = 60
	local height = 20

	local bufnr = vim.api.nvim_create_buf(false, true)

	local win_id = popup.create(bufnr, {
		title = "Split Popup",
		highlight = "Normal",
		line = math.floor((vim.o.lines - height) / 2),
		col = math.floor((vim.o.columns - width) / 2),
		minwidth = width,
		minheight = height,
		border = true,
	})

	-- vim.api.nvim_set_current_win(win_id)
	-- vim.api.nvim_command("vsplit")
	-- vim.cmd("vsplit")
	local second_bufnr = vim.api.nvim_create_buf(false, true)
	local second_win_id = vim.api.nvim_get_current_win()

	vim.api.nvim_buf_set_lines(bufnr, 0, -1, false, { "This is buffer 1" })

	-- vim.api.nvim_win_set_buf(win_id, second_bufnr)
	-- vim.api.nvim_buf_set_lines(second_bufnr, 0, -1, false, { "This is buffer 2" })

	vim.api.nvim_buf_set_keymap(bufnr, "n", "q", "<cmd>q<CR>", { noremap = true, silent = true })
	vim.api.nvim_buf_set_keymap(second_bufnr, "n", "q", "<cmd>q<CR>", { noremap = true, silent = true })

	vim.api.nvim_buf_set_keymap(bufnr, "n", "q", "", {
		callback = function()
			vim.api.nvim_win_close(win_id, true)
			vim.api.nvim_win_close(second_win_id, true)
		end,
	})
end

local function create_floating_window(width, height, col, row)
	local buf = vim.api.nvim_create_buf(false, true)

	local win_opts = {
		relative = "editor",
		width = width,
		height = height,
		col = col,
		row = row,
		style = "minimal",
		border = "none",
	}

	local win = vim.api.nvim_open_win(buf, true, win_opts)
	return win, buf
end

keep_popup.create_floating_window = function()
	create_floating_window(40, 10, 0, 0)
end

keep_popup.create_floating_window_test = function()
	local win1, buf1 = create_floating_window(40, 10, 0, 0)
	local win2, buf2 = create_floating_window(40, 10, 42, 0)

	vim.api.nvim_buf_set_lines(buf1, 0, -1, false, {
		"This is a floating window!",
		"Press 'q' to close.",
	})

	-- Set key mapping to close the window when 'q' is pressed
	vim.api.nvim_buf_set_keymap(buf1, "n", "q", "", {
		noremap = true,
		silent = true,
		callback = function()
			vim.api.nvim_win_close(win1, true)
		end,
	})

	-- Optional: Additional buffer/window options
	-- vim.api.nvim_buf_set_option(buf, 'modifiable', false) -- Make buffer read-only
	-- vim.wo.modifiable = false
	-- vim.api.nvim_win_set_option(win, 'cursorline', true) -- Highlight the current line
	-- vim.wo.cursorline = true
end

-- TESTING TESTING TESTING
--
-- TESTING TESTING TESTING

return keep_popup
