local tool = script.Parent
local anim = Instance.new("Animation")
anim.AnimationId = 'rbxassetid://92708429402636'
local track


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