local tool = script.Parent
local anim = Instance.new("Animation")
anim.AnimationId = 'rbxassetid://127535126388085'
local track
local player = game:GetService("Players").LocalPlayer
local Mouse = player:GetMouse()

local muzzleFlash = script.Parent.Handle.MuzzleFlashAttachment.MuzzleFlash

tool.Equipped:Connect(function()
	track = script.Parent.Parent.Humanoid:LoadAnimation(anim)
	track.Priority = Enum.AnimationPriority.Action
	track:Play()
end)

tool.Unequipped:Connect(function()
	if track then
		track:Stop()
	end
end)












tool.Activated:Connect(function()
	
	 
	if muzzleFlash then
		muzzleFlash:Emit(10) -- Emit a burst of 10 particles
	end
	-- Play a sound (if you have one in the tool handle)
	local fireSound = script.Parent.Handle:FindFirstChild("FireSound")
	if fireSound then
		fireSound:Play()
	end

	local rayOrigin = script.Parent.Handle.rayOrigin.WorldPosition
	local rayDirection = Mouse.UnitRay.Direction * 2007
	
	local raycastParams = RaycastParams.new()

	
	local character = tool.Parent
	raycastParams.FilterDescendantsInstances = {character}
	raycastParams.FilterType = Enum.RaycastFilterType.Exclude
	
	local rayResult = workspace:Raycast(rayOrigin, rayDirection, raycastParams)
	print(rayResult)
	
	if rayResult then
		local hitPart = rayResult.Instance
		local hitPosition = rayResult.Position
		
		print(hitPart)
		

		local hitAttachment = script.Parent.Handle.HitFlashAttachment
		if hitAttachment then
			
			
			
			
			local partTemp = Instance.new(`Part`)
			partTemp.Parent = workspace
			partTemp.Position = hitPosition
			partTemp.Anchored = true
			partTemp.CanCollide = false
			partTemp.Transparency = 1
			partTemp.Name = "partTemp"
			
			local clonedEmitter = hitAttachment:Clone()
			clonedEmitter.Parent = game.workspace.partTemp
			
			for _, emitter in pairs(clonedEmitter:GetChildren()) do
				if emitter:IsA("ParticleEmitter") then
					
					
					
					
					clonedEmitter:Emit(10)
				end
			end
		end
		
		
		
		local humanoid = hitPart.Parent:FindFirstChild("Humanoid")
		if humanoid then
			humanoid:TakeDamage(10) -- Adjust damage as needed
		end
	end
end)










