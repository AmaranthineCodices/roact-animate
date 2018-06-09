--[[
	An animation over a single value to a single other value.
	Combined via AnimationSequence to produce coordinated animations.
]]

local Signal = require(script.Parent.Signal)

local Animation = {}
Animation.__index = Animation

--[[
	Creates a new Animation.
]]
function Animation.new(value, tweenInfo, to)
	local self = setmetatable({
		_value = value,
		_tween = tweenInfo,
		_to = to,
		AnimationFinished = Signal.new(),
	}, Animation)

	-- When the value finishes an animation, fire this Animation's finished
	-- signal as well, to allow AnimationSequence to properly sequence things.
	value.AnimationFinished:Connect(function(...)
		self.AnimationFinished:Fire(...)
	end)

	return self
end

--[[
	Starts the animation.
]]
function Animation:Start()
	self._value:StartAnimation(self._to, self._tween)
end

return Animation
