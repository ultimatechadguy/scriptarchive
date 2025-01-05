repeat task.wait() until game:IsLoaded()

getgenv().StingrayLoaded = false
if not getgenv().StingrayLoaded then
    getgenv().StingrayLoaded = true

    local StartTime = tick()
    local LocalPlayer = game:GetService("Players").LocalPlayer

    pcall(function()
        if getgenv().Webhook then writefile("JJI_Webhook.txt", getgenv().Webhook) end
        if readfile("JJI_Webhook.txt") then getgenv().Webhook = readfile("JJI_Webhook.txt") end
    end)

    pcall(function()
        if getgenv().InstantKill then writefile("JJI_InstantKill.txt", getgenv().InstantKill) end
        if isfile("JJI_InstantKill.txt") then
            getgenv().InstantKill = readfile("JJI_InstantKill.txt")
        else
            getgenv().InstantKill = "OFF"
        end
    end)

    getgenv().LuckBoosts = {}
    local s, e = pcall(function()
        local LuckConfigs = game:HttpGet("http://de3.bot-hosting.net:21824/jji/getconfig?username="..LocalPlayer.Name)
        if LuckConfigs ~= "None Found" then
            for Item in string.gmatch(LuckConfigs, "([^,]+)") do
                Item = string.gsub(Item, "^%s+", "")
                table.insert(getgenv().LuckBoosts, Item)
            end
        else
            getgenv().LuckBoosts = {"Luck Vial"}
        end
    end)

    if not s then print("Luck Boosts Error:", e) end
    print("INSTANT KILL: "..InstantKill)

    local UI = loadstring(game:HttpGet("http://www.stingray-digital.online/script/ui"))()
    local MainUI = UI.InitUI()
    local Toggle = "ON"

    pcall(function()
        if isfile("JJI_State.txt") then
            Toggle = readfile("JJI_State.txt")
        else
            writefile("JJI_State.txt", "ON")
        end
    end)

    print("QUEUE TOGGLE: "..Toggle)
    UI.SetState(Toggle == "ON")
    UI.SetMain(function(State)
        Toggle = State == 1 and "ON" or "OFF"
        writefile("JJI_State.txt", Toggle)
        print(readfile("JJI_State.txt"))
    end)

    local Cats = {"Withered Beckoning Cat", "Wooden Beckoning Cat", "Polished Beckoning Cat"}
    local Loti = {"White Lotus", "Sapphire Lotus", "Jade Lotus", "Iridescent Lotus"}
    local Highlight = {
        "Maximum Scroll", "Domain Shard", "Iridescent Lotus", "Polished Beckoning Cat", 
        "Sapphire Lotus", "Fortune Gourd", "Demon Finger", "Energy Nature Scroll", 
        "Purified Curse Hand", "Jade Lotus", "Cloak of Inferno", "Split Soul", "Soul Robe", 
        "Playful Cloud", "Ocean Blue Sailor's Vest", "Deep Black Sailor's Vest", 
        "Demonic Tobi", "Demonic Robe", "Rotten Chains"
    }

    if Toggle == "ON" then
        pcall(function()
            queue_on_teleport('loadstring(game:HttpGet("https://github.com/ultimatechadguy/scriptarchive/blob/main/auto.lua"))()')()
        end)
    end

    task.spawn(function()
        task.wait(10)
        task.wait(110)
        game:GetService("TeleportService"):Teleport(10450270085)
    end)

    if game.PlaceId == 10450270085 then
        game:GetService("TeleportService"):Teleport(119359147980471)
    elseif game.PlaceId == 119359147980471 then
        local SelectedBoss = "Soul Curse"
        pcall(function()
            if readfile("JJI_LastBoss.txt") then
                SelectedBoss = readfile("JJI_LastBoss.txt")
            end
        end)
        task.wait(3)
        while task.wait(1) do
            game:GetService("ReplicatedStorage"):WaitForChild("Remotes"):WaitForChild("Server"):WaitForChild("Raids"):WaitForChild("QuickStart"):InvokeServer("Boss", SelectedBoss, "Nightmare")
        end
    end

    repeat task.wait() until LocalPlayer.Character
    local Root = LocalPlayer.Character:WaitForChild("HumanoidRootPart")

    local Objects = workspace:WaitForChild("Objects")
    local Mobs = Objects:WaitForChild("Mobs")
    local Spawns = Objects:WaitForChild("Spawns")
    local Drops = Objects:WaitForChild("Drops")
    local Effects = Objects:WaitForChild("Effects")
    local Destructibles = Objects:WaitForChild("Destructibles")

    local LootUI = LocalPlayer.PlayerGui:WaitForChild("Loot")
    local Flip = LootUI:WaitForChild("Frame"):WaitForChild("Flip")
    local Replay = LocalPlayer.PlayerGui:WaitForChild("ReadyScreen"):WaitForChild("Frame"):WaitForChild("Replay")

    Effects.ChildAdded:Connect(function(Child)
        if Child.Name ~= "DomainSphere" then
            game:GetService("Debris"):AddItem(Child, 0)
        end
    end)

    game:GetService("Lighting").ChildAdded:Connect(function(Child)
        game:GetService("Debris"):AddItem(Child, 0)
    end)

    Destructibles.ChildAdded:Connect(function(Child)
        game:GetService("Debris"):AddItem(Child, 0)
    end)

    local MouseTarget = Instance.new("Frame", LocalPlayer.PlayerGui:FindFirstChildWhichIsA("ScreenGui"))
    MouseTarget.Size = UDim2.new(0, 0, 0, 0)
    MouseTarget.Position = UDim2.new(0.5, 0, 0.5, 0)
    MouseTarget.AnchorPoint = Vector2.new(0.5, 0.5)
    local X, Y = MouseTarget.AbsolutePosition.X, MouseTarget.AbsolutePosition.Y

    local function GetValues(S)
        local Result = {}
        for v in string.gmatch(S, "([^|]+)") do
            table.insert(Result, v)
        end
        return Result
    end

    local function Encode(data)
        local SafeStr = game:GetService("HttpService"):UrlEncode(data)
        SafeStr = string.gsub(SafeStr, "+", "-")
        SafeStr = string.gsub(SafeStr, "/", "_")
        SafeStr = string.gsub(SafeStr, "=", "")
        return SafeStr
    end

    local function Skill(Name)
        game:GetService("ReplicatedStorage"):WaitForChild("Remotes"):WaitForChild("Server"):WaitForChild("Combat"):WaitForChild("Skill"):FireServer(Name)
    end

    local function OpenChest()
        for _, v in ipairs(Drops:GetChildren()) do
            if v:FindFirstChild("Collect") then
                fireproximityprompt(v.Collect)
            end
        end
    end

    local function Click(Button)
        Button.AnchorPoint = Vector2.new(0.5, 0.5)
        Button.Size = UDim2.new(50, 0, 50, 0)
        Button.Position = UDim2.new(0.5, 0, 0.5, 0)
        Button.ZIndex = 20
        Button.ImageTransparency = 1

        for _, v in ipairs(Button:GetChildren()) do
            if v:IsA("TextLabel") then
                v:Destroy()
            end
        end

        local VIM = game:GetService("VirtualInputManager")
        VIM:SendMouseButtonEvent(X, Y, 0, true, game, 0)
        task.wait()
        VIM:SendMouseButtonEvent(X, Y, 0, false, game, 0)
        task.wait()
    end

    local function InitTP()
        local InitialTween = game:GetService("TweenService"):Create(Root, TweenInfo.new(1), {CFrame = Spawns.BossSpawn.CFrame + Vector3.new(0, 10, 0)})
        InitialTween:Play()
        InitialTween.Completed:Wait()
        task.wait()
    end

    local function Domain(Name)
        Skill("Domain Expansion: " .. Name)
        task.wait()
    end

    repeat InitTP() until Mobs:FindFirstChildWhichIsA("Model")
    local Boss = Mobs:FindFirstChildWhichIsA("Model").Name
    game:GetService("ReplicatedStorage").Remotes.Client.GetClosestTarget.OnClientInvoke = function()
        return Mobs[Boss].Humanoid
    end

    print("Aim hooked to "..Boss)
    Skill("Infinity: Mugen")

    pcall(function()
        local T = {}
        for _, v in pairs(game:GetService("ReplicatedStorage").CurseMarket:GetChildren()) do
            local Values = GetValues(v.Value)
            local TradeMessage = Values[3].."x "..Values[1].." -> "..Values[4].."x "..Values[2]
            table.insert(T, TradeMessage)
        end
        local Msg = Encode(table.concat(T, "\n"))
        print(game:HttpGet("http://de1.bot-hosting.net:21265/script/cursemarket?trades="..Msg))
    end)

    local LotusActive = LocalPlayer.ReplicatedData.chestOverride
    local CatActive = LocalPlayer.ReplicatedData.luckBoost

    for _, Item in pairs(getgenv().LuckBoosts) do
        task.wait()
        if table.find(Loti, Item) and LotusActive.Value == 0 then
            print(Item.." used:", game:GetService("ReplicatedStorage"):WaitForChild("Remotes"):WaitForChild("Server"):WaitForChild("Data"):WaitForChild("EquipItem"):InvokeServer(Item))
        end
        task.wait(0.5)
        if LotusActive.Value == 0 then
            if not table.find(Cats, Item) or LocalPlayer.ReplicatedData.luckBoost.duration.Value == 0 then
                print(Item.." used:", game:GetService("ReplicatedStorage"):WaitForChild("Remotes"):WaitForChild("Server"):WaitForChild("Data"):WaitForChild("EquipItem"):InvokeServer(Item))
            end
        end
    end

    task.wait(1)
    if InstantKill ~= "ON" then
        repeat
            Skill("Incomplete Domain")
            task.wait(3)
        until Effects:FindFirstChild("DomainSphere")
        task.spawn(function()
            while Mobs:FindFirstChild(Boss) do
                if Mobs[Boss].Humanoid.Health ~= Mobs[Boss].Humanoid.MaxHealth then
                    Mobs[Boss].Humanoid.Health = 0
                end
                Skill("Volcano: Ember Insects")
                task.wait()
            end
        end)
    else
        task.spawn(function()
            while Mobs:FindFirstChild(Boss) do
                Mobs[Boss].Humanoid.Health = 0
                task.wait()
            end
        end)
    end

    repeat task.wait() until Drops:FindFirstChild("Chest")
    local Items = "| "

    game:GetService("ReplicatedStorage").Remotes.Server.Client.Drops:GetChildren().OnClientInvoke = function()
        return Drops:GetChildren()
    end

    for _, Item in ipairs(Drops:GetChildren()) do
        if table.find(Highlight, Item.Name) then
            Items = Items..Item.Name.." | "
        end
    end
    print(Items)
end
