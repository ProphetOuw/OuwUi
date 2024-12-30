return function(Time,EasingStyle,EasingDirection,Repeat,Reverse,DelayTime)
	local new = {}
	new.Time = Time or 1;
	new.EasingStyle = EasingStyle or Enum.EasingStyle.Linear;
	new.EasingDirection = EasingDirection or Enum.EasingDirection.Out;
	new.Repeat = Repeat or 0;
	new.Reverse = Reverse or false;
	new.DelayTime = DelayTime or 0;
	return new;
end