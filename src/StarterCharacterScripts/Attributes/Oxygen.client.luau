local tweenService = game:GetService("TweenService")
local runService = game:GetService("RunService")

local localPlayer = game.Players.LocalPlayer
local char = localPlayer.Character or localPlayer.CharacterAdded:Wait()
local playerGui = localPlayer:WaitForChild("PlayerGui")

local oxygenDisplay = playerGui.StatsUi.StatsBox.Oxygen  -- Updated variable name
local leftCircle = oxygenDisplay:WaitForChild("left"):WaitForChild("Circle")
local rightCircle = oxygenDisplay:WaitForChild("right"):WaitForChild("Circle")
local centerText = oxygenDisplay:WaitForChild("Center")

local oxygenLevel = Instance.new("NumberValue")  -- Renamed for clarity
oxygenLevel.Value = 50  -- Start at 100%

-- Store the original color of the UIGradient
local originalColorLeft = leftCircle.UIGradient.Color
local originalColorRight = rightCircle.UIGradient.Color

-- Variable to track blinking state
local isBlinking = false

-- Function to start blinking effect when oxygen is low
local function startBlinking()
	if isBlinking then return end  -- Prevent starting a new blink if already blinking
	isBlinking = true

	while oxygenLevel.Value <= 20 do
		-- Change to red
		leftCircle.UIGradient.Color = ColorSequence.new(Color3.fromRGB(255, 0, 0))
		rightCircle.UIGradient.Color = ColorSequence.new(Color3.fromRGB(255, 0, 0))

		task.wait(0.5)  -- Wait for half a second

		-- Change back to original color
		leftCircle.UIGradient.Color = originalColorLeft
		rightCircle.UIGradient.Color = originalColorRight

		task.wait(0.5)  -- Wait for half a second
	end

	isBlinking = false  -- Reset blinking state when exiting loop
end

-- Update function for oxygen display
oxygenLevel:GetPropertyChangedSignal("Value"):Connect(function()
	local rotation = math.floor(math.clamp(oxygenLevel.Value * 3.6, 0, 360))

	-- Update the percentage display as an integer without decimals
	centerText.Percentage.Text = math.floor(oxygenLevel.Value) .. "%"

	rightCircle.UIGradient.Rotation = math.clamp(rotation, 0, 180)
	leftCircle.UIGradient.Rotation = math.clamp(rotation, 180, 360)

	-- Check if oxygen level is 20% or below
	if oxygenLevel.Value <= 20 then
		-- Start blinking effect
		startBlinking()
	else
		-- Reset to original color if above 20%
		leftCircle.UIGradient.Color = originalColorLeft
		rightCircle.UIGradient.Color = originalColorRight
	end
end)

task.wait(1.5)

-- Variable to track if depletion is active
local isDepleting = false

-- Function to handle oxygen depletion if DepleteOxygen is true
local function depleteOxygenBar()
	isDepleting = true
	while oxygenLevel.Value > 0 and char:GetAttribute("DepleteOxygen") do
		local tween = tweenService:Create(
			oxygenLevel, 
			TweenInfo.new(1, Enum.EasingStyle.Quart, Enum.EasingDirection.Out),
			{
				Value = math.max(0, oxygenLevel.Value - 1)  -- Decrease by 1
			}
		)

		tween:Play()
		tween.Completed:Wait()  -- Wait for the tween to complete

		-- Check for DepleteOxygen attribute again after waiting
		if not char:GetAttribute("DepleteOxygen") then
			break
		end

		task.wait(5)  -- Wait before the next depletion
	end

	if oxygenLevel.Value <= 0 then
		-- Wait for 5 seconds if oxygen level is 0
		task.wait(5)

		-- Check again if oxygen level is still 0
		if oxygenLevel.Value <= 0 then
			-- Kill the player
			local humanoid = char:FindFirstChildOfClass("Humanoid")
			if humanoid then
				humanoid.Health = 0  -- Kill the player by setting health to 0
			end
		end
	end

	isDepleting = false
end

-- Function to start depletion when DepleteOxygen is true
local function checkDepleteOxygen()
	if char:GetAttribute("DepleteOxygen") and not isDepleting then
		depleteOxygenBar()
	end
end

-- Listen for changes to DepleteOxygen attribute
char:GetAttributeChangedSignal("DepleteOxygen"):Connect(checkDepleteOxygen)

checkDepleteOxygen()
