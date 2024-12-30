return function (T, frequency, damping)
	T = math.clamp(T, 0, 1)

	local angularFrequency = 2 * math.pi * frequency
	local dampingRatio = damping

	local displacement = T - 1

	local springResponse
	if dampingRatio >= 1 then
		local expTerm = math.exp(-angularFrequency * dampingRatio * T)
		springResponse = 1 - displacement * expTerm
	else
		local omegaD = angularFrequency * math.sqrt(1 - dampingRatio ^ 2) -- Damped natural frequency
		local decay = math.exp(-angularFrequency * dampingRatio * T)
		springResponse = 1 + displacement * decay * math.cos(omegaD * T)
	end

	return springResponse
end