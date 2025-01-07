local ContextActionService = game:GetService('ContextActionService')
local replicatedStorage = game:GetService("ReplicatedStorage")
local FreezeMovementEvent = replicatedStorage.Events:WaitForChild("FreezeMovementEvent") -- RemoteEvent reference

local function freezeMovement(freeze)
	if freeze then
		ContextActionService:BindAction(
			"FreezeMovement",
			function() return Enum.ContextActionResult.Sink end,
			false,
			unpack(Enum.PlayerActions:GetEnumItems())
		)
	else
		ContextActionService:UnbindAction("FreezeMovement")
	end
end

FreezeMovementEvent.OnClientEvent:Connect(function(freeze)
	freezeMovement(freeze ~= false) -- Default to freezing if `false` isn't explicitly passed
end)
