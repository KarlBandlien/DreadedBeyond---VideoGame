local RunService = game:GetService('RunService')

local Player = game.Players.LocalPlayer
local Character = Player.Character or Player.CharacterAdded:Wait()
local HumanoidRootPart = Character:WaitForChild('HumanoidRootPart')
local Humanoid = Character:WaitForChild('Humanoid')

local AnimationsFolder = script:WaitForChild('Animations')

local AnimationsTable = {
	['Idle'] = Humanoid:LoadAnimation(AnimationsFolder.Idle),
	['WalkForward'] = Humanoid:LoadAnimation(AnimationsFolder.WalkForward),
	['WalkRight'] = Humanoid:LoadAnimation(AnimationsFolder.WalkRight),
	['WalkLeft'] = Humanoid:LoadAnimation(AnimationsFolder.WalkLeft),
}

-- Set animation priorities
AnimationsTable['Idle'].Priority = Enum.AnimationPriority.Idle
AnimationsTable['WalkForward'].Priority = Enum.AnimationPriority.Movement
AnimationsTable['WalkRight'].Priority = Enum.AnimationPriority.Movement
AnimationsTable['WalkLeft'].Priority = Enum.AnimationPriority.Movement

for _, Animation in AnimationsTable do
	Animation:Play(0, 0.01, 0)
end

local SpeedMultiplier = 1.5  -- Factor by which to increase the animation speed

RunService.RenderStepped:Connect(function()
	local DirectionOfMovement = HumanoidRootPart.CFrame:VectorToObjectSpace(HumanoidRootPart.AssemblyLinearVelocity)

	local Forward = math.abs(math.clamp(DirectionOfMovement.Z / Humanoid.WalkSpeed, -1, -0.01))
	local Backwards = math.abs(math.clamp(DirectionOfMovement.Z / Humanoid.WalkSpeed, 0.01, 1))
	local Right = math.abs(math.clamp(DirectionOfMovement.X / Humanoid.WalkSpeed, 0.01, 1))
	local Left = math.abs(math.clamp(DirectionOfMovement.X / Humanoid.WalkSpeed, -1, -0.01))

	local SpeedUnit = (DirectionOfMovement.Magnitude / Humanoid.WalkSpeed)
	local State = Humanoid:GetState()

	if DirectionOfMovement.Magnitude > 0.1 then
		if not AnimationsTable.WalkForward.IsPlaying then
			AnimationsTable.WalkForward:Play(0, 0.01, 0)
			AnimationsTable.WalkRight:Play(0, 0.01, 0)
			AnimationsTable.WalkLeft:Play(0, 0.01, 0)
		end
	end

	if DirectionOfMovement.Z / Humanoid.WalkSpeed < 0.1 then
		AnimationsTable.WalkForward:AdjustWeight(Forward)
		AnimationsTable.WalkRight:AdjustWeight(Right)
		AnimationsTable.WalkLeft:AdjustWeight(Left)

		-- Apply the speed multiplier here to increase animation speed
		AnimationsTable.WalkForward:AdjustSpeed(SpeedUnit * SpeedMultiplier)
		AnimationsTable.WalkRight:AdjustSpeed(SpeedUnit * SpeedMultiplier)
		AnimationsTable.WalkLeft:AdjustSpeed(SpeedUnit * SpeedMultiplier)

		AnimationsTable.Idle:AdjustWeight(0.001)
	else
		AnimationsTable.WalkForward:AdjustWeight(Backwards)
		AnimationsTable.WalkRight:AdjustWeight(Left)
		AnimationsTable.WalkLeft:AdjustWeight(Right)

		-- Apply the speed multiplier here as well for backward movement
		AnimationsTable.WalkForward:AdjustSpeed(SpeedUnit * -1 * SpeedMultiplier)
		AnimationsTable.WalkRight:AdjustSpeed(SpeedUnit * -1 * SpeedMultiplier)
		AnimationsTable.WalkLeft:AdjustSpeed(SpeedUnit * -1 * SpeedMultiplier)

		AnimationsTable.Idle:AdjustWeight(0.001)
	end

	if DirectionOfMovement.Magnitude < 0.1 then
		AnimationsTable.Idle:AdjustWeight(1)
	end
end)
