# request.nvim
Why should you need to leave your favorite editor to make API requests?  
A neovim api request client written in Lua

![Screenshot](assets/20240907-screenshot.png)

## Documentation
See also `:help request.nvim`.

### Setup
If you're using [Lazy.nvim](https://github.com/folke/lazy.nvim)
```lua
{
-- other plugins
    "kongreif/request.nvim",
-- other plugins
}
```

### UI
Open the request.nvim window via `:Request`.  
Command keys are shown in `[ ]`, e.g. `[U]` to start inserting the request URL.  
Hitting `Enter` will perform the request and show the response.

The post params are expected in valid JSON.

So far only get and post requests can be performed via the UI.

### Commands
You can try out the [commands](https://github.com/kongreif/request.nvim/blob/main/lua/request/commands.lua) in Neovim's command mode like this:
```lua
:lua print(require("request").get("https://jsonplaceholder.typicode.com/posts/1"))

:lua print(require("request").post("https://jsonplaceholder.typicode.com/posts", { userId = 1, title = 'foo', body = 'bar' }))
```

So far get and post are implemented.

## Contributing
### Cone the repo
```bash
git clone https://github.com/xyz/zipzod@latest
cd zipzod
```
### Add it to your packages
E.g.
```lua
"kongreif/request.nvim",
```
###  Run tests
Run tests in `/tests` via [plenary's test framework](https://github.com/nvim-lua/plenary.nvim/blob/master/TESTS_README.md).
### Submit a pull request
If you'd like to contribute, please fork the repository and open a pull request to the `main` branch.
