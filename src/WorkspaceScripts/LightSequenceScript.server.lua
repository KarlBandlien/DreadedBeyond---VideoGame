local lightSequenceFolder = script.Parent
local totalCycles = 6 -- Total number of LightCycle folders
local waitTime = 0.7
-- Wait time between cycles
local meetingRoomFolder = script.Parent.Parent

-- Function to set light color to a medium orange
local function setLightColor(light)
	if light then
		light.Color = Color3.new(0.647059, 0.380392, 0.164706) -- Orange color
	end
end

-- Function to reset light color to regular color (assuming white as the regular color)
local function resetLightColor(light)
	if light then
		light.Color = Color3.new(0.639216, 0.635294, 0.647059) -- White color, or regular color
	end
end

-- Function to process a specific folder and set the lights to orange
local function processFolder(folder)
	for _, child in ipairs(folder:GetChildren()) do
		setLightColor(child)
	end
end

-- Function to reset all lights in a folder back to their regular color
local function resetFolder(folder)
	for _, child in ipairs(folder:GetChildren()) do
		resetLightColor(child)
	end
end

-- Main loop to cycle through the folders
while true do
	for i = 1, totalCycles do
		local folderName = "LightCycle" .. i
		local folder = lightSequenceFolder:FindFirstChild(folderName)

	
		if folder then
			

			-- Check if the folder has an ID attribute, and set the 'IDLit' attribute of meetingRoomFolder
			local folderID = folder:GetAttribute("ID")
			if folderID then
				meetingRoomFolder:SetAttribute("IDLit", folderID)
			end

			-- Process the folder (set lights to orange)
			processFolder(folder)

			-- Wait before resetting the color
			wait(waitTime)

			-- Reset the lights back to their regular color
			resetFolder(folder)
		end
	end
end
