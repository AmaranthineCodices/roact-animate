local Animation = {}
Animation.__index = Animation

function Animation.new(value, tweenInfo, to)
	local self = setmetatable({
		_value = value;
		_tween = tweenInfo;
		_to = to;
		_finished = Instance.new("BindableEvent");
	}, Animation)

	self.AnimationFinished = self._finished.Event

	value.AnimationFinished:Connect(function(...)
		self._finished:Fire(...)
	end)

	return self
end

function Animation:Start()
	self._value:StartAnimation(self._to, self._tween)
end

return Animation
