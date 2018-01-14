local AnimationSequence = {}
AnimationSequence.__index = AnimationSequence

function AnimationSequence.new(animations, parallel)
	local self = setmetatable({
		_animations = animations;
		_parallel = parallel;
		_finished = Instance.new("BindableEvent");
	}, AnimationSequence)

	self.AnimationFinished = self._finished.Event

	return self
end

function AnimationSequence:Start()
	spawn(function()
		for _, animation in ipairs(self._animations) do
			animation:Start()

			if not self._parallel then
				animation.AnimationFinished:Wait()
			end
		end

		self._finished:Fire()
	end)
end

return AnimationSequence
