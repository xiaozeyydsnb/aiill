local ESP = {}

-- ==================== 小泽 ESP 透视（独立GUI） ====================
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UIS = game:GetService("UserInputService")
local Camera = workspace.CurrentCamera
local LP = Players.LocalPlayer

local Settings = {
    Enabled = false,
    Box = false,
    Name = false,
    Health = false,
    Distance = false,
    Tracer = false,
    NPC = false,
    TeamCheck = false
}

local Gui = Instance.new("ScreenGui")
pcall(function() Gui.Parent = game.CoreGui end)
Gui.ResetOnSpawn = false

local Main = Instance.new("Frame")
Main.Parent = Gui
Main.Size = UDim2.new(0,190,0,35)
Main.Position = UDim2.new(0,20,0.35,0)
Main.BackgroundColor3 = Color3.fromRGB(18,18,18)
Main.BorderSizePixel = 0
Instance.new("UICorner",Main)

local Title = Instance.new("TextLabel")
Title.Parent = Main
Title.Size = UDim2.new(1,0,0,35)
Title.BackgroundTransparency = 1
Title.Text = "小泽 ESP"
Title.Font = Enum.Font.SourceSansBold
Title.TextSize = 22
Title.TextColor3 = Color3.new(1,1,1)

local OpenButton = Instance.new("TextButton")
OpenButton.Parent = Main
OpenButton.Size = UDim2.new(0,30,0,30)
OpenButton.Position = UDim2.new(1,-35,0,2)
OpenButton.Text = "+"
OpenButton.TextColor3 = Color3.new(1,1,1)
OpenButton.BackgroundColor3 = Color3.fromRGB(30,30,30)
Instance.new("UICorner",OpenButton)

local CountText = Instance.new("TextLabel")
CountText.Parent = Gui
CountText.Size = UDim2.new(0,400,0,30)
CountText.Position = UDim2.new(0.5,-200,0,5)
CountText.BackgroundTransparency = 1
CountText.TextColor3 = Color3.new(1,1,1)
CountText.Font = Enum.Font.SourceSansBold
CountText.TextSize = 23
CountText.Text = ""

local Scroll = Instance.new("ScrollingFrame")
Scroll.Parent = Main
Scroll.Position = UDim2.new(0,0,0,40)
Scroll.Size = UDim2.new(1,0,0,260)
Scroll.CanvasSize = UDim2.new(0,0,0,450)
Scroll.ScrollBarThickness = 3
Scroll.BackgroundTransparency = 1
Scroll.Visible = false

local Layout = Instance.new("UIListLayout")
Layout.Parent = Scroll
Layout.Padding = UDim.new(0,5)

local Open = false
OpenButton.MouseButton1Click:Connect(function()
    Open = not Open
    if Open then
        Main.Size = UDim2.new(0,190,0,305)
        Scroll.Visible = true
        OpenButton.Text = "-"
    else
        Main.Size = UDim2.new(0,190,0,35)
        Scroll.Visible = false
        OpenButton.Text = "+"
    end
end)

local dragging = false
local dragStart
local startPos
Title.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.Touch or input.UserInputType == Enum.UserInputType.MouseButton1 then
        dragging = true
        dragStart = input.Position
        startPos = Main.Position
    end
end)
UIS.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.Touch or input.UserInputType == Enum.UserInputType.MouseButton1 then
        dragging = false
    end
end)
UIS.InputChanged:Connect(function(input)
    if dragging and (input.UserInputType == Enum.UserInputType.Touch or input.UserInputType == Enum.UserInputType.MouseMovement) then
        local delta = input.Position - dragStart
        Main.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
    end
end)

local function CreateToggle(name,flag)
    local Button = Instance.new("TextButton")
    Button.Parent = Scroll
    Button.Size = UDim2.new(1,-8,0,35)
    Button.BackgroundColor3 = Color3.fromRGB(28,28,28)
    Button.TextColor3 = Color3.new(1,1,1)
    Button.Font = Enum.Font.SourceSansBold
    Button.TextSize = 19
    Instance.new("UICorner",Button)
    local function Update()
        Button.Text = name.." : "..(Settings[flag] and "ON" or "OFF")
    end
    Update()
    Button.MouseButton1Click:Connect(function()
        Settings[flag] = not Settings[flag]
        Update()
    end)
end

CreateToggle("总开关","Enabled")
CreateToggle("方框","Box")
CreateToggle("名字","Name")
CreateToggle("血量","Health")
CreateToggle("距离","Distance")
CreateToggle("射线","Tracer")
CreateToggle("NPC透视","NPC")
CreateToggle("队伍检测","TeamCheck")

local ESPCache = {}
local NPCESP = {}

local function CreateDrawings(color)
    local tbl = {}
    local Box = Drawing.new("Square")
    Box.Visible = false; Box.Color = color; Box.Thickness = 1; Box.Filled = false
    local Name = Drawing.new("Text")
    Name.Visible = false; Name.Center = true; Name.Outline = true; Name.Size = 13; Name.Color = Color3.new(1,1,1)
    local Health = Drawing.new("Text")
    Health.Visible = false; Health.Center = true; Health.Outline = true; Health.Size = 13; Health.Color = Color3.fromRGB(0,255,0)
    local Distance = Drawing.new("Text")
    Distance.Visible = false; Distance.Center = true; Distance.Outline = true; Distance.Size = 13; Distance.Color = Color3.fromRGB(255,255,0)
    local Tracer = Drawing.new("Line")
    Tracer.Visible = false; Tracer.Color = Color3.new(1,1,1)
    tbl.Box = Box; tbl.Name = Name; tbl.Health = Health; tbl.Distance = Distance; tbl.Tracer = Tracer
    -- 注意：移除了血量条相关Drawing（hBar, hBg, hBorder）
    return tbl
end

local function Hide(draw)
    for _,v in pairs(draw) do v.Visible = false end
end

for _,v in pairs(Players:GetPlayers()) do
    if v ~= LP then ESPCache[v] = CreateDrawings(Color3.fromRGB(255,0,0)) end
end
Players.PlayerAdded:Connect(function(v)
    if v ~= LP then ESPCache[v] = CreateDrawings(Color3.fromRGB(255,0,0)) end
end)
Players.PlayerRemoving:Connect(function(v)
    if ESPCache[v] then
        for _,x in pairs(ESPCache[v]) do x:Remove() end
        ESPCache[v] = nil
    end
end)

local function UpdateESP(char,draw,name)
    local Hum = char:FindFirstChildOfClass("Humanoid")
    local HRP = char:FindFirstChild("HumanoidRootPart")
    local Head = char:FindFirstChild("Head")
    if not Hum or not HRP or not Head or Hum.Health <= 0 or not char.Parent or not HRP:IsDescendantOf(workspace) then
        Hide(draw)
        return false
    end
    local RootPos,Visible = Camera:WorldToViewportPoint(HRP.Position)
    if RootPos.Z <= 0 then
        Hide(draw)
        return false
    end
    local HeadPos = Camera:WorldToViewportPoint(Head.Position + Vector3.new(0,0.5,0))
    local LegPos = Camera:WorldToViewportPoint(HRP.Position - Vector3.new(0,3,0))
    local Height = math.abs(HeadPos.Y - LegPos.Y)
    local Width = Height / 2
    local X = RootPos.X - Width / 2
    local Y = RootPos.Y - Height / 2

    draw.Box.Size = Vector2.new(Width,Height)
    draw.Box.Position = Vector2.new(X,Y)
    draw.Box.Visible = Settings.Box

    draw.Name.Text = name
    draw.Name.Position = Vector2.new(RootPos.X, Y - 15)
    draw.Name.Visible = Settings.Name

    draw.Health.Text = "HP : "..math.floor(Hum.Health)
    draw.Health.Position = Vector2.new(RootPos.X, Y + Height + 2)
    draw.Health.Visible = Settings.Health

    -- 距离显示位置移到方框上方（原来在底部下方）
    if LP.Character and LP.Character:FindFirstChild("HumanoidRootPart") then
        local Dist = math.floor((LP.Character.HumanoidRootPart.Position - HRP.Position).Magnitude)
        draw.Distance.Text = Dist.."M"
        draw.Distance.Position = Vector2.new(RootPos.X, Y - 30)   -- 原来：Y + Height + 16
        draw.Distance.Visible = Settings.Distance
    end

    draw.Tracer.From = Vector2.new(Camera.ViewportSize.X/2, Camera.ViewportSize.Y)
    draw.Tracer.To = Vector2.new(RootPos.X, Y + Height)
    draw.Tracer.Visible = Settings.Tracer

    return true
end

RunService.RenderStepped:Connect(function()
    local PlayerCount = 0
    local NPCCount = 0

    if not Settings.Enabled then
        for _,v in pairs(ESPCache) do Hide(v) end
        for _,v in pairs(NPCESP) do Hide(v) end
        CountText.Text = ""
        return
    end

    for Player,Draw in pairs(ESPCache) do
        local Char = Player.Character
        if Char then
            if Settings.TeamCheck and Player.Team == LP.Team then
                Hide(Draw)
            else
                if UpdateESP(Char, Draw, Player.Name) then
                    PlayerCount = PlayerCount + 1
                end
            end
        else
            Hide(Draw)
        end
    end

    if Settings.NPC then
        for _,NPC in pairs(workspace:GetChildren()) do
            if NPC:IsA("Model") and NPC ~= LP.Character and not Players:GetPlayerFromCharacter(NPC) then
                local Hum = NPC:FindFirstChildOfClass("Humanoid")
                local HRP = NPC:FindFirstChild("HumanoidRootPart")
                local Head = NPC:FindFirstChild("Head")
                if Hum and HRP and Head and Hum.Health > 0 and NPC.Parent and HRP:IsDescendantOf(workspace) then
                    if not NPCESP[NPC] then
                        NPCESP[NPC] = CreateDrawings(Color3.fromRGB(255,170,0))
                    end
                    if UpdateESP(NPC, NPCESP[NPC], NPC.Name) then
                        NPCCount = NPCCount + 1
                    end
                else
                    if NPCESP[NPC] then Hide(NPCESP[NPC]) end
                end
            end
        end
    else
        for _,v in pairs(NPCESP) do Hide(v) end
    end

    CountText.Text = "真人: "..PlayerCount.." | NPC: "..NPCCount
end)

-- ==================== 保留原 esp.lua 中的其他功能 ====================
-- 飞行助手
TabCommon:Button({
    Title = "飞行助手",
    Callback = function()
        if game.Players.LocalPlayer.PlayerGui:FindFirstChild("main") then
            game.Players.LocalPlayer.PlayerGui.main:Destroy()
        end
        
        local main = Instance.new("ScreenGui")
        local Frame = Instance.new("Frame")
        local up = Instance.new("TextButton")
        local down = Instance.new("TextButton")
        local onof = Instance.new("TextButton")
        local TextLabel = Instance.new("TextLabel")
        local plus = Instance.new("TextButton")
        local speed = Instance.new("TextLabel")
        local mine = Instance.new("TextButton")
        local closebutton = Instance.new("TextButton")
        local mini = Instance.new("TextButton")
        local mini2 = Instance.new("TextButton")

        main.Name = "main"
        main.Parent = game.Players.LocalPlayer:WaitForChild("PlayerGui")
        main.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
        main.ResetOnSpawn = false

        Frame.Parent = main
        Frame.BackgroundColor3 = Color3.fromRGB(163, 255, 137)
        Frame.BorderColor3 = Color3.fromRGB(103, 221, 213)
        Frame.Position = UDim2.new(0.100320168, 0, 0.379746825, 0)
        Frame.Size = UDim2.new(0, 190, 0, 57)

        up.Name = "上"
        up.Parent = Frame
        up.BackgroundColor3 = Color3.fromRGB(79, 255, 152)
        up.Size = UDim2.new(0, 44, 0, 28)
        up.Font = Enum.Font.SourceSans
        up.Text = "上"
        up.TextColor3 = Color3.fromRGB(0, 0, 0)
        up.TextSize = 14

        down.Name = "下"
        down.Parent = Frame
        down.BackgroundColor3 = Color3.fromRGB(215, 255, 121)
        down.Position = UDim2.new(0, 0, 0.491228074, 0)
        down.Size = UDim2.new(0, 44, 0, 28)
        down.Font = Enum.Font.SourceSans
        down.Text = "下"
        down.TextColor3 = Color3.fromRGB(0, 0, 0)
        down.TextSize = 14

        onof.Name = "onof"
        onof.Parent = Frame
        onof.BackgroundColor3 = Color3.fromRGB(255, 249, 74)
        onof.Position = UDim2.new(0.702823281, 0, 0.491228074, 0)
        onof.Size = UDim2.new(0, 56, 0, 28)
        onof.Font = Enum.Font.SourceSans
        onof.Text = "飞"
        onof.TextColor3 = Color3.fromRGB(0, 0, 0)
        onof.TextSize = 14

        TextLabel.Parent = Frame
        TextLabel.BackgroundColor3 = Color3.fromRGB(242, 60, 255)
        TextLabel.Position = UDim2.new(0.469327301, 0, 0, 0)
        TextLabel.Size = UDim2.new(0, 100, 0, 28)
        TextLabel.Font = Enum.Font.SourceSans
        TextLabel.Text = "小泽汉化"
        TextLabel.TextColor3 = Color3.fromRGB(0, 0, 0)
        TextLabel.TextScaled = true
        TextLabel.TextWrapped = true

        plus.Name = "plus"
        plus.Parent = Frame
        plus.BackgroundColor3 = Color3.fromRGB(133, 145, 255)
        plus.Position = UDim2.new(0.231578946, 0, 0, 0)
        plus.Size = UDim2.new(0, 45, 0, 28)
        plus.Font = Enum.Font.SourceSans
        plus.Text = "加速"
        plus.TextColor3 = Color3.fromRGB(0, 0, 0)
        plus.TextScaled = true
        plus.TextSize = 14
        plus.TextWrapped = true

        speed.Name = "speed"
        speed.Parent = Frame
        speed.BackgroundColor3 = Color3.fromRGB(255, 85, 0)
        speed.Position = UDim2.new(0.468421042, 0, 0.491228074, 0)
        speed.Size = UDim2.new(0, 44, 0, 28)
        speed.Font = Enum.Font.SourceSans
        speed.Text = "1"
        speed.TextColor3 = Color3.fromRGB(0, 0, 0)
        speed.TextScaled = true
        speed.TextWrapped = true

        mine.Name = "mine"
        mine.Parent = Frame
        mine.BackgroundColor3 = Color3.fromRGB(123, 255, 247)
        mine.Position = UDim2.new(0.231578946, 0, 0.491228074, 0)
        mine.Size = UDim2.new(0, 45, 0, 29)
        mine.Font = Enum.Font.SourceSans
        mine.Text = "减速"
        mine.TextColor3 = Color3.fromRGB(0, 0, 0)
        mine.TextScaled = true
        mine.TextSize = 14
        mine.TextWrapped = true

        closebutton.Name = "Close"
        closebutton.Parent = main.Frame
        closebutton.BackgroundColor3 = Color3.fromRGB(225, 25, 0)
        closebutton.Font = "SourceSans"
        closebutton.Size = UDim2.new(0, 45, 0, 28)
        closebutton.Text = "关闭"
        closebutton.TextSize = 30
        closebutton.Position = UDim2.new(0, 0, -1, 27)

        mini.Name = "minimize"
        mini.Parent = main.Frame
        mini.BackgroundColor3 = Color3.fromRGB(192, 150, 230)
        mini.Font = "SourceSans"
        mini.Size = UDim2.new(0, 45, 0, 28)
        mini.Text = "收起"
        mini.TextSize = 30
        mini.Position = UDim2.new(0, 44, -1, 27)

        mini2.Name = "minimize2"
        mini2.Parent = main.Frame
        mini2.BackgroundColor3 = Color3.fromRGB(192, 150, 230)
        mini2.Font = "SourceSans"
        mini2.Size = UDim2.new(0, 45, 0, 28)
        mini2.Text = "收起"
        mini2.TextSize = 30
        mini2.Position = UDim2.new(0, 44, -1, 57)
        mini2.Visible = false

        speeds = 1
        local speaker = game:GetService("Players").LocalPlayer
        local chr = game.Players.LocalPlayer.Character
        local hum = chr and chr:FindFirstChildWhichIsA("Humanoid")
        nowe = false

        game:GetService("StarterGui"):SetCore("SendNotification", {
            Title = "小泽汉化",
            Text = "汉化飞行🤤🤓",
            Icon = "rbxthumb://type=Asset&id=123135436684871&w=150&h=150"
        })

        Frame.Active = true
        Frame.Draggable = true

        onof.MouseButton1Down:connect(function()
            if nowe == true then
                nowe = false
                speaker.Character.Humanoid:SetStateEnabled(Enum.HumanoidStateType.Climbing,true)
                speaker.Character.Humanoid:SetStateEnabled(Enum.HumanoidStateType.FallingDown,true)
                speaker.Character.Humanoid:SetStateEnabled(Enum.HumanoidStateType.Flying,true)
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

-- 锁定朝向
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

-- 传送模式
TabCommon:Button({
    Title = "传送模式",
    Callback = function()
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

-- 夜视
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

-- 无限跳
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

-- 穿墙
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

-- 防挂机
local afkRunning = false
local afkThread = nil
local function getValidCharacter()
    local char = game.Players.LocalPlayer.Character
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
            pcall(function() Notify("防挂机", "已开启", 2, "success") end)
        else
            stopAFK()
            pcall(function() Notify("防挂机", "已关闭", 2, "info") end)
        end
    end
})

return ESP
