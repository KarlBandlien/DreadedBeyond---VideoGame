local proximityPrompt = script.Parent
local seat = proximityPrompt.Parent
local sitAnimId = "116063059732144" -- Animation ID (unused in the original script)
local currentAnimationTrack = nil -- Variable to hold the animation track

-- Ensure the ProximityPrompt reacts to the seat's state
seat:GetPropertyChangedSignal("Occupant"):Connect(function()
	if seat.Occupant then
		proximityPrompt.Enabled = false
	else
		proximityPrompt.Enabled = true
	end
end)

-- Handle the ProximityPrompt trigger
proximityPrompt.Triggered:Connect(function(player)
	local character = player.Character
	if character and character:FindFirstChild("Humanoid") then
		seat:Sit(character.Humanoid)

		-- Optional: Play the sit animation
		local animator = character.Humanoid:FindFirstChild("Animator")
		if animator then
			local sitAnim = Instance.new("Animation")
			sitAnim.AnimationId = "rbxassetid://" .. sitAnimId
			local animationTrack = animator:LoadAnimation(sitAnim)
			animationTrack:Play()

			-- Store the current animation track for stopping later
			currentAnimationTrack = animationTrack
		end
	end
end)

-- Stop the animation when the player leaves the seat
seat:GetPropertyChangedSignal("Occupant"):Connect(function()
	if not seat.Occupant then
		-- Find the player who was sitting and stop their animation
		if currentAnimationTrack then
			currentAnimationTrack:Stop()  -- Stop the current animation when the player leaves
			currentAnimationTrack = nil   -- Reset the animation track variable
		end
	end
end)
