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
		for _, animation in ipairs(self._animations) do
			animation:Start()

			-- If this isn't a parallel sequence, wait for the current animation to finish.
			if not self._parallel then
				animation.AnimationFinished:Wait()
			end
		end

		-- Fire the finished event so the next one up knows we're done.
		self._finished:Fire()
	end)
end

return AnimationSequence
