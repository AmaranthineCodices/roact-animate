--[[
	A signal that calls listeners [a]synchronously.
]]

local function wrapInPointer(...)
	local args = { ... }
	return function()
		return unpack(args)
	end
end

local FastSpawn = Instance.new("BindableEvent")
FastSpawn.Event:Connect(function(callback, pointer)
	callback(pointer())
end)

local Signal = {}
Signal.__index = Signal

function Signal.new()
	return setmetatable({
		_listeners = {},
	}, Signal)
end

function Signal:Connect(listener)
	table.insert(self._listeners, listener)

	return {
		Disconnect = function()
			for i = #self._listeners, 1, -1 do
				if self._listeners[i] == listener then
					table.remove(self._listeners, i)
					break
				end
			end
		end,
	}
end

function Signal:Fire(...)
	for _, listener in ipairs(self._listeners) do
		FastSpawn:Fire(listener, wrapInPointer(...))
	end
end

return Signal
