local Types = require(script.Parent.Parent.Misc.Types)
local CompileProperties = require(script.Parent:WaitForChild("CompileProperties"))

local Runservice = game:GetService("RunService")
local RunType = Runservice:IsRunning()

return function(Trove,Type)
	return function(Properties)
		if RunType == false then
			if Type == "ScreenGui" and true then
				Type = "Frame";
				
				Properties.Size = UDim2.fromScale(1,1);
				Properties.BackgroundTransparency = 1;
				Properties.ZIndex = ((Properties.DisplayOrder) or 0 )+1;
				Properties.DisplayOrder = nil;
			end
		end;
		local inst = Instance.new(Type)
		local TableToReturn = setmetatable({Instance = inst},{})
		TableToReturn.__Type = "Instance"
		TableToReturn.__index = TableToReturn;
		local Cache
		function TableToReturn:Destroy()
			self.Destroyed = true;
			if self.Instance ~= nil then
				self.Instance:Destroy()
			end
			for k in pairs(self) do
				rawset(self, k, nil)
			end
			setmetatable(self, nil)
			if Cache ~= nil then
				for i,v in pairs(Cache) do
					local ty = typeof(v)
					if ty == "Instance" or ty == "table" then
						if v["Destroy"] then
							v:Destroy()
						end
					elseif ty == "RBXScriptConnection" then
						if v["Disconnect"] then
							v:Disconnect() 
						end
					else
						print(v,ty," has no destroy type - ",script.Parent.Name)
					end
				end
				Cache = nil;
			end
			
		end
		
		local NoCleaner = Properties["Cleaner"];
		if NoCleaner == nil then
			NoCleaner = true;
		end
		if Properties["Cleaner"] ~= nil then
			Properties["Cleaner"] = nil;
		end
		Cache = Properties.Cache
		if Cache ~= nil then
			Properties["Cache"] = nil;
		end
		local feedback = CompileProperties(Trove,inst,Properties)
		if NoCleaner ~= false then
			if feedback ~= nil and feedback.CleanFunction ~= nil and typeof(feedback.CleanFunction) == "function"  then
				local Index = `{tostring(math.random(1,9999))}{tostring(math.random(1,9999))}`
				local Cleaned = false;
				local Func = function()
					if Cleaned == true then return end;
					Cleaned = true;
					Trove:Remove(Index)
					if TableToReturn == nil then return end;
					if TableToReturn.Destroyed == true or TableToReturn["Destroy"] == nil then return end;
					task.spawn(function()
						local ret,err = pcall(function()
							feedback.CleanFunction(TableToReturn.Instance)
						end)
						if ret == false then
							warn(err,debug.info(1,"sln"))
						end
						if TableToReturn.Destroyed ~= true then
							if TableToReturn ~= nil and TableToReturn["Destroy"] ~= nil then
								TableToReturn:Destroy()
							end
						end;
					end)
				end
				TableToReturn["CleanerFunction"] = Func
				Trove:Add(Func,nil,Index)
			else
				Trove:Add(TableToReturn,"Destroy")
			end
			
		end;
		return TableToReturn;
	end
end