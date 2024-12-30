types = {

}
local TypesHolder = require(script.Parent.Parent.Misc.Types)
for i,v in pairs(script.SupportedTypes:GetChildren()) do
	types[v.Name] = require(v)
end
local mt = {}
function mt:AddWithIndex(Index,Value)
	local vg = rawget(self, "_Value")
	if vg ~= nil and vg["Add"] ~= nil then
		print("Do")
		vg:Add(Index,Value)
		return
	end
	warn(`This value type does not support the "AddWithIndex" function.`)
end
function mt.__add(Tab,New)
	local vg = rawget(Tab, "_Value")
	if vg ~= nil and vg["Add"] ~= nil then
		vg:Add(New)
	end
	return Tab
end
function mt.__sub(Tab,New)
	local vg = rawget(Tab, "_Value")
	if vg ~= nil and vg["Sub"] ~= nil then
		vg:Sub(New)
	end
	return Tab
end
function mt:Cleanup()
	local vg = rawget(self, "_Value")
	if vg ~= nil and vg["Cleanup"] ~= nil then
		vg:Destroy()
		print("Send destroy value")
	else
		rawset(self, "_Value", nil)
	end
end
mt.__index = function(Tab,Index)
	local vg = rawget(Tab, "_Value")
	if vg ~= nil then
		return vg[Index]
	end
	return (Tab ~= nil and rawget(Tab,Index)) or nil
end
mt.__call = function(Tab,Value)
	if Tab == nil then return end;
	local vg = rawget(Tab, "_Value")
	if vg ~= nil then
		if Value ~= nil then
			if vg ~= nil then
				vg:Set(Value)
			end;
		else
			return vg:Get()
		end
	end
end

function mt:Destroy()
	local vg = rawget(self, "_Value")
	if vg ~= nil then
		if vg["Destroy"] ~= nil then
			vg:Destroy()
		end
		rawset(self, "_Value", nil)
	else
		print("No _Value to clean up")
	end
	for k in pairs(self) do
		rawset(self, k, nil)
	end
	
	setmetatable(self, nil)
end

return function(Cleaner,newValue)
	--[[if newValue == nil then warn("You must provide a value when trying to initiate Scope.Value") return end;
	if newValue == "Instance" then warn("Instances are not accepeted") return end;]]
	local ty = typeof(newValue)

	local self = {}
	setmetatable(self,mt)
	do
		local handler = (types[ty] ~= nil and types[ty](Cleaner,newValue,ty)) or types["others"](Cleaner,newValue,ty)
		handler.__IsValue = true;
		self._Value = handler;
	end
	return self,true;
end