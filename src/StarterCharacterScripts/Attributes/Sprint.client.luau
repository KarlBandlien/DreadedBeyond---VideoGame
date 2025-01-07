-- Variables
local player = game.Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()
local humanoid = character:WaitForChild("Humanoid")
local sprintSpeed = 24 -- Speed when sprinting
local normalSpeed = humanoid.WalkSpeed -- Capture the original speed
local reducedSpeed = 6 -- Reduced speed when stamina is zero
local sprintKey = Enum.KeyCode.LeftShift -- Key used for sprinting
local playergui = player.PlayerGui

-- Stamina Settings
local maxStamina = 100 -- Maximum stamina
local currentStamina = maxStamina -- Start with full stamina
local staminaDrainRate = maxStamina / 7 -- Depletes over 7 seconds
local staminaRegenRate = maxStamina / 10 -- Regenerates in 10 seconds
local punishmentDuration = 3 -- Punishment lasts 3 seconds

-- FOV and Tween Settings
local TweenService = game:GetService("TweenService")
local camera = game.Workspace.CurrentCamera
local normalFOV = camera.FieldOfView -- Original FOV
local sprintFOV = 80 -- FOV while sprinting
local tweenTime = 0.3 -- Duration of the FOV tween

local statsBox = playergui.StatsUi.StatsBox
local stamina = statsBox.Stamina
local staminaBar = stamina.StaminaOutline.Stamina

local isSprinting = false -- Track if sprinting to handle stamina
local isPunished = false -- Track if punishment is active

-- Function to create and play a tween for FOV
local function tweenFOV(targetFOV)
	local tweenInfo = TweenInfo.new(tweenTime, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
	local tween = TweenService:Create(camera, tweenInfo, { FieldOfView = targetFOV })
	tween:Play()
end

-- Function to update the stamina bar UI
local function updateStaminaBar()
	staminaBar.Size = UDim2.new(currentStamina / maxStamina, 0, 1, 0)
end

-- Function to start sprinting
local function startSprinting()
	if currentStamina > 0 and not isPunished then
		isSprinting = true
		humanoid.WalkSpeed = sprintSpeed
		tweenFOV(sprintFOV) -- Smoothly increase FOV for sprint effect
	end
end

-- Function to stop sprinting
local function stopSprinting()
	isSprinting = false
	humanoid.WalkSpeed = normalSpeed -- Restore original speed
	tweenFOV(normalFOV) -- Smoothly reset FOV
end

-- Function to apply punishment when stamina reaches zero
local function applyPunishment()
	isPunished = true
	isSprinting = false -- Stop sprinting during punishment
	humanoid.WalkSpeed = reducedSpeed -- Reduce speed

	-- Stop stamina regeneration during punishment
	task.delay(punishmentDuration, function()
		isPunished = false
		humanoid.WalkSpeed = normalSpeed -- Restore normal speed after punishment
	end)
end

-- Stamina management loop
game:GetService("RunService").RenderStepped:Connect(function(deltaTime)
	-- If moving, regardless of sprinting or walking, regenerate stamina
	if humanoid.MoveDirection.Magnitude > 0 then
		-- Regenerate stamina while moving, even if not sprinting
		if not isSprinting and currentStamina < maxStamina then
			currentStamina = math.min(currentStamina + staminaRegenRate * deltaTime, maxStamina)
		end

		-- Drain stamina while sprinting
		if isSprinting then
			currentStamina = math.max(currentStamina - staminaDrainRate * deltaTime, 0)
			if currentStamina <= 0 and not isPunished then
				stopSprinting() -- Stop sprinting if stamina is depleted
				applyPunishment() -- Apply punishment
			end
		end
	elseif humanoid.MoveDirection.Magnitude == 0 and not isPunished then
		-- Regenerate stamina when not moving, even if sprint key is held
		currentStamina = math.min(currentStamina + staminaRegenRate * deltaTime, maxStamina)
	end

	updateStaminaBar() -- Update the stamina bar display
end)

-- Detect key press to start sprinting
local UserInputService = game:GetService("UserInputService")
UserInputService.InputBegan:Connect(function(input, isProcessed)
	if isProcessed then return end -- Ignore if the input is already processed
	if input.KeyCode == sprintKey then
		startSprinting()
	end
end)

-- Detect key release to stop sprinting
UserInputService.InputEnded:Connect(function(input)
	if input.KeyCode == sprintKey then
		stopSprinting()
	end
end)

-- Update normal speed on respawn
player.CharacterAdded:Connect(function(newCharacter)
	character = newCharacter
	humanoid = character:WaitForChild("Humanoid")
	normalSpeed = humanoid.WalkSpeed -- Capture new character's original speed
end)
