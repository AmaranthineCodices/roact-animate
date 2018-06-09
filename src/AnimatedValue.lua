-- Represents an animated value.
-- This is literally a Lua implementation of a generic *Value.

local Signal = require(script.Parent.Signal)

local Value = {}
Value.__index = Value

function Value.new(initial)
	local self = setmetatable({
		Value = initial,
		_valueType = typeof(initial),
		AnimationStarted = Signal.new(),
		AnimationFinished = Signal.new(),
		Changed = Signal.new(),
		_class = Value,
	}, Value)

	return self
end

function Value:Change(newValue)
	self.Value = newValue
	self.Changed:Fire(newValue)
end

function Value:StartAnimation(toValue, tweenInfo)
	self.AnimationStarted:Fire(toValue, tweenInfo)
end

function Value:FinishAnimation()
	self.AnimationFinished:Fire()
end

return Value
