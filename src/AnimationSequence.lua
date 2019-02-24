local Signal = require(script.Parent.Signal)

local AnimationSequence = {}
AnimationSequence.__index = AnimationSequence

--[[
	Creates a new animation sequence.
]]
function AnimationSequence.new(animations, parallel)
	local self = setmetatable({
		_animations = animations,
		_parallel = parallel,
		AnimationFinished = Signal.new(),
	}, AnimationSequence)

	return self
end

--[[
	Starts the animation sequence. All animations are run asynchronously; this
	method does not yield!

	If called when the animation sequence is already playing, this will halt
	the current sequence and start over from the beginning.
]]
function AnimationSequence:Start()
	-- Do all of this asynchronously.
	spawn(function()
		-- If this is a parallel animation set, we can run all of the
		-- animations at the same time.
		if self._parallel then
			-- How many animations are currently running
			local count = #self._animations

			for _, animation in ipairs(self._animations) do
				local allCompleted = true
				local connection
				connection = animation.AnimationFinished:Connect(function(wasCompleted)
					connection:Disconnect()
					count = count - 1

					allCompleted = allCompleted and wasCompleted

					-- If all of the animations are done, fire the AnimationFinished signal.
					if count <= 0 then
						self.AnimationFinished:Fire(allCompleted)
					end
				end)

				-- Once we've set the finished connection up, start the animation.
				-- Starting after the connection is set up prevents issues where
				-- the animations complete instantly (PrepareSteps).
				animation:Start()
			end
		-- If this is a sequential animation set then we need to run things
		-- one at a time - this is what _startSequential handles. Start at
		-- the first animation.
		else
			self:_startSequential(1)
		end
	end)
end

--[[
	Starts playing animations sequentially at a given index.
]]
function AnimationSequence:_startSequential(index)
	local animation = self._animations[index]

	local connection
	connection = animation.AnimationFinished:Connect(function(wasCompleted)
		connection:Disconnect()

		if wasCompleted then
			local newIndex = index + 1
			-- If the index is greater than the length of the table, this was the
			-- last animation - we're done!
			if newIndex > #self._animations then
				self.AnimationFinished:Fire(true)
			-- Otherwise, go on to the next animation.
			else
				self:_startSequential(newIndex)
			end
		else
			self.AnimationFinished:Fire(false)
		end
	end)

	animation:Start()
end

return AnimationSequence
