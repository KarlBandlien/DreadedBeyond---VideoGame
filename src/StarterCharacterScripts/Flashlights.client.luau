local playersService = game:GetService("Players")
local userInputService = game:GetService("UserInputService")

-- Reference to the local player
local player = playersService.LocalPlayer
local char = player.Character

-- References to the lights
local lightLeft = char:WaitForChild("Head"):WaitForChild("LeftLightAttatchment"):WaitForChild("LeftLight")
local rightLight = char:WaitForChild("Head"):WaitForChild("RightLightAttatchment"):WaitForChild("RightLight")


-- Function to toggle the Enabled property
local function toggleLights()
	lightLeft.Enabled = not lightLeft.Enabled
	rightLight.Enabled = not rightLight.Enabled
end


userInputService.InputBegan:Connect(function(input, gameProcessed)
	
	if not gameProcessed and input.KeyCode == Enum.KeyCode.F then
		toggleLights()
	end
end)