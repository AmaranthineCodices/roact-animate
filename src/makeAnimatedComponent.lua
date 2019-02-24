-- Wraps a component to produce a new component that responds to animated values.

local NON_PRIMITIVE_ERROR = "The component %q cannot be animated because it is not a primitive component."

local TweenService = game:GetService("TweenService")

local RoactModule = game:GetService("ReplicatedStorage"):FindFirstChild("rbx-roact", true)
local Roact = require(RoactModule.roact.lib)
local AnimatedValue = require(script.Parent.AnimatedValue)

local function makeAnimatedComponent(toWrap)
	-- Non-primitive components cannot be animated because you can't use refs
	-- with them.
	if typeof(toWrap) ~= "string" then
		error(NON_PRIMITIVE_ERROR:format(tostring(toWrap)), 2)
	end

	-- Component name is weird(ish) to avoid name collisions
	-- This is automatically created, so w/e
	local wrappedComponent = Roact.Component:extend("_animatedComponent:"..toWrap)

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
						local tween = TweenService:Create(self._rbx, tweenInfo, { [key] = to, })
						tween:Play()
						_currentTween = tween

						-- For feedback - this is used for sequential animations
						local finishStatus = _currentTween.Completed:Wait()
						if finishStatus == Enum.PlaybackState.Completed then
							-- Finish animation marked as "completed"
							value:FinishAnimation(true)
						else
							-- Finish animation marked as "overridden"
							value:FinishAnimation(false)
						end
					else
						-- Close animation immediately
						value:FinishAnimation(false)
					end
				end))

				-- Handle value changes (PrepareStep)
				table.insert(self._listeners, value.Changed:Connect(function(new)
					if self._rbx then
						self._rbx[key] = new
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
				if typeof(ref) == "function" then
					ref(rbx)
				elseif typeof(ref) == "table" then
					ref.current = rbx
				end
			end
		end

		return Roact.createElement(toWrap, props)
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