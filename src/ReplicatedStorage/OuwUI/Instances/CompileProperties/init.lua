local Menum = require(script.Parent.Parent:WaitForChild("Utility"):WaitForChild("Menum"))
local Types = {}
local Bases = {}
for i,v in pairs(script:WaitForChild("Types"):GetChildren()) do
	Types[v.Name] = require(v)
end
for i,v in pairs(script.Bases:GetChildren()) do
	Bases[v.Name] = require(v);
end
function extractBaseProperty(input)
	local baseProperty = input:match('^(.-)OnChanged$')
	return baseProperty or input
end
function Compile(Cleaner,entity,properties,IsOnce,NoAutoFill)
	local feedback = {}
	local function Dig(tab)
		local RegValues = {}
		local TabValues = {}
		for i,v in pairs(tab) do
			if typeof(v) == "table" or typeof(v) == "function" then
				if typeof(i) == "number" then
					table.insert(TabValues,v)
				else
					TabValues[i] = v;
				end
			else
				RegValues[i] = v;
			end
		end
		local function DoThing(i,v)
			local vType = typeof(v)
			if vType == "function" then
				local Work = "function"
				if i == "OnClean" then
					feedback.CleanFunction = v;
				else
					local ret,err = pcall(function()
						local IsF = string.find(tostring(i),"OnChanged")
						local Property = nil;
						if IsF ~= nil then
							local Prop = extractBaseProperty(tostring(i))
							if Prop ~= nil and entity[Prop] ~= nil then
								Property = Prop
							end
						end
						local Signal = nil;
						if Property ~= nil then
							Signal = entity:GetPropertyChangedSignal(Property)
						else
							Signal = entity[i]
						end
						if typeof(Signal) == "RBXScriptSignal" then
							Cleaner:Connect(Signal,function(...)
								local params = table.pack(...)
								table.insert(params,entity)
								v(table.unpack(params))
							end)
						end
					end)
					if ret == false then
						warn(err)
					end
				end
			elseif (vType == "Instance" or (vType == "table" and v["Instance"] ~= nil)) and tonumber(i) ~= nil then
				if vType == "table" then
					v.Instance.Parent = entity
				else
					v.Parent = entity
				end
				if IsOnce then
					if vType == "table" then
						v["asdasd"] = "Test";
					end
					return v;
				end
			elseif vType == "table" then
				local get = rawget(v,"_Value")
				if get ~= nil then
					--< is value
					entity[i] = get:Get();
					get.Changed:Connect(function(newv)
						entity[i] = newv;
					end)
					--> is value
				else
					local Type = v.__Type
					if Type ~= nil and Types[Type] then
						--< is an instance table
						Types[Type](Cleaner,entity,i,v,Compile)
						-->
					else
						--< is regular table
						if IsOnce then
							return Dig(v,IsOnce)
						else
							Dig(v)
						end
						-->
					end
				end
			else
				entity[i] = v;
			end
		end
		for i,v in pairs(RegValues) do
			if IsOnce then
				return DoThing(i,v)
			else
				DoThing(i,v)
			end
		end
		for i,v in pairs(TabValues) do
			if IsOnce then
				return DoThing(i,v)
			else
				DoThing(i,v)
			end
		end
	end
	if NoAutoFill == nil then
		local Base = Bases[entity.ClassName]
		if Base ~= nil and IsOnce ~= true then
			for i,v in pairs(Base) do
				entity[i] = v
			end
		end
	end;
	local Parent = properties["Parent"]
	properties.Parent = nil;
	local r = Dig(properties)
	if Parent ~= nil then
		entity.Parent = Parent;
	end
	if r ~= nil then
		feedback.InstanceRet = r;
	end
	return feedback;
end

return Compile