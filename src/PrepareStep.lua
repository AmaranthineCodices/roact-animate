--[[
    A "prepare" step.
    Exposes the same API as Animation/AnimationSequence, but instantly completes its goal.
]]

local Signal = require(script.Parent.Signal)

local PrepareStep = {}
PrepareStep.__index = PrepareStep

function PrepareStep.new(value, to)
    local self = setmetatable({
        _value = value,
        _to = to,
        AnimationFinished = Signal.new(),
    }, PrepareStep)

    return self
end

--[[
    "Starts" the step, instantly changing the value to the specified new value.
]]
function PrepareStep:Start()
    self._value:Change(self._to)
    self.AnimationFinished:Fire(true)
end

return PrepareStep