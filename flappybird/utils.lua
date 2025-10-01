utils = {}

function utils:with_cooldown(max, decrementer, fn)
	local cooldown = 0
	return function()
		cooldown = cooldown - decrementer
		if cooldown <= 0 then
			cooldown = max
			fn()
		end
	end
end

return utils