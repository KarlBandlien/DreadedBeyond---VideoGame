local tweenService = game:GetService("TweenService")

local localPlayer = game.Players.LocalPlayer
local char = localPlayer.Character or localPlayer.CharacterAdded:Wait()
local playerGui = localPlayer:WaitForChild("PlayerGui")

-- Change from progress to Health
local healthDisplay = playerGui.StatsUi.StatsBox.Health
local left = healthDisplay:WaitForChild("left"):WaitForChild("Circle")
local right = healthDisplay:WaitForChild("right"):WaitForChild("Circle")
local center = healthDisplay:WaitForChild("Center")

-- Initialize health percentage
local healthPercentage = Instance.new("NumberValue")
healthPercentage.Value = 100  -- Start at 100% health

-- Function to update the health bar UI
local function updateHealthBar()
	local rotation = math.floor(math.clamp(healthPercentage.Value * 3.6, 0, 360))

	-- Update the percentage display as an integer without decimals
	center.Percentage.Text = math.floor(healthPercentage.Value) .. "%"

	-- Rotate UI gradients based on the health percentage
	right.UIGradient.Rotation = math.clamp(rotation, 0, 180)
	left.UIGradient.Rotation = math.clamp(rotation, 180, 360)
end

-- Update the health bar whenever healthPercentage.Value changes
healthPercentage:GetPropertyChangedSignal("Value"):Connect(updateHealthBar)

-- Function to handle health changes
local function onHealthChanged(newHealth)
	-- Calculate health as a percentage of maximum health
	local humanoid = char:FindFirstChild("Humanoid")
	if humanoid then
		local maxHealth = humanoid.MaxHealth
		local healthPercent = (newHealth / maxHealth) * 100

		-- Tween the healthPercentage value to smoothly update the UI
		local tween = tweenService:Create(
			healthPercentage,
			TweenInfo.new(0.3, Enum.EasingStyle.Quart, Enum.EasingDirection.Out),  -- Adjust speed as needed
			{ Value = healthPercent }
		)
		tween:Play()
	end
end

-- Function to setup health listener
local function setupHealthListener()
	local humanoid = char:WaitForChild("Humanoid")
	onHealthChanged(humanoid.Health)  -- Initialize UI based on current health

	humanoid.HealthChanged:Connect(onHealthChanged)
end

-- Listen for character respawn and setup health listener
local function onCharacterAdded(newCharacter)
	char = newCharacter
	setupHealthListener()  -- Setup the health listener for the new character
end

-- Initial setup
setupHealthListener()

-- Connect to the CharacterAdded event in case the player respawns
localPlayer.CharacterAdded:Connect(onCharacterAdded)
