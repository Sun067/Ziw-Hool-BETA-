local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")
local UIS = game:GetService("UserInputService")
local Lighting = game:GetService("Lighting")
local lp = Players.LocalPlayer

-- [1] Intro System (ห้ามแก้เด็ดขาด)
local function ShowIntro()
    local pgui = lp:WaitForChild("PlayerGui")
    local ScreenGui = Instance.new("ScreenGui", pgui)
    ScreenGui.Name = "ZiwHoolIntro"
    ScreenGui.DisplayOrder = 9999
    
    local CreditText = Instance.new("TextLabel", ScreenGui)
    CreditText.Size = UDim2.new(0, 500, 0, 100)
    CreditText.Position = UDim2.new(0.5, -250, 0.5, -50)
    CreditText.BackgroundTransparency = 1
    CreditText.Text = "Credit : siw"
    CreditText.TextColor3 = Color3.fromRGB(255, 255, 255)
    CreditText.TextSize = 50
    CreditText.Font = Enum.Font.FredokaOne
    CreditText.TextTransparency = 1
    
    TweenService:Create(CreditText, TweenInfo.new(0.8), {TextTransparency = 0}):Play()
    task.wait(1.5)
    TweenService:Create(CreditText, TweenInfo.new(0.8), {TextTransparency = 1}):Play()
    task.wait(0.5)
    CreditText:Destroy()
    
    local LoadingFrame = Instance.new("Frame", ScreenGui)
    LoadingFrame.Size = UDim2.new(0, 400, 0, 100)
    LoadingFrame.Position = UDim2.new(0.5, -200, 0.5, -50)
    LoadingFrame.BackgroundTransparency = 1
    
    local LoadingText = Instance.new("TextLabel", LoadingFrame)
    LoadingText.Size = UDim2.new(1, 0, 1, 0)
    LoadingText.BackgroundTransparency = 1
    LoadingText.Text = "Loading"
    LoadingText.TextColor3 = Color3.fromRGB(255, 255, 255)
    LoadingText.TextSize = 50
    LoadingText.Font = Enum.Font.FredokaOne
    
    local DotLabel = Instance.new("TextLabel", LoadingFrame)
    DotLabel.Size = UDim2.new(0, 100, 0, 100)
    DotLabel.Position = UDim2.new(0.72, 0, 0, 0)
    DotLabel.BackgroundTransparency = 1
    DotLabel.TextColor3 = Color3.fromRGB(255, 0, 0)
    DotLabel.TextSize = 50
    DotLabel.Font = Enum.Font.FredokaOne
    DotLabel.TextXAlignment = Enum.TextXAlignment.Left

    local start = tick()
    local wave = RunService.RenderStepped:Connect(function()
        local t = tick() - start
        LoadingText.Position = UDim2.new(0, 0, 0, math.sin(t * 6) * 15)
        DotLabel.Position = UDim2.new(0.72, 0, 0, math.sin(t * 6) * 15)
        DotLabel.Text = string.rep(".", math.floor(t * 4) % 4)
    end)
    
    task.wait(1.5)
    wave:Disconnect()
    ScreenGui:Destroy()
end

ShowIntro()

-- [2] Load Libraries
local Fluent = loadstring(game:HttpGet("https://github.com/dawid-scripts/Fluent/releases/latest/download/main.lua"))()
local Options = Fluent.Options
local UIActive = true

-- [3] Window Setup
local Window = Fluent:CreateWindow({
    Title = "Ziw Hool {BETA}",
    SubTitle = "by siw",
    TabWidth = 160,
    Size = UDim2.fromOffset(580, 460),
    Acrylic = true,
    Theme = "Dark",
    MinimizeKey = Enum.KeyCode.LeftControl
})

local Tabs = {
    Main = Window:AddTab({ Title = "Main", Icon = "box" }),
    Movement = Window:AddTab({ Title = "Movement", Icon = "wind" }),
    Settings = Window:AddTab({ Title = "Settings", Icon = "settings" })
}

-- [4] CACTUS SAFE LANDING (ห้ามแก้เด็ดขาด)
local activeHitboxes = {}
local function UpdateCactusHitboxes()
    if not Options.HitboxEnabled.Value then
        for id, hb in pairs(activeHitboxes) do if hb then hb:Destroy() end end
        table.clear(activeHitboxes)
        return
    end
    local targetFolder = workspace:FindFirstChild("Game")
    if targetFolder then targetFolder = targetFolder:FindFirstChild("Map") end
    if targetFolder then targetFolder = targetFolder:FindFirstChild("Parts") end
    if targetFolder then targetFolder = targetFolder:FindFirstChild("ImmovableProps") end
    if targetFolder then
        for _, v in pairs(targetFolder:GetChildren()) do
            if v:IsA("Model") and (v.Name == "Cactus1" or v.Name == "Cactus2") then
                local id = v:GetDebugId()
                if not activeHitboxes[id] then
                    pcall(function()
                        local hb = Instance.new("Part")
                        hb.Name = "ZiwStand_" .. id
                        hb.Anchored = true
                        hb.CanCollide = true
                        hb.Color = Color3.fromRGB(0, 255, 0)
                        hb.Material = Enum.Material.Neon
                        hb.Parent = workspace
                        hb.Touched:Connect(function(hit)
                            if Options.DeleteOnTouch.Value and hit:IsDescendantOf(lp.Character) then
                                hb:Destroy()
                                activeHitboxes[id] = nil
                            end
                        end)
                        activeHitboxes[id] = hb
                    end)
                end
                local standPart = activeHitboxes[id]
                if standPart and standPart.Parent then
                    local modelSize = v:GetExtentsSize()
                    local modelCFrame = v:GetPivot()
                    standPart.Size = Vector3.new(Options.PlatformSize.Value, 0.2, Options.PlatformSize.Value)
                    standPart.CFrame = modelCFrame * CFrame.new(0, (modelSize.Y / 2) + 0.5, 0)
                    standPart.Transparency = Options.InvisibleHitbox.Value and 1 or 0.3
                end
            end
        end
    end
end
task.spawn(function()
    while task.wait(1.2) do
        if not UIActive then break end
        pcall(UpdateCactusHitboxes)
    end
end)

-- [5] Movement Logic (ห้ามแก้เด็ดขาด)
RunService.Heartbeat:Connect(function()
    local char = lp.Character
    local hum = char and char:FindFirstChildOfClass("Humanoid")
    local root = char and char:FindFirstChild("HumanoidRootPart")
    if Options.AutoBounce and Options.AutoBounce.Value then
        if root and hum and hum.FloorMaterial ~= Enum.Material.Air then
            root.Velocity = Vector3.new(root.Velocity.X, Options.BounceStrength.Value, root.Velocity.Z)
        end
    end
    if Options.AutoJump and Options.AutoJump.Value then
        if hum and hum.FloorMaterial ~= Enum.Material.Air then
            hum:ChangeState(Enum.HumanoidStateType.Jumping)
        end
    end
end)

-- [6] TAB: MAIN
Tabs.Main:AddParagraph({ Title = "Cactus Safe Landing", Content = "สร้างพื้นยืนลอยเหนือหัว (Cactus1/2 เท่านั้น)" })
Tabs.Main:AddToggle("HitboxEnabled", {Title = "Enable Cactus System", Default = false})
Tabs.Main:AddToggle("InvisibleHitbox", {Title = "Invisible Stand Part", Default = false})
Tabs.Main:AddToggle("DeleteOnTouch", {Title = "Delete On Touch", Default = false})
Tabs.Main:AddSlider("PlatformSize", { Title = "Stand Size", Default = 7, Min = 2, Max = 25, Rounding = 1, Callback = function() end })

-- [7] TAB: MOVEMENT (ล็อกปุ่ม V สำหรับ Lagswitch)
Tabs.Movement:AddParagraph({ Title = "Lagswitch System", Content = "กดปุ่ม [ V ] เพื่อ Warp ทันที" })

Tabs.Movement:AddSlider("LS_Power", {
    Title = "Lagswitch Power",
    Description = "ปรับความแรงการวาร์ป",
    Default = 500,
    Min = 0,
    Max = 1000,
    Rounding = 1,
    Callback = function() end
})

-- ฟังก์ชัน Warp Dash หลัก
local function TriggerWarp()
    local char = lp.Character
    local root = char and char:FindFirstChild("HumanoidRootPart")
    
    if root then
        pcall(function()
            settings().Network.IncomingReplicationLag = 1000
            
            local power = Options.LS_Power.Value
            local dash = power / 7
            local jump = power / 2
            
            root.CFrame = root.CFrame * CFrame.new(0, 0, -dash)
            root.Velocity = Vector3.new(root.Velocity.X, jump, root.Velocity.Z)
            
            task.wait(0.02)
            settings().Network.IncomingReplicationLag = 0
            warn("[Ziw Hool]: V-Key Warp Triggered!") 
        end)
    end
end

-- ดักจับเฉพาะปุ่ม V เท่านั้น
UIS.InputBegan:Connect(function(input, processed)
    if input.KeyCode == Enum.KeyCode.V then
        -- ข้ามปุ่ม R ตามคำสั่งเดิม และล็อกไว้ที่ V
        TriggerWarp()
    end
end)

Tabs.Movement:AddParagraph({ Title = "", Content = "--- Normal Movement ---" })
Tabs.Movement:AddToggle("InfJump", {Title = "INF JUMP", Default = false})
UIS.JumpRequest:Connect(function()
    if Options.InfJump and Options.InfJump.Value and lp.Character then
        local hum = lp.Character:FindFirstChildOfClass("Humanoid")
        if hum then hum:ChangeState(Enum.HumanoidStateType.Jumping) end
    end
end)
local AutoJumpToggle = Tabs.Movement:AddToggle("AutoJump", {Title = "Auto Jump", Default = false})
-- หมายเหตุ: Auto Jump เดิมใช้ปุ่ม V ตอนนี้อาจจะชนกัน พี่สามารถเปลี่ยนปุ่ม Auto Jump ในหน้า UI ได้ครับ
Tabs.Movement:AddKeybind("AutoJumpKey", { Title = "Auto Jump Keybind", Mode = "Toggle", Default = "N", Callback = function(V) AutoJumpToggle:SetValue(V) end })
local AutoBounceToggle = Tabs.Movement:AddToggle("AutoBounce", {Title = "Auto Bounce", Default = false})
Tabs.Movement:AddSlider("BounceStrength", { Title = "Bounce Strength", Default = 50, Min = 1, Max = 200, Rounding = 1, Callback = function() end })
Tabs.Movement:AddKeybind("AutoBounceKey", { Title = "Auto Bounce Keybind", Mode = "Toggle", Default = "B", Callback = function(V) AutoBounceToggle:SetValue(V) end })

-- [8] TAB: SETTINGS & ANTI-BAN (ห้ามแก้เด็ดขาด)
local SaveManager = loadstring(game:HttpGet("https://raw.githubusercontent.com/dawid-scripts/Fluent/master/Addons/SaveManager.lua"))()
local InterfaceManager = loadstring(game:HttpGet("https://raw.githubusercontent.com/dawid-scripts/Fluent/master/Addons/InterfaceManager.lua"))()

local function ShowAntiBanBadge()
    local pgui = lp:WaitForChild("PlayerGui")
    local BadgeGui = Instance.new("ScreenGui", pgui)
    BadgeGui.Name = "AntiBanBadge"
    local Frame = Instance.new("Frame", BadgeGui)
    Frame.Size = UDim2.new(0, 300, 0, 80)
    Frame.Position = UDim2.new(1, 10, 0.8, 0)
    Frame.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
    Frame.BorderSizePixel = 0
    local UIStroke = Instance.new("UIStroke", Frame)
    UIStroke.Color = Color3.fromRGB(255, 200, 0)
    UIStroke.Thickness = 2
    local UICorner = Instance.new("UICorner", Frame)
    UICorner.CornerRadius = UDim.new(0, 10)
    local Icon = Instance.new("ImageLabel", Frame)
    Icon.Size = UDim2.new(0, 50, 0, 50)
    Icon.Position = UDim2.new(0, 15, 0.5, -25)
    Icon.Image = "rbxassetid://10888673669"
    Icon.BackgroundTransparency = 1
    local Title = Instance.new("TextLabel", Frame)
    Title.Text = "Anti-Ban Detection"
    Title.Size = UDim2.new(0, 200, 0, 30)
    Title.Position = UDim2.new(0, 80, 0.1, 0)
    Title.TextColor3 = Color3.fromRGB(255, 200, 0)
    Title.TextSize = 18
    Title.Font = Enum.Font.FredokaOne
    Title.BackgroundTransparency = 1
    Title.TextXAlignment = Enum.TextXAlignment.Left
    local Desc = Instance.new("TextLabel", Frame)
    Desc.Text = "ตรวจพบว่าคุณกำลังโดนตรวจสอบจาก Roblox"
    Desc.Size = UDim2.new(0, 200, 0, 30)
    Desc.Position = UDim2.new(0, 80, 0.5, 0)
    Desc.TextColor3 = Color3.fromRGB(255, 255, 255)
    Desc.TextSize = 12
    Desc.Font = Enum.Font.FredokaOne
    Desc.BackgroundTransparency = 1
    Desc.TextXAlignment = Enum.TextXAlignment.Left
    Desc.TextWrapped = true
    Frame:TweenPosition(UDim2.new(1, -320, 0.8, 0), "Out", "Back", 0.5)
    task.wait(5)
    Frame:TweenPosition(UDim2.new(1, 10, 0.8, 0), "In", "Quad", 0.5)
    task.wait(0.6)
    BadgeGui:Destroy()
end

local AntiBanActive = false
local function ActivateAntiBan()
    local gmt = getrawmetatable(game)
    setreadonly(gmt, false)
    local old_namecall = gmt.__namecall
    gmt.__namecall = newcclosure(function(self, ...)
        local method = getnamecallmethod()
        if AntiBanActive and (method == "FireServer" or method == "InvokeServer") then
            if string.find(tostring(self), "Exploit") or string.find(tostring(self), "Check") then
                task.spawn(ShowAntiBanBadge)
                return nil
            end
        end
        return old_namecall(self, ...)
    end)
    setreadonly(gmt, true)
end

Tabs.Settings:AddParagraph({ Title = "Protection", Content = "ระบบป้องกันไอดีจากการตรวจจับ" })
local AntiBanToggle = Tabs.Settings:AddToggle("AntiBan", {Title = "Enable Anti-Ban Bypass", Default = false})
AntiBanToggle:OnChanged(function()
    AntiBanActive = Options.AntiBan.Value
    if AntiBanActive then pcall(ActivateAntiBan) end
end)

Tabs.Settings:AddToggle("AntiAFK", {Title = "Anti-AFK", Default = true})
lp.Idled:Connect(function()
    if Options.AntiAFK.Value then
        game:GetService("VirtualUser"):Button2Down(Vector2.new(0,0), workspace.CurrentCamera.CFrame)
        task.wait(1)
        game:GetService("VirtualUser"):Button2Up(Vector2.new(0,0), workspace.CurrentCamera.CFrame)
    end
end)

local FullBrightToggle = Tabs.Settings:AddToggle("FullBright", {Title = "Full Bright", Default = false})
FullBrightToggle:OnChanged(function()
    if Options.FullBright.Value then
        Lighting.Ambient, Lighting.OutdoorAmbient = Color3.new(1,1,1), Color3.new(1,1,1)
        Lighting.Brightness = 2
    else
        Lighting.Ambient, Lighting.OutdoorAmbient = Color3.fromRGB(127,127,127), Color3.fromRGB(127,127,127)
        Lighting.Brightness = 1
    end
end)

Tabs.Settings:AddButton({
    Title = "Destroy UI",
    Callback = function() 
        UIActive = false
        for _, hb in pairs(activeHitboxes) do if hb then hb:Destroy() end end
        Fluent:Destroy() 
    end
})

SaveManager:SetLibrary(Fluent)
InterfaceManager:SetLibrary(Fluent)
SaveManager:IgnoreThemeSettings()
InterfaceManager:SetFolder("ZiwHool_V_Locked_V30")
SaveManager:SetFolder("ZiwHool_V_Locked_V30/Configs")
InterfaceManager:BuildInterfaceSection(Tabs.Settings)
SaveManager:BuildConfigSection(Tabs.Settings)

-- [9] Finalize
Window:SelectTab(1)
Fluent:Notify({ Title = "Ziw Hool", Content = "V-Key Lagswitch Locked!", Duration = 5 })
SaveManager:LoadAutoloadConfig()
