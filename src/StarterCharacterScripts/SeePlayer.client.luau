
local camera = workspace.CurrentCamera
local player = game.Players.LocalPlayer

-- Wait for the character to load
local character = player.Character or player.CharacterAdded:Wait()
local humanoid = character:WaitForChild("Humanoid")
wait(1)

local char = script.Parent
local hum = char:WaitForChild("Humanoid")

hum.CameraOffset = Vector3.new(0, 0, -1)


-- Function to set transparency for all relevant parts and adjust light properties recursively
local function setTransparency(part)
	if part:IsA("BasePart") or part:IsA("MeshPart") then
		if not part.Name:find("Head") then
			-- Keep transparency tied to its actual transparency
			part:GetPropertyChangedSignal("LocalTransparencyModifier"):Connect(function()
				part.LocalTransparencyModifier = part.Transparency
			end)
			part.LocalTransparencyModifier = part.Transparency
		else
			-- Make the head fully transparent
			part.Transparency = 1
			part.LocalTransparencyModifier = 1
		end
	elseif part:IsA("Attatchment") or part:IsA("Beam") then
		-- Handle lights: ensure visibility and adjust properties as needed
		part.LocalTransparencyModifier  = 0
		part.Enabled = true
		part:GetPropertyChangedSignal("Enabled"):Connect(function()
			
			if not part.Enabled then
				part.Enabled = true -- Keep lights always enabled
			end
		end)
	end

	-- Recursively handle children
	for _, child in ipairs(part:GetChildren()) do
		setTransparency(child)
	end
end

-- Start with the character
setTransparency(character)

-- If the player steps into a vehicle
camera:GetPropertyChangedSignal("CameraSubject"):Connect(function()
	if camera.CameraSubject:IsA("VehicleSeat") then
		camera.CameraSubject = humanoid
	end
end)
