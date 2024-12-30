return function(Cleaner,Entity,Index,Value)
	Value:addSingle({Entity,Index})
	if Value.SetToGoalOnNextPlay == true and Value.Goal ~= nil then
		Entity[Index] = Value.Goal
	end
	Value:Play()
	local Connect; Connect = Entity:GetPropertyChangedSignal("Parent"):Connect(function()
		if Entity == nil or Entity.Parent == nil then
			Value:Destroy()
			if Connect then
				Connect:Disconnect()
				Connect = nil;
			end
		end
	end)
	Cleaner:Add(Connect)
end