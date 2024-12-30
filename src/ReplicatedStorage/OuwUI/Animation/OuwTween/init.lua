local RunService = game:GetService("RunService")
--<
local Functions = require(script:WaitForChild("Functions"))
local TypeLerpers = require(script:WaitForChild("Lerps"))
script.Parent.Parent.Utility:WaitForChild("FastSignal")
local Signal = require(script.Parent.Parent.Utility.FastSignal)
-->
local mt = {}
mt.__index = mt;
function mt.__call(self)
	self.SetToGoalOnNextPlay = true;
	return self;
end
function mt:addSingle(Info)
	if Info == nil or Info[1] == nil and Info[2] == nil then warn("Some parameters are missing") return end;
	local First = (typeof(Info[1]) == "table" and Info[1].Instance) or Info[1]
	table.insert(self._Listeners,{
		Entity = First;
		Property = Info[2];
		Initial = First[Info[2]];
	})
end
function mt:Play()
	if self.Destroyed == true then return end;
	if self.Goal == nil then warn("Goal is missing for tween.") return end;
	self.PlaybackState = Enum.PlaybackState.Playing
	local ElN = self.Elapsed;
	if ElN ~= nil and ElN >0 then
		if self.Resumed ~= nil then
			self.Resumed:Fire()
		end
	end
	if self.PlaybackConnection then
		self.PlaybackConnection:Disconnect()
		self.PlaybackConnection = nil
	end
	--<
	local One = false;
	for i,v in pairs(self._Listeners) do
		One = true;
		v.Initial = v.Entity[v.Property]
	end
	if One == false then
		self:Destroy()
		return;
	end
	-->
	local function SetValue(New)
		local Exists = false;
		if self._Listeners == nil then return end;
		for i,v in pairs(self._Listeners) do
			if v.Entity ~= nil and v.Entity.Parent ~= nil then
				Exists = true;
				local In = self.Goal
				local Out = v.Initial
				v.Entity[v.Property] = TypeLerpers[typeof(In)](Out,In)(New)
			end
		end
		if Exists == false then
			self:Destroy()
		end
	end
	local function PlayIn()
		local TimeToAdd = ((ElN ~= nil and ElN) or 0)
		if ElN ~= nil then
			ElN = nil;
		end
		local started = os.clock()-TimeToAdd
		if self.PlaybackConnection ~= nil then
			self.PlaybackConnection:Disconnect()
			self.PlaybackConnection = nil
		end
		self.PlaybackConnection = self._Step:Connect(function(tm)
			self.Elapsed = (os.clock()-started) + tm
			local RealElasped = math.clamp((self.Elapsed-((self.ReverseType ~= true and self.DelayTime) or 0 ))/self.Time,0,1)
			if self.SetToGoalOnNextPlay then
				RealElasped = 1;
				self.SetToGoalOnNextPlay = nil;
			end
			if RealElasped >= 1 then
				SetValue((self.Reverse == true and self.ReverseType == true and 0) or 1)
				if self.Reverse == true and self.ReverseType ~= true then
					self.ReverseType = true;
					PlayIn()
				else
					if self.IsRepeatFinal == nil or self.IsRepeatFinal == 0 then
						if self.Completed ~= nil then
							self.Completed:Fire()
						end
						self:Stop(true)
						if self.DestroyOnComplete == true then
							self:Destroy()
						end
					else
						do
							if self.IsRepeatFinal >0 then
								self.IsRepeatFinal -=1
							end
							self.ReverseType = nil;
							PlayIn()
						end
					end
				end
			else
				local Delta = (self.ReverseType == true and 1-RealElasped) or (RealElasped)
				local Position = math.clamp(self._TweenFunction(Delta),0,1)
				SetValue(Position)
			end
			--<setter
			
			-->
		end)
		self.PlaybackState = Enum.PlaybackState.Playing
	end
	if self.RepeatCount ~= nil then
		self.IsRepeatFinal = self.RepeatCount
		if self.RepeatCount >0 then
			self.IsRepeatFinal -= 1
		end
	end
	PlayIn()
end
function mt:Stop(Completed)
	if self.Destroyed == true then return end;
	--Stop function
	if Completed ~= true then
		self.PlaybackState = Enum.PlaybackState.Paused
	end
	if self.Stopped ~= nil then
		self.Stopped:Fire()
	end
	if self.PlaybackConnection then
		self.PlaybackConnection:Disconnect()
		self.PlaybackConnection = nil;
	end
end
function mt:Destroy()
	if self.Destroyed == true then return end;
	self.Destroyed = true;
	self.PlaybackState = Enum.PlaybackState.Cancelled
	if self.PlaybackConnection ~= nil then
		self.PlaybackConnection:Disconnect()
		self.PlaybackConnection = nil;
	end
	if self.Completed ~= nil then
		self.Completed:Destroy()
		self.Completed = nil;
	end
	if self.Stopped ~= nil then
		self.Stopped:Destroy()
		self.Stopped = nil
	end
	if self.Resumed ~= nil then
		self.Resumed:Destroy()
		self.Resumed = nil;
	end
	if self.ChangeConnect ~= nil then
		self.ChangeConnect:Disconnect()
		self.ChangeConnect = nil;
	end
	if self.InfoChangeConnect ~= nil then
		self.InfoChangeConnect:Disconnect()
		self.InfoChangeConnect = nil;
	end
	if self._Listeners then
		for i,v in pairs(self._Listeners) do
			self._Listeners[i] = nil;
		end
		self._Listeners = nil;
	end
	
	self._Target = nil
	self._Step = nil
	for k in pairs(self) do
		self[k] = nil
	end
end
export type TweenInfoType = {
	Time: number;
	EasingStyle: number;
	Damping: number;
	Repeat: number;
	Reverse : boolean;
	DelayTime: number;
}
local Tweeninfo = require(script.TweenInfo)
return function(Goal: any,_Info:TweenInfoType ,Indexes)
	if Goal == nil then warn("Failed to initiate tween because Goal is missing(param 1).") return end;
	if _Info == nil then warn("Failed to initiate tween because TweenInfo is missing(param 2).") return end;
	local self = {}
	setmetatable(self,mt)
	self._Target = Goal;
	self.__Type = "Tween";
	self._Step = RunService.RenderStepped
	
	--< new code
	local function setInfo(Info)
		self._Info = Info or Tweeninfo()
		self.Time = Info.Time;
		self.DelayTime = Info.DelayTime
		self.RepeatCount = Info.Repeat;
		self._TweenFunction = Functions[Info.EasingStyle.Name][Info.EasingDirection.Name]
		self.Reverse = Info.Reverse	
	end
	local g = rawget(_Info,"_Value")
	if g ~= nil then
		local One = false;
		setInfo(g:Get())
		self.InfoChangeConnect = g.Changed:Connect(function(new)
			setInfo(new)
		end)
	else
		setInfo(_Info)
	end
	-->
	if typeof(Goal) == "table" then
		local g = rawget(Goal,"_Value")
		if g ~= nil then
			local One = false;
			self.Goal = g:Get()
			self.ChangeConnect = g.Changed:Connect(function(new)
				if self.Destroyed ~= true then
					if self._Listeners ~= nil then
						for i,v in pairs(self._Listeners) do
							One = true;
							v.Initial = v.Entity[v.Property]
						end
						if One == false then
							self:Destroy()
						end
						self.SetToGoalOnNextPlay = nil;
						self.Elapsed = nil;
						self.ReverseType = nil;
						self.Goal = new;
						self:Play()
					end;
				end
			end)
		end
	else
		self.DestroyOnComplete = true;
		self.Goal = Goal;
	end
	self.Completed = Signal.new()
	self.Stopped = Signal.new()
	self.Resumed = Signal.new()
	self.Destroyed = false;
	self.PlaybackConnection = nil;
	self.PlaybackState = Enum.PlaybackState.Completed
	self._Listeners = {}
	if Indexes then
		if typeof(Indexes[1]) == "Instance" or (typeof(Indexes[1]) == "table" and Indexes[1].Instance ~= nil) then
			self:addSingle(Indexes)
		else
			for i,v in pairs(Indexes) do
				if not (typeof(v[1]) == "Instance" or (typeof(v[1]) == "table" and typeof(v[1].Instance) == "Instance")) then continue end;
				local First = (typeof(v[1]) == "table" and v[1].Instance) or v[1]
				table.insert(self._Listeners,{
					Entity = First;
					Property = v[2];
					Initial = First[v[2]];
				})
			end
		end
	end
	return self;
end