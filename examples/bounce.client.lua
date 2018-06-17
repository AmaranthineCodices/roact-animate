local Roact = require(game.ReplicatedStorage.Roact)
local RoactAnimate = require(game.ReplicatedStorage.RoactAnimate)

local BouncingButton = Roact.PureComponent:extend("BouncingButton")

function BouncingButton:init()
	self._position = RoactAnimate.Value.new(
		-- Use the Position property if it's given...
		self.props.Position
		-- ...or default to this position.
		or UDim2.new(0, 0, 0, 0)
	)
end

function BouncingButton:render()
	return Roact.createElement(RoactAnimate.TextButton, {
		-- Use a Value to make the property animateable.
		Position = self._position,
		-- Everything else can't be animated!
		BackgroundColor3 = Color3.new(1, 1, 1),
		Font = Enum.Font.SourceSans,
		Size = UDim2.new(0, 120, 0, 40),
		Text = "Bounce!",
		TextColor3 = Color3.new(0, 0, 0),
		TextSize = 18,
		[Roact.Event.MouseButton1Click] = function()
			RoactAnimate.Sequence({
				RoactAnimate(self._position, TweenInfo.new(0.125), self.props.Position - UDim2.new(0, 0, 0, 10)),
				RoactAnimate(self._position, TweenInfo.new(
					0.5,
					Enum.EasingStyle.Bounce
				), self.props.Position)
			}):Start()
		end,
	})
end

local testTree = Roact.createElement("ScreenGui", {}, {
	Roact.createElement(BouncingButton, {
		Position = UDim2.new(0.5, 0, 0.5, 0),
	})
})

Roact.mount(testTree, game.Players.LocalPlayer:WaitForChild("PlayerGui"), "Bouncing")