local AnimationSequence = {}
AnimationSequence.__index = AnimationSequence

function AnimationSequence.new(animations, parallel)
	local self = setmetatable({
		_animations = animations;
		_parallel = parallel;
		_finished = Instance.new("BindableEvent");
	}, AnimationSequence)

	-- Fired when the animation finishes.
	-- Not fired when the animation is canceled in any way.
	self.AnimationFinished = self._finished.Event

	return self
end

function AnimationSequence:Start()
	-- Do all of this asynchronously.
	spawn(function()
		local allCompleted = Instance.new("BindableEvent")
		local count = #self._animations

		for _, animation in ipairs(self._animations) do
			animation:Start()

			-- If this isn't a parallel sequence, wait for the current animation to finish.
			if not self._parallel then
				if not animation.Done then
					animation.AnimationFinished:Wait()
				end

				-- Perform bookkeeping here - no need for an event connection.
				count = count - 1

				if count <= 0 then
					allCompleted:Fire()
				end
			-- If this is a parallel sequence we have to connect to AnimationFinished to
			-- wait until all the animations are done executing.
			else
				local connection
				connection = animation.AnimationFinished:Connect(function()
					connection:Disconnect()
					count = count - 1

					if count <= 0 then
						allCompleted:Fire()
					end
				end)
			end
		end

		-- Wait for everyone to be finished
		allCompleted.Event:Wait()
		allCompleted:Destroy()

		self.Done = true
		-- Fire the finished event so the next one up knows we're done.
		self._finished:Fire()
	end)
end

return AnimationSequence
