local mt = {}
mt.__index = mt;

function mt.__call(self)
	local Get = self.Values
	if typeof(Get) ==  "table" then
		local rg = rawget(Get,"_Value")
		if rg ~= nil then
			Get = Get:Get()
		end
	end
	local NewT = {}
	for i,v in pairs(Get) do
		local Index,Value = self.Function(i,v)
		if Value == nil then
			table.insert(NewT,Index)
		else
			NewT[Index] = Value;
		end 
	end
	return NewT;
end
function mt:Destroy()
	self.Values = nil
	self.Function = nil
	for k in pairs(self) do
		rawset(self, k, nil)
	end
	setmetatable(self, nil)
end

return function(Cleaner,TableValue,Func)
	if TableValue == nil then warn("Value is missing for the ForPairs method.") return end;
	local self = {}
	setmetatable(self,mt)
	self.__Type = "ForPairs"
	self.Values = TableValue
	self.Function = Func
	return self,true
end