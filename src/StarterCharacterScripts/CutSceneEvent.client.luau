local replicatedStorage = game:GetService("ReplicatedStorage")
local CutsceneEvent = replicatedStorage:WaitForChild("CutsceneEvent")
local currentCamera = workspace.CurrentCamera
local Players = game:GetService("Players")

-- Function to instantly set the camera to the passed attachment's CFrame
local function setCameraToAttachment(attachment)
	currentCamera.CameraType = Enum.CameraType.Scriptable

	-- Set the camera's CFrame to the attachment's World CFrame
	currentCamera.CFrame = attachment.WorldCFrame
end

CutsceneEvent.OnClientEvent:Connect(function(action, attachment, animationId)
	local player = Players.LocalPlayer
	local character = player.Character or player.CharacterAdded:Wait()
	local humanoid = character:WaitForChild("Humanoid")

	if action == "start" and attachment then
		-- Instantly set the camera to the passed attachment
		setCameraToAttachment(attachment)

		-- Play the animation
		if animationId then
			local animator = humanoid:FindFirstChildWhichIsA("Animator")
			if not animator then
				-- Create Animator if it doesn't exist
				animator = Instance.new("Animator", humanoid)
			end

			-- Load and play the animation
			local animation = Instance.new("Animation")
			animation.AnimationId = animationId
			local animationTrack = animator:LoadAnimation(animation)
			animationTrack.Priority = Enum.AnimationPriority.Action
			animationTrack:Play()
		end
	elseif action == "stop" then
		-- Reset the camera back to normal
		currentCamera.CameraType = Enum.CameraType.Custom

		-- Stop any animation if it's playing
		if humanoid and humanoid:FindFirstChildWhichIsA("Animator") then
			local animator = humanoid:FindFirstChildWhichIsA("Animator")
			for _, track in pairs(animator:GetPlayingAnimationTracks()) do
				track:Stop()
			end
		end
	end
end)
