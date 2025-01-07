local replicatedStorage = game:GetService("ReplicatedStorage")
local CutsceneEvent = replicatedStorage.Events:WaitForChild("CutsceneEvent")
local proximityPrompt = script.Parent -- The ProximityPrompt
local cellFrame = proximityPrompt.Parent.Parent -- Assuming the ProximityPrompt is under the CellFrame
local leftAttachment = cellFrame:WaitForChild("LeftTeleportAttachment") -- Left teleport point
local rightAttachment = cellFrame:WaitForChild("RightTeleportAttachment") -- Right teleport point
local soundService = game:GetService("SoundService")
local PowerCoreOn = soundService.PowerCoreOn
local PowerCoreCell = soundService.PowerCoreCell


local LeftCell = cellFrame.LeftCell
local RightCell = cellFrame.RightCell

local LeftLight = cellFrame.LightLeft
local RightLight = cellFrame.LightRight

-- Setting initial cell attributes
cellFrame:SetAttribute("LeftCell", false)
cellFrame:SetAttribute("RightCell", false)

-- Function to check for the NucularPowerCell and delete it
local function removePowerCell(player)
	local character = player.Character
	local backpack = player:FindFirstChild("Backpack")

	-- Check the Character and Backpack for the NucularPowerCell
	if character then
		local cellInCharacter = character:FindFirstChild("NucularPowerCell")
		if cellInCharacter then
			cellInCharacter:Destroy()
			return true -- PowerCell removed
		end
	end

	return false -- No PowerCell found
end


-- Custom logic function when both cells are full
local function customFullCellsLogic(player)

	if cellFrame:GetAttribute("LeftCell", true) and cellFrame:GetAttribute("RightCell", true) then
		local PowerCore = cellFrame.Parent.Parent.POWERCORE

		for _, part in ipairs(PowerCore:GetChildren()) do
			print("jaksdf")
			part.Transparency = 0
		end

		-- Play the PowerCoreOn sound when both cells are full
		PowerCoreOn:Play()
	end

end

-- Function to teleport the player
local function teleportPlayer(player)
	-- Ensure the player has a character and HumanoidRootPart
	local character = player.Character or player.CharacterAdded:Wait()
	local rootPart = character:FindFirstChild("HumanoidRootPart")

	if rootPart then
		-- Check if the player has a NucularPowerCell
		local hasCell = removePowerCell(player)
		if not hasCell then
			print("Player does not have a NucularPowerCell!")
			return
		end

		-- Check attributes on the CellFrame to determine teleport destination
		if not cellFrame:GetAttribute("LeftCell") then
			--rootPart.CFrame = leftAttachment.WorldCFrame
			cellFrame:SetAttribute("LeftCell", true) -- Mark the left cell as full
			for _, part in ipairs(LeftCell:GetChildren()) do
				part.Transparency = 0
			end
			LeftLight.Color = Color3.fromRGB(0, 255, 0) -- Change light color to green
			PowerCoreCell:Play() -- Play the PowerCoreCell sound when the left cell is filled
			customFullCellsLogic(player) -- Call the custom logic function when both cells are full

		elseif not cellFrame:GetAttribute("RightCell") then
			--rootPart.CFrame = rightAttachment.WorldCFrame
			cellFrame:SetAttribute("RightCell", true) -- Mark the right cell as full
			for _, part in ipairs(RightCell:GetChildren()) do
				part.Transparency = 0
			end
			RightLight.Color = Color3.fromRGB(0, 255, 0) -- Change light color to green
			PowerCoreCell:Play() -- Play the PowerCoreCell sound when the right cell is filled
			customFullCellsLogic(player) -- Call the custom logic function when both cells are full
		end
	else
		warn("HumanoidRootPart not found for " .. player.Name)
	end
end


-- ProximityPrompt Triggered Event
proximityPrompt.Triggered:Connect(function(player)
	teleportPlayer(player)
end)
