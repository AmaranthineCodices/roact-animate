local makeAnimatedComponent = require(script.makeAnimatedComponent)

local RoactAnimate = {}

for _, class in ipairs({ "Frame", "ImageLabel", "ImageButton", "TextButton", "TextBox", "TextLabel", "ScrollingFrame" }) do
	RoactAnimate[class] = makeAnimatedComponent(class)
end

RoactAnimate.Value = require(script.AnimatedValue)
RoactAnimate.makeAnimatedComponent = makeAnimatedComponent
RoactAnimate.Animation = require(script.Animation)
RoactAnimate.AnimationSequence = require(script.AnimationSequence)

function RoactAnimate.Animate(value, tweenInfo, to)
	return RoactAnimate.Animation.new(value, tweenInfo, to)
end

function RoactAnimate.Sequence(animations)
	return RoactAnimate.AnimationSequence.new(animations, false)
end

function RoactAnimate.Parallel(animations)
	return RoactAnimate.AnimationSequence.new(animations, true)
end

setmetatable(RoactAnimate, { __call = function(_, ...) return RoactAnimate.Animate(...) end; })

return RoactAnimate
