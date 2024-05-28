local utils = require("react-component-generator.utils")

-- Define the default template directory
local default_template_dir = utils.get_plugin_dir() .. "/templates/"
local default_file_extension = "tsx"

-- Generate React component
local function GenerateComponent(component_name, template_dir, config)
	-- Null check component name
	if component_name == nil or component_name == "" then
		print("You must provide a component name")
		return
	end

	-- Remove any extension and preceding whitespace from the component name
	local component_name_trimmed, file_extension = component_name:match("(%S+)%s*(%w*)$")
	component_name = component_name_trimmed

	-- Convert the component name to PascalCase
	local pascal_case_name = utils.to_pascal_case(component_name)

	-- Get the current working directory
	local current_dir = vim.fn.getcwd()

	-- Set the directory path
	local dir_path = current_dir .. "/src/app/components/" .. pascal_case_name

	-- Create the component directory
	if not utils.create_directory(dir_path) then
		return
	end

	-- Determine the file extension
	file_extension = file_extension ~= "" and file_extension or config.file_extension or default_file_extension

	-- Read the index template from the specified template directory
	local template_file = "index_" .. file_extension .. "_template." .. file_extension
	local index_template_path = template_dir .. "/" .. template_file
	local index_template = utils.read_file(index_template_path)

	-- If the template content is nil, attempt to read from the default template directory
	if not index_template and template_dir ~= default_template_dir then
		index_template_path = default_template_dir .. "/" .. template_file
		index_template = utils.read_file(index_template_path)
	end

	if not index_template then
		print("Error: Unable to read index template")
		return
	end

	-- Replace placeholders with the actual component name
	local index_content = index_template:gsub("{{ComponentName}}", pascal_case_name)

	-- Write the index file
	local index_file = dir_path .. "/index." .. file_extension
	if not utils.write_file(index_file, index_content) then
		return
	end

	-- Create the styles file
	local styles_file = dir_path .. "/styles.css"
	local styles_content = "." .. pascal_case_name .. [[ {
    /* Add your styles here */
}
]]
	if not utils.write_file(styles_file, styles_content) then
		return
	end

	-- Print success message
	print("Component " .. pascal_case_name .. " created successfully in " .. dir_path)
end

local function setup(config)
	config = config or {}

	-- Ensure the command is created only once
	if vim.g.react_component_generator_commands_created then
		return
	end

	-- Create the user command for generating components
	vim.api.nvim_create_user_command("CreateComponent", function(opts)
		-- Set template directory
		local templates_dir = config.templates_dir and vim.fn.expand(config.templates_dir) or default_template_dir
		local file_extension = config.file_extension or default_file_extension

		-- Call the GenerateComponent function
		GenerateComponent(opts.args, templates_dir, { file_extension = file_extension })

		-- Check if NeoTree is installed and refresh if it is
		if pcall(require, "neo-tree.sources.filesystem.commands") then
			require("neo-tree.sources.filesystem.commands").refresh(
				require("neo-tree.sources.manager").get_state("filesystem")
			)
		end
	end, { nargs = "*" })

	-- Mark commands as created
	vim.g.react_component_generator_commands_created = true
end

return { setup = setup }
