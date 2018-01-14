# roact-animate
An animation library for [Roact](https://github.com/Roblox/Roact) modeled after React Native's [Animated](https://facebook.github.io/react-native/docs/animations.html) library. This is currently a work in progress; the API may change at random!

## Installation
There are two ways to install `roact-animate`. The recommended way is to download the installer from the [latest release](https://github.com/AmaranthineCodices/roact-material/releases/latest) and run it from Studio's Run Script option (in the Test tab). Alternatively, you can download the repository's `src` directory manually and get it into Roblox Studio. You can use [Rojo](https://github.com/LPGhatguy/rojo) or a similar plugin for this.

Regardless of which method you use, if Roact is **not** installed in `ReplicatedStorage`, you will need to change the `makeAnimatedComponent` module to account for that. Specifically, where it requires Roact in:

```lua
local Roact = require(game:GetService("ReplicatedStorage").Roact)
```

Change it to
```lua
local Roact = -- however you choose to import Roact
```

## Usage
Documentation coming soon<sup>tm</sup>. Here's a quick example:

```lua
local Roact = require(game.ReplicatedStorage.Roact)
local RoactAnimate = require(game.ReplicatedStorage.RoactAnimate)

local TestComponent = Roact.Component:extend("AnimateTest")

function TestComponent:init()
	self.state = {
		Transparency = RoactAnimate.Value.new(1);
		Size = RoactAnimate.Value.new(UDim2.new(0, 100, 0, 100));
		Color = RoactAnimate.Value.new(Color3.new(1, 1, 1));
	}
end

function TestComponent:didMount()
	spawn(function()
		wait(1)
		RoactAnimate.Sequence({
			RoactAnimate(
				self.state.Transparency,
				TweenInfo.new(1),
				0),
			RoactAnimate.Parallel({
				RoactAnimate(self.state.Size,
					TweenInfo.new(0.5),
					UDim2.new(0, 200, 0, 50)),
				RoactAnimate(self.state.Color,
					TweenInfo.new(0.5),
					Color3.new(0.5, 0.1, 1)),
			})
		}):Start()
	end)
end

function TestComponent:render()
	return Roact.createElement(RoactAnimate.Frame, {
		BackgroundTransparency = self.state.Transparency;
		Position = UDim2.new(0.5, 0, 0.5, 0);
		Size = self.state.Size;
		BackgroundColor3 = self.state.Color;
	}, self.props[Roact.Children])
end

local testTree = Roact.createElement("ScreenGui", {}, {
	Roact.createElement(TestComponent)
})

Roact.reify(testTree, game.Players.LocalPlayer:WaitForChild("PlayerGui"))
```
