local tool = script.Parent
local anim = Instance.new("Animation")
anim.AnimationId = 'rbxassetid://127535126388085'
local track
local player = game:GetService("Players").LocalPlayer
local Mouse = player:GetMouse()

local muzzleFlash = script.Parent.Handle.MuzzleFlashAttachment.MuzzleFlash
local debounce = false

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
	if debounce then return end
	debounce = true

	if muzzleFlash then
		muzzleFlash:Emit(10)
	end

	local fireSound = script.Parent.Handle.FireSoundAttachment:FindFirstChild("FireSound")
	local hitSound = script.Parent.Handle.HitSoundAttachment:FindFirstChild("HitSound")
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
		if hitSound then
			hitSound:Play()
		end
		
		
		local hitPart = rayResult.Instance
		local hitPosition = rayResult.Position

		local partTemp = Instance.new("Part")
		partTemp.Size = Vector3.new(1, 1, 1)
		partTemp.Position = hitPosition
		partTemp.Anchored = true
		partTemp.CanCollide = false
		partTemp.Transparency = 1
		partTemp.Name = "partTemp"
		partTemp.Parent = workspace

		local hitAttachment = script.Parent.Handle.HitFlashAttachment
		if hitAttachment then
			for _, child in ipairs(hitAttachment:GetChildren()) do
				if child:IsA("ParticleEmitter") then
					local clonedEmitter = child:Clone()
					clonedEmitter.Parent = partTemp
					clonedEmitter:Emit(10)
				end
			end

			task.delay(0.5, function()
				partTemp:Destroy()
			end)
		end

		local humanoid = hitPart.Parent:FindFirstChild("Humanoid")
		if humanoid then
			humanoid:TakeDamage(10)
		end
	end

	task.delay(0.5, function()
		debounce = false
	end)
end)
