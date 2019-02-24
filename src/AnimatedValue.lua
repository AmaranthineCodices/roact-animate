-- Represents an animated value.
-- This is literally a Lua implementation of a generic *Value.

local Signal = require(script.Parent.Signal)

local Value = {}
Value.__index = Value

--[[
	Creates a new value with a starting inner value.
]]
function Value.new(initial)
	local self = setmetatable({
		Value = initial,
		AnimationStarted = Signal.new(),
		AnimationFinished = Signal.new(),
		Changed = Signal.new(),
		_class = Value,
		_isAnimating = false,
	}, Value)

	return self
end

--[[
	Triggers a change in the value. This immediately changes the value for all
	objects it is used in, with no animation.
]]
function Value:Change(newValue)
	self.Value = newValue
	self.Changed:Fire(newValue)
end

--[[
	Starts an animation over the property's value, using supplied tween properties.
]]
function Value:StartAnimation(toValue, tweenInfo)
	if self._isAnimating then
		self:FinishAnimation(false)
	end

	self._isAnimating = true
	self.AnimationStarted:Fire(toValue, tweenInfo)
end

--[[
	Finishes an animation; called by animated components.
]]
function Value:FinishAnimation(wasCompleted)
	self._isAnimating = false
	self.AnimationFinished:Fire(wasCompleted)
end

return Value
