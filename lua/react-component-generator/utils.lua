local M = {}

-- Convert string to PascalCase
function M.to_pascal_case(str)
	return str:gsub("(%a)([%w_']*)", function(first, rest)
		return first:upper() .. rest:lower()
	end):gsub("_", "")
end

-- Read file content
function M.read_file(path)
	local file, err = io.open(path, "r")
	if not file then
		print("Error: Unable to read file at " .. path .. ". Error: " .. err)
		return nil
	end
	local content = file:read("*all")
	file:close()
	return content
end

-- Get script current directory
function M.get_plugin_dir()
	local str = debug.getinfo(1, "S").source:sub(2)
	return str:match("(.*/)") .. "../.." -- Adjust to get the root directory of the plugin
end

-- Create a directory if it doesn't exist
function M.create_directory(path)
	local uv = vim.loop
	local ok, err = uv.fs_mkdir(path, 511) -- 511 corresponds to 0777 permissions
	if not ok and not err:match("EEXIST") then
		print("Error: Unable to create directory at " .. path .. ". Error: " .. err)
		return false
	end
	return true
end

-- Write content to file
function M.write_file(path, content)
	local file, err = io.open(path, "w")
	if not file then
		print("Error: Unable to write file at " .. path .. ". Error: " .. err)
		return false
	end
	file:write(content)
	file:close()
	return true
end

return M
