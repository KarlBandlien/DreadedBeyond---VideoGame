local player = game.Players.LocalPlayer

-- Function to set character attributes and states
local function handleCharacterAttributes(character)
	local humanoid = character:WaitForChild("Humanoid")

	-- Disable climbing state
	humanoid:SetStateEnabled(Enum.HumanoidStateType.Climbing, false)

	
end

-- Connect to CharacterAdded to apply it on each respawn
player.CharacterAdded:Connect(handleCharacterAttributes)

-- Apply it to the current character if it already exists
if player.Character then
	handleCharacterAttributes(player.Character)
end
