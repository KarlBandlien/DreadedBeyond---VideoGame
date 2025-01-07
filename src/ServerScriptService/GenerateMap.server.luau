local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Workspace = game.Workspace

local RoomsFolder = ReplicatedStorage:WaitForChild("Rooms")
local HallwaysFolder = ReplicatedStorage:WaitForChild("Hallways")

local lastSpawnedType = nil

local workspaceRoomsFolder = Workspace:FindFirstChild("RoomsFolder") or Instance.new("Folder", Workspace)
workspaceRoomsFolder.Name = "RoomsFolder"

local gridNodeFolder = Workspace:FindFirstChild("GridNodeFolder") or Instance.new("Folder", Workspace)
gridNodeFolder.Name = "GridNodeFolder"


local startRoomPosition = workspace.WorkSpace.StartingPos.Position




local MaxSegmentsPhase1 = 6
local MinSegmentsPhase1 = 3

local MaxSegmentsPhase2 = 20
local MinSegmentsPhase2 = 3


local GridSizePhase1 = 1
local GridSizePhase2 = 5
local GridSizePhase3 = 10




local NodeSpacing = 50
local visitedNodes = {}
local doorsUnconnected = {}
local gridNumber = 0


local nextNode




























--local function getValidDoor(newModel)
--	local newDoors = getDoors(newModel)
--	if #newDoors == 0 then
--		warn("New model has no doors.")
--		newModel:Destroy() -- Cleanup cloned model if no doors are found
--		return nil
--	end

--	-- Select a random door from the new model
--	return newDoors[math.random(1, #newDoors)]
--end

--local function calculateAlignedCFrame(previousDoor, newDoor)
--	local previousCFrame = previousDoor.CFrame
--	local newCFrame = newDoor.CFrame

--	-- Calculate the rotation to make the new door face the opposite direction of the previous door
--	local oppositeRotation = CFrame.Angles(0, math.pi, 0)

--	-- Align the new model's PrimaryPart (the chosen door) at the previous door position with the opposite rotation
--	return previousCFrame * oppositeRotation
--end

--local function createAndCheckHitbox(alignedCFrame, newModel)
--	-- Create a hitbox for collision checking
--	local hitbox = Instance.new("Part")
--	hitbox.Size = Vector3.new(5,10,5) -- Use rounded dimensions
--	hitbox.CFrame = alignedCFrame * CFrame.new(0, 0, -25) -- Offset by 25 studs in the opposite direction
--	hitbox.Transparency = 0.5 -- Semi-transparent for visibility
--	hitbox.Anchored = true
--	hitbox.CanCollide = true -- Enable collision for :GetTouchingParts()
--	hitbox.BrickColor = BrickColor.new("Bright yellow") -- Assign a visible color
--	hitbox.Parent = workspace

--	-- Check for collisions using :GetTouchingParts()
--	local touchingParts = hitbox:GetTouchingParts()

--	local nodeOccupied = false

--	if not (#touchingParts == 0) then
--		for _, part in ipairs(touchingParts) do
--			-- Ensure the part is in workspace and not part of the new model
--			if part:IsDescendantOf(workspace) and not part:IsDescendantOf(newModel) then
--				local isNode = string.lower(part.Name):find("node") ~= nil

--				if not isNode then
--					-- Non-Node part detected; set collision flag

--					nodeOccupied = true
--					break
--				else
--					-- Check Node part's Occupied attribute
--					local occupied = part:GetAttribute("Occupied")
--					if occupied == true then

--						nodeOccupied = true
--						break
--					elseif occupied == false then
--						-- Explicitly unoccupied Node parts are ignored
--						break
--					end
--				end
--			end
--		end
--	else
--		nodeOccupied = true
--	end

--	wait()
--	-- Cleanup hitbox
--	hitbox:Destroy()

--	return nodeOccupied
--end








--local function setRoomDistanceAndBillboard(newModel, previousDoor)
--	-- Get the previous room's distance (stored as an attribute)
--	local previousRoomDistance = previousDoor.Parent.Parent:GetAttribute("RoomDistance") or 0 -- Default to 0 if no attribute exists

--	-- Set the new room's distance as the previous room's distance + 1
--	newModel:SetAttribute("RoomDistance", previousRoomDistance + 1)

--	-- Create a BillboardGui to display the room's number
--	local billboard = Instance.new("BillboardGui")
--	billboard.Adornee = newModel.PrimaryPart -- Attach the BillboardGui to the primary part of the room
--	billboard.Size = UDim2.new(0, 100, 0, 50) -- Set size of the BillboardGui
--	billboard.StudsOffset = Vector3.new(0, 5, 0) -- Offset the BillboardGui above the room
--	billboard.AlwaysOnTop = true -- Ensure the billboard is always visible

--	-- Create a TextLabel to display the number
--	local textLabel = Instance.new("TextLabel")
--	textLabel.Size = UDim2.new(1, 0, 1, 0)
--	textLabel.Text = tostring(previousRoomDistance + 1) -- Display the current room number
--	textLabel.TextSize = 24
--	textLabel.TextColor3 = Color3.new(1, 1, 1) -- White text
--	textLabel.BackgroundTransparency = 1 -- Make the background transparent
--	textLabel.TextScaled = true -- Make the text scale with the label size
--	textLabel.Parent = billboard

--	-- Parent the BillboardGui to the room's PrimaryPart
--	billboard.Parent = newModel
--end




--local function placeAtDoor(previousDoor, newModel)
--	-- Get a valid door from the new model
--	local newDoor = getValidDoor(newModel)
--	if not newDoor then return false end

--	-- Set the chosen door as the PrimaryPart of the new model
--	newModel.PrimaryPart = newDoor

--	-- Calculate the aligned position and rotation for the new model
--	local alignedCFrame = calculateAlignedCFrame(previousDoor, newDoor)

--	-- Check for collisions with other parts
--	local nodeOccupied = createAndCheckHitbox(alignedCFrame, newModel)

--	if nodeOccupied then
--		warn("Detected occupied Node")
--		newModel:Destroy() -- Clean up the cloned room
--		return false -- Abort placement
--	end

--	-- Set the new model's position and rotation
--	newModel:SetPrimaryPartCFrame(alignedCFrame)

--	-- Parent the new model to the "Rooms" folder
--	newModel.Parent = workspaceRoomsFolder

--	-- Set node occupied and other attributes

--	setNodeOccupied(newModel)
--	setRoomDistanceAndBillboard(newModel, previousDoor)

--	-- Delete the used doors
--	previousDoor:Destroy()
--	newDoor:Destroy()

--	return previousDoor, newDoor
--end




--local function checkAndDeleteTouchingDoors()
--	-- Get all doors in the workspace
--	local allDoors = {}
--	for _, model in ipairs(workspaceRoomsFolder:GetDescendants()) do
--		if model:IsA("Model") then
--			local doorsFolder = model:FindFirstChild("Doors")
--			if doorsFolder then
--				for _, door in ipairs(doorsFolder:GetChildren()) do
--					if door:IsA("BasePart") then
--						table.insert(allDoors, door)
--					end
--				end
--			end
--		end
--	end



--	-- Check for overlapping doors
--	local processedDoors = {}
--	for i, door1 in ipairs(allDoors) do
--		if not processedDoors[door1] and door1:IsDescendantOf(workspace) then
--			local isTouching = false -- Flag to track if the door is touching another door
--			for j = i + 1, #allDoors do
--				local door2 = allDoors[j]
--				if not processedDoors[door2] and door2:IsDescendantOf(workspace) then
--					-- Check if the doors are overlapping
--					local overlap = (door1.Position - door2.Position).Magnitude < (door1.Size.Magnitude + door2.Size.Magnitude) / 2
--					if overlap then

--						-- Destroy both doors
--						door1:Destroy()
--						door2:Destroy()
--						-- Mark as processed
--						processedDoors[door1] = true
--						processedDoors[door2] = true
--						isTouching = true
--						break
--					end
--				end
--			end

--			-- If the door is not touching any other doors, add it to the doorsUnconnected array
--			if not isTouching and not processedDoors[door1] then
--				table.insert(doorsUnconnected, door1)
--				processedDoors[door1] = true
--			end
--		end
--	end

--	-- Now we want to connect a room from RoomFolder.OneDoorRooms to each of the unconnected doors
--	local oneDoorRooms = ReplicatedStorage.oneDoorRooms


--	for _, door in ipairs(doorsUnconnected) do
--		-- Choose a random room from OneDoorRooms
--		local randomRoom = oneDoorRooms:GetChildren()[math.random(1, #oneDoorRooms:GetChildren())]

--		if randomRoom then
--			-- Clone the room
--			local newRoom = randomRoom:Clone()

--			-- Use placeAtDoor function to position the room at the door's location
--			placeAtDoor(door, newRoom)



--			-- Optionally, you can add more logic here to adjust the room’s position/rotation relative to the door
--			-- E.g., adjusting door orientation, aligning door frames, etc.
--		end
--	end
--	--connectDoors()
--end






















-- Helper function to get all door parts in a model
local function getDoors(model)
	local doorsFolder = model:FindFirstChild("Doors")
	if doorsFolder then
		return doorsFolder:GetChildren()
	end
	return {}
end



local function setNodeOccupied(model)



	-- Check which grid nodes the room touches
	local touchingParts = model.NodeChecker:GetTouchingParts()

	for _, part in ipairs(touchingParts) do
		if part.Name:find("GridNode") or part.Name:find("EdgeNode") then
			part:SetAttribute("Occupied", true)

		end
	end
	
end


-- Function to create a new grid node
local function CreateGridNode(position, IsEdgeNode)
	
	
	if not IsEdgeNode then
		local gridNode = Instance.new("Part")
		gridNode.Name = "GridNode" .. gridNumber
		gridNode.Position = position
		gridNode.Size = Vector3.new(2, 2, 2)
		gridNode.Color = Color3.new(0, 1, 0) -- Color for grid nodes
		gridNode.Anchored = true
		gridNode.CanCollide = true
		gridNode.Parent = gridNodeFolder
		gridNode:SetAttribute("Occupied", false)
		gridNode:SetAttribute("Goal", false)
		gridNode:SetAttribute("GoalDistance", 0)
		
	else
		
		local gridNode = Instance.new("Part")
		gridNode.Name = "EdgeNode" .. gridNumber
		gridNode.Position = position
		gridNode.Size = Vector3.new(2, 2, 2)
		gridNode.Color = Color3.new(1, 0, 0.984314) -- Color for grid nodes
		gridNode.Anchored = true
		gridNode.CanCollide = true
		gridNode.Parent = gridNodeFolder
		gridNode:SetAttribute("Occupied", false)
		gridNode:SetAttribute("Goal", false)
		gridNode:SetAttribute("GoalDistance", 0)
	end
	


end






-- Helper function to get a string key for a position
local function GetPositionKey(position)
	return tostring(position.X) .. "," .. tostring(position.Y) .. "," .. tostring(position.Z)
end


local function SpawnGridNode(position, depthX, depthZ, GridSizeNumber, visitedNodes)
	-- Debug prints for tracking
	

	-- Check if the depth exceeds the grid size by more than 1
	if math.abs(depthX) > GridSizeNumber + 1 or math.abs(depthZ) > GridSizeNumber + 1 then
		return
	end

	-- Check if this position is already visited
	local positionKey = GetPositionKey(position)
	if visitedNodes[positionKey] then
		return
	end
	visitedNodes[positionKey] = true

	-- Determine if this is an edge node (1 past max grid size)
	local isEdgeNode = math.abs(depthX) == GridSizeNumber + 1 or math.abs(depthZ) == GridSizeNumber + 1

	-- Create the grid node with edgeNode parameter
	CreateGridNode(position, isEdgeNode)

	gridNumber = gridNumber + 1

	-- Directions for north, east, south, and west
	local directions = {
		{Vector3.new(0, 0, NodeSpacing), depthX, depthZ + 1},   -- North
		{Vector3.new(NodeSpacing, 0, 0), depthX + 1, depthZ},   -- East
		{Vector3.new(0, 0, -NodeSpacing), depthX, depthZ - 1},  -- South
		{Vector3.new(-NodeSpacing, 0, 0), depthX - 1, depthZ}   -- West
	}

	-- Recursively spawn nodes in each direction
	for _, dir in ipairs(directions) do
		local newPosition = position + dir[1]
		local newDepthX = dir[2]
		local newDepthZ = dir[3]
		SpawnGridNode(newPosition, newDepthX, newDepthZ, GridSizeNumber, visitedNodes)
	end
end


-- Function to generate the map
local function MapGeneration()
	
	visitedNodes = {} -- Clear the visited nodes to restart grid spawning
	doorsUnconnected = {} -- Clear unconnected doors
	workspaceRoomsFolder:ClearAllChildren() -- Clear the room instances in the workspace
	gridNodeFolder:ClearAllChildren() -- Clear the grid nodes

	-- Initialize variables
	local depthX = 0
	local depthZ = 0
	 

	-- Start the recursive grid generation
	SpawnGridNode(startRoomPosition, depthX, depthZ, GridSizePhase1, visitedNodes)
	
	
	
	local currentPosition = startRoomPosition
	local startRoomClone = ReplicatedStorage.StartRoom:Clone()
	startRoomClone.Parent = workspaceRoomsFolder
	startRoomClone:SetPrimaryPartCFrame(CFrame.new(currentPosition))

	setNodeOccupied(startRoomClone)

	
	local queue = {}
	for _, door in ipairs(getDoors(startRoomClone)) do
		table.insert(queue, door)
	end

	
	
	
	wait(4)
	
	visitedNodes = {} -- Clear the visited nodes to restart grid spawning
	doorsUnconnected = {} -- Clear unconnected doors
	workspaceRoomsFolder:ClearAllChildren() -- Clear the room instances in the workspace
	gridNodeFolder:ClearAllChildren() -- Clear the grid nodes
	
	
	
	
	-- Start the recursive grid generation
	SpawnGridNode(startRoomPosition, depthX, depthZ, GridSizePhase2, visitedNodes)
	
	
	
	
	
	
	
	
	
	
	
	
	

	

	
	

	--	-- Track the total number of segments created
	--	local segmentCount = 0

	--	-- Process the queue
	--	while #queue > 0 and segmentCount < MaxSegments do
	--		wait() -- Optional delay for visualization

	--		-- Get the next door to process
	--		local currentDoor = table.remove(queue, 1)

	--		-- Determine the type of room to spawn
	--		local newModel
	--		if math.random() > 0.5 then
	--			newModel = RoomsFolder:GetChildren()[math.random(1, #RoomsFolder:GetChildren())]:Clone()
	--		else
	--			newModel = HallwaysFolder:GetChildren()[math.random(1, #HallwaysFolder:GetChildren())]:Clone()
	--		end

	--		-- Place the new model at the current door
	--		local success = placeAtDoor(currentDoor, newModel)
	--		if success then
	--			segmentCount += 1
	--		end

	--		-- Stop further processing if limit is reached
	--		if segmentCount >= MaxSegments then
	--			break
	--		end

	--		-- Add the new model's doors to the queue (if within limit)
	--		for _, door in ipairs(getDoors(newModel)) do
	--			if not door:GetAttribute("Processed") then
	--				door:SetAttribute("Processed", true)
	--				if segmentCount + #queue < MaxSegments then
	--					table.insert(queue, door)
	--				else
	--					break
	--				end
	--			end
	--		end
	--	end

	--	checkAndDeleteTouchingDoors()

	--	-- Check if the minimum requirement is met
	--	if segmentCount < MinSegments then
	--		print("Not enough rooms generated, retrying...")
	--	else
	--		print("Map generation complete!")
	--	end
	--until segmentCount >= MinSegments
end

MapGeneration()