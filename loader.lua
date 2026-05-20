local a = "https://raw."
local b = "githubusercontent.com/"
local c = "xiaozeyydsnb/aiill/main/"

local BASE = a..b..c

local function LoadModule(name)
    local ok,res = pcall(function()
        return game:HttpGet(BASE .. name .. ".lua")
    end)

    if not ok then
        warn("加载失败: "..name)
        return
    end

    local fn = loadstring(res)

    if fn then
        return fn()
    end
end

if getgenv().XiaoZeLoaded then
    return
end

getgenv().XiaoZeLoaded = true

LoadModule("main")
