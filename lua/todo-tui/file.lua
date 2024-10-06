local file = {}

file.write_file = function(filepath, content)
	local f = io.open(filepath, "w") -- open the file in write mode ("w" overwrites the file)
	if not f then
		vim.api.nvim_err_writeln("Could not open file: " .. filepath)
		return false
	end
	f:write(content) -- write the content to the file
	f:close() -- close the file
	return true
end

file.read_file = function(filepath)
	local f = io.open(filepath, "r")
	local opts = {}
	if f then
		for line in f:lines() do
			table.insert(opts, line)
		end
	else
		vim.api.nvim_err_writeln("Could not open file: " .. filepath)
		opts = nil
	end
	return opts
end

file.write_current_to_file = function(filepath)
	local buf = vim.api.nvim_get_current_buf()
	local lines = vim.api.nvim_buf_get_lines(buf, 0, -1, false)

	file.write_file(filepath, table.concat(lines, "\n"))
end

return file
