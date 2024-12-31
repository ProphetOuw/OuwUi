script.Parent:WaitForChild("CompileProperties")
local CompileProperties = require(script.Parent.CompileProperties);


return function(Inst,IsHydrate)
    print(Inst,IsHydrate)
    return function(Properties)
        
    end
end
