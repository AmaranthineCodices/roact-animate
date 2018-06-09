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
		while true do
			wait(5)

			RoactAnimate.Sequence({
				RoactAnimate.Parallel({
					RoactAnimate.Prepare(self.state.Transparency, 1),
					RoactAnimate.Prepare(self.state.Size, UDim2.new(0, 100, 0, 100)),
					RoactAnimate.Prepare(self.state.Color, Color3.new(1, 1, 1)),
				}),
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
		end
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

Roact.mount(testTree, game.Players.LocalPlayer:WaitForChild("PlayerGui"))