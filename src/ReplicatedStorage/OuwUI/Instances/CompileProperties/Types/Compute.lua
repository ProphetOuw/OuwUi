return function(Cleaner,Entity,Index,Value,Compiler)
	local function upd()
		if Entity == nil then return end;
		if Value.__Type ~= "Compute" then return end;
		local New = Value(true);
		if New ~= nil then
			if typeof(Index) == "number" or typeof(New) == "table" then
				New = {New}
				Compiler(Value.Cleaner,Entity,New,nil,true)
			else
				Entity[Index] = New;
			end
		end
	end
	Value.CurrentEntity = Entity
	Cleaner:Connect(Value.Update,upd)
	task.spawn(function()
		upd()
	end)
end