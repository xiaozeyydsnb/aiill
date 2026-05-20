local Main = {}

local Players = game:GetService("Players")
local StarterGui = game:GetService("StarterGui")

local WINDUI_URL = "https://raw.githubusercontent.com/ylt410/roblox-Script/refs/heads/main/UI库"

-- 防止你窗口热键/浮窗开关变量没定义，然后 Lua 又开始装死
local PCWindowToggleKey = PCWindowToggleKey or Enum.KeyCode.RightControl
local InitialOpenButtonEnabled = (InitialOpenButtonEnabled ~= false)

-- 等游戏基础加载，避免 SetCore 太早调用失败
if not game:IsLoaded() then
    pcall(function()
        game.Loaded:Wait()
    end)
end

-- =================== 启动声明弹窗开始 ===================
local CoreGui = game:GetService("CoreGui")
local QQGroupNumber = "1082030508" -- ⚠️请把这里的数字换成你真实的QQ群号！

local IntroGui = Instance.new("ScreenGui")
IntroGui.Name = "ZeScriptIntroGui"
IntroGui.ResetOnSpawn = false

-- 兼容性处理：优先放 CoreGui 防死亡消失，不行就放 PlayerGui
local success = pcall(function() IntroGui.Parent = CoreGui end)
if not success then 
    IntroGui.Parent = game:GetService("Players").LocalPlayer:WaitForChild("PlayerGui") 
end

local MainFrame = Instance.new("Frame", IntroGui)
MainFrame.Size = UDim2.new(0, 380, 0, 200)
MainFrame.Position = UDim2.new(0.5, -190, 0.5, -100)
MainFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 35)
MainFrame.BorderSizePixel = 0
Instance.new("UICorner", MainFrame).CornerRadius = UDim.new(0, 12)

-- 添加个微微的边框发光效果
local Stroke = Instance.new("UIStroke", MainFrame)
Stroke.Color = Color3.fromRGB(0, 200, 255)
Stroke.Thickness = 2
Stroke.Transparency = 0.5

-- 标题
local Title = Instance.new("TextLabel", MainFrame)
Title.Size = UDim2.new(1, 0, 0, 40)
Title.BackgroundTransparency = 1
Title.Text = "✨ 泽脚本 - 启动声明"
Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Title.Font = Enum.Font.GothamBold
Title.TextSize = 18

-- 内容文本
local Content = Instance.new("TextLabel", MainFrame)
Content.Size = UDim2.new(1, -40, 0, 80)
Content.Position = UDim2.new(0, 20, 0, 45)
Content.BackgroundTransparency = 1
Content.Text = "本脚本一直都是免费的 喜欢就用 不喜欢就不用\n（本脚本随便开源破解 试着玩的）"
Content.TextColor3 = Color3.fromRGB(220, 220, 220)
Content.Font = Enum.Font.Gotham
Content.TextSize = 15
Content.TextWrapped = true

-- 复制群号按钮
local CopyBtn = Instance.new("TextButton", MainFrame)
CopyBtn.Size = UDim2.new(0, 130, 0, 38)
CopyBtn.Position = UDim2.new(0, 40, 1, -60)
CopyBtn.BackgroundColor3 = Color3.fromRGB(70, 130, 220)
CopyBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
CopyBtn.Text = "📋 复制QQ群号"
CopyBtn.Font = Enum.Font.GothamBold
CopyBtn.TextSize = 14
Instance.new("UICorner", CopyBtn).CornerRadius = UDim.new(0, 8)

-- 进入脚本按钮
local EnterBtn = Instance.new("TextButton", MainFrame)
EnterBtn.Size = UDim2.new(0, 130, 0, 38)
EnterBtn.Position = UDim2.new(1, -170, 1, -60)
EnterBtn.BackgroundColor3 = Color3.fromRGB(60, 200, 100)
EnterBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
EnterBtn.Text = "✅ 确认并进入"
EnterBtn.Font = Enum.Font.GothamBold
EnterBtn.TextSize = 14
Instance.new("UICorner", EnterBtn).CornerRadius = UDim.new(0, 8)

-- 复制按钮点击事件
CopyBtn.MouseButton1Click:Connect(function()
    if setclipboard then
        setclipboard(QQGroupNumber)
        CopyBtn.Text = "复制成功！"
        CopyBtn.BackgroundColor3 = Color3.fromRGB(100, 200, 100)
        task.wait(1.5)
        CopyBtn.Text = "📋 复制QQ群号"
        CopyBtn.BackgroundColor3 = Color3.fromRGB(70, 130, 220)
    else
        CopyBtn.Text = "注入器不支持复制"
        CopyBtn.BackgroundColor3 = Color3.fromRGB(220, 80, 80)
        task.wait(1.5)
        CopyBtn.Text = "📋 复制QQ群号"
        CopyBtn.BackgroundColor3 = Color3.fromRGB(70, 130, 220)
    end
end)

-- 阻断执行变量
local isWaiting = true

-- 确认按钮点击事件
EnterBtn.MouseButton1Click:Connect(function()
    IntroGui:Destroy()
    isWaiting = false
end)

-- 核心：卡住脚本，不让后面的 UI库 加载，直到玩家点击确认
repeat task.wait(0.1) until not isWaiting
-- =================== 启动声明弹窗结束 ===================


-- 更稳的通知函数：SetCore 失败会重试，不再静默消失
local function FallbackNotify(title, content, duration)
    title = tostring(title or "通知")
    content = tostring(content or "")
    duration = duration or 4

    task.spawn(function()
        for _ = 1, 30 do
            local ok = pcall(function()
                StarterGui:SetCore("SendNotification", {
                    Title = title,
                    Text = content,
                    Duration = duration
                })
            end)

            if ok then
                return
            end

            task.wait(0.2)
        end

        warn("[通知失败] " .. title .. " | " .. content)
    end)
end

-- 给任意函数加超时
local function RunWithTimeout(name, timeout, callback)
    local finished = false
    local success = false
    local result = nil
    local err = nil

    task.spawn(function()
        local ok, res = pcall(callback)

        success = ok

        if ok then
            result = res
        else
            err = res
        end

        finished = true
    end)

    local startTime = os.clock()

    while not finished and os.clock() - startTime < timeout do
        task.wait(0.05)
    end

    if not finished then
        return false, nil, tostring(name) .. "超时"
    end

    if not success then
        return false, nil, tostring(err)
    end

    return true, result, nil
end

-- 安全编译 loadstring
local function CompileScript(content)
    local ok, fnOrErr = pcall(function()
        return loadstring(content)
    end)

    if not ok then
        return false, nil, "loadstring 编译异常：" .. tostring(fnOrErr)
    end

    if type(fnOrErr) ~= "function" then
        return false, nil, "loadstring 没有返回函数"
    end

    return true, fnOrErr, nil
end

-- WindUI 加载函数：HttpGet 和执行阶段都带超时
local function tryLoadWindUI(retries, httpTimeout, executeTimeout)
    retries = retries or 5
    httpTimeout = httpTimeout or 7
    executeTimeout = executeTimeout or 7

    local lastErr = "未知错误"

    for i = 1, retries do
        print("[WindUI] 加载尝试 #" .. i)

        FallbackNotify(
            "加载中",
            "正在加载 UI库，第 " .. i .. "/" .. retries .. " 次",
            2
        )

        -- 加时间戳，避免部分环境缓存旧内容
        local requestUrl = WINDUI_URL .. "?t=" .. tostring(math.floor(os.clock() * 100000)) .. "_" .. tostring(i)

        local getOk, content, getErr = RunWithTimeout("HttpGet", httpTimeout, function()
            return game:HttpGet(requestUrl)
        end)

        if not getOk then
            lastErr = getErr
        elseif type(content) ~= "string" or #content < 10 then
            lastErr = "HttpGet 返回内容为空或异常"
        else
            local compileOk, compiledFunc, compileErr = CompileScript(content)

            if not compileOk then
                lastErr = compileErr
            else
                local runOk, lib, runErr = RunWithTimeout("UI库执行", executeTimeout, function()
                    return compiledFunc()
                end)

                if runOk and lib then
                    return lib, nil
                end

                lastErr = runErr or "UI库执行完成，但没有返回库对象"
            end
        end

        warn("[WindUI] 第 " .. i .. " 次加载失败：" .. tostring(lastErr))

        FallbackNotify(
            "加载重试",
            "UI库第 " .. i .. " 次加载失败：" .. tostring(lastErr),
            3
        )

        task.wait(math.min(1 + i * 0.2, 2))
    end

    return nil, lastErr
end

-- 注入提示
FallbackNotify("泽脚本", "基础脚本已加载，正在加载 UI库", 3)
FallbackNotify("加载中", "开始载入 UI，网络差会自动重试", 3)

-- 启动加载
local WindUI, loadErr = tryLoadWindUI(5, 7, 7)

-- 加载失败处理
if not WindUI then
    FallbackNotify(
        "加载失败",
        "UI库加载失败，请更换网络或重新注入\n错误：" .. tostring(loadErr),
        10
    )

    warn("[WindUI] 最终加载失败：" .. tostring(loadErr))
    return
end

-- 成功提示
FallbackNotify("加载成功", "WindUI 已加载，脚本继续执行", 3)

print("[WindUI] 加载成功")

-- =================== 背景图预设 ===================
local BgPresets = {
    ["蓝色系少女"] = "https://raw.githubusercontent.com/ylt410/Liquid-glass-script/refs/heads/main/E7B068E4-0859-420F-A6B1-AF519C804C39.png",
    ["粉色系少女"] = "https://raw.githubusercontent.com/ylt410/Liquid-glass-script/refs/heads/main/A19A17E7-7AF5-4E1D-998B-DA69A7C0CD77.png",
    ["蓝色系猫娘"] = "https://raw.githubusercontent.com/ylt410/Liquid-glass-script/refs/heads/main/FB28370F-CEA8-4CC6-A6E0-51B7DF9071D3.png",
    ["彩蛋"] = "https://raw.githubusercontent.com/ylt410/Liquid-glass-script/refs/heads/main/IMG_3671.jpeg",
    ["紫色系御姐"] = "https://raw.githubusercontent.com/ylt410/Liquid-glass-script/refs/heads/main/F99AB9B7-A68C-4EC1-8D39-BAB06FDA5F0D.png",
    ["蓝色系少女2"] = "https://raw.githubusercontent.com/ylt410/Liquid-glass-script/refs/heads/main/IMG_3672.jpeg",
    ["你懂的"] = "https://raw.githubusercontent.com/ylt410/Liquid-glass-script/refs/heads/main/IMG_3683.jpeg",
    ["你懂的2"] = "https://raw.githubusercontent.com/ylt410/Liquid-glass-script/refs/heads/main/IMG_3707.jpeg",
    ["你懂的3"] = "https://raw.githubusercontent.com/ylt410/Liquid-glass-script/refs/heads/main/IMG_3706.jpeg",
    ["罪恶王冠楪祈"] = "https://raw.githubusercontent.com/ylt410/Liquid-glass-script/refs/heads/main/IMG_3710.jpeg",
    ["罪恶王冠楪祈2"] = "https://raw.githubusercontent.com/ylt410/Liquid-glass-script/refs/heads/main/IMG_3711.jpeg",
    ["这是鸣潮的吗？"] = "https://raw.githubusercontent.com/ylt410/Liquid-glass-script/refs/heads/main/6FCEE1DA-7DEA-469D-AE17-C52A59AA8FDD.png",
}

local function Notify(title, content, duration, icon)
    pcall(function()
        WindUI:Notify({
            Title = tostring(title or "提示"),
            Content = tostring(content or ""),
            Duration = duration or 3,
            Icon = icon or "info",
        })
    end)
end

-- =================== 背景图配置 ===================
local BgFile = "NightBackground.txt"
local BgPresetFile = "NightBgPreset.txt"
local BgTransFile = "NightBgTrans.txt"
local BackgroundEnabled = true
local BgTransValue = 0.55
local SavedBgPreset = "默认背景"
local BgImage = "https://raw.githubusercontent.com/ylt410/Liquid-glass-script/refs/heads/main/E7B068E4-0859-420F-A6B1-AF519C804C39.png"

pcall(function()
    if isfile and isfile(BgFile) then
        local saved = readfile(BgFile)
        BackgroundEnabled = (saved ~= "false")
    end
end)

pcall(function()
    if isfile and isfile(BgTransFile) then
        local saved = tonumber(readfile(BgTransFile))
        if saved then
            BgTransValue = math.clamp(saved, 0, 1)
        end
    end
end)

pcall(function()
    if isfile and isfile(BgPresetFile) then
        local saved = readfile(BgPresetFile)
        if saved and saved ~= "" then
            SavedBgPreset = saved
        end
    end
end)

if BgPresets[SavedBgPreset] then
    BgImage = BgPresets[SavedBgPreset]
end

-- ================= 主题注册 =================
-- 🖤 BlackGold
WindUI:AddTheme({
    Name = "BlackGold",

    Background = Color3.fromRGB(8,8,10),

    -- ⭐关键：卡片层（必须明显存在）
    ElementBackground = Color3.fromRGB(98,98,100),

    -- ⭐控件层（再亮一层）
    Button = Color3.fromRGB(140,125,100),

    Hover = Color3.fromRGB(255,255,255),

    Text = Color3.fromRGB(235,235,235),
    Placeholder = Color3.fromRGB(120,120,130),
    Icon = Color3.fromRGB(200,160,80),

    Outline = Color3.fromRGB(70,70,75),

    Accent = WindUI:Gradient({
        ["0"] = { Color = Color3.fromRGB(200,160,80), Transparency = 0.5 },
        ["100"] = { Color = Color3.fromRGB(120,90,40), Transparency = 0.5 },
    }),

    WindowBackground = Color3.fromRGB(8,8,10),

    TabTitle = Color3.fromRGB(235,235,235),
    TabIcon = Color3.fromRGB(200,160,80),

    ElementTitle = Color3.fromRGB(235,235,235),
    ElementDesc = Color3.fromRGB(150,150,160),

    Toggle = Color3.fromRGB(90,70,40),
    ToggleBar = Color3.fromRGB(255,255,255),

    Slider = Color3.fromRGB(90,70,40),
    SliderThumb = Color3.fromRGB(255,255,255),

    Checkbox = Color3.fromRGB(90,70,40),
    CheckboxIcon = Color3.fromRGB(255,255,255),
})

-- 🌌 Aurora
WindUI:AddTheme({
    Name = "Aurora",

    Background = Color3.fromRGB(18,18,22),

    ElementBackground = Color3.fromRGB(98,98,102),
    Button = Color3.fromRGB(155,145,210),

    Hover = Color3.fromRGB(255,255,255),

    Text = Color3.fromRGB(235,235,235),
    Placeholder = Color3.fromRGB(140,140,160),
    Icon = Color3.fromRGB(170,150,255),

    Outline = Color3.fromRGB(80,80,100),

    Accent = WindUI:Gradient({
        ["0"] = { Color = Color3.fromRGB(140,100,255), Transparency = 0.5 },
        ["100"] = { Color = Color3.fromRGB(80,60,200), Transparency = 0.5 },
    }),

    WindowBackground = Color3.fromRGB(18,18,22),

    TabTitle = Color3.fromRGB(235,235,235),
    TabIcon = Color3.fromRGB(170,150,255),

    ElementTitle = Color3.fromRGB(235,235,235),
    ElementDesc = Color3.fromRGB(150,150,170),

    Toggle = Color3.fromRGB(100,90,160),
    ToggleBar = Color3.fromRGB(255,255,255),

    Slider = Color3.fromRGB(100,90,160),
    SliderThumb = Color3.fromRGB(255,255,255),

    Checkbox = Color3.fromRGB(100,90,160),
    CheckboxIcon = Color3.fromRGB(255,255,255),
})

-- 🌊 Cyan
WindUI:AddTheme({
    Name = "Cyan",

    Background = Color3.fromRGB(10,18,20),

    ElementBackground = Color3.fromRGB(105,120,120),
    Button = Color3.fromRGB(130,170,180),

    Hover = Color3.fromRGB(255,255,255),

    Text = Color3.fromRGB(210,240,240),
    Placeholder = Color3.fromRGB(130,170,170),
    Icon = Color3.fromRGB(80,220,200),

    Outline = Color3.fromRGB(80,110,110),

    Accent = WindUI:Gradient({
        ["0"] = { Color = Color3.fromRGB(0,200,180), Transparency = 0.5 },
        ["100"] = { Color = Color3.fromRGB(0,120,200), Transparency = 0.5 },
    }, { Rotation = 45 }),

    WindowBackground = Color3.fromRGB(10,18,20),

    TabTitle = Color3.fromRGB(210,240,240),
    TabIcon = Color3.fromRGB(80,220,200),

    ElementTitle = Color3.fromRGB(210,240,240),
    ElementDesc = Color3.fromRGB(150,190,190),

    Toggle = Color3.fromRGB(90,130,130),
    ToggleBar = Color3.fromRGB(255,255,255),

    Slider = Color3.fromRGB(90,130,130),
    SliderThumb = Color3.fromRGB(255,255,255),

    Checkbox = Color3.fromRGB(90,130,130),
    CheckboxIcon = Color3.fromRGB(255,255,255),
})

-- 🔵 Blue
WindUI:AddTheme({
    Name = "Blue",

    Background = Color3.fromRGB(8,10,18),
    ElementBackground = Color3.fromRGB(120,136,188),
    Button = Color3.fromRGB(120,140,200),

    Hover = Color3.fromRGB(255,255,255),

    Text = Color3.fromRGB(235,240,255),
    Placeholder = Color3.fromRGB(130,140,170),
    Icon = Color3.fromRGB(120,160,255),

    Outline = Color3.fromRGB(90,100,130),

    Accent = WindUI:Gradient({
        ["0"] = { Color = Color3.fromRGB(120,160,255), Transparency = 0.5 },
        ["100"] = { Color = Color3.fromRGB(60,100,200), Transparency = 0.5 },
    }),

    WindowBackground = Color3.fromRGB(8,10,18),

    TabTitle = Color3.fromRGB(235,240,255),
    TabIcon = Color3.fromRGB(120,160,255),

    ElementTitle = Color3.fromRGB(235,240,255),
    ElementDesc = Color3.fromRGB(150,160,180),

    Toggle = Color3.fromRGB(60,70,90),
    ToggleBar = Color3.fromRGB(255,255,255),

    Slider = Color3.fromRGB(100,120,180),
    SliderThumb = Color3.fromRGB(255,255,255),

    Checkbox = Color3.fromRGB(100,120,180),
    CheckboxIcon = Color3.fromRGB(255,255,255),
})

-- ================= 主题保存 =================
local ThemeFile = "NightTheme.txt"
local CurrentTheme = "Dark"

pcall(function()
    if isfile and isfile(ThemeFile) then
        local saved = readfile(ThemeFile)
        if saved and saved ~= "" then
            CurrentTheme = saved
        end
    end
end)

-- =================== UI创建前性能检测 ===================
local LOW_END_THRESHOLD = 0.15
local TEST_COUNT = 1_000_000
local TEST_ROUNDS = 3

local function runPerformanceTest()
    local startTime = os.clock()
    local result = 0

    for i = 1, TEST_COUNT do
        result += math.sqrt(i) * math.sin(i)
    end

    local costTime = os.clock() - startTime

    return costTime, result
end

local function getAveragePerformanceTime()
    local totalTime = 0
    local finalResult = 0

    for round = 1, TEST_ROUNDS do
        local costTime, result = runPerformanceTest()

        totalTime += costTime
        finalResult += result

        task.wait()
    end

    local averageTime = totalTime / TEST_ROUNDS

    return averageTime, finalResult
end

local function isLowEndDevice()
    local averageTime, result = getAveragePerformanceTime()

    print("平均性能测试耗时:", averageTime)
    print("测试结果:", result)

    if averageTime >= LOW_END_THRESHOLD then
        return true, averageTime
    else
        return false, averageTime
    end
end

local lowEnd, averageTime = isLowEndDevice()

if lowEnd then
    task.wait(2)
else
    print("继续执行")
end

-- =================== UI窗口创建 ===================
local Window = WindUI:CreateWindow({
    Title = "泽脚本",
    Icon = "rbxassetid://114890258053806",
    Author = "作者:泽（UI夜）",
    Folder = "1",

    Size = UDim2.fromOffset(520, 420),

    Transparent = true,
    Theme = CurrentTheme,

    -- ⭐核心：开启新UI系统
    NewElements = false,

    -- ⭐窗口打开快捷键（PC设置可改）
    ToggleKey = PCWindowToggleKey,

    -- ⭐浮动按钮（iOS风格）
    OpenButton = {
        CornerRadius = UDim.new(1, 0),
        Scale = 1,
        Draggable = true,
        OnlyMobile = false,
        Enabled = InitialOpenButtonEnabled,

        Color = ColorSequence.new(
            Color3.fromRGB(120, 80, 255),
            Color3.fromRGB(0, 200, 255)
        )
    },

    SideBarWidth = 150,
    ScrollBarEnabled = false,

    Background = BackgroundEnabled and BgImage or nil,
    BackgroundImageTransparency = BgTransValue,

    User = {
        Enabled = true,
        Anonymous = false
    }
})

-- ⭐再补一层保险（防UI初始化不同步）
pcall(function()
    WindUI:SetTheme(CurrentTheme)

    if BackgroundEnabled then
        pcall(function()
            Window.BackgroundImage = BgImage
            Window.BackgroundImageTransparency = BgTransValue
        end)
    end
end)
-- =================== 边框系统（保留原彩虹版） ===================
task.wait(0.3)

local RunService = game:GetService("RunService")
local Main = Window.UIElements and Window.UIElements.Main

if Main then
    -- ===== 文件 =====
    local BorderModeFile = "WindUI_BorderMode.txt"
    local BorderEnabledFile = "WindUI_BorderEnabled.txt"

    -- ===== 默认（强制彩虹 + 开启）=====
    local BorderMode = "Rainbow"
    local BorderEnabled = true

    -- ===== 读取（如果没有文件就用默认）=====
    pcall(function()
        if isfile and isfile(BorderModeFile) then
            local v = readfile(BorderModeFile)
            if v ~= "" then
                BorderMode = v
            end
        end
    end)

    pcall(function()
        if isfile and isfile(BorderEnabledFile) then
            BorderEnabled = readfile(BorderEnabledFile) == "true"
        end
    end)

    -- ===== 清理旧 =====
    for _, v in ipairs(Main:GetDescendants()) do
        if v:IsA("UIStroke") and v.Name == "RainbowBorder" then
            v:Destroy()
        end
    end

    -- ===== 创建描边 =====
    local Stroke = Instance.new("UIStroke")
    Stroke.Name = "RainbowBorder"
    Stroke.Thickness = 3.5
    Stroke.Color = Color3.new(1, 1, 1)
    Stroke.LineJoinMode = Enum.LineJoinMode.Round
    Stroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
    Stroke.Parent = Main

    -- ===== 原版彩虹渐变 =====
    local Gradient = Instance.new("UIGradient")
    Gradient.Name = "RainbowGradient"
    Gradient.Color = ColorSequence.new({
        ColorSequenceKeypoint.new(0,    Color3.fromRGB(255, 0, 0)),
        ColorSequenceKeypoint.new(0.16, Color3.fromRGB(255, 255, 0)),
        ColorSequenceKeypoint.new(0.33, Color3.fromRGB(0, 255, 0)),
        ColorSequenceKeypoint.new(0.5,  Color3.fromRGB(0, 255, 255)),
        ColorSequenceKeypoint.new(0.66, Color3.fromRGB(0, 0, 255)),
        ColorSequenceKeypoint.new(0.83, Color3.fromRGB(255, 0, 255)),
        ColorSequenceKeypoint.new(1,    Color3.fromRGB(255, 0, 0))
    })
    Gradient.Rotation = 1
    Gradient.Parent = Stroke

    -- ===== 模式切换 =====
    local function ApplyBorderMode(mode)
        BorderMode = mode

        if mode == "Rainbow" then
            Gradient.Enabled = true
            Stroke.Color = Color3.new(1, 1, 1)

        elseif mode == "Red" then
            Gradient.Enabled = false
            Stroke.Color = Color3.fromRGB(255, 60, 60)

        elseif mode == "Blue" then
            Gradient.Enabled = false
            Stroke.Color = Color3.fromRGB(80, 160, 255)
        end

        pcall(function()
            if writefile then
                writefile(BorderModeFile, mode)
            end
        end)
    end

    -- ===== 开关 =====
    local function SetBorderEnabled(v)
        BorderEnabled = v
        Stroke.Enabled = v

        pcall(function()
            if writefile then
                writefile(BorderEnabledFile, tostring(v))
            end
        end)
    end

    -- ===== 初始化（先执行，确保变量状态正确）=====
    ApplyBorderMode(BorderMode)
    SetBorderEnabled(BorderEnabled)

    -- ===== 动画（初始化之后再连接，保证 BorderMode 已同步）=====
    local currentAngle = 1

    -- ⭐ 关键修复：连接前先强制写一次 Rotation，激活 Roblox 渲染管线
    Gradient.Rotation = currentAngle

    RunService.RenderStepped:Connect(function(dt)
        if not Stroke or not Stroke.Parent then return end
        if BorderMode ~= "Rainbow" then return end
        if not Gradient.Enabled then return end

        currentAngle = (currentAngle + dt * 150) % 360
        Gradient.Rotation = currentAngle
    end)

    -- ===== 圆角 =====
    local Corner = Main:FindFirstChildOfClass("UICorner")
    if not Corner then
        Corner = Instance.new("UICorner")
        Corner.CornerRadius = UDim.new(0, 12)
        Corner.Parent = Main
    end

    -- ===== 全局 =====
    _G.ApplyBorderMode = ApplyBorderMode
    _G.SetBorderEnabled = SetBorderEnabled
    _G.BorderMode = BorderMode
    _G.BorderEnabled = BorderEnabled
else
    warn("[UI边框] Window.UIElements.Main 不存在，已跳过边框系统")
    _G.ApplyBorderMode = function() end
    _G.SetBorderEnabled = function() end
    _G.BorderMode = "Rainbow"
    _G.BorderEnabled = false
end

-- ================= 配置 =================
local TabConfig = Window:Tab({
    Title = "配置",
    Icon = "settings",
    Locked = false,
})

-- ⭐延迟获取主题（确保 AddTheme 已注册）
task.wait()

local ThemeList = {}

pcall(function()
    ThemeList = WindUI:GetThemes()
end)

-- ⭐严格校验
if not table.find(ThemeList, CurrentTheme) then
    warn("主题不存在，重置为 Dark ->", CurrentTheme)
    CurrentTheme = "Dark"
end

-- ================= 主题列表（关键修复） =================
ThemeList = {}

pcall(function()
    ThemeList = WindUI:GetThemes()
end)

-- ⭐手动加入自定义主题
local CustomThemes = {"Aurora", "Cyan", "Blue", "BlackGold"}

for _, v in ipairs(CustomThemes) do
    if not table.find(ThemeList, v) then
        table.insert(ThemeList, v)
    end
end

-- ⭐去重并确保 Dark 在第一位
local NewList = {"Dark"}

for _, v in ipairs(ThemeList) do
    if v ~= "Dark" and not table.find(NewList, v) then
        table.insert(NewList, v)
    end
end

ThemeList = NewList

-- ================= 主题切换 =================
TabConfig:Dropdown({
    Title = "UI主题",
    Values = ThemeList,
    Default = CurrentTheme,

    Callback = function(v)
        if typeof(v) == "table" then
            v = v.Value or v[1]
        end
        if not v then return end

        CurrentTheme = v

        pcall(function()
            WindUI:SetTheme(v)
        end)

        pcall(function()
            if writefile then
                writefile(ThemeFile, v)
            end
        end)

        Notify("主题切换", "已切换为 " .. tostring(v), 2, "success")
    end
})

-- ================= 背景图开关 =================
TabConfig:Toggle({
    Title = "背景图（重启脚本生效）",
    Value = BackgroundEnabled,

    Callback = function(v)
        BackgroundEnabled = v

        pcall(function()
            if writefile then
                writefile(BgFile, tostring(v))
            end
        end)

        if v then
            pcall(function()
                Window.BackgroundImage = BgImage
                Window.BackgroundImageTransparency = BgTransValue
            end)
        else
            pcall(function()
                Window.BackgroundImage = ""
            end)
        end
    end
})

-- ================= 背景图预设 =================
local BgPresetNames = {
    "蓝色系少女",
    "粉色系少女",
    "蓝色系猫娘",
    "彩蛋",
    "紫色系御姐",
    "蓝色系少女2",
    "你懂的",
    "你懂的2",
    "你懂的3",
    "罪恶王冠楪祈",
    "罪恶王冠楪祈2",
    "这是鸣潮的吗？",
}

TabConfig:Dropdown({
    Title = "背景图预设",
    Desc = "选择预设背景重启脚本生效",
    Values = BgPresetNames,
    Default = SavedBgPreset,

    Callback = function(v)
        if typeof(v) == "table" then
            v = v.Value or v[1]
        end
        if not v then return end

        local url = BgPresets[v]
        if not url then return end

        -- 更新全局变量
        BgImage = url
        SavedBgPreset = v

        -- 保存到文件
        pcall(function()
            if writefile then
                writefile(BgPresetFile, v)
            end
        end)

        -- 应用（仅在开启时生效）
        if BackgroundEnabled then
            pcall(function()
                Window.BackgroundImage = BgImage
                Window.BackgroundImageTransparency = BgTransValue
            end)
        end

        Notify("背景图", "已切换为 " .. tostring(v), 2, "success")
    end
})

-- ================= 背景图透明度 =================
TabConfig:Slider({
    Title = "背景图透明度（重启脚本生效）",
    Desc = "0=不透明  100=全透明",
    Value = {
        Min = 0,
        Max = 100,
        Default = math.floor(BgTransValue * 100),
    },
    Increment = 5,

    Callback = function(v)
        local realVal = v / 100
        BgTransValue = realVal

        pcall(function()
            if writefile then
                writefile(BgTransFile, tostring(realVal))
            end
        end)

        if BackgroundEnabled then
            pcall(function()
                Window.BackgroundImageTransparency = realVal
            end)
        end
    end
})

-- ================= UI边框开关 =================
TabConfig:Toggle({
    Title = "UI边框",
    Value = _G.BorderEnabled,

    Callback = function(v)
        _G.SetBorderEnabled(v)

        Notify("边框", v and "已开启" or "已关闭", 2, "success")
    end
})

-- ================= 边框样式 =================
TabConfig:Dropdown({
    Title = "边框样式",
    Values = {"Rainbow", "Red", "Blue"},
    Default = _G.BorderMode or "Rainbow",

    Callback = function(v)
        if typeof(v) == "table" then
            v = v.Value or v[1]
        end
        if not v then return end

        _G.ApplyBorderMode(v)

        Notify("边框样式", "已切换为 " .. tostring(v), 2, "success")
    end
})

-- ⭐关键修复：Dropdown 创建后手动触发一次，确保初始模式生效
task.defer(function()
    _G.ApplyBorderMode(_G.BorderMode or "Rainbow")
end)

-- ================= 重进服务器 =================
TabConfig:Button({
    Title = "重新进入服务器",

    Callback = function()
        Notify("正在重进", "请稍候...", 3)

        local TeleportService = game:GetService("TeleportService")
        local player = Players.LocalPlayer

        TeleportService:Teleport(game.PlaceId, player)
    end
})

task.wait(0.2)

local TabTerminate = Window:Tab({ Title = "终止", Icon = "skull", Locked = false })
TabTerminate:Button({
    Title = "自杀",
    Callback = function()
        local char = game.Players.LocalPlayer.Character
        if char then char:BreakJoints() end
    end
})

local TabCommon = Window:Tab({
    Title = "通用",
    Icon = "box",
    Locked = false,
})

local ESPSection = TabCommon:Section({ Title = "ESP透视", Opened = false })  -- 默认折叠

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


pcall(function()
    loadstring(game:HttpGet("https://raw.githubusercontent.com/xiaozeyydsnb/aiill/main/config.lua"))()
end)

pcall(function()
    loadstring(game:HttpGet("https://raw.githubusercontent.com/xiaozeyydsnb/aiill/main/notify.lua"))()
end)

return Main
