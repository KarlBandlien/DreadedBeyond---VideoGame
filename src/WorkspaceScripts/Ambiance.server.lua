local AmbienceSound = script.Parent
local AmbientSounds = AmbienceSound.AmbianceSounds

-- Function to play a random sound from a given list (and access the sound's child)
local function playRandomSound(soundList)
	-- Ensure the list is not empty
	if #soundList > 0 then
		-- Choose a random ambient sound from the list
		local sound = soundList[math.random(1, #soundList)]

		-- Check if the sound is a valid Sound object
		if sound:IsA("Sound") then
			sound:Play()
		else
			-- If the sound is a folder, choose a sound from inside it (if there are children)
			local soundChildren = sound:GetChildren()
			if #soundChildren > 0 then
				local childSound = soundChildren[math.random(1, #soundChildren)]
				if childSound and childSound:IsA("Sound") then
					childSound:Play()
				end
			end
		end
	else
		warn("No sounds found in the Ambience folder!")
	end
end

-- Continuously play ambient sounds
while true do
	-- Play a random ambient sound
	playRandomSound(AmbientSounds:GetChildren())  -- Get the children of the Ambiance folder to pick from
	
	print(AmbientSounds:GetChildren())
	
	wait(math.random(2, 10))
end
