local mt = {}
mt.__index = mt;
--<
local Menum = require(script.Parent.Parent.Parent.Parent.Utility.Menum)
local Signal = require(script.Parent.Parent.Parent.Parent.Utility.FastSignal)
-->
local bannedTypes = {
	--"table",
}
function mt:AddWithIndex(Index,Value)
	return self:Add(Index,Value)
end
function mt:Add(Index,New)
	if New == nil then
		New = Index
		Index = nil;
	end
	if New == nil then return end;
	local Typ = typeof(New)
	if table.find(bannedTypes,Typ) then warn(`The add function does not work for complex types like {Typ}s.`) return end;
	if Index ~= nil then
		self.Value[Index] = New;
	else
		table.insert(self.Value,New)
	end
	self.NewAdded:Fire(table.find(self.Value,New),New)
end
function mt:Sub(New)
	if New == nil then return end;
	local Typ = typeof(New)
	if table.find(bannedTypes,Typ) then warn(`The add function does not work for complex types like {Typ}s.`) return end;
	local Find = table.find(self.Value,New)
	if Find then
		table.remove(self.Value,Find)
		self.NewRemoved:Fire(Find,New)
	end
end
function mt:Get()
	return self.Value;
end
function mt:Set(new)
	if new ~= nil then
		if self.Value ~= new then
			self.Value = new;
			self.Changed:Fire(new)
		end
	end
end
function mt:Destroy()

	if self.Changed then
		self.Changed:Destroy()
		self.Changed = nil
	end
	if self.NewAdded then
		self.NewAdded:Destroy()
		self.NewAdded = nil
	end
	if self.NewRemoved then
		self.NewRemoved:Destroy()
		self.NewRemoved = nil
	end

	self.Value = nil
	self.Default = nil

	if self.Cleaner then
		self.Cleaner:Remove(self)
		self.Cleaner = nil
	end

	for k in pairs(self) do
		self[k] = nil
	end
end

return function(Cleaner,newvalue)
	local self = {}
	setmetatable(self,mt)
	self.__Type = script.Name;
	self.Default = newvalue;
	self.Value = newvalue;
	self.Cleaner = Cleaner
	self.NewAdded = Signal.new()
	self.NewRemoved = Signal.new()
	self.Changed = Signal.new()
	Cleaner:Add(self.Changed,"Destroy")
	Cleaner:Add(self.NewAdded,"Destroy")
	Cleaner:Add(self.NewRemoved,"Destroy")
	return self;
end