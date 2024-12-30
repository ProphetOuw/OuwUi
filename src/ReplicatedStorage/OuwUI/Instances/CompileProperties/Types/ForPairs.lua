return function(Cleaner,Entity,Index,Value,Compiler)
	local ForPairs = (Value.Values ~= nil and Value.Values._Value) or nil
	local CurrentInstances = {}
	local function Update(TbAdd,V)
		local Index,Value = Value.Function(TbAdd,V)
		if Index ~= nil and Value == nil then
			Value = Index;
			Index = TbAdd;
		end
		if Index ~= nil and Value ~= nil then
			local Instance_ = Compiler(Cleaner,Entity,{[Index] = Value},true,true).InstanceRet
			if Instance_ ~= nil and (typeof(Instance_) == "Instance" or (typeof(Instance_) == "table" and Instance_.Instance ~= nil)) then
				CurrentInstances[V] = Instance_;
			else
				Instance_:Destroy()
			end
		end
	end
	local function Destroy(Value)
		if Value ~= nil and CurrentInstances[Value] then
			local G = CurrentInstances[Value]
			CurrentInstances[Value] = nil;
			if G["CleanerFunction"] then
				G["CleanerFunction"]()
			else
				G:Destroy()
			end
		end
	end
	for i,v in pairs((ForPairs ~= nil and ForPairs:Get()) or Value.Values) do
		Update(i,v)
	end
	if ForPairs ~= nil then
		local E1 = ForPairs.NewAdded:Connect(function(Index,Value)
			Destroy(Value)
			Update(Index,Value)
		end)
		local E2 = ForPairs.NewRemoved:Connect(function(Index,Value)
			Destroy(Value)
		end)
		local E3 = ForPairs.Changed:Connect(function(new)
			for i,v in pairs(CurrentInstances) do
				task.spawn(function()
					Destroy(i)
				end)
			end
			CurrentInstances = {}
			for i,v in pairs(new) do
				Update(i,v)
			end
		end)
		local Connect; Connect = Entity:GetPropertyChangedSignal("Parent"):Connect(function()
			if Entity == nil or Entity.Parent == nil then
				if Value ~= nil and Value["Destroy"] then
					Value:Destroy()
				end
				if E1 ~= nil then
					E1:Disconnect()
					E1 = nil;
				end
				if E2 ~= nil then
					E2:Disconnect()
					E2 = nil;
				end
				if E3 ~= nil then
					E3:Disconnect()
					E3 = nil;
				end
				if Connect then
					Connect:Disconnect()
					Connect = nil;
				end
			end
		end)
		Cleaner:Add(Connect)
		Cleaner:Add(E1)
		Cleaner:Add(E2)
		Cleaner:Add(E3)
	end
end