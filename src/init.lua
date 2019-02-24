local makeAnimatedComponent = require(script.makeAnimatedComponent)

local RoactAnimate = {}

-- Create animated variants of all the Roblox classes
for _, class in ipairs({
		"Frame",
		"ImageLabel",
		"ImageButton",
		"TextButton",
		"TextBox",
		"TextLabel",
		"ScrollingFrame"
	}) do
	RoactAnimate[class] = makeAnimatedComponent(class)
end

local Animation = require(script.Animation)
local AnimationSequence = require(script.AnimationSequence)
local PrepareStep = require(script.PrepareStep)

RoactAnimate.Value = require(script.AnimatedValue)
RoactAnimate.makeAnimatedComponent = makeAnimatedComponent

-- Creates an animation for a value.
function RoactAnimate.Animate(value, tweenInfo, to)
	return Animation.new(value, tweenInfo, to)
end

-- Creates an animation from a table of animations.
-- These animations will be run one-by-one.
function RoactAnimate.Sequence(animations)
	return AnimationSequence.new(animations, false)
end

-- Creates an animation from a table of animations.
-- These animations will be run all at once.
function RoactAnimate.Parallel(animations)
	return AnimationSequence.new(animations, true)
end

-- Creates a preparation step.
-- This allows instantaneous resetting of a value prior to animations completing.
function RoactAnimate.Prepare(value, to)
	return PrepareStep.new(value, to)
end

setmetatable(RoactAnimate, { __call = function(_, ...) return RoactAnimate.Animate(...) end; })

return RoactAnimate
