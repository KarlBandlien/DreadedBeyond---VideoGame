local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")

script.Parent.Triggered:Connect(function()
	print("Start")
	local lockerDoor = script.Parent.Parent
	local proximityPrompt = lockerDoor:FindFirstChild("ProximityPrompt") -- Find the ProximityPrompt
	local isOpen = lockerDoor:GetAttribute("IsOpen")

	if isOpen == nil then
		print("SetAttribute")
		lockerDoor:SetAttribute("IsOpen", false)
		isOpen = false
	end

	-- Define rotation parameters
	local pivot = lockerDoor:GetPivot()
	local rotationAngle = math.rad(100) -- Rotation angle in radians
	local duration = 0.2 -- Duration of the rotation in seconds
	local elapsedTime = 0

	local startCFrame = pivot
	local targetCFrame

	local openSoundFolder = script.Parent:FindFirstChild("Open") -- Reference to the Open sound folder
	local openSoundPick = math.random(1, #openSoundFolder:GetChildren())
	local openSound = openSoundFolder:GetChildren()[openSoundPick]
	local closeSound = script.Parent:FindFirstChild("Close") -- Reference to the Close sound

	if not isOpen then
		-- Use a small delay to ensure the ProximityPrompt hides immediately before starting animation
		if proximityPrompt then
			task.wait(0.1) -- Small delay
			proximityPrompt.Enabled = false
		end

		-- Change the ProximityPrompt text to "Close"
		if proximityPrompt then
			proximityPrompt.ActionText = "Close"
		end

		-- Open the door by rotating the specified angle
		targetCFrame = pivot * CFrame.Angles(0, 0, rotationAngle)
		lockerDoor:SetAttribute("IsOpen", true)

		-- Play the open sound
		if openSound then
			openSound:Play()
		end
	else
		-- Use a small delay to ensure the ProximityPrompt hides immediately before starting animation
		if proximityPrompt then
			task.wait(0.1) -- Small delay
			proximityPrompt.Enabled = false
		end

		-- Change the ProximityPrompt text to "Open"
		if proximityPrompt then
			proximityPrompt.ActionText = "Open"
		end

		-- Close the door by rotating back to the original position
		targetCFrame = pivot * CFrame.Angles(0, 0, -rotationAngle)
		lockerDoor:SetAttribute("IsOpen", false)

		-- Play the close sound
		if closeSound then
			closeSound:Play()
		end
	end

	-- Function for quadratic ease-in and ease-out interpolation
	local function easeQuadraticInOut(t)
		if t < 0.5 then
			return 2 * t * t
		else
			return -1 + (4 - 2 * t) * t
		end
	end

	-- Animate the rotation manually with quadratic easing
	local connection
	connection = RunService.Heartbeat:Connect(function(deltaTime)
		elapsedTime = elapsedTime + deltaTime
		local alpha = math.clamp(elapsedTime / duration, 0, 1)
		local easedAlpha = easeQuadraticInOut(alpha)

		-- Interpolate between the start and target rotations using easedAlpha
		local interpolatedCFrame = startCFrame:Lerp(targetCFrame, easedAlpha)
		lockerDoor:PivotTo(interpolatedCFrame)

		if alpha >= 1 then
			-- Stop the animation when complete
			connection:Disconnect()
			lockerDoor:PivotTo(targetCFrame) -- Ensure final alignment

			-- Immediately re-enable the ProximityPrompt once the animation is done
			if proximityPrompt then
				proximityPrompt.Enabled = true
			end
		end
	end)
end)
