--[[

```
local BestUI = require(game.ReplicatedStorage.BestUI)
return function()
	local Scope = BestUI:Init()

	local Create = Scope.Create --Allows you to create elements
	local Hydrate = Scope.Hydrate --Allows you to edit created elements that you might be storing elsewhere
	local Tween = Scope.Tween --Allows you to add tween animations
	local Spring = Scope.Spring --allows you to add Spring animations
	local Compute = scope.Compute --allows you to run computations in spots where they would normally not be possinle
	local ForPairs = Scope.ForPairs --allows you to manage tables
	local Value = Scope.Value --lets you create values
	
	local Color = Value(Color3.new(1,0,0))
	
	local Elements = ForPairs(table or value object with table as value,function(Index,Value)
		-- Do your modifications to index and value in here
		return Index,Value --you don't have to return these
	end)


	Scope.Hydrate(game.StarterGui.ImageLabel:Clone()) {
		Parent = Target;
		Position = UDim2.fromScale(.3,0,.2,0)
	}
	Create "Frame" {
		Size = Spring(Size,Scope.SpringInfo()),
		Parent = Target;
		Scope.Compute(function(use)
			print("Test")
		end);
		MouseEnter = function()
			TableValue:AddWithIndex(1,TestItm)
			Info(Info.Default)
			Size(UDim2.fromOffset(150,150))
		end,
		MouseLeave = function()
			TableValue -= TestItm
			Info(Scope.SpringInfo(.1,1,.2))
			Size(Size.Default)
		end,
		ForPairs(TableValue,function(Index,Value)
			return Create "Frame" {
				Name = "TestFrame";
				Position = Spring(UDim2.fromScale(.3,0),Scope.SpringInfo(.3,1,.2,-1,true));
				Size = Tween(UDim2.fromScale(.3,.3),Scope.TweenInfo(.3,Enum.EasingStyle.Sine,Enum.EasingDirection.InOut,-1,true));
				BackgroundColor3 = Color3.new(1,0,0)
			}
		end)
	}
	
	return function()
		Scope:Clean() --make sure to always clean your scope especially if you are using a UI Viwing plugin
	end
end
--You can nest tables, it will always search tables if their nested for values.
```


]]
return nil;