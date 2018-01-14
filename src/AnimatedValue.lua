-- Represents an animated value.
-- This is literally a Lua implementation of a generic *Value.

local Value = {}
Value.__index = Value

function Value.new(initial)
	local self = setmetatable({
		Value = initial;
		_valueType = typeof(initial);
		_startAnimation = Instance.new("BindableEvent");
		_finishAnimation = Instance.new("BindableEvent");
		_class = Value;
	}, Value)

	self.AnimationStarted = self._startAnimation.Event
	self.AnimationFinished = self._finishAnimation.Event

	return self
end

function Value:StartAnimation(toValue, tweenInfo)
	self._startAnimation:Fire(toValue, tweenInfo)
end

function Value:FinishAnimation()
	self._finishAnimation:Fire()
end

return Value
