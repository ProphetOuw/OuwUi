# OuwUI
> [!Note]
> Coded by ProphetOuw somewhere in 2024. went public on the 26th of december, 2024.
## Project setup
You can use this module in any setup, or code block, but the ideal setup would be as follows:
```lua
local OuwUI = require(script.Parent.OuwUI)
return function(Parent,...)
    return function() --cleanup function

    end
end
```
If you use a UI visualizing plugin, this is the setup they will most likely want you to use.
## Scopes
Scopes are workspaces, for the UI framework.
### Why are scopes important?
Scopes help us clean all of the different stuff we create later on, this is why it is mandatory to use here.
### How to create scopes
