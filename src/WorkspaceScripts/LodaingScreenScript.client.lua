local this = script.Parent

local TweenService = game:GetService("TweenService")
local ReplicatedFirst = game:GetService('ReplicatedFirst')
local ContentProvider = game:GetService("ContentProvider")

local Assets = game:GetDescendants()
local Player = game:GetService("Players").LocalPlayer

local deltaWalkSpeed = Player.Character:WaitForChild("Humanoid").WalkSpeed
local deltaJumpHeight = Player.Character:WaitForChild("Humanoid").JumpHeight

ReplicatedFirst:RemoveDefaultLoadingScreen()
repeat task.wait() until game:IsLoaded()

Player.Character:WaitForChild("Humanoid").WalkSpeed = 0
Player.Character:WaitForChild("Humanoid").JumpHeight = 0

local deltaPosition = this.Background.LoadingBarBackground.LoadingBar.Position
local playButton = this.Background:WaitForChild("PlayButton") -- Reference to the Play button

-- Initially, the Play button is hidden
playButton.Visible = false

-- Reference to the Camera and Theme Songs
local camera = game.Workspace.CurrentCamera
local cameraPart = workspace.WorkSpace:WaitForChild("CameraModel"):WaitForChild("CamPart")
local SoundService = game:GetService("SoundService")
local mainTheme = SoundService.MainTheme:Clone()
local mainTheme1 = SoundService.MainTheme2:Clone()

mainTheme.Parent = camera
mainTheme1.Parent = camera

-- Camera Tween Settings
local cameraTweenInfo = TweenInfo.new(1, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
local cameraTween = TweenService:Create(camera, cameraTweenInfo, {CFrame = cameraPart.CFrame})

-- Play both main theme songs when the game starts
mainTheme:Play()
mainTheme1:Play()

-- Camera Movement Function to move to the part (camera start position)
local function moveCameraToPart()
	this.Background.Visible = true
	camera.CameraType = Enum.CameraType.Scriptable
	camera.CFrame = cameraPart.CFrame
	cameraTween:Play()
end


-- Move the camera to the part when the game starts
moveCameraToPart()
local function moveCameraToPlayer()
	local playerHead = Player.Character:WaitForChild("Head")
	camera.CameraType = Enum.CameraType.Scriptable
	camera.CFrame = playerHead.CFrame -- Move camera to player head immediately
	

	-- Switch camera to custom after tween
	camera.CameraType = Enum.CameraType.Custom
end


-- Play loading screen animation
task.spawn(function()
	while task.wait(math.pi) do
		TweenService:Create(this.Background.LoadingBarBackground.LoadingBar, TweenInfo.new(.65), {Position = this.Background.LoadingBarBackground.Port0Image.Position}):Play()
		TweenService:Create(this.Background.LoadingBarBackground.LoadingBar, TweenInfo.new(1), {Rotation = 90}):Play()
		TweenService:Create(this.Background.LoadingBarBackground.Port0Image, TweenInfo.new(1), {ImageTransparency = .5}):Play()
		TweenService:Create(this.Background.LoadingBarBackground.Port0Image, TweenInfo.new(2), {ImageColor3 = Color3.fromRGB(30, 165, 30)}):Play()
		task.wait(1)
		script.Reached:Play()
		TweenService:Create(this.Background.LoadingBarBackground.Port0Image, TweenInfo.new(1), {ImageColor3 = Color3.fromRGB(200, 200, 200)}):Play()
		TweenService:Create(this.Background.LoadingBarBackground.Port0Image, TweenInfo.new(1), {ImageTransparency = 1}):Play()
		TweenService:Create(this.Background.LoadingBarBackground.LoadingBar, TweenInfo.new(1), {Position = deltaPosition}):Play()
		TweenService:Create(this.Background.LoadingBarBackground.LoadingBar, TweenInfo.new(1), {Rotation = 0}):Play()
		task.wait(math.pi)
		TweenService:Create(this.Background.LoadingBarBackground.LoadingBar, TweenInfo.new(.65), {Position = this.Background.LoadingBarBackground.Port1Image.Position}):Play()
		TweenService:Create(this.Background.LoadingBarBackground.LoadingBar, TweenInfo.new(1), {Rotation = -90}):Play()
		TweenService:Create(this.Background.LoadingBarBackground.Port1Image, TweenInfo.new(1), {ImageTransparency = .5}):Play()
		TweenService:Create(this.Background.LoadingBarBackground.Port1Image, TweenInfo.new(2), {ImageColor3 = Color3.fromRGB(30, 165, 30)}):Play()
		task.wait(1)
		script.Reached:Play()

		TweenService:Create(this.Background.LoadingBarBackground.Port1Image, TweenInfo.new(1), {ImageColor3 = Color3.fromRGB(200, 200, 200)}):Play()
		TweenService:Create(this.Background.LoadingBarBackground.Port1Image, TweenInfo.new(1), {ImageTransparency = 1}):Play()
		TweenService:Create(this.Background.LoadingBarBackground.LoadingBar, TweenInfo.new(1), {Position = deltaPosition}):Play()
		TweenService:Create(this.Background.LoadingBarBackground.LoadingBar, TweenInfo.new(1), {Rotation = 0}):Play()
	end
end)

-- Preload assets
for file = 1, #Assets do
	local asset = Assets[file]
	ContentProvider:PreloadAsync({asset})
	this.Background.LoadingBarBackground.FileImage.Files.Text = file
	this.Background.LoadingBarBackground.LogsImage.Log.Text = asset.Name
end

playButton.Visible = true

-- Add an action for the Play button
playButton.MouseButton1Click:Connect(function()
	-- Stop the theme music
	mainTheme:Stop()
	mainTheme1:Stop()

	-- Tween the animation frame (visual effect)
	TweenService:Create(script.Parent.AnimationFrame, TweenInfo.new(math.pi), {Transparency = 0}):Play()
	task.wait(math.pi)
	script.Parent.Background:Destroy()
	TweenService:Create(script.Parent.AnimationFrame, TweenInfo.new(math.pi), {Transparency = 1}):Play()
	script.Loaded:Play()

	-- Restore original player settings
	Player.Character:WaitForChild("Humanoid").WalkSpeed = deltaWalkSpeed
	Player.Character:WaitForChild("Humanoid").JumpHeight = deltaJumpHeight

	-- Show the play button after loading finishes
	playButton.Visible = false

	-- Switch camera back to the player and move it
	moveCameraToPlayer()

	
end)
