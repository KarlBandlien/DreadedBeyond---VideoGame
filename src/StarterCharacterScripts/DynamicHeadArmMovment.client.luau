local Player = game.Players.LocalPlayer
local Camera = workspace.CurrentCamera
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local HeadMovementEvent = ReplicatedStorage.Events:WaitForChild("HeadMovementEvent")

local Character = Player.Character or Player.CharacterAdded:Wait()
local Head = Character:WaitForChild("Head")
local Torso = Character:WaitForChild("Torso")
local Neck = Torso:WaitForChild("Neck")
local RShoulder = Torso:WaitForChild("Right Shoulder")
local LShoulder = Torso:WaitForChild("Left Shoulder")
local Humanoid = Character:WaitForChild("Humanoid")

local PlayerMouse = Player:GetMouse()
local NeckOriginC0 = Neck.C0
local RShoulderOriginC0 = RShoulder.C0
local LShoulderOriginC0 = LShoulder.C0

-- Ensure lights are visible in first-person mode
local function ensureLightsVisible()
	for _, child in ipairs(Head:GetChildren()) do
		if child:IsA("Light") then
			child.Enabled = true
		end
	end
end





game:GetService("RunService").RenderStepped:Connect(function()
	if Neck and Head and Torso then
		
		--Get the direction the camera is facing on the X axis
		local CamDirection = -Camera.CFrame.LookVector.Y
		
		--Convert camera orientation into CFrame format
		local LookOrientationX = CFrame.Angles(CamDirection, math.rad(0), math.rad(0))
		local LookOrientationZ = CFrame.Angles(math.rad(0), math.rad(0), CamDirection)
		local LookOrientationNegZ = CFrame.Angles(math.rad(0), math.rad(0), -CamDirection)
		
		--Do the math for the new cframe on the neck and apply the new CFrame on the client
		local NewNeckCFrame = NeckOriginC0 * LookOrientationX
		Neck.C0 = NewNeckCFrame
		
		--Calculate the new CFrame for the arms and apply to both shoulders on the client
		local NewRShoulderCFrame = RShoulderOriginC0 * LookOrientationNegZ
		RShoulder.C0 = NewRShoulderCFrame
		local NewLShoulderCFrame = LShoulderOriginC0 * LookOrientationZ
		LShoulder.C0 = NewLShoulderCFrame
				
		-- Send the new CFrames to the server for replication
		HeadMovementEvent:FireServer(NewNeckCFrame, NewRShoulderCFrame, NewLShoulderCFrame)

		-- Ensure lights remain visible
		ensureLightsVisible()
		
	end
end)
