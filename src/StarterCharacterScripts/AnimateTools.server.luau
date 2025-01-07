local character = script.Parent
local humanoid = character:WaitForChild("Humanoid")

local function childAdded(object)
    if object:IsA("Tool") then
        local handle = object:FindFirstChild("Handle")
        if handle then
            local rightArm
            if humanoid.RigType == Enum.HumanoidRigType.R6 then
                rightArm = character:FindFirstChild("Right Arm")
            else
                rightArm = character:FindFirstChild("RightHand")
            end
            if rightArm then
                local rightGrip = rightArm:FindFirstChild("RightGrip")
                if rightGrip then
                    -- Copy RightGrip's C0 and C1
                    local originalC0 = rightGrip.C0
                    local originalC1 = rightGrip.C1

                    -- Disable RightGrip and create new Motor6D
                    rightGrip.Enabled = false
                    local motor = Instance.new("Motor6D")
                    motor.Part0 = rightArm
                    motor.Part1 = handle
                    motor.C0 = CFrame.new(0, -rightArm.Size.Y / 2, 0) * CFrame.Angles(-math.pi / 2, 0, 0)

                    -- Set C1 to include a rotation of 0, -90, 0
                    motor.C1 = CFrame.Angles(0, math.rad(-90), 0)

                    motor.Name = "ToolGrip"
                    motor.Parent = rightArm

                    -- Wait for RightGrip to be removed
                    repeat
                        rightGrip.AncestryChanged:Wait()
                    until not rightGrip:IsDescendantOf(character)

                    -- Clean up the Motor6D
                    motor:Destroy()
                end
            end
        end
    end
end

character.ChildAdded:Connect(childAdded)
