-- Importing the TweenService for animations
local TweenService = game:GetService("TweenService")

-- Define the door model for easier reference
local doorModel = script.Parent.Parent.Parent.Parent.Parent.Parent

-- Define both proximity prompts attached to the door for interaction
local proximityPrompt = doorModel.RightDoor.LightLatch.InsideCylinder.Attachment:FindFirstChild("ProximityPrompt")
local proximityPrompt2 = doorModel.LeftDoor.LightLatch.InsideCylinder.Attachment:FindFirstChild("ProximityPrompt")

-- Sound references
local lightBeamSound = script.LightBeam
local PistonSound = script.Pistons
local doorOpenSound = script.DoorOpen
local doorCloseSound = script.DoorClose

-- Ensure the sounds are parented to the Workspace (or a part of the door)
local function ensureSoundParenting()
	lightBeamSound.Parent = doorModel.LeftDoor -- Parent light beam sound to the left door part
	PistonSound.Parent = doorModel.LeftDoor.Piston.PistonBlock -- Parent piston sound to a piston block
	doorOpenSound.Parent = doorModel.LeftDoor -- Parent door open sound to the left door part
	doorCloseSound.Parent = doorModel.LeftDoor -- Parent door close sound to the left door part
end

-- Getting the piston blocks for the door's animation
local piston1 = doorModel.LeftDoor.Piston.PistonBlock
local piston2 = doorModel.RightDoor.Piston.PistonBlock
local piston3 = doorModel.TopDoor.Piston.PistonBlock

-- Function to wait for a single tween to complete
local function waitForTweenCompletion(tween)
	tween.Completed:Wait()  -- Waits for the specific tween to complete
end

-- Function to create tweens for welds
local function tweenWeldC1(weld, rotationZ, duration)
	if weld and weld:IsA("Weld") then
		local tweenInfo = TweenInfo.new(duration, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
		local targetC1 = weld.C1 * CFrame.Angles(0, 0, math.rad(rotationZ))
		local tween = TweenService:Create(weld, tweenInfo, { C1 = targetC1 })
		tween:Play()
		return tween
	end
end

-- Function to create tweens for door parts
local function tweenDoorParts(door, shiftCFrame, duration)
	local tweens = {}
	local tweenInfo = TweenInfo.new(duration, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
	for _, part in ipairs(door:GetDescendants()) do
		if part:IsA("BasePart") then
			local targetCFrame = part.CFrame * shiftCFrame
			local tween = TweenService:Create(part, tweenInfo, { CFrame = targetCFrame })
			tween:Play()
			table.insert(tweens, tween)
		end
	end
	return tweens
end

-- Function to create tweens for pistons
local function tweenPistons(pistons, targetPositions, duration)
	local tweens = {}
	local tweenInfo = TweenInfo.new(duration, Enum.EasingStyle.Linear, Enum.EasingDirection.InOut)
	for i, piston in ipairs(pistons) do
		local tween = TweenService:Create(piston, tweenInfo, { Position = targetPositions[i] })
		tween:Play()
		table.insert(tweens, tween)
	end
	return tweens
end

-- Connecting the trigger to the action
script.Parent.Triggered:Connect(function()
	-- Ensure the sounds are parented correctly
	ensureSoundParenting()

	-- Check if the door is currently closed by looking at the "Closed" attribute
	if doorModel:GetAttribute("Closed") == true then
		print("Start")

		-- Disable both proximity prompts to prevent triggering during the door's animation process
		proximityPrompt.Enabled = false
		proximityPrompt2.Enabled = false

		-- Play the light beam sound at the start of Section 1
		lightBeamSound:Play()

		-- SECTION 1
		-- Reference the cylinders responsible for the light beam animations
		local leftCylinder = doorModel.LeftDoor.LightLatch.InsideCylinder
		local rightCylinder = doorModel.RightDoor.LightLatch.InsideCylinder

		-- Reference the welds that control the light beam positions
		local leftLightBeamWeld = leftCylinder:FindFirstChild("LightBeam")
		local rightLightBeamWeld = rightCylinder:FindFirstChild("LightBeam")
		local leftLightBeamSidesWeld = leftCylinder:FindFirstChild("LightBeamSides")
		local rightLightBeamSidesWeld = rightCylinder:FindFirstChild("LightBeamSides")

		-- Start the tweens for light beam welds one by one
		local tween1 = tweenWeldC1(leftLightBeamWeld, 260, 1)
		local tween2 = tweenWeldC1(rightLightBeamWeld, 260, 1)
		local tween3 = tweenWeldC1(leftLightBeamSidesWeld, -140, 1)
		local tween4 = tweenWeldC1(rightLightBeamSidesWeld, -140, 1)
		waitForTweenCompletion(tween4)

		-- END SECTION 1

		-- Play the piston sound at the start of Section 2
		PistonSound:Play()

		-- SECTION 2
		-- Defining the target positions for each piston (their final positions)
		-- Calculate target positions relative to the pistons' local orientations
		local piston1TargetPosition = piston1.CFrame:PointToWorldSpace(Vector3.new(0.3, -1, 0))
		local piston2TargetPosition = piston2.CFrame:PointToWorldSpace(Vector3.new(-1, 0, 0))
		local piston3TargetPosition = piston3.CFrame:PointToWorldSpace(Vector3.new(0.3, 1, 0))


		-- Create piston tweens one by one
		local pistonTween1 = tweenPistons({piston1}, {piston1TargetPosition}, 1)[1]
		local pistonTween2 = tweenPistons({piston2}, {piston2TargetPosition}, 1)[1]
		local pistonTween3 = tweenPistons({piston3}, {piston3TargetPosition}, 1)[1]
		waitForTweenCompletion(pistonTween3)

		-- END SECTION 2

		-- Play the door opening sound at the start of Section 3
		doorOpenSound:Play()

		-- SECTION 3
		-- Create door movement tweens one by one
		local leftDoorTween = tweenDoorParts(doorModel.LeftDoor, CFrame.new(8, 0, 0), 1)[1]
		local rightDoorTween = tweenDoorParts(doorModel.RightDoor, CFrame.new(-8, 0, 0), 1)[1]
		local topDoorTween = tweenDoorParts(doorModel.TopDoor, CFrame.new(0, 3, 0), 1)[1]
		waitForTweenCompletion(topDoorTween)

		-- END SECTION 3

		print("done")

		-- Reactivate the proximity prompts after all animations are completed
		proximityPrompt.Enabled = true
		proximityPrompt2.Enabled = true

		-- Toggle the "Closed" attribute to its opposite value (open the door)
		doorModel:SetAttribute("Closed", false)

	else
		-- Play the door closing sound at the start of the closing sequence
		doorCloseSound:Play()

		proximityPrompt.Enabled = false
		proximityPrompt2.Enabled = false

		-- SECTION 3
		-- Create door movement tweens one by one
		local leftDoorTween = tweenDoorParts(doorModel.LeftDoor, CFrame.new(-8, 0, 0), 1)[1]
		local rightDoorTween = tweenDoorParts(doorModel.RightDoor, CFrame.new(8, 0, 0), 1)[1]
		local topDoorTween = tweenDoorParts(doorModel.TopDoor, CFrame.new(0, -3, 0), 1)[1]
		waitForTweenCompletion(topDoorTween)

		-- END SECTION 3

		-- SECTION 2
		-- Calculate target positions relative to the pistons' local orientations
		local piston1TargetPosition = piston1.CFrame:PointToWorldSpace(Vector3.new(-0.3, 1, 0))
		local piston2TargetPosition = piston2.CFrame:PointToWorldSpace(Vector3.new(1, 0, 0))
		local piston3TargetPosition = piston3.CFrame:PointToWorldSpace(Vector3.new(-0.3, -1, 0))


		-- Create piston tweens one by one
		local pistonTween1 = tweenPistons({piston1}, {piston1TargetPosition}, 1)[1]
		local pistonTween2 = tweenPistons({piston2}, {piston2TargetPosition}, 1)[1]
		local pistonTween3 = tweenPistons({piston3}, {piston3TargetPosition}, 1)[1]
		waitForTweenCompletion(pistonTween3)

		-- END SECTION 2

		-- Play the light beam sound for closing the door in SECTION 1
		lightBeamSound:Play()

		-- SECTION 1
		-- Reference the cylinders responsible for the light beam animations
		local leftCylinder = doorModel.LeftDoor.LightLatch.InsideCylinder
		local rightCylinder = doorModel.RightDoor.LightLatch.InsideCylinder

		-- Reference the welds that control the light beam positions
		local leftLightBeamWeld = leftCylinder:FindFirstChild("LightBeam")
		local rightLightBeamWeld = rightCylinder:FindFirstChild("LightBeam")
		local leftLightBeamSidesWeld = leftCylinder:FindFirstChild("LightBeamSides")
		local rightLightBeamSidesWeld = rightCylinder:FindFirstChild("LightBeamSides")

		-- Start the tweens for light beam welds one by one
		local tween1 = tweenWeldC1(leftLightBeamWeld, -260, 1)
		local tween2 = tweenWeldC1(rightLightBeamWeld, -260, 1)
		local tween3 = tweenWeldC1(leftLightBeamSidesWeld, 140, 1)
		local tween4 = tweenWeldC1(rightLightBeamSidesWeld, 140, 1)
		waitForTweenCompletion(tween4)

		-- END SECTION 1

		-- Reactivate the proximity prompts after all reverse animations are finished
		proximityPrompt.Enabled = true
		proximityPrompt2.Enabled = true

		-- Toggle the "Closed" attribute to its opposite value (open the door)
		doorModel:SetAttribute("Closed", true)
	end
end)
