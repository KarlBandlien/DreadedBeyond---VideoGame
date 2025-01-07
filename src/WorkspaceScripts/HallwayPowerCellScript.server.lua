local PowerScreen = script.Parent.Parent.Parent.Parent
local Hallway = script.Parent.Parent.Parent.Parent.Parent.Parent
local replicatedStorage = game:GetService("ReplicatedStorage")

local HallwayLightParts = Hallway.Models.Ceiling.Lights
local HallwayLights = Hallway.LightParts.LightPartsChanging
local PillarsLights = Hallway.Models.Pillars.Lights  -- Added this variable to reference the Pillar lights

local PowerScreenDisplay = PowerScreen.SurfaceGui.Frame.ScreenGUI
local LeftColorBar = PowerScreen.SurfaceGui.Frame.Frame.LeftColorBar
local RightColorBar = PowerScreen.SurfaceGui.Frame.Frame.RightColorBar
local LeftSmallBar = PowerScreen.SurfaceGui.Frame.Frame.LeftSmallBar
local RightSmallBar = PowerScreen.SurfaceGui.Frame.Frame.RightSmallBar
local PowerConditionText = PowerScreen.SurfaceGui.Frame.Frame.TextFrame.PowerCondition
local proximityPrompt = script.Parent

local Colors = {
	Off = {
		PowerScreenDisplayBackgroundColor = "#ff544e",
		PowerScreenDisplayImageColor = "#ff0000",
		LeftColorBarBackgroundColor = "#915d33",
		RightColorBarBackgroundColor = "#915d33",
		LeftSmallBarBackgroundColor = "#ff9966",
		RightSmallBarBackgroundColor = "#ff9966",
		PowerConditionTextColor = "#b55a2c"
	},
	On = {
		PowerScreenDisplayBackgroundColor = "#b6ff97",
		PowerScreenDisplayImageColor = "#bc902b",
		LeftColorBarBackgroundColor = "#439133",
		RightColorBarBackgroundColor = "#439133",
		LeftSmallBarBackgroundColor = "#66ff73",
		RightSmallBarBackgroundColor = "#66ff73",
		PowerConditionTextColor = "#22a82b"
	}
}

local function applyColors(state)
	local stateColors = Colors[state]
	if stateColors then
		PowerScreenDisplay.BackgroundColor3 = Color3.fromHex(stateColors.PowerScreenDisplayBackgroundColor)
		PowerScreenDisplay.ImageColor3 = Color3.fromHex(stateColors.PowerScreenDisplayImageColor)
		LeftColorBar.BackgroundColor3 = Color3.fromHex(stateColors.LeftColorBarBackgroundColor)
		RightColorBar.BackgroundColor3 = Color3.fromHex(stateColors.RightColorBarBackgroundColor)
		LeftSmallBar.BackgroundColor3 = Color3.fromHex(stateColors.LeftSmallBarBackgroundColor)
		RightSmallBar.BackgroundColor3 = Color3.fromHex(stateColors.RightSmallBarBackgroundColor)
		PowerConditionText.TextColor3 = Color3.fromHex(stateColors.PowerConditionTextColor)
	else
		warn("Invalid state: " .. tostring(state))
	end
end

local Players = game:GetService("Players")
local ContextActionEvent = replicatedStorage.Events:WaitForChild("FreezeMovementEvent")

script.Parent.Triggered:Connect(function(player)
	print("Triggered")
	local powerOn = PowerScreen:GetAttribute("PowerOn")

	if powerOn then
		proximityPrompt.Enabled = false
		ContextActionEvent:FireClient(player)
		task.wait(1)

		ContextActionEvent:FireClient(player, false)
		applyColors("Off")
		PowerConditionText.Text = "Power Off"

		-- Gradual dimming for power off effect (lights stay on, but gradually dim)
		local dimDuration = .5  -- Duration of the gradual dimming (in seconds)
		local dimSteps = 10 -- Number of gradual dimming steps (the more steps, the smoother)
		local dimDelay = dimDuration / dimSteps  -- Delay between each dimming step

		for step = 1, dimSteps do
			local brightness = 1 - (step / dimSteps)  -- Gradual decrease in brightness
			for _, Light in ipairs(HallwayLights:GetDescendants()) do
				if Light:IsA("PointLight") or Light:IsA("SpotLight") or Light:IsA("Beam") then
					Light.Brightness = brightness
				end
			end
			task.wait(dimDelay)  -- Wait between each dimming step
		end

		for _, Light in ipairs(HallwayLights:GetDescendants()) do
			if Light:IsA("PointLight") or Light:IsA("SpotLight") or Light:IsA("Beam") then
				Light.Enabled = false
			end
		end

		-- Change Pillar Lights to black (off)
		for _, Light in ipairs(PillarsLights:GetChildren()) do
			Light.Color = Color3.fromHex("#000000")  -- Set color to black
		end

		for _, Light in ipairs(HallwayLightParts:GetChildren()) do
			Light.Color = Color3.new(57 / 255, 45 / 255, 27 / 255)
		end

		local powerOn = PowerScreen:SetAttribute("PowerOn", false)
		proximityPrompt.Enabled = true

	else
		proximityPrompt.Enabled = false
		ContextActionEvent:FireClient(player)
		task.wait(1)

		-- Change Pillar Lights to white (on)
		for _, Light in ipairs(PillarsLights:GetChildren()) do
			Light.Color = Color3.fromHex("#FFFFFF")  -- Set color to white
		end

		for _, Light in ipairs(HallwayLightParts:GetChildren()) do
			Light.Color = Color3.new(255 / 255, 135 / 255, 30 / 255)
		end

		for _, Light in ipairs(HallwayLights:GetDescendants()) do
			if Light:IsA("PointLight") or Light:IsA("SpotLight") or Light:IsA("Beam") then
				Light.Enabled = true
			end
		end

		ContextActionEvent:FireClient(player, false)
		applyColors("On")
		PowerConditionText.Text = "Power On"
		local powerOn = PowerScreen:SetAttribute("PowerOn", true)
		proximityPrompt.Enabled = true

		-- Flickering effect for 5 times with faster transitions
		for i = 1, 5 do
			for _, Light in ipairs(HallwayLights:GetDescendants()) do
				if Light:IsA("PointLight") or Light:IsA("SpotLight") or Light:IsA("Beam") then
					Light.Brightness = math.random(3, 7) / 10  -- Randomly dim the lights
				end
			end
			task.wait(math.random(0.1, 0.2))  -- Shorter flicker duration (0.1 to 0.2 seconds)

			-- Restore brightness quickly
			for _, Light in ipairs(HallwayLights:GetDescendants()) do
				if Light:IsA("PointLight") or Light:IsA("SpotLight") or Light:IsA("Beam") then
					Light.Brightness = 1  -- Full brightness
				end
			end
			task.wait(math.random(0.1, 0.2))  -- Short pause between flickers (0.1 to 0.2 seconds)
		end
	end
end)
