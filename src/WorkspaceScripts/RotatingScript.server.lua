local Hologram = script.Parent:FindFirstChild("gnomehollogram")  -- Ensure the model exists
local RunService = game:GetService("RunService")

-- Rotation speed in radians per second
local rotationSpeed = math.rad(50)  -- Adjust speed as needed

local humanoid = Hologram.Humanoid

-- Set the name display off
humanoid.DisplayDistanceType = Enum.HumanoidDisplayDistanceType.None

if Hologram and Hologram.PrimaryPart then
	-- Ensure the model has a PrimaryPart set
	RunService.Heartbeat:Connect(function(deltaTime)
		-- Rotate the model around its PrimaryPart
		local primaryPart = Hologram.PrimaryPart
		local currentCFrame = primaryPart.CFrame
		local rotationCFrame = CFrame.Angles(0, rotationSpeed * deltaTime, 0)

		-- Apply the rotation to the PrimaryPart and update the whole model
		local newCFrame = currentCFrame * rotationCFrame
		Hologram:SetPrimaryPartCFrame(newCFrame)
	end)
else
	warn("Hologram model or its PrimaryPart is missing.")
end
