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

return file
