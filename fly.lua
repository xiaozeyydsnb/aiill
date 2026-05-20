local Fly = {}

Flying,true)
                speaker.Character.Humanoid:SetStateEnabled(Enum.HumanoidStateType.Freefall,true)
                speaker.Character.Humanoid:SetStateEnabled(Enum.HumanoidStateType.GettingUp,true)
                speaker.Character.Humanoid:SetStateEnabled(Enum.HumanoidStateType.Jumping,true)
                speaker.Character.Humanoid:SetStateEnabled(Enum.HumanoidStateType.Landed,true)
                speaker.Character.Humanoid:SetStateEnabled(Enum.HumanoidStateType.Physics,true)
                speaker.Character.Humanoid:SetStateEnabled(Enum.HumanoidStateType.PlatformStanding,true)
                speaker.Character.Humanoid:SetStateEnabled(Enum.HumanoidStateType.Ragdoll,true)
                speaker.Character.Humanoid:SetStateEnabled(Enum.HumanoidStateType.Running,true)
                speaker.Character.Humanoid:SetStateEnabled(Enum.HumanoidStateType.RunningNoPhysics,true)
                speaker.Character.Humanoid:SetStateEnabled(Enum.HumanoidStateType.Seated,true)
                speaker.Character.Humanoid:SetStateEnabled(Enum.HumanoidStateType.StrafingNoPhysics,true)
                speaker.Character.Humanoid:SetStateEnabled(Enum.HumanoidStateType.Swimming,true)
                speaker.Character.Humanoid:ChangeState(Enum.HumanoidStateType.RunningNoPhysics)
            else
                nowe = true
                for i = 1, speeds do
                    spawn(function()
                        local hb = game:GetService("RunService").Heartbeat
                        tpwalking = true
                        local chr = game.Players.LocalPlayer.Character
                        local hum = chr and chr:FindFirstChildWhichIsA("Humanoid")
                        while tpwalking and hb:Wait() and chr and hum and hum.Parent do
                            if hum.MoveDirection.Magnitude > 0 then
                                chr:TranslateBy(hum.MoveDirection)
                            end
                        end
                    end)
                end
                game.Players.LocalPlayer.Character.Animate.Disabled = true
                local Char = game.Players.LocalPlayer.Character
                local Hum = Char:FindFirstChildOfClass("Humanoid") or Char:FindFirstChildOfClass("AnimationController")
                for i,v in next, Hum:GetPlayingAnimationTracks() do
                    v:AdjustSpeed(0)
                end
                speaker.Character.Humanoid:SetStateEnabled(Enum.HumanoidStateType.Climbing,false)
                speaker.Character.Humanoid:SetStateEnabled(Enum.HumanoidStateType.FallingDown,false)
                speaker.Character.Humanoid:SetStateEnabled(Enum.HumanoidStateType.Flying,false)
                speaker.Character.Humanoid:SetStateEnabled(Enum.HumanoidStateType.Freefall,false)
                speaker.Character.Humanoid:SetStateEnabled(Enum.HumanoidStateType.GettingUp,false)
                speaker.Character.Humanoid:SetStateEnabled(Enum.HumanoidStateType.Jumping,false)
                speaker.Character.Humanoid:SetStateEnabled(Enum.HumanoidStateType.Landed,false)
                speaker.Character.Humanoid:SetStateEnabled(Enum.HumanoidStateType.Physics,false)
                speaker.Character.Humanoid:SetStateEnabled(Enum.HumanoidStateType.PlatformStanding,false)
                speaker.Character.Humanoid:SetStateEnabled(Enum.HumanoidStateType.Ragdoll,false)
                speaker.Character.Humanoid:SetStateEnabled(Enum.HumanoidStateType.Running,false)
                speaker.Character.Humanoid:SetStateEnabled(Enum.HumanoidStateType.RunningNoPhysics,false)
                speaker.Character.Humanoid:SetStateEnabled(Enum.HumanoidStateType.Seated,false)
                speaker.Character.Humanoid:SetStateEnabled(Enum.HumanoidStateType.StrafingNoPhysics,false)
                speaker.Character.Humanoid:SetStateEnabled(Enum.HumanoidStateType.Swimming,false)
                speaker.Character.Humanoid:ChangeState(Enum.HumanoidStateType.Swimming)
            end

            if game:GetService("Players").LocalPlayer.Character:FindFirstChildOfClass("Humanoid").RigType == Enum.HumanoidRigType.R6 then
                local plr = game.Players.LocalPlayer
                local torso = plr.Character.Torso
                local ctrl = {f = 0, b = 0, l = 0, r = 0}
                local lastctrl = {f = 0, b = 0, l = 0, r = 0}
                local maxspeed = 50
                local speed = 0
                local bg = Instance.new("BodyGyro", torso)
                bg.P = 9e4
                bg.maxTorque = Vector3.new(9e9, 9e9, 9e9)
                bg.cframe = torso.CFrame
                local bv = Instance.new("BodyVelocity", torso)
                bv.velocity = Vector3.new(0,0.1,0)
                bv.maxForce = Vector3.new(9e9, 9e9, 9e9)
                if nowe == true then
                    plr.Character.Humanoid.PlatformStand = true
                end
                while nowe == true or game:GetService("Players").LocalPlayer.Character.Humanoid.Health == 0 do
                    game:GetService("RunService").RenderStepped:Wait()
                    if ctrl.l + ctrl.r ~= 0 or ctrl.f + ctrl.b ~= 0 then
                        speed = speed+.5+(speed/maxspeed)
                        if speed > maxspeed then
                            speed = maxspeed
                        end
                    elseif not (ctrl.l + ctrl.r ~= 0 or ctrl.f + ctrl.b ~= 0) and speed ~= 0 then
                        speed = speed-1
                        if speed < 0 then
                            speed = 0
                        end
                    end
                    if (ctrl.l + ctrl.r) ~= 0 or (ctrl.f + ctrl.b) ~= 0 then
                        bv.velocity = ((game.Workspace.CurrentCamera.CoordinateFrame.lookVector * (ctrl.f+ctrl.b)) + ((game.Workspace.CurrentCamera.CoordinateFrame * CFrame.new(ctrl.l+ctrl.r,(ctrl.f+ctrl.b)*.2,0).p) - game.Workspace.CurrentCamera.CoordinateFrame.p))*speed
                        lastctrl = {f = ctrl.f, b = ctrl.b, l = ctrl.l, r = ctrl.r}
                    elseif (ctrl.l + ctrl.r) == 0 and (ctrl.f + ctrl.b) == 0 and speed ~= 0 then
                        bv.velocity = ((game.Workspace.CurrentCamera.CoordinateFrame.lookVector * (lastctrl.f+lastctrl.b)) + ((game.Workspace.CurrentCamera.CoordinateFrame * CFrame.new(lastctrl.l+lastctrl.r,(lastctrl.f+lastctrl.b)*.2,0).p) - game.Workspace.CurrentCamera.CoordinateFrame.p))*speed
                    else
                        bv.velocity = Vector3.new(0,0,0)
                    end
                    bg.cframe = game.Workspace.CurrentCamera.CoordinateFrame * CFrame.Angles(-math.rad((ctrl.f+ctrl.b)*50*speed/maxspeed),0,0)
                end
                ctrl = {f = 0, b = 0, l = 0, r = 0}
                lastctrl = {f = 0, b = 0, l = 0, r = 0}
                speed = 0
                bg:Destroy()
                bv:Destroy()
                plr.Character.Humanoid.PlatformStand = false
                game.Players.LocalPlayer.Character.Animate.Disabled = false
                tpwalking = false
            else
                local plr = game.Players.LocalPlayer
                local UpperTorso = plr.Character.UpperTorso
                local ctrl = {f = 0, b = 0, l = 0, r = 0}
                local lastctrl = {f = 0, b = 0, l = 0, r = 0}
                local maxspeed = 50
                local speed = 0
                local bg = Instance.new("BodyGyro", UpperTorso)
                bg.P = 9e4
                bg.maxTorque = Vector3.new(9e9, 9e9, 9e9)
                bg.cframe = UpperTorso.CFrame
                local bv = Instance.new("BodyVelocity", UpperTorso)
                bv.velocity = Vector3.new(0,0.1,0)
                bv.maxForce = Vector3.new(9e9, 9e9, 9e9)
                if nowe == true then
                    plr.Character.Humanoid.PlatformStand = true
                end
                while nowe == true or game:GetService("Players").LocalPlayer.Character.Humanoid.Health == 0 do
                    wait()
                    if ctrl.l + ctrl.r ~= 0 or ctrl.f + ctrl.b ~= 0 then
                        speed = speed+.5+(speed/maxspeed)
                        if speed > maxspeed then
                            speed = maxspeed
                        end
                    elseif not (ctrl.l + ctrl.r ~= 0 or ctrl.f + ctrl.b ~= 0) and speed ~= 0 then
                        speed = speed-1
                        if speed < 0 then
                            speed = 0
                        end
                    end
                    if (ctrl.l + ctrl.r) ~= 0 or (ctrl.f + ctrl.b) ~= 0 then
                        bv.velocity = ((game.Workspace.CurrentCamera.CoordinateFrame.lookVector * (ctrl.f+ctrl.b)) + ((game.Workspace.CurrentCamera.CoordinateFrame * CFrame.new(ctrl.l+ctrl.r,(ctrl.f+ctrl.b)*.2,0).p) - game.Workspace.CurrentCamera.CoordinateFrame.p))*speed
                        lastctrl = {f = ctrl.f, b = ctrl.b, l = ctrl.l, r = ctrl.r}
                    elseif (ctrl.l + ctrl.r) == 0 and (ctrl.f + ctrl.b) == 0 and speed ~= 0 then
                        bv.velocity = ((game.Workspace.CurrentCamera.CoordinateFrame.lookVector * (lastctrl.f+lastctrl.b)) + ((game.Workspace.CurrentCamera.CoordinateFrame * CFrame.new(lastctrl.l+lastctrl.r,(lastctrl.f+lastctrl.b)*.2,0).p) - game.Workspace.CurrentCamera.CoordinateFrame.p))*speed
                    else
                        bv.velocity = Vector3.new(0,0,0)
                    end
                    bg.cframe = game.Workspace.CurrentCamera.CoordinateFrame * CFrame.Angles(-math.rad((ctrl.f+ctrl.b)*50*speed/maxspeed),0,0)
                end
                ctrl = {f = 0, b = 0, l = 0, r = 0}
                lastctrl = {f = 0, b = 0, l = 0, r = 0}
                speed = 0
                bg:Destroy()
                bv:Destroy()
                plr.Character.Humanoid.PlatformStand = false
                game.Players.LocalPlayer.Character.Animate.Disabled = false
                tpwalking = false
            end
        end)

        local tis
        up.MouseButton1Down:connect(function()
            tis = up.MouseEnter:connect(function()
                while tis do
                    wait()
                    game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame * CFrame.new(0,1,0)
                end
            end)
        end)
        up.MouseLeave:connect(function()
            if tis then
                tis:Disconnect()
                tis = nil
            end
        end)

        local dis
        down.MouseButton1Down:connect(function()
            dis = down.MouseEnter:connect(function()
                while dis do
                    wait()
                    game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame * CFrame.new(0,-1,0)
                end
            end)
        end)
        down.MouseLeave:connect(function()
            if dis then
                dis:Disconnect()
                dis = nil
            end
        end)

        game:GetService("Players").LocalPlayer.CharacterAdded:Connect(function(char)
            wait(0.7)
            game.Players.LocalPlayer.Character.Humanoid.PlatformStand = false
            game.Players.LocalPlayer.Character.Animate.Disabled = false
        end)

        plus.MouseButton1Down:connect(function()
            speeds = speeds + 1
            speed.Text = speeds
            if nowe == true then
                tpwalking = false
                for i = 1, speeds do
                    spawn(function()
                        local hb = game:GetService("RunService").Heartbeat
                        tpwalking = true
                        local chr = game.Players.LocalPlayer.Character
                        local hum = chr and chr:FindFirstChildWhichIsA("Humanoid")
                        while tpwalking and hb:Wait() and chr and hum and hum.Parent do
                            if hum.MoveDirection.Magnitude > 0 then
                                chr:TranslateBy(hum.MoveDirection)
                            end
                        end
                    end)
                end
            end
        end)

        mine.MouseButton1Down:connect(function()
            if speeds == 1 then
                speed.Text = 'flyno1'
                wait(1)
                speed.Text = speeds
            else
                speeds = speeds - 1
                speed.Text = speeds
                if nowe == true then
                    tpwalking = false
                    for i = 1, speeds do
                        spawn(function()
                            local hb = game:GetService("RunService").Heartbeat
                            tpwalking = true
                            local chr = game.Players.LocalPlayer.Character
                            local hum = chr and chr:FindFirstChildWhichIsA("Humanoid")
                            while tpwalking and hb:Wait() and chr and hum and hum.Parent do
                                if hum.MoveDirection.Magnitude > 0 then
                                    chr:TranslateBy(hum.MoveDirection)
                                end
                            end
                        end)
                    end
                end
            end
        end)

        closebutton.MouseButton1Click:Connect(function()
            main:Destroy()
        end)

        mini.MouseButton1Click:Connect(function()
            up.Visible = false
            down.Visible = false
            onof.Visible = false
            plus.Visible = false
            speed.Visible = false
            mine.Visible = false
            mini.Visible = false
            mini2.Visible = true
            main.Frame.BackgroundTransparency = 1
            closebutton.Position = UDim2.new(0, 0, -1, 57)
        end)

        mini2.MouseButton1Click:Connect(function()
            up.Visible = true
            down.Visible = true
            onof.Visible = true
            plus.Visible = true
            speed.Visible = true
            mine.Visible = true
            mini.Visible = true
            mini2.Visible = false
            main.Frame.BackgroundTransparency = 0
            closebutton.Position = UDim2.new(0, 0, -1, 27)
        end)
    end
})

-- 假设你的通用脚本已经有 Window 和 TabCommon
TabCommon:Button({
    Title = "锁定朝向",
    Callback = function()
        local Players = game:GetService("Players")
        local RunService = game:GetService("RunService")
        local UserInputService = game:GetService("UserInputService")
        
        local player = Players.LocalPlayer
        local PlayerGui = player:WaitForChild("PlayerGui")
        
        local screenGui = Instance.new("ScreenGui")
        screenGui.Name = "LockButtonGui"
        screenGui.Parent = PlayerGui
        screenGui.ResetOnSpawn = false
        screenGui.IgnoreGuiInset = true

        -- 酷炫右上弹窗
        local topLabel = Instance.new("TextLabel")
        topLabel.Size = UDim2.new(0, 250, 0, 50)
        topLabel.Position = UDim2.new(1, -270, 0, 20)
        topLabel.AnchorPoint = Vector2.new(0,0)
        topLabel.BackgroundTransparency = 0.3
        topLabel.BackgroundColor3 = Color3.fromRGB(15,15,20)
        topLabel.Text = "✨小泽制作✨"
        topLabel.TextColor3 = Color3.fromRGB(0, 255, 255)
        topLabel.Font = Enum.Font.GothamBlack
        topLabel.TextSize = 24
        topLabel.ZIndex = 200
        topLabel.Parent = screenGui

        local corner = Instance.new("UICorner")
        corner.CornerRadius = UDim.new(0,10)
        corner.Parent = topLabel

        local stroke = Instance.new("UIStroke")
        stroke.Color = Color3.fromRGB(0,255,255)
        stroke.Thickness = 2
        stroke.Transparency = 1
        stroke.Parent = topLabel

        local tweenIn = game:GetService("TweenService"):Create(topLabel, TweenInfo.new(0.5), {Position = UDim2.new(1,-270,0,20)})
        local tweenOut = game:GetService("TweenService"):Create(topLabel, TweenInfo.new(0.6), {Position = UDim2.new(1,-270,0,-70), BackgroundTransparency=1})
        tweenIn:Play()
        task.delay(5, function() tweenOut:Play() task.delay(0.7,function() topLabel:Destroy() end) end)

        -- 锁按钮
        local lockButton = Instance.new("TextButton")
        lockButton.Size = UDim2.new(0, 50, 0, 50)
        lockButton.Position = UDim2.new(0, 100, 0, 100)
        lockButton.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
        lockButton.Text = "🔒"
        lockButton.TextSize = 30
        lockButton.TextColor3 = Color3.fromRGB(255, 255, 255)
        lockButton.BorderSizePixel = 0
        lockButton.BackgroundTransparency = 0.2
        lockButton.AutoButtonColor = false
        lockButton.ZIndex = 10
        lockButton.Active = true
        lockButton.Selectable = false
        lockButton.Parent = screenGui

        local corner = Instance.new("UICorner")
        corner.CornerRadius = UDim.new(0, 10)
        corner.Parent = lockButton

        local isLocked = false
        local dragging = false
        local touchStartPos = Vector2.zero
        local buttonStartPos = Vector2.zero
        local isTouchOnButton = false
        local currentHumanoid = nil

        local function updateCharacterAutoRotate()
            if currentHumanoid then
                currentHumanoid.AutoRotate = not isLocked
            end
        end

        local function setupCharacter(character)
            local humanoid = character:WaitForChild("Humanoid")
            local rootPart = character:WaitForChild("HumanoidRootPart")
            
            currentHumanoid = humanoid
            humanoid.AutoRotate = true
            
            local conn
            conn = RunService.RenderStepped:Connect(function()
                if not character or not character.Parent or not humanoid or not humanoid.Parent or not rootPart or not rootPart.Parent then
                    conn:Disconnect()
                    currentHumanoid = nil
                    return
                end
                if not isLocked then return end
                local camera = workspace.CurrentCamera
                if not camera then return end
                local flatLook = Vector3.new(camera.CFrame.LookVector.X,0,camera.CFrame.LookVector.Z).Unit
                if flatLook.Magnitude > 0 then
                    rootPart.CFrame = CFrame.new(rootPart.Position, rootPart.Position + flatLook)
                end
            end)
        end

        if player.Character then setupCharacter(player.Character) end
        player.CharacterAdded:Connect(setupCharacter)

        -- 拖动 & 点击切换锁定状态
        lockButton.InputBegan:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 then
                dragging = true
                touchStartPos = input.Position
                buttonStartPos = lockButton.AbsolutePosition
            elseif input.UserInputType == Enum.UserInputType.Touch then
                local touchPos = input.Position
                local btnPos = lockButton.AbsolutePosition
                local btnSize = lockButton.AbsoluteSize
                if touchPos.X >= btnPos.X and touchPos.X <= btnPos.X + btnSize.X and touchPos.Y >= btnPos.Y and touchPos.Y <= btnPos.Y + btnSize.Y then
                    isTouchOnButton = true
                    dragging = true
                    touchStartPos = touchPos
                    buttonStartPos = btnPos
                end
            end
        end)

        UserInputService.InputChanged:Connect(function(input)
            if not dragging then return end
            local delta = input.Position - touchStartPos
            if input.UserInputType == Enum.UserInputType.MouseMovement or (input.UserInputType == Enum.UserInputType.Touch and isTouchOnButton) then
                lockButton.Position = UDim2.new(0, buttonStartPos.X + delta.X, 0, buttonStartPos.Y + delta.Y)
            end
        end)

        UserInputService.InputEnded:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 or (input.UserInputType == Enum.UserInputType.Touch and isTouchOnButton) then
                local endPos = input.Position
                local delta = (endPos - touchStartPos).Magnitude
                if delta < 5 then
                    isLocked = not isLocked
                    if isLocked then
                        lockButton.TextColor3 = Color3.fromRGB(255, 80, 80)
                        lockButton.BackgroundColor3 = Color3.fromRGB(40, 20, 20)
                    else
                        lockButton.TextColor3 = Color3.fromRGB(255, 255, 255)
                        lockButton.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
                    end
                    updateCharacterAutoRotate()
                end
                dragging = false
                isTouchOnButton = false
            end
        end)
    end
})

-- 假设前面已经创建了 Window、TabCommon 等通用脚本部分

-- 添加“传送模式”按钮入口
TabCommon:Button({
    Title = "传送模式",
    Callback = function()
        -- 以下 loadUI 函数就是小泽制作的屏幕传送脚本
        local mod = {}
        local loaded = false

        local function loadUI()
            if loaded then
                if mod.gui then mod.gui.Enabled = true end
                return
            end
            loaded = true

            local Players = game:GetService("Players")
            local UIS = game:GetService("UserInputService")
            local RunService = game:GetService("RunService")
            local Workspace = game:GetService("Workspace")
            local TweenService = game:GetService("TweenService")

            local plr = Players.LocalPlayer
            local cam = Workspace.CurrentCamera

            local isFlying = false
            local root, hum
            local oldCamCF, oldCamType
            local oldWS, oldJP
            local moveInput = Vector2.zero
            local heightSpeed = 28
            local camSpeed = 60
            local fixedPos = Vector3.zero

            local gui = Instance.new("ScreenGui")
            gui.Parent = game.CoreGui
            gui.IgnoreGuiInset = true
            gui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
            mod.gui = gui

            local inputBlock = Instance.new("TextButton")
            inputBlock.Size = UDim2.new(1,0,1,0)
            inputBlock.BackgroundTransparency = 1
            inputBlock.Text = ""
            inputBlock.Visible = false
            inputBlock.ZIndex = 1
            inputBlock.Parent = gui

            local btn = Instance.new("TextButton")
            btn.Size = UDim2.new(0,100,0,45)
            btn.Position = UDim2.new(1,-110,0.3,0)
            btn.Text = "传送模式"
            btn.BackgroundColor3 = Color3.fromRGB(40,40,40)
            btn.TextColor3 = Color3.new(1,1,1)
            btn.Font = Enum.Font.SourceSansBold
            btn.TextSize = 14
            btn.ZIndex = 10
            btn.Parent = gui
            Instance.new("UICorner", btn).CornerRadius = UDim.new(0,8)

            local closeBtn = Instance.new("TextButton")
            closeBtn.Size = UDim2.new(0,22,0,22)
            closeBtn.Position = UDim2.new(1,-11,0,-11)
            closeBtn.Text = "×"
            closeBtn.BackgroundColor3 = Color3.fromRGB(220,50,50)
            closeBtn.TextColor3 = Color3.new(1,1,1)
            closeBtn.Font = Enum.Font.SourceSansBold
            closeBtn.TextSize = 16
            closeBtn.ZIndex = 12
            closeBtn.Parent = btn
            Instance.new("UICorner", closeBtn).CornerRadius = UDim.new(1,0)

            local cross = Instance.new("Frame")
            cross.Size = UDim2.new(0,12,0,12)
            cross.AnchorPoint = Vector2.new(0.5,0.5)
            cross.Position = UDim2.new(0.5,0,0.5,0)
            cross.BackgroundColor3 = Color3.fromRGB(255,0,0)
            cross.BorderSizePixel = 0
            cross.Visible = false
            cross.ZIndex = 10
            cross.Parent = gui
            Instance.new("UICorner", cross).CornerRadius = UDim.new(1,0)

            local upBtn = Instance.new("TextButton")
            upBtn.Size = UDim2.new(0,70,0,70)
            upBtn.Position = UDim2.new(1,-85,0.55,-80)
            upBtn.Text = "↑"
            upBtn.BackgroundColor3 = Color3.fromRGB(60,60,60)
            upBtn.TextColor3 = Color3.new(1,1,1)
            upBtn.Font = Enum.Font.SourceSansBold
            upBtn.TextSize = 30
            upBtn.Visible = false
            upBtn.ZIndex = 10
            upBtn.Parent = gui
            Instance.new("UICorner", upBtn).CornerRadius = UDim.new(1,0)

            local downBtn = Instance.new("TextButton")
            downBtn.Size = UDim2.new(0,70,0,70)
            downBtn.Position = UDim2.new(1,-85,0.55,10)
            downBtn.Text = "↓"
            downBtn.BackgroundColor3 = Color3.fromRGB(60,60,60)
            downBtn.TextColor3 = Color3.new(1,1,1)
            downBtn.Font = Enum.Font.SourceSansBold
            downBtn.TextSize = 30
            downBtn.Visible = false
            downBtn.ZIndex = 10
            downBtn.Parent = gui
            Instance.new("UICorner", downBtn).CornerRadius = UDim.new(1,0)

            local hint = Instance.new("TextLabel")
            hint.Size = UDim2.new(0,300,0,30)
            hint.Position = UDim2.new(0.5,-150,0.85,0)
            hint.Text = ""
            hint.TextColor3 = Color3.new(1,1,1)
            hint.BackgroundTransparency = 1
            hint.Font = Enum.Font.SourceSansBold
            hint.TextSize = 16
            hint.Visible = false
            hint.ZIndex = 10
            hint.Parent = gui

            local dragging = false
            local dragStart, btnStart
            local clickThreshold = 6

            btn.InputBegan:Connect(function(input)
                if input.UserInputType == Enum.UserInputType.Touch then
                    dragging = true
                    dragStart = input.Position
                    btnStart = btn.Position
                end
            end)

            UIS.InputEnded:Connect(function(input)
                if input.UserInputType == Enum.UserInputType.Touch then
                    local delta = input.Position - dragStart
                    if dragging and delta.Magnitude < clickThreshold then
                        if isFlying then exitFly() else enterFly() end
                    end
                    dragging = false
                end
            end)

            UIS.InputChanged:Connect(function(input)
                if dragging and input.UserInputType == Enum.UserInputType.Touch then
                    local delta = input.Position - dragStart
                    btn.Position = UDim2.new(
                        btnStart.X.Scale,
                        btnStart.X.Offset + delta.X,
                        btnStart.Y.Scale,
                        btnStart.Y.Offset + delta.Y
                    )
                end
            end)

            local function lockChar()
                local char = plr.Character
                if not char then return end
                root = char:FindFirstChild("HumanoidRootPart")
                hum = char:FindFirstChildOfClass("Humanoid")

                if root then 
                    root.Anchored = true 
                    fixedPos = root.Position
                    root.Velocity = Vector3.zero
                    root.AssemblyLinearVelocity = Vector3.zero
                end
                if hum then
                    oldWS = hum.WalkSpeed
                    oldJP = hum.JumpPower
                    hum.WalkSpeed = 0
                    hum.JumpPower = 0
                    hum.AutoRotate = false
                    hum.PlatformStand = true
                end
            end

            local function unlockChar()
                if root then root.Anchored = false end
                if hum then
                    hum.WalkSpeed = oldWS or 16
                    hum.JumpPower = oldJP or 50
                    hum.AutoRotate = true
                    hum.PlatformStand = false
                end
            end

            function enterFly()
                local char = plr.Character
                local r = char and char:FindFirstChild("HumanoidRootPart")
                if not r then return end

                root = r
                hum = char:FindFirstChildOfClass("Humanoid")

                oldCamCF = cam.CFrame
                oldCamType = cam.CameraType

                cam.CameraType = Enum.CameraType.Scriptable
                cam.CFrame = CFrame.new(root.Position + Vector3.new(0,60,0)) * CFrame.Angles(math.rad(-90),0,0)

                lockChar()

                inputBlock.Visible = true
                cross.Visible = true
                upBtn.Visible = true
                downBtn.Visible = true
                hint.Visible = true
                hint.Text = "拖动屏幕移动 上下调高度"
                btn.Text = "确认传送"
                isFlying = true
            end

            function exitFly()
                if root and hum then
                    root.Velocity = Vector3.zero
                    root.AssemblyLinearVelocity = Vector3.zero
                    root.AssemblyAngularVelocity = Vector3.zero

                    local originalHealth = hum.Health
                    local fallDamageConn
                    fallDamageConn = hum.HealthChanged:Connect(function(newHealth)
                        if newHealth < originalHealth then
                            hum.Health = originalHealth
                        end
                    end)

                    local rayParams = RaycastParams.new()
                    rayParams.FilterDescendantsInstances = {plr.Character}
                    rayParams.FilterType = Enum.RaycastFilterType.Exclude

                    local result = Workspace:Raycast(cam.CFrame.Position, Vector3.new(0,-1200,0), rayParams)
                    if result then
                        root.CFrame = CFrame.new(result.Position + Vector3.new(0,2.2,0))
                    else
                        root.CFrame = CFrame.new(cam.CFrame.Position.X, root.Position.Y, cam.CFrame.Position.Z)
                    end

                    task.delay(0.5, function()
                        if fallDamageConn then fallDamageConn:Disconnect() end
                    end)
                end

                cam.CameraType = oldCamType
                cam.CameraType = Enum.CameraType.Custom
                cam.CFrame = oldCamCF
                unlockChar()

                inputBlock.Visible = false
                cross.Visible = false
                upBtn.Visible = false
                downBtn.Visible = false
                hint.Visible = false
                btn.Text = "传送模式"
                isFlying = false
            end

            closeBtn.MouseButton1Click:Connect(function()
                if isFlying then
                    exitFly()
                end
                gui:Destroy()
                loaded = false
            end)

            local screenDrag = false
            local lastTouchPos

            inputBlock.InputBegan:Connect(function(input)
                if not isFlying then return end
                if input.UserInputType == Enum.UserInputType.Touch then
                    screenDrag = true
                    lastTouchPos = input.Position
                end
            end)

            inputBlock.InputEnded:Connect(function(input)
                screenDrag = false
                moveInput = Vector2.zero
            end)

            inputBlock.InputChanged:Connect(function(input)
                if not isFlying or not screenDrag then return end
                if input.UserInputType == Enum.UserInputType.Touch then
                    local delta = input.Position - lastTouchPos
                    lastTouchPos = input.Position
                    moveInput = delta
                end
            end)

            local heightDir = 0
            upBtn.InputBegan:Connect(function() heightDir = 1 end)
            upBtn.InputEnded:Connect(function() heightDir = 0 end)
            downBtn.InputBegan:Connect(function() heightDir = -1 end)
            downBtn.InputEnded:Connect(function() heightDir = 0 end)

            RunService.RenderStepped:Connect(function(dt)
                if not isFlying then return end
                local rightVec = cam.CFrame.RightVector
                local forwardVec = Vector3.new(cam.CFrame.LookVector.X,0,cam.CFrame.LookVector.Z).Unit

                local moveVec = (rightVec * moveInput.X + forwardVec * moveInput.Y) * camSpeed * dt
                local heightVec = Vector3.new(0, heightDir * heightSpeed * dt, 0)

                cam.CFrame += moveVec + heightVec
                moveInput = Vector2.zero

                if root then
                    root.CFrame = CFrame.new(fixedPos)
                    root.Velocity = Vector3.zero
                    root.AssemblyLinearVelocity = Vector3.zero
                end
            end)

            plr.CharacterAdded:Connect(function()
                task.wait(0.2)
                if isFlying then lockChar() end
            end)
        end

        task.spawn(loadUI)
    end
})



TabCommon:Toggle({
    Title = "夜视",
    Default = false,
    Callback = function(v)
        if v then
            game.Lighting.Ambient = Color3.new(2,2,2)
        else
            game.Lighting.Ambient = Color3.new(0,0,0)
        end
    end
})

local InfiniteJump = false

TabCommon:Toggle({
    Title = "无限跳",
    Default = false,
    Callback = function(v)
        InfiniteJump = v
    end
})

game:GetService("UserInputService").JumpRequest:Connect(function()
    if InfiniteJump then
        local hum = game.Players.LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
        if hum then
            hum:ChangeState(Enum.HumanoidStateType.Jumping)
        end
    end
end)

local noclip = false

TabCommon:Toggle({
    Title = "穿墙",
    Default = false,
    Callback = function(v)
        noclip = v
    end
})

game:GetService("RunService").Stepped:Connect(function()
    if noclip then
        local char = game.Players.LocalPlayer.Character
        if char then
            for _, part in pairs(char:GetDescendants()) do
                if part:IsA("BasePart") then
                    part.CanCollide = false
                end
            end
        end
    end
end)



local afkRunning = false
local afkThread = nil

local function getValidCharacter()
    local char = player.Character
    if not char then return nil, nil, nil end
    local hum = char:FindFirstChildOfClass("Humanoid")
    local root = char:FindFirstChild("HumanoidRootPart")
    if not root or not hum or hum.Health <= 0 then return nil, nil, nil end
    if hum:GetState() == Enum.HumanoidStateType.Dead then return nil, nil, nil end
    return char, hum, root
end

local function actionWalk()
    local char, hum, root = getValidCharacter()
    if not char then return end
    local moveDir = Vector3.new((math.random() - 0.5) * 2, 0, (math.random() - 0.5) * 2).Unit * 0.5
    hum:Move(moveDir, false)
    task.wait(0.2 + math.random() * 0.3)
    hum:Move(Vector3.zero, false)
end

local function actionJump()
    local char, hum, root = getValidCharacter()
    if not char then return end
    hum.Jump = true
end

local function actionLook()
    local char, hum, root = getValidCharacter()
    if not char then return end
    workspace.CurrentCamera.CFrame = workspace.CurrentCamera.CFrame * CFrame.Angles(math.rad((math.random() - 0.5) * 0.3), math.rad((math.random() - 0.5) * 0.5), 0)
end

local function actionKeyPress()
    local char, hum, root = getValidCharacter()
    if not char then return end
    local keys = {Enum.KeyCode.W, Enum.KeyCode.A, Enum.KeyCode.S, Enum.KeyCode.D}
    local key = keys[math.random(1, #keys)]
    local UIS = game:GetService("UserInputService")
    UIS:FireKey(key, true)
    task.wait(0.05 + math.random() * 0.1)
    UIS:FireKey(key, false)
end

local function DoAFK()
    local actionCount = 1 + math.random(0, 2)
    local actions = {actionWalk, actionJump, actionLook, actionKeyPress}
    for i = 1, actionCount do
        actions[math.random(1, #actions)]()
        task.wait(0.1 + math.random() * 0.3)
    end
end

local function startAFK()
    afkThread = task.spawn(function()
        while afkRunning do
            DoAFK()
            task.wait(25 + math.random() * 20)
        end
    end)
end

local function stopAFK()
    afkRunning = false
    if afkThread then
        task.cancel(afkThread)
        afkThread = nil
    end
end


TabCommon:Toggle({
    Title = "防挂机",
    Desc = "自动走路/跳跃/转视角/按键防止挂机",
    Value = false,
    Callback = function(v)
        afkRunning = v
        if v then
            startAFK()
            Notify("防挂机", "已开启", 2, "success")
        else
            stopAFK()
            Notify("防挂机", "已关闭", 2, "info")
        end
    end
})

local TabDisaster = Window:Tab({
    Title = "自然灾害",
    Icon = "cloud-lightning",
    Locked = false,
})


TabDisaster:Slider({
    Title = "跳跃高度",
    Value = {Min = 50, Max = 200, Default = 50},
    Increment = 1,
    Callback = function(v)
        local hum = player.Character and player.Character:FindFirstChild("Humanoid")
        if hum then hum.JumpHeight = v end
    end
})

TabDisaster:Slider({
    Title = "镜头FOV",
    Value = {Min = 70, Max = 120, Default = 70},
    Increment = 1,
    Callback = function(v)
        workspace.CurrentCamera.FieldOfView = v
    end
})

TabDisaster:Button({
    Title = "删除摔落伤害",
    Callback = function()
        local char = player.Character
        if not char then return end
        local fs = char:FindFirstChild("FallDamageScript")
        if fs then fs:Destroy() end
        char.ChildAdded:Connect(function(c)
            if c.Name == "FallDamageScript" then c:Destroy() end
        end)
    end
})

TabDisaster:Toggle({
    Title = "预测灾难",
    Value = false,
    Callback = function(v)
        if not v then return end
        local st = player.Character and player.Character:FindFirstChild("SurvivalTag")
        if not st then return end
        local dn = {Blizzard = "暴风雪", Tornado = "龙卷风", ["Volcanic Eruption"] = "火山", ["Flash Flood"] = "洪水", ["Deadly Virus"] = "病毒", Tsunami = "海啸", ["Acid Rain"] = "酸雨", Fire = "火焰", ["Meteor Shower"] = "流星雨", Earthquake = "地震", ["Thunder Storm"] = "暴风雨", Avalanche = "雪崩", Lightning = "闪电", Sandstorm = "沙尘暴"}
        Notify("当前灾难", dn[st.Value] or st.Value, 3, "info")
    end
})
local TabPrison = Window:Tab({
    Title = "监狱人生",
    Icon = "prison",
    Locked = false,
})

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local player = Players.LocalPlayer
local char = player.Character

local function getChar()
    local c = player.Character
    if not c or not c.Parent then return nil end
    return c
end

TabPrison:Button({
    Title = "拿车",
    Callback = function()
        pcall(function()
            local OldPos = player.Character:GetPrimaryPartCFrame()
            player.Character:SetPrimaryPartCFrame(CFrame.new(-910, 95, 2157))
            task.wait()
            local car = nil
            task.spawn(function()
                car = workspace.CarContainer.ChildAdded:Wait()
            end)
            repeat
                task.wait(0.1)
                local btn = workspace.Prison_ITEMS.buttons:GetChildren()[8]["Car Spawner"]
                workspace.Remote.ItemHandler:InvokeServer(btn)
            until car
            repeat task.wait() until car:FindFirstChild("RWD") and car:FindFirstChild("Body") and car.Body:FindFirstChild("VehicleSeat")
            car.PrimaryPart = car.RWD
            player.Character:SetPrimaryPartCFrame(OldPos)
            task.wait(1)
            local Done = false
            car.Body.VehicleSeat:Sit(player.Character:FindFirstChildOfClass("Humanoid"))
            repeat
                RunService.RenderStepped:Wait()
                car:SetPrimaryPartCFrame(OldPos)
                player.Character.HumanoidRootPart.CFrame = CFrame.new(car.Body.VehicleSeat.Position)
                car.Body.VehicleSeat:Sit(player.Character:FindFirstChildOfClass("Humanoid"))
                if player.Character:FindFirstChildOfClass("Humanoid").Sit == true then
                    Done = true
                end
            until Done
        end)
    end
})

TabPrison:Dropdown({
    Title = "传送位置列表",
    Values = {"警卫室","监狱室内","犯罪点","院子"},
    Callback = function(val)
        local cf = nil
        if val == "警卫室" then
            cf = CFrame.new(847.7261352539062, 98.95999908447266, 2267.387451171875)
        elseif val == "监狱室内" then
            cf = CFrame.new(919.2575073242188, 98.95999908447266, 2379.74169921875)
        elseif val == "犯罪点" then
            cf = CFrame.new(-937.5891723632812, 93.09876251220703, 2063.031982421875)
        elseif val == "院子" then
            cf = CFrame.new(760.6033325195312, 96.96992492675781, 2475.405029296875)
        end
        if cf and player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
            player.Character.HumanoidRootPart.CFrame = cf
        end
    end
})

TabPrison:Button({
    Title = "给所有枪",
    Callback = function()
        local char = player.Character
        if not char then return end
        local root = char:FindFirstChild("HumanoidRootPart")
        if not root then return end
        root.CFrame = CFrame.new(822, 101, 2251)
        task.wait(1.1)
        local args = { [1] = workspace.Prison_ITEMS.giver.M9.ITEMPICKUP }
        workspace.Remote.ItemHandler:InvokeServer(unpack(args))
        task.wait(1.1)
        root.CFrame = CFrame.new(824.801025, 104.330627, 2250.36157)
        task.wait(1.1)
        args = { [1] = workspace.Prison_ITEMS.giver["Remington 870"].ITEMPICKUP }
        workspace.Remote.ItemHandler:InvokeServer(unpack(args))
        task.wait(1.1)
        root.CFrame = CFrame.new(-936.710632, 93.5627747, 2054.66602)
        task.wait(1.1)
        args = { [1] = workspace.Prison_ITEMS.giver["AK-47"].ITEMPICKUP }
        workspace.Remote.ItemHandler:InvokeServer(unpack(args))
    end
})

local killAuraPart = nil
local killAuraActive = false

local function createKillPart()
    if killAuraPart then killAuraPart:Destroy() end
    local part = Instance.new("Part", player.Character)
    local hl = Instance.new("Highlight", part)
    hl.FillTransparency = 1
    part.Anchored = true
    part.CanCollide = false
    part.CanTouch = false
    part.Transparency = 0.98
    part.Size = Vector3.new(20,2,20)
    part.Name = "KillAuraPart"
    killAuraPart = part
end

TabPrison:Toggle({
    Title = "杀死光环",
    Value = false,
    Callback = function(v)
        killAuraActive = v
        if v then
            createKillPart()
        else
            if killAuraPart then killAuraPart:Destroy(); killAuraPart = nil end
        end
    end
})

game:GetService("RunService").Stepped:Connect(function()
    if not killAuraActive then return end
    local char = player.Character
    if not char then return end
    local root = char:FindFirstChild("HumanoidRootPart")
    if not root then return end
    for _, target in ipairs(Players:GetPlayers()) do
        if target ~= player and target.Character and target.Character:FindFirstChild("HumanoidRootPart") then
            local tRoot = target.Character.HumanoidRootPart
            if (tRoot.Position - root.Position).Magnitude < 14 and target.Character.Humanoid.Health > 0 then
                ReplicatedStorage.meleeEvent:FireServer(target)
            end
        end
    end
end)

local soundSpamActive = false
local soundSpamThread = nil

local function spamSoundLoop()
    while soundSpamActive do
        for _, v in pairs(game:GetDescendants()) do
            if v:IsA("Sound") then
                pcall(function() v:Play() end)
            end
        end
        task.wait()
    end
end

TabPrison:Toggle({
    Title = "声音折磨",
    Value = false,
    Callback = function(v)
        soundSpamActive = v
        if v then
            if soundSpamThread then task.cancel(soundSpamThread) end
            soundSpamThread = task.spawn(spamSoundLoop)
        else
            if soundSpamThread then task.cancel(soundSpamThread); soundSpamThread = nil end
        end
    end
})

TabPrison:Toggle({
    Title = "删除门",
    Value = false,
    Callback = function(v)
        local doors = workspace:FindFirstChild("Doors")
        local nikodoors = ReplicatedStorage:FindFirstChild("nikodoors")
        if not doors or not nikodoors then return end
        if v then
            for _, d in pairs(doors:GetChildren()) do
                d.Parent = nikodoors
            end
        else
            for _, d in pairs(nikodoors:GetChildren()) do
                d.Parent = doors
            end
        end
    end
})

local prisonNoclip = false
local prisonNoclipConn = nil
TabPrison:Toggle({
    Title = "穿墙",
    Value = false,
    Callback = function(v)
        prisonNoclip = v
        if prisonNoclipConn then prisonNoclipConn:Disconnect() end
        if v then
            prisonNoclipConn = game:GetService("RunService").Stepped:Connect(function()
                if not prisonNoclip then return end
                local c = player.Character
                if c then
                    for _, part in ipairs(c:GetDescendants()) do
                        if part:IsA("BasePart") then
                            part.CanCollide = false
                        end
                    end
                end
            end)
        end
    end
})

TabPrison:Button({
    Title = "逮捕所有罪犯",
    Callback = function()
        local criminals = game.Teams:FindFirstChild("Criminals")
        if not criminals then return end
        local myChar = player.Character
        if not myChar then return end
        local myRoot = myChar:FindFirstChild("HumanoidRootPart")
        if not myRoot then return end
        local oldCF = myRoot.CFrame
        for _, target in ipairs(criminals:GetPlayers()) do
            if target ~= player and target.Character then
                local tRoot = target.Character:FindFirstChild("HumanoidRootPart")
                if tRoot then
                    for _ = 1, 10 do
                        myRoot.CFrame = tRoot.CFrame * CFrame.new(0,0,1)
                        workspace.Remote.arrest:InvokeServer(tRoot)
                        task.wait()
                    end
                end
            end
        end
        myRoot.CFrame = oldCF
    end
})

TabPrison:Button({
    Title = "变成警察",
    Callback = function()
        workspace.Remote.TeamEvent:FireServer("Bright blue")
    end
})
TabPrison:Button({
    Title = "变成囚犯",
    Callback = function()
        workspace.Remote.TeamEvent:FireServer("Bright orange")
    end
})

TabPrison:Button({
    Title = "金字塔（武器特效）",
    Callback = function()
        local plr_local = player
        local char_local = plr_local.Character
        if not char_local then return end
        local mouse = plr_local:GetMouse()
        local firing = false
        local m = Instance.new("Model", char_local)
        local illum = Instance.new("Part", m)
        illum.CanCollide = false
        illum.Size = Vector3.new(0.2,0.2,0.2)
        illum.Anchored = true
        local s = Instance.new("Sound", m)
        s.SoundId = "rbxassetid://185492305"
        s.Volume = 0.8
        s.Looped = true
        s:Play()
        local SP = Instance.new("SpecialMesh", illum)
        SP.MeshId = "rbxassetid://438530093"
        SP.TextureId = "rbxassetid://438530120"
        SP.Scale = Vector3.new(0.2,0.2,0.2)
        local MousePart = Instance.new("Part", m)
        MousePart.CanCollide = false
        MousePart.Size = Vector3.new(0.2,0.2,0.2)
        MousePart.Anchored = true
        local TipPart = Instance.new("Part", m)
        TipPart.CanCollide = false
        TipPart.BrickColor = BrickColor.new("Lime green")
        TipPart.Material = Enum.Material.Neon
        TipPart.Shape = Enum.PartType.Ball
        TipPart.Size = Vector3.new(2,2,2)
        TipPart.Anchored = true
        TipPart.Transparency = 0.5
        local pe1 = Instance.new("ParticleEmitter", TipPart)
        pe1.Texture = "rbxassetid://686815657"
        pe1.Rate = 30
        local pe2 = Instance.new("ParticleEmitter", TipPart)
        pe2.Texture = "rbxassetid://686815657"
        pe2.Rate = 10
        local pe3 = Instance.new("ParticleEmitter", TipPart)
        pe3.Texture = "rbxassetid://686815657"
        pe3.Rate = 10
        local pe4 = Instance.new("ParticleEmitter", MousePart)
        pe4.Texture = "rbxassetid://15361603644"
        pe4.Rate = 100
        local pe5 = Instance.new("ParticleEmitter", MousePart)
        pe5.Texture = "rbxassetid://686815657"
        pe5.Rate = 100
        local pe6 = Instance.new("ParticleEmitter", MousePart)
        pe6.Texture = "rbxassetid://644165701"
        pe6.Rate = 100
        for _, pe in ipairs({pe1,pe2,pe3,pe4,pe5,pe6}) do
            pe.Enabled = false
            pe.Acceleration = Vector3.new(0,-10,0)
            pe.Lifetime = NumberRange.new(2,4)
            pe.Speed = NumberRange.new(8,10)
            pe.VelocitySpread = 50
        end
        local function drawlazer(p1,p2)
            local part = Instance.new("Part", m)
            part.Name = "Location"
            part.BrickColor = BrickColor.new("Lime green")
            part.Material = Enum.Material.Neon
            part.Shape = Enum.PartType.Ball
            part.Size = Vector3.new(4,4,4)
            part.Anchored = true
            part.CanCollide = false
            part.Transparency = 0.5
            part.CFrame = CFrame.new(p1.Position)
            local obj = part
            local objC = obj:Clone()
            objC.Name = "Line"
            objC.Parent = m
            objC.Shape = Enum.PartType.Ball
            objC.Anchored = true
            local distance = (p2.Position - obj.CFrame.p).magnitude
            objC.Size = Vector3.new(10,10,distance)
            objC.CFrame = CFrame.new(p2.Position, obj.Position) * CFrame.new(0,0,-distance/2)
            local objCC1 = objC:Clone()
            objCC1.Parent = objC
            objCC1.CFrame = CFrame.new(p2.Position, obj.Position) * CFrame.new(0,0,-distance/2.5)
            objCC1.Size = Vector3.new(4,4,distance/2)
            objCC1.Name = "LineC1"
            local objCC2 = objC:Clone()
            objCC2.Parent = objC
            objCC2.CFrame = CFrame.new(p2.Position, obj.Position) * CFrame.new(0,0,-distance/1.5)
            objCC2.Size = Vector3.new(4,4,distance/2)
            objCC2.Name = "LineC2"
        end
        local function drawlazer2(p1,p2)
            local part = m:FindFirstChild("Location")
            part.CFrame = CFrame.new(p1.Position)
            local obj = part
            local distance = (p2.Position - obj.CFrame.p).magnitude
            local objC = m.Line:Clone()
            objC.Name = "Line2"
            objC.Parent = m
            objC.Size = Vector3.new(4,4,distance)
            objC.CFrame = CFrame.new(p2.Position, obj.Position) * CFrame.new(0,0,-distance/2)
            local objCC1 = objC.LineC1
            objCC1.CFrame = CFrame.new(p2.Position, obj.Position) * CFrame.new(0,0,-distance/2.5)
            objCC1.Size = Vector3.new(4,4,distance/2)
            local objCC2 = objC.LineC2
            objCC2.CFrame = CFrame.new(p2.Position, obj.Position) * CFrame.new(0,0,-distance/1.5)
            objCC2.Size = Vector3.new(4,4,distance/2)
            m.Line:Destroy()
            objC.Name = "Line"
        end
        local function despawn1(part1,part2,length)
            for i = 10,1,-1 do
                part1.Transparency = part1.Transparency + 0.1
                part1.Size = part1.Size + Vector3.new(0.2,0.2,length)
                part1.Size = Vector3.new(part1.Size.X,part1.Size.Y,length)
                task.wait(0.01)
            end
            part1:Destroy()
            for i = 10,1,-1 do
                part2.Transparency = part2.Transparency + 0.1
                task.wait(0.01)
            end
            part2:Destroy()
        end
        local function despawn2(part1,length)
            for i = 10,1,-1 do
                part1.Transparency = part1.Transparency + 0.1
                part1.Size = part1.Size + Vector3.new(0.2,0,length)
                part1.Size = Vector3.new(part1.Size.X,part1.Size.Y,length)
                task.wait(0.01)
            end
            part1:Destroy()
        end
        local function snipe(T)
            for i, plr in pairs(Players:GetPlayers()) do
                if plr ~= player then
                    for i = 1, 10 do
                        ReplicatedStorage.meleeEvent:FireServer(plr)
                    end
                end
            end
            local part = Instance.new("Part", m)
            part.Name = "Sniper"
            part.BrickColor = BrickColor.new("Really black")
            part.Material = Enum.Material.Neon
            part.Size = Vector3.new(1,1,3)
            part.Anchored = true
            part.CanCollide = false
            local SP = Instance.new("SpecialMesh", part)
            SP.MeshId = "rbxassetid://685827900"
            SP.Scale = Vector3.new(0.05,0.05,0.05)
            SP.Offset = Vector3.new(0,-0.3,3.05)
            part.Position = char_local.Torso.Position + Vector3.new(math.random(-5,5), math.random(3,8), math.random(-5,5))
            part.CFrame = CFrame.new(part.Position, T.Position)
            local obj = part
            local objC = obj:Clone()
            objC.Mesh:Destroy()
            task.wait(0.05)
            objC.Parent = part
            objC.Shape = Enum.PartType.Ball
            objC.Anchored = true
            objC.BrickColor = BrickColor.new("New Yeller")
            local distance = (T.Position - obj.CFrame.p).magnitude
            objC.Size = Vector3.new(0.2,0.2,distance)
            objC.CFrame = CFrame.new(T.Position, obj.Position) * CFrame.new(0,0,-distance/2)
            local s = Instance.new("Sound", part)
            s.SoundId = "rbxassetid://680140087"
            s.Volume = 1
            s.PlayOnRemove = true
            s:Destroy()
            despawn1(objC, part, distance)
            if mouse.Target.Parent:FindFirstChildOfClass("Humanoid") then
                mouse.Target.Parent:FindFirstChildOfClass("Humanoid"):TakeDamage(20)
                local PETemp = Instance.new("ParticleEmitter", mouse.Target)
                PETemp.Texture = "rbxassetid://644165701"
                PETemp.Acceleration = Vector3.new(0,-10,0)
                PETemp.Lifetime = NumberRange.new(2,4)
                PETemp.Speed = NumberRange.new(8,10)
                PETemp.Rate = 100
                PETemp.VelocitySpread = 50
                PETemp.Enabled = true
                task.wait(0.1)
                PETemp.Enabled = false
            end
        end
        local function ThrowDorito(a,b)
            local animation = Instance.new("Animation", char_local:FindFirstChildOfClass("Humanoid"))
            animation.Name = "Throw"
            animation.AnimationId = "http://www.roblox.com/asset/?id=15426655759"
            local anim = char_local:FindFirstChildOfClass("Humanoid"):LoadAnimation(animation)
            anim:Play()
            local part = Instance.new("Part", m)
            part.Name = "Dorito"
            part.BrickColor = BrickColor.new("Neon orange")
            part.Material = Enum.Material.Neon
            part.Shape = Enum.PartType.Ball
            part.Size = Vector3.new(1,0.2,1)
            part.Anchored = true
            part.CanCollide = false
            part.Transparency = 0
            part.CFrame = CFrame.new(a.Position)
            local SP = Instance.new("SpecialMesh", part)
            SP.MeshId = "rbxassetid://627995517"
            SP.Scale = Vector3.new(1,1,1)
            local obj = part
            local objC = obj:Clone()
            objC.Name = "DoritoTrail"
            objC.Mesh:Destroy()
            objC.Parent = m
            objC.Anchored = true
            objC.Transparency = 0.5
            objC.BrickColor = BrickColor.new("CGA brown")
            local distance = (b.Position - obj.CFrame.p).magnitude
            objC.Size = Vector3.new(1,0.2,distance)
            objC.CFrame = CFrame.new(b.Position, obj.Position) * CFrame.new(0,0,-distance/2)
            obj.CFrame = CFrame.new(b.Position, obj.Position) * CFrame.new(0,0,-distance)
            obj.CFrame = obj.CFrame * CFrame.fromEulerAnglesXYZ(0, math.random(1,99), 0)
            objC.Size = Vector3.new(1,0.2,distance)
            local target = mouse.Target
            local weld = Instance.new("ManualWeld")
            weld.Part0 = part
            weld.Part1 = target
            weld.C0 = CFrame.new()
            weld.C1 = target.CFrame:inverse() * part.CFrame
            weld.Parent = part
            part.Anchored = false
            if target.Parent:FindFirstChildOfClass("Humanoid") then
                target.Parent:FindFirstChildOfClass("Humanoid"):TakeDamage(5)
            end
            despawn2(objC, distance)
        end
        local function shoot()
            for i, plr in pairs(Players:GetPlayers()) do
                if plr ~= player then
                    for i = 1, 10 do
                        ReplicatedStorage.meleeEvent:FireServer(plr)
                    end
                end
            end
            TipPart.Transparency = 0.5
            if m:FindFirstChild("Line") == nil then
                drawlazer(MousePart, TipPart)
            else
                drawlazer2(MousePart, TipPart)
            end
            local s = Instance.new("Sound", TipPart)
            s.SoundId = "rbxassetid://705502934"
            s.Volume = 2.5
            s.PlayOnRemove = true
            s:Destroy()
            task.wait()
        end
        mouse.Button1Up:Connect(function()
            firing = false
            for _, pe in ipairs({pe1,pe2,pe3,pe4,pe5,pe6}) do pe.Enabled = false end
            if m:FindFirstChild("Line") then
                m.Line:Destroy()
                m.Location:Destroy()
            end
            TipPart.Transparency = 1
            repeat
                illum.CFrame = illum.CFrame * CFrame.fromEulerAnglesXYZ(0,0.05,0)
                illum.Position = char_local.Torso.Position + Vector3.new(0,0.01,0)
                if m:FindFirstChild("Line") then m:FindFirstChild("Line"):Destroy() end
                if m:FindFirstChild("Location") then m:FindFirstChild("Location"):Destroy() end
                task.wait()
            until firing == true
        end)
        mouse.Button1Down:Connect(function()
            firing = true
            pe1.Enabled = true
            pe4.Enabled = true
            pe5.Enabled = true
            pe6.Enabled = true
            repeat
                MousePart.CFrame = CFrame.new(mouse.Hit.p)
                TipPart.Position = char_local.Head.Position + Vector3.new(0,9,0)
                illum.CFrame = illum.CFrame * CFrame.fromEulerAnglesXYZ(0,0.05,0)
                illum.Position = char_local.Torso.Position + Vector3.new(0,0.01,0)
                shoot()
                task.wait()
            until firing == false
        end)
        mouse.KeyDown:Connect(function(key)
            if key == "q" and firing == false then
                MousePart.CFrame = CFrame.new(mouse.Hit.p)
                snipe(MousePart)
            elseif key == "e" and firing == false then
                MousePart.CFrame = CFrame.new(mouse.Hit.p)
                ThrowDorito(MousePart, char_local:FindFirstChild("Right Arm"))
            end
        end)
    end
})

TabPrison:Button({
    Title = "甩飞警察",
    Callback = function()
        local function skidFling(targetPlayer)
            local myChar = player.Character
            if not myChar then return end
            local myRoot = myChar:FindFirstChild("HumanoidRootPart")
            local myHum = myChar:FindFirstChildOfClass("Humanoid")
            if not myRoot or not myHum then return end
            local tChar = targetPlayer.Character
            if not tChar then return end
            local tRoot = tChar:FindFirstChild("HumanoidRootPart")
            local tHead = tChar:FindFirstChild("Head")
            local targetPart = tRoot or tHead
            if not targetPart then return end
            local oldPos = myRoot.CFrame
            myHum:SetStateEnabled(Enum.HumanoidStateType.Seated, false)
            local bv = Instance.new("BodyVelocity", myRoot)
            bv.Velocity = Vector3.new(9e8,9e8,9e8)
            bv.MaxForce = Vector3.new(math.huge,math.huge,math.huge)
            local angle = 0
            for _ = 1, 30 do
                angle = angle + 100
                myRoot.CFrame = CFrame.new(targetPart.Position) * CFrame.new(0,1.5,0) * CFrame.Angles(math.rad(angle),0,0)
                task.wait()
                myRoot.CFrame = CFrame.new(targetPart.Position) * CFrame.new(0,-1.5,0) * CFrame.Angles(math.rad(angle),0,0)
                task.wait()
            end
            bv:Destroy()
            myHum:SetStateEnabled(Enum.HumanoidStateType.Seated, true)
            myRoot.CFrame = oldPos
        end
        for _, p in ipairs(Players:GetPlayers()) do
            if p ~= player and (p.Team and p.Team.Name == "Police") then
                skidFling(p)
            end
        end
    end
})

local killAllActive = false
local killAllThread = nil

local function killAllLoop()
    while killAllActive do
        for _, target in ipairs(Players:GetPlayers()) do
            if target ~= player and target.Character and target.Character:FindFirstChildOfClass("Humanoid") and target.Character.Humanoid.Health > 0 then
                pcall(function()
                    ReplicatedStorage.meleeEvent:FireServer(target)
                end)
            end
        end
        task.wait(0.1)
    end
end

TabPrison:Toggle({
    Title = "杀死全部",
    Value = false,
    Callback = function(v)
        killAllActive = v
        if v then
            if killAllThread then task.cancel(killAllThread) end
            killAllThread = task.spawn(killAllLoop)
        else
            if killAllThread then task.cancel(killAllThread); killAllThread = nil end
        end
    end
})
local TabEverest = Window:Tab({
    Title = "珠峰模拟器",
    Icon = "mountain",
    Locked = false,
})

TabEverest:Button({
    Title = "传送到山顶",
    Callback = function()

        local char = game.Players.LocalPlayer.Character

        if char and char:FindFirstChild("HumanoidRootPart") then

            char.HumanoidRootPart.CFrame =
            CFrame.new(-5183.8422,8488.1103,1100.8852)

        end
    end
})
local TabDoors = Window:Tab({
    Title = "Doors",
    Icon = "door-open",
    Locked = false,
})

TabDoors:Button({
    Title = "到达酒店",
    Callback = function()
        game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame =
        CFrame.new(-12.6052,10003.9970,52.6931)
    end
})

TabDoors:Button({
    Title = "Seek追逐战1",
    Callback = function()
        game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame =
        CFrame.new(267.9065,10003.9970,57.0241)
    end
})

TabDoors:Button({
    Title = "图书馆",
    Callback = function()
        game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame =
        CFrame.new(165.1287,10004.9970,129.6620)
    end
})

TabDoors:Button({
    Title = "Seek追逐战2",
    Callback = function()
        game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame =
        CFrame.new(-258.4086,10009.9980,-0.5703)
    end
})

TabDoors:Button({
    Title = "100门",
    Callback = function()
        game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame =
        CFrame.new(-805.6561,10009.9980,-494.2725)
    end
})

TabDoors:Button({
    Title = "电路室",
    Callback = function()
        game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame =
        CFrame.new(-813.7102,10009.9980,-566.4942)
    end
})

TabDoors:Button({
    Title = "100门通关",
    Callback = function()
        game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame =
        CFrame.new(-778.1950,10010.1279,-582.7162)
    end
})

TabDoors:Button({
    Title = "50门通关",
    Callback = function()
        game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame =
        CFrame.new(63.6537,10009.9970,131.2858)
    end
})

TabDoors:Button({
    Title = "追逐战1通关",
    Callback = function()
        game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame =
        CFrame.new(422.2347,10003.9970,101.2111)
    end
})

TabDoors:Button({
    Title = "追逐战2通关",
    Callback = function()
        game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame =
        CFrame.new(-431.0469,10009.9970,-134.9712)
    end
})
Window:Tag({
    Title = "泽脚本出品",
    Icon = "github",
    Color = Color3.fromRGB(255, 204, 0),
    Radius = 8,
})
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local player = Players.LocalPlayer
local GrabEvent = ReplicatedStorage:WaitForChild("Events"):WaitForChild("Grab")
local EquipEvent = ReplicatedStorage:WaitForChild("Events"):WaitForChild("EquipTool")
local MAX_DISTANCE = 50

local function getNearestPlayer()
    local character = player.Character
    if not character then return nil end
    local root = character:FindFirstChild("HumanoidRootPart")
    if not root then return nil end
    local nearestPlayer = nil
    local nearestDistance = math.huge
    for _, target in ipairs(Players:GetPlayers()) do
        if target ~= player then
            local targetChar = target.Character
            if targetChar then
                local targetRoot = targetChar:FindFirstChild("HumanoidRootPart")
                if targetRoot then
                    local distance = (root.Position - targetRoot.Position).Magnitude
                    if distance < nearestDistance and distance <= MAX_DISTANCE then
                        nearestDistance = distance
                        nearestPlayer = target
                    end
                end
            end
        end
    end
    return nearestPlayer
end

local function grabNearest()
    local target = getNearestPlayer()
    if not target then
        
        return
    end
    local myChar = player.Character
    local targetChar = target.Character
    if not myChar or not targetChar then return end
    local bodyPart = targetChar:FindFirstChild("Right Leg") or targetChar:FindFirstChild("HumanoidRootPart") or targetChar:FindFirstChild("Left Leg")
    if not bodyPart then
        
        return
    end
    local myRoot = myChar:FindFirstChild("HumanoidRootPart")
    if myRoot then
        local lookAt = CFrame.lookAt(myRoot.Position, Vector3.new(bodyPart.Position.X, myRoot.Position.Y, bodyPart.Position.Z))
        myRoot.CFrame = lookAt
    end
    task.wait(0.05)
    bodyPart = targetChar:FindFirstChild("Right Leg") or targetChar:FindFirstChild("HumanoidRootPart") or targetChar:FindFirstChild("Left Leg")
    if not bodyPart then return end
    GrabEvent:FireServer(bodyPart, "Grab", bodyPart.Position, bodyPart.CFrame)

end

local function taseNearest(freePass)
    local target = getNearestPlayer()
    if not target then
        
        return
    end
    local myChar = player.Character
    local targetChar = target.Character
    if not myChar or not targetChar then return end
    local bodyPart = targetChar:FindFirstChild("Left Arm") or targetChar:FindFirstChild("Right Arm") or targetChar:FindFirstChild("HumanoidRootPart")
    if not bodyPart then

        return
    end
    local myRoot = myChar:FindFirstChild("HumanoidRootPart")
    if myRoot then
        local lookAt = CFrame.lookAt(myRoot.Position, Vector3.new(bodyPart.Position.X, myRoot.Position.Y, bodyPart.Position.Z))
        myRoot.CFrame = lookAt
    end
    task.wait(0.05)
    bodyPart = targetChar:FindFirstChild("Left Arm") or targetChar:FindFirstChild("Right Arm") or targetChar:FindFirstChild("HumanoidRootPart")
    if not bodyPart then return end
    if freePass then
        EquipEvent:FireServer("Taser")
        task.wait(0.1)
        GrabEvent:FireServer(bodyPart, "Taser", bodyPart.Position, bodyPart.CFrame)
        task.wait(0.1)
        EquipEvent:FireServer("Rope")
    else
        GrabEvent:FireServer(bodyPart, "Taser", bodyPart.Position, bodyPart.CFrame)
    end
    
end

local function mindControlNearest(freePass)
    local target = getNearestPlayer()
    if not target then
        
        return
    end
    local targetChar = target.Character
    if not targetChar then return end
    local bodyPart = targetChar:FindFirstChild("Torso") or targetChar:FindFirstChild("UpperTorso") or targetChar:FindFirstChild("HumanoidRootPart")
    if not bodyPart then
        
        return
    end
    local myChar = player.Character
    if not myChar then return end
    local myRoot = myChar:FindFirstChild("HumanoidRootPart")
    if myRoot then
        local lookAt = CFrame.lookAt(myRoot.Position, Vector3.new(bodyPart.Position.X, myRoot.Position.Y, bodyPart.Position.Z))
        myRoot.CFrame = lookAt
    end
    task.wait(0.05)
    bodyPart = targetChar:FindFirstChild("Torso") or targetChar:FindFirstChild("UpperTorso") or targetChar:FindFirstChild("HumanoidRootPart")
    if not bodyPart then return end
    if freePass then
        EquipEvent:FireServer("Taser")
        task.wait(0.1)
        GrabEvent:FireServer(bodyPart, "Mind Control", bodyPart.Position, bodyPart.CFrame)
        task.wait(0.1)
        EquipEvent:FireServer("Rope")
    else
        GrabEvent:FireServer(bodyPart, "Mind Control", bodyPart.Position, bodyPart.CFrame)
    end
    
end

local TabFunction = Window:Tab({
    Title = "载人模拟器",
    Icon = "swords",
    Locked = false,
})

local freePassEnabled = false

local quickBtns = {}

local function makeBtn(name, text, color, posY, callback)

local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = name .. "Gui"
ScreenGui.Parent = game:GetService("CoreGui")

    local btn = Instance.new("TextButton")
    btn.Name = name
    btn.Size = UDim2.new(0, 55, 0, 48)
    btn.Position = UDim2.new(1, -63, 0, posY)
    btn.BackgroundColor3 = color
    btn.TextColor3 = Color3.fromRGB(255, 255, 255)
    btn.Text = text
    btn.TextSize = 14
    btn.Font = Enum.Font.GothamBold
    btn.Parent = ScreenGui

    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 10)
    corner.Parent = btn

    local stroke = Instance.new("UIStroke")
    stroke.Color = Color3.fromRGB(255, 255, 255)
    stroke.Thickness = 1.5
    stroke.Transparency = 0.5
    stroke.Parent = btn

    btn.Activated:Connect(callback)
    
    quickBtns[name] = ScreenGui
    return ScreenGui
end

local grabGui = makeBtn("GrabQuick", "抓取", Color3.fromRGB(255, 70, 70), 10, grabNearest)
local taseGui = makeBtn("TaseQuick", "电击", Color3.fromRGB(70, 120, 255), 63, function() taseNearest(freePassEnabled) end)
local mindGui = makeBtn("MindQuick", "控制", Color3.fromRGB(150, 50, 200), 116, function() mindControlNearest(freePassEnabled) end)

grabGui.Enabled = false
taseGui.Enabled = false
mindGui.Enabled = false

player.CharacterAdded:Connect(function()
    task.wait(0.5)
    if quickBtns["GrabQuick"] then quickBtns["GrabQuick"].Parent = game:GetService("CoreGui") end
    if quickBtns["TaseQuick"] then quickBtns["TaseQuick"].Parent = game:GetService("CoreGui") end
    if quickBtns["MindQuick"] then quickBtns["MindQuick"].Parent = game:GetService("CoreGui") end
end)

TabFunction:Toggle({
    Title = "免费通行证模式",
    Desc = "开启后可用绳子触发电击/心灵控制",
    Value = false,
    Callback = function(v)
        freePassEnabled = v
        Notify("通行证模式", v and "已开启（切换武器执行）" or "已关闭（需要通行证）", 2, "info")
    end
})

TabFunction:Toggle({
    Title = "显示抓取按钮",
    Desc = "屏幕右上角显示抓取快捷按钮",
    Value = false,
    Callback = function(v)
        if quickBtns["GrabQuick"] then
            quickBtns["GrabQuick"].Enabled = v
        end
    end
})

TabFunction:Toggle({
    Title = "显示电击按钮",
    Desc = "屏幕右上角显示电击快捷按钮",
    Value = false,
    Callback = function(v)
        if quickBtns["TaseQuick"] then
            quickBtns["TaseQuick"].Enabled = v
        end
    end
})

TabFunction:Toggle({
    Title = "显示控制按钮",
    Desc = "屏幕右上角显示心灵控制快捷按钮",
    Value = false,
    Callback = function(v)
        if quickBtns["MindQuick"] then
            quickBtns["MindQuick"].Enabled = v
        end
    end
})

TabFunction:Button({
    Title = "抓取最近玩家",
    Desc = "自动面向并抓取距离最近的玩家",
    Callback = function()
        grabNearest()
    end
})

TabFunction:Button({
    Title = "电击最近玩家",
    Desc = "使用电击枪电击最近玩家",
    Callback = function()
        taseNearest(freePassEnabled)
    end
})

TabFunction:Button({
    Title = "心灵控制最近玩家",
    Desc = "对最近玩家使用心灵控制",
    Callback = function()
        mindControlNearest(freePassEnabled)
    end
})

do
    local NewPlayers = game:GetService("Players")
    local NewReplicatedStorage = game:GetService("ReplicatedStorage")
    local NewPlayer = NewPlayers.LocalPlayer
    local NewGrabEvent = NewReplicatedStorage:WaitForChild("Events"):WaitForChild("Grab")

    local function getNearestPlayerForTp()
        local char = NewPlayer.Character
        if not char then return nil end
        local root = char:FindFirstChild("HumanoidRootPart")
        if not root then return nil end
        local nearest, minDist = nil, math.huge
        for _, target in ipairs(NewPlayers:GetPlayers()) do
            if target ~= NewPlayer and target.Character then
                local targetRoot = target.Character:FindFirstChild("HumanoidRootPart")
                if targetRoot then
                    local dist = (root.Position - targetRoot.Position).Magnitude
                    if dist < minDist then
                        minDist = dist
                        nearest = target
                    end
                end
            end
        end
        return nearest
    end

    local function tpAndGrabNearest()
        local target = getNearestPlayerForTp()
        if not target then return end
        local myChar = NewPlayer.Character
        local targetChar = target.Character
        if not myChar or not targetChar then return end
        local myRoot = myChar:FindFirstChild("HumanoidRootPart")
        local targetRoot = targetChar:FindFirstChild("HumanoidRootPart")
        if not myRoot or not targetRoot then return end

        local oldPos = myRoot.CFrame
        myRoot.CFrame = targetRoot.CFrame * CFrame.new(0, 0, -2)
        task.wait(0.25)
        myRoot.CFrame = CFrame.lookAt(myRoot.Position, Vector3.new(targetRoot.Position.X, myRoot.Position.Y, targetRoot.Position.Z))
        task.wait(0.05)
        local bodyPart = targetChar:FindFirstChild("HumanoidRootPart") or targetChar:FindFirstChild("Right Leg") or targetChar:FindFirstChild("Left Leg")
        if bodyPart then
            NewGrabEvent:FireServer(bodyPart, "Grab", bodyPart.Position, bodyPart.CFrame)
        end
        task.wait(0.3)
        myRoot.CFrame = oldPos
    end

    TabFunction:Button({
        Title = "瞬移抓取最近玩家",
        Desc = "瞬移到最近玩家背后并实施抓取",
        Callback = function()
            pcall(tpAndGrabNearest)
        end
    })

    local function grabSpecificPlayer(target)
        if not target or not target.Character then return end
        local myChar = NewPlayer.Character
        local targetChar = target.Character
        if not myChar or not targetChar then return end
        local myRoot = myChar:FindFirstChild("HumanoidRootPart")
        local targetRoot = targetChar:FindFirstChild("HumanoidRootPart")
        if not myRoot or not targetRoot then return end

        local oldPos = myRoot.CFrame
        myRoot.CFrame = targetRoot.CFrame * CFrame.new(0, 0, -2)
        task.wait(0.25)
        myRoot.CFrame = CFrame.lookAt(myRoot.Position, Vector3.new(targetRoot.Position.X, myRoot.Position.Y, targetRoot.Position.Z))
        task.wait(0.05)
        local bodyPart = targetChar:FindFirstChild("HumanoidRootPart") or targetChar:FindFirstChild("Right Leg") or targetChar:FindFirstChild("Left Leg")
        if bodyPart then
            NewGrabEvent:FireServer(bodyPart, "Grab", bodyPart.Position, bodyPart.CFrame)
        end
        task.wait(0.3)
        myRoot.CFrame = oldPos
    end

    local gui = Instance.new("ScreenGui")
    gui.Name = "TpGrabSelectGui"
    gui.Enabled = false
    gui.Parent = game:GetService("CoreGui")

    local mainBtn = Instance.new("TextButton")
    mainBtn.Size = UDim2.new(0, 120, 0, 40)
    mainBtn.Position = UDim2.new(1, -130, 0, 140)
    mainBtn.BackgroundColor3 = Color3.fromRGB(255, 120, 0)
    mainBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    mainBtn.Text = "瞬抓玩家 ▶"
    mainBtn.TextSize = 14
    mainBtn.Font = Enum.Font.GothamBold
    mainBtn.Parent = gui

    Instance.new("UICorner", mainBtn).CornerRadius = UDim.new(0, 8)
    local stroke = Instance.new("UIStroke", mainBtn)
    stroke.Color = Color3.fromRGB(255, 255, 255)
    stroke.Thickness = 1.5
    stroke.Transparency = 0.3

    local listFrame = Instance.new("Frame")
    listFrame.Name = "PlayerList"
    listFrame.Size = UDim2.new(0, 140, 0, 200)
    listFrame.Position = UDim2.new(1, -150, 0, 185)
    listFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 35)
    listFrame.BorderSizePixel = 0
    listFrame.Visible = false
    listFrame.Parent = gui

    Instance.new("UICorner", listFrame).CornerRadius = UDim.new(0, 8)
    Instance.new("UIStroke", listFrame).Color = Color3.fromRGB(100, 60, 255)
    listFrame.UIStroke.Thickness = 1.5

    local scroll = Instance.new("ScrollingFrame", listFrame)
    scroll.Size = UDim2.new(1, -4, 1, -4)
    scroll.Position = UDim2.new(0, 2, 0, 2)
    scroll.BackgroundTransparency = 1
    scroll.BorderSizePixel = 0
    scroll.ScrollBarThickness = 3

    local listLayout = Instance.new("UIListLayout", scroll)
    listLayout.Padding = UDim.new(0, 4)
    listLayout.SortOrder = Enum.SortOrder.LayoutOrder

    local function refreshList()
        for _, child in ipairs(scroll:GetChildren()) do
            if child:IsA("TextButton") then child:Destroy() end
        end
        local totalHeight = 0
        for _, target in ipairs(NewPlayers:GetPlayers()) do
            if target ~= NewPlayer then
                local btn = Instance.new("TextButton")
                btn.Size = UDim2.new(1, -4, 0, 30)
                btn.BackgroundColor3 = Color3.fromRGB(40, 40, 45)
                btn.TextColor3 = Color3.fromRGB(255, 255, 255)
                btn.Text = target.Name
                btn.TextSize = 13
                btn.Font = Enum.Font.Gotham
                btn.Parent = scroll
                Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 4)

                btn.Activated:Connect(function()
                    pcall(function() grabSpecificPlayer(target) end)
                    listFrame.Visible = false
                    mainBtn.Text = "瞬抓玩家 ▶"
                end)
                totalHeight += 34
            end
        end
        scroll.CanvasSize = UDim2.new(0, 0, 0, totalHeight)
    end

    mainBtn.Activated:Connect(function()
        if listFrame.Visible then
            listFrame.Visible = false
            mainBtn.Text = "瞬抓玩家 ▶"
        else
            refreshList()
            listFrame.Visible = true
            mainBtn.Text = "瞬抓玩家 ▼"
        end
    end)

    local UIS = game:GetService("UserInputService")
    local drag, startInput, startPos, moved = false, nil, nil, false

    mainBtn.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            drag, moved, startInput, startPos = true, false, input.Position, mainBtn.Position
        end
    end)
    mainBtn.InputEnded:Connect(function() drag = false end)
    UIS.InputChanged:Connect(function(input)
        if drag and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
            local delta = input.Position - startInput
            if math.abs(delta.X) > 5 or math.abs(delta.Y) > 5 then moved = true end
            if moved then
                mainBtn.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
                listFrame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X + 10, startPos.Y.Scale, startPos.Y.Offset + delta.Y + 50)
            end
        end
    end)

    TabFunction:Toggle({
        Title = "显示选择抓取按钮",
        Desc = "开启后在屏幕上加载选人瞬抓的小工具",
        Value = false,
        Callback = function(v)
            gui.Enabled = v
            if not v then
                listFrame.Visible = false
                mainBtn.Text = "瞬抓玩家 ▶"
            end
        end
    })
end


return Fly
