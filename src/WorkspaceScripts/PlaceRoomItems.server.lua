local repstorage = game:GetService("ReplicatedStorage")
local itemsFolder = repstorage.ItemsFolder
local smallFolder = itemsFolder:WaitForChild("Small")
local bigFolder = itemsFolder:WaitForChild("Big")
local weaponFolder = itemsFolder:WaitForChild("Weapon")

-- Create the SpawnedItems folder inside script.Parent
local spawnedItemsFolder = script.Parent:FindFirstChild("SpawnedItems")
if not spawnedItemsFolder then
	spawnedItemsFolder = Instance.new("Folder")
	spawnedItemsFolder.Name = "SpawnedItems"
	spawnedItemsFolder.Parent = script.Parent
end

-- Variables to keep track of the current index for cycling
local smallIndex = 1
local bigIndex = 1
local weaponIndex = 1

local function getNextItem(folder, currentIndex)
	local items = folder:GetChildren()
	if #items > 0 then
		-- Use the currentIndex and cycle it
		local nextItem = items[currentIndex]
		-- Increment index and loop back to 1 if necessary
		currentIndex = (currentIndex % #items) + 1
		return nextItem, currentIndex
	end
	return nil, currentIndex
end

local function placeItemAtSpawn(chosenSpawn)
	-- Check if an item is already placed at this spawn (i.e., if it has children)
	if chosenSpawn.Parent:FindFirstChild("ItemPlaced") then
		return -- Skip placing an item if one already exists
	end

	-- Check if the spawn point is "Weapon" for 100% chance
	if chosenSpawn.Name == "Weapon" then
		-- 100% chance to spawn a weapon item
		local randomItem
		randomItem, weaponIndex = getNextItem(weaponFolder, weaponIndex)

		if randomItem then
			local newItem = randomItem:Clone()

			-- Ensure the item has a PrimaryPart set before proceeding
			if newItem.PrimaryPart then
				local primaryPart = newItem.PrimaryPart

				-- Get the world position of the Attachment by using its parent's CFrame and the attachment's position
				local worldPosition = chosenSpawn.Parent.CFrame:pointToWorldSpace(chosenSpawn.Position)

				-- Generate random rotations only around the Y axis
				local randomYRotation = math.random(0, 360)

				-- Create a CFrame for random rotations only around the Y axis
				local rotation = CFrame.Angles(0, math.rad(randomYRotation), 0)

				-- Parent the item to the SpawnedItems folder and set the CFrame to the world position with the random Y rotation
				newItem.Parent = spawnedItemsFolder
				newItem:SetPrimaryPartCFrame(CFrame.new(worldPosition) * rotation)

				-- Mark this spawn as having an item placed
				local itemPlacedMarker = Instance.new("BoolValue")
				itemPlacedMarker.Name = "ItemPlaced"
				itemPlacedMarker.Parent = chosenSpawn.Parent
			else
				warn("No PrimaryPart set for item: " .. randomItem.Name)
			end
		end
	else
		-- 50% chance to place an item at each spawn point for "Small" or "Big"
		if math.random() < 0.5 then
			local randomItem
			if chosenSpawn.Name == "Small" then
				randomItem, smallIndex = getNextItem(smallFolder, smallIndex)
			elseif chosenSpawn.Name == "Big" then
				randomItem, bigIndex = getNextItem(bigFolder, bigIndex)
			end

			if randomItem then
				local newItem = randomItem:Clone()

				-- Ensure the item has a PrimaryPart set before proceeding
				if newItem.PrimaryPart then
					local primaryPart = newItem.PrimaryPart

					-- Get the world position of the Attachment by using its parent's CFrame and the attachment's position
					local worldPosition = chosenSpawn.Parent.CFrame:pointToWorldSpace(chosenSpawn.Position)

					-- Generate random rotations only around the Y axis
					local randomYRotation = math.random(0, 360)

					-- Create a CFrame for random rotations only around the Y axis
					local rotation = CFrame.Angles(0, math.rad(randomYRotation), 0)

					-- Parent the item to the SpawnedItems folder and set the CFrame to the world position with the random Y rotation
					newItem.Parent = spawnedItemsFolder
					newItem:SetPrimaryPartCFrame(CFrame.new(worldPosition) * rotation)

					-- Mark this spawn as having an item placed
					local itemPlacedMarker = Instance.new("BoolValue")
					itemPlacedMarker.Name = "ItemPlaced"
					itemPlacedMarker.Parent = chosenSpawn.Parent
				else
					warn("No PrimaryPart set for item: " .. randomItem.Name)
				end
			end
		end
	end
end

local function placeItemsInAllModels()
	for _, model in pairs(workspace:GetChildren()) do
		if model:FindFirstChild("ItemSpawns") then
			local itemSpawnPoints = model.ItemSpawns

			for _, chosenSpawn in pairs(itemSpawnPoints:GetDescendants()) do
				if chosenSpawn:IsA("Attachment") then
					placeItemAtSpawn(chosenSpawn)
				end
			end
		end
	end
end

placeItemsInAllModels()
