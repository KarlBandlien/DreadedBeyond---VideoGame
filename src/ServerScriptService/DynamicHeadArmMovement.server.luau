-- Server Script (e.g., in ServerScriptService)

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local HeadMovementEvent = ReplicatedStorage.Events.HeadMovementEvent

-- Broadcast updates to all clients
HeadMovementEvent.OnServerEvent:Connect(function(player, neckCFrame, RShoulderCFrame, LShoulderCFrame)
	-- Validate input (make sure neckCFrame is a valid CFrame)
	if typeof(neckCFrame) == "CFrame" and player.Character then
		local Character = player.Character
		local Torso = Character:FindFirstChild("Torso")
		local Head = Character:FindFirstChild("Head")
		local Neck = Torso and Torso:FindFirstChild("Neck")
		local RShoulder = Torso:FindFirstChild("Right Shoulder")
		local LShoulder = Torso:FindFirstChild("Left Shoulder")
		
		if Neck then
			-- Update the Neck CFrame for all clients
			Neck.C0 = neckCFrame
		end
		if RShoulder then
			-- Update the Right Shoulder CFrame for all clients
			RShoulder.C0 = RShoulderCFrame
		end
		if LShoulder then
			-- Update the left shoulder Cframe for all clients
			LShoulder.C0 = LShoulderCFrame
		end
	end
end)
