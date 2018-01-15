local makeAnimatedComponent = require(script.makeAnimatedComponent)

local RoactAnimate = {}

-- Create animated variants of all the Roblox classes
for _, class in ipairs({ "Frame", "ImageLabel", "ImageButton", "TextButton", "TextBox", "TextLabel", "ScrollingFrame" }) do
	RoactAnimate[class] = makeAnimatedComponent(class)
end

RoactAnimate.Value = require(script.AnimatedValue)
RoactAnimate.makeAnimatedComponent = makeAnimatedComponent
RoactAnimate.Animation = require(script.Animation)
RoactAnimate.AnimationSequence = require(script.AnimationSequence)
RoactAnimate.PrepareStep = require(script.PrepareStep)

-- Creates an animation for a value.
function RoactAnimate.Animate(value, tweenInfo, to)
	return RoactAnimate.Animation.new(value, tweenInfo, to)
end

-- Creates an animation from a table of animations.
-- These animations will be run one-by-one.
function RoactAnimate.Sequence(animations)
	return RoactAnimate.AnimationSequence.new(animations, false)
end

-- Creates an animation from a table of animations.
-- These animations will be run all at once.
function RoactAnimate.Parallel(animations)
	return RoactAnimate.AnimationSequence.new(animations, true)
end

-- Creates a preparation step.
-- This allows instantaneous resetting of a value prior to animations completing.
function RoactAnimate.Prepare(value, to)
	return RoactAnimate.PrepareStep.new(value, to)
end

setmetatable(RoactAnimate, { __call = function(_, ...) return RoactAnimate.Animate(...) end; })

return RoactAnimate
