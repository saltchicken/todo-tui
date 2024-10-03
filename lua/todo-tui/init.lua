local todo_tui = {}

todo_tui.setup = function(opts)
	-- require("nvim-ollama-pilot.request").setup(opts)
	print("hello world")
	local nui = require("nui")
	local popup = require("nui.popup")

	local win = popup({
		enter = true,
		focusable = true,
		border = {
			style = "single",
			text = {
				top = "Your TUI",
				top_align = "center",
			},
		},
		position = "50%",
		size = {
			width = 80,
			height = 20,
		},
		buf_options = {
			modifiable = true,
			readonly = false,
		},
	})

	win:mount()

	-- Set up keymaps to close or handle inputs
	win:on("BufLeave", function()
		win:unmount()
	end)
end

return todo_tui
