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

return keep_popup
