local m = {}
local Janitor = require(script.Utility.janitor)

local Types = require(script.Utility.Types)

function m.New()
    local obj: Types.OuwUIType = {
        Cleaner = Janitor.new(),
        New = function() -- creating new objects
         
        end,
        Hydrate = function() --hydrating existing objects
            
        end,
        Clean = function()
            
        end
    };
    return obj;
end

return m