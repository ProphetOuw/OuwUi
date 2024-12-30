local signal = require(script.Parent.Parent:WaitForChild("Utility"):WaitForChild("FastSignal"))
local mt = {}
mt.__index = mt;
function mt:WatchValue(Value)
	if Value == nil then return end;
	local get = rawget(Value,"_Value")
	if get ~= nil then
		self.Cleaner:Connect(get.Changed,function()
			self.Update:Fire()
		end)
	end
	return get:Get()
end
mt.__call = function(self,ListeningEnabled)
	local IsFirst = false;
	if self.First == true then
		IsFirst = true;
		self.First = false;
	end
	return self.Function(function(ValueToWatch)
		if ListeningEnabled then
			if IsFirst then
				return self:WatchValue(ValueToWatch)
			else
				local get = rawget(ValueToWatch,"_Value")
				if get ~= nil then
					return get:Get()
				end
			end
		end;
	end,self.CurrentEntity);
end
function mt:Destroy()
	if self.Update then
		self.Update:Destroy()
		self.Update = nil
	end
	self.Function = nil
	self.Cleaner = nil
	for k in pairs(self) do
		rawset(self, k, nil)
	end
	setmetatable(self, nil)
end

return function(Cleaner,Func)
	local self = {}
	setmetatable(self,mt)
	self.__Type = "Compute"
	self.Cleaner = Cleaner;
	self.Function = Func
	self.Update = signal.new()
	self.First = true
	Cleaner:Add(self.Update,"Destroy")
	return  self,true;
end