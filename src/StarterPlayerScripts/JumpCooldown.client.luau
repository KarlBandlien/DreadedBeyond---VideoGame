local JUMP_COOLDOWN = .5

local localPlayer = game:GetService("Players").LocalPlayer
local Character = localPlayer.Character or localPlayer.CharacterAdded:Wait()
local Humanoid = Character:FindFirstChild("Humanoid") or Character:WaitForChild("Humanoid")

local canJump = true

local function onStateChanged(_, newState)
	if newState == Enum.HumanoidStateType.Jumping and canJump then
		canJump = false
		Humanoid:SetStateEnabled("Jumping", false)
		task.wait(JUMP_COOLDOWN)                    
		canJump = true
		Humanoid:SetStateEnabled("Jumping", true) 
	end
end

Humanoid.StateChanged:Connect(onStateChanged)
