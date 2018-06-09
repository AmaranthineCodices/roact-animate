local Signal = require(script.Parent.Signal)

local Animation = {}
Animation.__index = Animation

function Animation.new(value, tweenInfo, to)
	local self = setmetatable({
		_value = value,
		_tween = tweenInfo,
		_to = to,
		AnimationFinished = Signal.new(),
	}, Animation)

	value.AnimationFinished:Connect(function(...)
		self.AnimationFinished:Fire(...)
	end)

	return self
end

function Animation:Start()
	self._value:StartAnimation(self._to, self._tween)
end

return Animation
