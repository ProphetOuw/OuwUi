return function(Time,Frequency,Damping,Repeat,Reverse,DelayTime)
	local new = {}
	new.Time = Time or 1;
	new.Frequency = Frequency or 1;
	new.Damping = Damping or .2;
	new.Repeat = Repeat or 0;
	new.Reverse = Reverse or false;
	new.DelayTime = DelayTime or 0;
	return new;
end