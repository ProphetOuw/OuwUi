local mt = {}
mt.__index = mt;
--<
local Menum = require(script.Parent.Parent.Parent.Parent.Utility.Menum)
local Signal = require(script.Parent.Parent.Parent.Parent.Utility.FastSignal)
-->
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
	-- Destroy the Changed signal
	if self.Changed then
		self.Changed:Destroy()
		self.Changed = nil
	end

	-- Clear the Value and Default properties
	self.Value = nil
	self.Default = nil

	-- Notify the Cleaner if applicable
	if self.Cleaner then
		self.Cleaner:Remove(self)
		self.Cleaner = nil
	end

	-- Clear all other references
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
	self.Changed = Signal.new()
	Cleaner:Add(self.Changed,"Destroy")
	return self;
end