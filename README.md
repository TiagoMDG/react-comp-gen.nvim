# React Component Generator

### Introduction

The React Component Generator is a Neovim plugin designed to streamline the process of creating React components by generating the necessary files and directory structure with a single command:

`:CreateComponent <ComponentName> [FileExtension]`

![Alt Text](https://i.imgur.com/25RVelr.gif)

#### Main Features

- **Component Generation**:
    - Automatically creates component directories and files.
    - Converts component names to PascalCase.
    - Works with both JSX and TSX file formats.

<br>

- **Customization Options**:
    - Allows users to use their own templates.
    - Provides flexibility with custom template directories.
   
<br>

- **Command-Line Interface**:
    - User-friendly commands for component generation.
    - Supports multiple arguments for seamless usage.

<br>

- **Configuration**:
    - Offers options to set default settings.
    - Configurable file extension for generated components.


## Installation

Install with [lazy.nvim](https://github.com/folke/lazy.nvim):

Add this to your `init.lua or plugins.lua`

```lua
{
  "TiagoMDG/react-comp-gen.nvim",
  name = "react-component-generator",
  config = function()
    require("react-component-generator").setup({
      templates_dir = "~/custom-templates-directory", -- Custom templates directory (Optional)
      file_extension = "tsx", -- Preferred file extension (Optional)
    })
  end,
}
```

Setup a template directory and preferred file extension otherwise it will use the default values. 

Default templates location: `<plugin_directory>/templates/index_tsx_template.tsx`

Default file extension: `tsx`

When creating template files be sure to follow the naming convention used in the plugin `index_<file_extension>_template.<file_extension>.tsx`

And then inside your template set the placeholders for the component name like this `{{ComponentName}}`

```js
import './styles.css';

const {{ComponentName}} = () => {
  return (
    <div className="{{ComponentName}}">
      <h1>{{ComponentName}} Component</h1>
    </div>
  );
}

export default {{ComponentName}};
```
## Usage

It's simple, just use the command and start coding!

`:CreateComponent <ComponentName> [FileExtension]`

It also creates a CSS file inside the component's structure.

```css
.ComponentName{
    /* Add your styles here */
}

```

## Contributing
Contributions to the React Component Generator plugin are welcome! <br>
Feel free to open an issue for bug reports, feature requests, or submit a pull request to contribute code improvements.

## License
This project is licensed under the MIT License. See the LICENSE file for details.
