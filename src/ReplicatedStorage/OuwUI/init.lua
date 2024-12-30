local Cleaners = script:WaitForChild("Cleaners")
local Setters = script:WaitForChild("Setters")
local Misc = script:WaitForChild("Misc")
local Instances = script:WaitForChild("Instances")
local Animations = script:WaitForChild("Animation")
local Types = require(Misc.Types)
local Cleaner = require(Cleaners.Janitor)
local m = {
	--< methods
	AutoAdd = {
		Hydrate = require(Instances.Hydrate);
		Create = require(Instances.New);
		Value = require(Setters.Value);
		Compute = require(Setters.Compute);
		ForPairs = require(Setters.ForPairs)
	};
	Spring = require(Animations.OuwSpring);
	SpringInfo = require(Animations.OuwSpring.SpringInfo);
	TwInfo = require(Animations.OuwTween.TweenInfo);
	Tween = require(Animations.OuwTween);
	-->
}

function m:Init(CleanerToExtendFrom,Extend)
	local self = {};
	--< methods
	function self:Add(...)
		self.Cleaner:Add(...)
	end
	function self:Remove(...)
		self.Cleaner:Remove(...)
	end
	function self:Connect(connect,func)
		self.Cleaner:Add(connect:Connect(func),"Disconnect")
	end
	function self:Clean()
		self.Cleaner:Destroy();
	end
	-->
	local CleanerAlready = nil;
	if CleanerToExtendFrom ~= nil then
		if Extend then
			CleanerAlready = Cleaner.new();
			CleanerToExtendFrom:Add(CleanerAlready,"Destroy")
		else
			CleanerAlready = CleanerToExtendFrom
		end
	end
	self.Cleaner = (CleanerAlready) or Cleaner.new()
	self.__type = "Scope"
	self.Extend = function()
		local NewSc =m:Init(self,true)
		return NewSc
	end

	for i,v in (m.AutoAdd) do
		self[i] = function(...)
			local ret,destroy = v(self,...)
			if destroy == true then
				self:Add(ret,"Destroy")
			end
			return ret
		end
	end
	self.SpringInfo = m.SpringInfo
	self.TweenInfo = m.TwInfo
	self.Spring = function(Goal: any,SpringInfo: Types.SpringInfoType,Indexes)
		local Sp = m.Spring(Goal,SpringInfo,Indexes)
		self:Add(Sp,"Destroy")
		return Sp
	end
	self.Tween = function(Goal:any ,Info: TweenInfo,Indexes)
		local Tw = m.Tween(Goal,Info,Indexes)
		self:Add(Tw,"Destroy")
		return Tw;
	end
	return self;
end

return m