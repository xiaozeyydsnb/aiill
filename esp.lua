local ESP = {}

ESPSection = TabCommon:Section({ Title = "ESP透视", Opened = false })  -- 默认折叠

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local Workspace = game:GetService("Workspace")
local Camera = workspace.CurrentCamera
local LocalPlayer = Players.LocalPlayer

local espEnabled = false
local showBox = false
local showSkeleton = false
local showHealth = false
local showDistance = false
local teamCheck = false
local maxDistance = 1000
local npcEsp = false

local colors = {
    box = Color3.fromRGB(255,255,255),
    skeleton = Color3.fromRGB(0,255,255),
    healthBar = Color3.fromRGB(0,255,0),
    healthText = Color3.fromRGB(255,255,255),
    distance = Color3.fromRGB(255,255,0)
}
local thickness = { box = 1, skeleton = 2 }

local playerEspData = {}
local npcHighlights = {}

local function WorldToViewport(pos)
    if not Camera then return Vector2.new(0,0), false end
    local v, on = Camera:WorldToViewportPoint(pos)
    return Vector2.new(v.X, v.Y), on, v.Z
end

local function CreatePlayerESP(p)
    if playerEspData[p] then return end
    local box = Drawing.new("Square")
    box.Visible = false; box.Color = colors.box; box.Thickness = thickness.box; box.Filled = false
    local skeleton = {}
    for i=1,15 do skeleton[i]=Drawing.new("Line"); skeleton[i].Visible=false; skeleton[i].Color=colors.skeleton; skeleton[i].Thickness=thickness.skeleton end
    local hBar = Drawing.new("Square"); hBar.Visible=false; hBar.Color=colors.healthBar; hBar.Thickness=1; hBar.Filled=true
    local hBg = Drawing.new("Square"); hBg.Visible=false; hBg.Color=Color3.new(0,0,0); hBg.Transparency=0.5; hBg.Thickness=1; hBg.Filled=true
    local hBorder = Drawing.new("Square"); hBorder.Visible=false; hBorder.Color=Color3.new(1,1,1); hBorder.Thickness=1; hBorder.Filled=false
    local hText = Drawing.new("Text"); hText.Visible=false; hText.Color=colors.healthText; hText.Size=14; hText.Font=Drawing.Fonts.Monospace; hText.Outline=true; hText.OutlineColor=Color3.new(0,0,0)
    local distText = Drawing.new("Text"); distText.Visible=false; distText.Color=colors.distance; distText.Size=14; distText.Font=Drawing.Fonts.Monospace; distText.Outline=true; distText.OutlineColor=Color3.new(0,0,0)
    playerEspData[p] = {box=box, skeleton=skeleton, hBar=hBar, hBg=hBg, hBorder=hBorder, hText=hText, distText=distText}
end

local function RemovePlayerESP(p)
    local d = playerEspData[p]
    if d then
        d.box:Remove(); d.hBar:Remove(); d.hBg:Remove(); d.hBorder:Remove(); d.hText:Remove(); d.distText:Remove()
        for _,l in ipairs(d.skeleton) do l:Remove() end
        playerEspData[p]=nil
    end
end

local function UpdatePlayerESP(p)
    local d = playerEspData[p]
    if not d then return end
    if not espEnabled then
        d.box.Visible=false; d.hBar.Visible=false; d.hBg.Visible=false; d.hBorder.Visible=false; d.hText.Visible=false; d.distText.Visible=false
        for _,l in ipairs(d.skeleton) do l.Visible=false end
        return
    end
    local c = p.Character
    if not c or not c.Parent then return end
    local r, hum = c:FindFirstChild("HumanoidRootPart"), c:FindFirstChildOfClass("Humanoid")
    if not r or not hum or hum.Health<=0 then
        d.box.Visible=false; d.hBar.Visible=false; d.hBg.Visible=false; d.hBorder.Visible=false; d.hText.Visible=false; d.distText.Visible=false
        for _,l in ipairs(d.skeleton) do l.Visible=false end
        return
    end
    if teamCheck and p.Team==LocalPlayer.Team then
        d.box.Visible=false; d.hBar.Visible=false; d.hBg.Visible=false; d.hBorder.Visible=false; d.hText.Visible=false; d.distText.Visible=false
        for _,l in ipairs(d.skeleton) do l.Visible=false end
        return
    end
    local dist = (r.Position - Camera.CFrame.Position).Magnitude
    if dist > maxDistance then
        d.box.Visible=false; d.hBar.Visible=false; d.hBg.Visible=false; d.hBorder.Visible=false; d.hText.Visible=false; d.distText.Visible=false
        for _,l in ipairs(d.skeleton) do l.Visible=false end
        return
    end
    local head = c:FindFirstChild("Head")
    local headPos = head and head.Position or (r.Position+Vector3.new(0,2,0))
    local footPos = r.Position - Vector3.new(0,3,0)
    local hScr, hOn = WorldToViewport(headPos)
    local fScr, fOn = WorldToViewport(footPos)
    if not hOn and not fOn then
        d.box.Visible=false; d.hBar.Visible=false; d.hBg.Visible=false; d.hBorder.Visible=false; d.hText.Visible=false; d.distText.Visible=false
        for _,l in ipairs(d.skeleton) do l.Visible=false end
        return
    end
    local height = fScr.Y - hScr.Y
    local width = height * 0.6
    local boxPos = Vector2.new(hScr.X - width/2, hScr.Y)
    if showBox then d.box.Size=Vector2.new(width,height); d.box.Position=boxPos; d.box.Visible=true else d.box.Visible=false end
    if showHealth then
        local pct = hum.Health/hum.MaxHealth
        local bw, bh = 50, 5
        local bx = hScr.X - bw/2
        local by = hScr.Y - 10
        d.hBg.Size=Vector2.new(bw,bh); d.hBg.Position=Vector2.new(bx,by); d.hBg.Visible=true
        d.hBorder.Size=Vector2.new(bw,bh); d.hBorder.Position=Vector2.new(bx,by); d.hBorder.Visible=true
        d.hBar.Size=Vector2.new(bw*pct,bh); d.hBar.Position=Vector2.new(bx,by)
        if pct>=0.8 then d.hBar.Color=Color3.new(0,1,0) elseif pct>=0.5 then d.hBar.Color=Color3.new(1,1,0) elseif pct>=0.2 then d.hBar.Color=Color3.new(1,0.5,0) else d.hBar.Color=Color3.new(1,0,0) end
        d.hBar.Visible=true
        d.hText.Position=Vector2.new(bx+bw+5, by-5); d.hText.Text=math.floor(hum.Health).."/"..math.floor(hum.MaxHealth); d.hText.Visible=true
    else d.hBar.Visible=false; d.hBg.Visible=false; d.hBorder.Visible=false; d.hText.Visible=false end
    if showDistance then d.distText.Position=Vector2.new(hScr.X, hScr.Y+10); d.distText.Text=math.floor(dist).."m"; d.distText.Visible=true else d.distText.Visible=false end
    if showSkeleton then
        local torso = c:FindFirstChild("UpperTorso") or c:FindFirstChild("Torso")
        local leftArm = c:FindFirstChild("LeftUpperArm") or c:FindFirstChild("Left Arm")
        local rightArm = c:FindFirstChild("RightUpperArm") or c:FindFirstChild("Right Arm")
        local leftLeg = c:FindFirstChild("LeftUpperLeg") or c:FindFirstChild("Left Leg")
        local rightLeg = c:FindFirstChild("RightUpperLeg") or c:FindFirstChild("Right Leg")
        if head and torso then
            local hs, hon = WorldToViewport(head.Position)
            local ts, ton = WorldToViewport(torso.Position)
            if hon and ton then d.skeleton[1].From=hs; d.skeleton[1].To=ts; d.skeleton[1].Visible=true else d.skeleton[1].Visible=false end
            if leftArm then local las, laon = WorldToViewport(leftArm.Position); if laon then d.skeleton[2].From=ts; d.skeleton[2].To=las; d.skeleton[2].Visible=true else d.skeleton[2].Visible=false end end
            if rightArm then local ras, raon = WorldToViewport(rightArm.Position); if raon then d.skeleton[3].From=ts; d.skeleton[3].To=ras; d.skeleton[3].Visible=true else d.skeleton[3].Visible=false end end
            if leftLeg then local lls, llon = WorldToViewport(leftLeg.Position); if llon then d.skeleton[4].From=ts; d.skeleton[4].To=lls; d.skeleton[4].Visible=true else d.skeleton[4].Visible=false end end
            if rightLeg then local rls, rlon = WorldToViewport(rightLeg.Position); if rlon then d.skeleton[5].From=ts; d.skeleton[5].To=rls; d.skeleton[5].Visible=true else d.skeleton[5].Visible=false end end
        end
        for i=6,15 do d.skeleton[i].Visible=false end
    else for _,l in ipairs(d.skeleton) do l.Visible=false end end
end

local function AddNPCESP(model)
    if npcHighlights[model] then return end
    if not npcEsp or not espEnabled then return end
    local hl = Instance.new("Highlight")
    hl.FillColor = Color3.fromRGB(255,100,0); hl.OutlineColor = Color3.fromRGB(255,255,0); hl.FillTransparency=0.5; hl.Parent=model
    local part = model:FindFirstChild("Head") or model:FindFirstChild("HumanoidRootPart") or model.PrimaryPart or model:FindFirstChildWhichIsA("BasePart")
    local bb = nil
    if part then
        bb = Instance.new("BillboardGui"); bb.Adornee=part; bb.Size=UDim2.new(0,200,0,40); bb.StudsOffset=Vector3.new(0,3,0); bb.AlwaysOnTop=true; bb.Parent=part
        local lbl = Instance.new("TextLabel"); lbl.Size=UDim2.new(1,0,1,0); lbl.BackgroundTransparency=1; lbl.Text=model.Name; lbl.TextColor3=Color3.fromRGB(255,255,0); lbl.TextScaled=true; lbl.Font=Enum.Font.GothamBold; lbl.Parent=bb
    end
    npcHighlights[model] = {hl=hl, bb=bb}
end

local function RemoveNPCESP(model)
    local d = npcHighlights[model]
    if d then if d.hl then d.hl:Destroy() end; if d.bb then d.bb:Destroy() end; npcHighlights[model]=nil end
end

local function ScanNPCs()
    if not npcEsp or not espEnabled then
        for m,_ in pairs(npcHighlights) do RemoveNPCESP(m) end
        return
    end
    local keywords = {"NPC","Monster","Enemy","Animal","Zombie","Ghost","SCP","Figure","Rush","Seek","Entity","Cultist","Wolf","Deer","Bear"}
    for _,obj in ipairs(Workspace:GetDescendants()) do
        if obj:IsA("Model") and (obj:FindFirstChildOfClass("Humanoid") and not Players:GetPlayerFromCharacter(obj)) then
            if not npcHighlights[obj] then AddNPCESP(obj) end
        else
            local isKeyword = false
            for _,kw in ipairs(keywords) do if obj.Name:find(kw) then isKeyword=true; break end end
            if isKeyword and obj:IsA("Model") then if not npcHighlights[obj] then AddNPCESP(obj) end
            elseif npcHighlights[obj] then RemoveNPCESP(obj) end
        end
    end
    for m,_ in pairs(npcHighlights) do if not m.Parent then RemoveNPCESP(m) end end
end

local renderConn = nil
local function StartLoop()
    if renderConn then renderConn:Disconnect() end
    renderConn = RunService.RenderStepped:Connect(function()
        for _,p in ipairs(Players:GetPlayers()) do
            if p ~= LocalPlayer then
                -- 确保ESP对象存在
                if not playerEspData[p] then CreatePlayerESP(p) end
                UpdatePlayerESP(p)
            end
        end
        ScanNPCs()
    end)
end
local function StopLoop()
    if renderConn then renderConn:Disconnect(); renderConn=nil end
    for p,_ in pairs(playerEspData) do RemovePlayerESP(p) end
    for m,_ in pairs(npcHighlights) do RemoveNPCESP(m) end
end

ESPSection:Toggle({ Title = "整体透视开关", Value = false, Callback = function(v) espEnabled=v; if v then StartLoop() else StopLoop() end end })
ESPSection:Toggle({ Title = "方框透视", Value = false, Callback = function(v) showBox=v end })
ESPSection:Toggle({ Title = "骨骼透视", Value = false, Callback = function(v) showSkeleton=v end })
ESPSection:Toggle({ Title = "血量显示", Value = false, Callback = function(v) showHealth=v end })
ESPSection:Toggle({ Title = "距离显示", Value = false, Callback = function(v) showDistance=v end })
ESPSection:Toggle({ Title = "队伍检测", Value = false, Callback = function(v) teamCheck=v end })
ESPSection:Toggle({ Title = "NPC透视", Value = false, Callback = function(v) npcEsp=v; if v and espEnabled then ScanNPCs() elseif not v then for m,_ in pairs(npcHighlights) do RemoveNPCESP(m) end end end })
ESPSection:Slider({ Title = "最大距离", Value = { Min = 100, Max = 5000, Default = 1000 }, Callback = function(v) maxDistance=v end })

-- 初始化现有玩家
for _,p in ipairs(Players:GetPlayers()) do if p~=LocalPlayer then CreatePlayerESP(p) end end
Players.PlayerAdded:Connect(function(p) if p~=LocalPlayer then CreatePlayerESP(p) end end)
Players.PlayerRemoving:Connect(RemovePlayerESP)

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
                speaker.Character.Humanoid:SetStateEnabled(Enum.HumanoidStateType.

return ESP
