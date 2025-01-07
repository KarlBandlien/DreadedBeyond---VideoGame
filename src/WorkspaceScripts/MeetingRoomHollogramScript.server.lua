local meetingRoom = script.Parent.Parent
local Hollogramer = script.Parent
local VolumeLights = Hollogramer.VolumetricLights:GetChildren()
local NeonParts = Hollogramer.NeonParts:GetChildren()
local hologramLight = script.Parent.TopHollogramer.HologramerLight.PointLight

local hologramsound1 = script.Parent.TopHollogramer.HologramSound1 
local hologramsound2 = script.Parent.TopHollogramer.HologramSound2

local gnomeHologram = script.Parent.gnomehollogram:GetDescendants()

-- Define the function to check the attribute value
local function checkObjectives()
	local objectivesComplete = meetingRoom:GetAttribute("ObjectivesComplete")
	if objectivesComplete == 2 then
		hologramLight.Enabled = true
		hologramsound1:Play()
		hologramsound2:Play()
		
		-- Set all NeonParts to Neon material
		for _, part in ipairs(gnomeHologram) do
			if part:IsA("Part") then
				if part.Transparency > 0 then
					part.Transparency = 0
				end
			end
		end


		-- Set all NeonParts to Neon material
		for _, part in ipairs(NeonParts) do
			part.Material = Enum.Material.Neon
		end

		-- Toggle the beams' enabled state to simulate flickering
		for _, part in ipairs(VolumeLights) do
			for _, light in ipairs(part:GetChildren()) do
				if light:IsA("Beam") then
					-- Start a flicker effect for the beam
					coroutine.wrap(function()
						local flickerDuration = 0.1  -- Initial flicker speed
						local flickerCount = 10  -- How many times to flicker

						for i = 1, flickerCount do
							light.Enabled = not light.Enabled
							wait(flickerDuration)

							-- Reduce flicker duration to make it faster
							flickerDuration = math.max(0.02, flickerDuration * 0.8)  -- Speed up the flicker, but not below 0.02 seconds
						end

						-- After flickering, make sure the beam stays enabled
						light.Enabled = true
					end)()
				end
			end
		end
	end
end

-- Connect the function to the attribute change signal
meetingRoom:GetAttributeChangedSignal("ObjectivesComplete"):Connect(checkObjectives)

-- Optionally, you can check the value initially
checkObjectives()
