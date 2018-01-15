-- A "prepare" step.
-- Exposes the same API as Animation/AnimationSequence, but instantly completes its goal.

local PrepareStep = {}
PrepareStep.__index = PrepareStep

function PrepareStep.new(value, to)
    local self = setmetatable({
        _value = value;
        _to = to;
        _finished = Instance.new("BindableEvent");
    }, PrepareStep)

    self.AnimationFinished = self._finished.Event

    return self
end

function PrepareStep:Start()
    self._value:Change(self._to)
    self._finished:Fire()
end

return PrepareStep