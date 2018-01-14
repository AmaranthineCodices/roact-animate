-- Wraps a component to produce a new component that responds to animated values.

local TweenService = game:GetService("TweenService")

local Roact = require(game:GetService("ReplicatedStorage").Roact)
local AnimatedValue = require(script.Parent.AnimatedValue)

local function makeAnimatedComponent(toWrap)
	-- Component name is weird(ish) to avoid name collisions
	-- This is automatically created, so w/e
	local wrappedComponent = Roact.Component:extend("_animatedComponent:"..tostring(toWrap))

	function wrappedComponent:didMount()
		-- Disconnect any currently registered listeners, just in case.
		self:_disconnectListeners()

		-- All the listeners in _listeners will be disconnected.
		-- Recreating the table is easier than nuking them all.
		self._listeners = {}

		for key, value in pairs(self.props) do
			-- If it's an AnimatedValue then we need to listen to it
			if typeof(value) == "table" and value._class == AnimatedValue then
				-- Stored to cancel the current tween
				local _currentTween = nil

				table.insert(self._listeners, value.AnimationStarted:Connect(function(to, tweenInfo)
					-- In case something borks / component renders nil
					if self._rbx then
						-- Cancel the current tween automatically
						if _currentTween then
							_currentTween:Cancel()
						end

						-- Theoretically there are optimizations that could be done here, but
						-- it's much simpler to just do one-tween-per-property.
						-- Is optimizing this even relevant?
						local tween = TweenService:Create(self._rbx, tweenInfo, { [key] = to; })
						tween:Play()
						_currentTween = tween

						-- For feedback - this is used for sequential animations
						_currentTween.Completed:Connect(function(status)
							-- Only "finish" the animation if it wasn't canceled.
							if status == Enum.PlaybackState.Completed then
								value:FinishAnimation()
							end
						end)
					end
				end))
			end
		end
	end

	-- disconnect all listeners on unmount
	function wrappedComponent:willUnmount()
		self:_disconnectListeners()
	end

	function wrappedComponent:render()
		-- Intercept Roact.Ref; we need access to the reference as well
		local ref = self.props[Roact.Ref]

		-- Create the properties table from scratch
		local props = {}

		for key, value in pairs(self.props) do
			-- If it's an AnimatedValue, use its current value.
			if typeof(value) == "table" and value._class == AnimatedValue then
				props[key] = value.Value
			-- Otherwise, just forward it on.
			else
				props[key] = value
			end
		end

		props[Roact.Ref] = function(rbx)
			self._rbx = rbx

			-- forward the ref to the original component
			if ref then
				ref(rbx)
			end
		end

		return Roact.createElement(toWrap, props, self.props[Roact.Children])
	end

	function wrappedComponent:_disconnectListeners()
		if not self._listeners then return end

		for _, listener in ipairs(self._listeners) do
			listener:Disconnect()
		end
	end

	return wrappedComponent
end

return makeAnimatedComponent