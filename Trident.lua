local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

local Window = Rayfield:CreateWindow({
    Name = "@pepel_product",
    Icon = 0,
    LoadingTitle = "Loading...",
    LoadingSubtitle = "By @pepel_ru",
    ConfigurationSaving = {
        Enabled = true,
        FolderName = "@pepel_product",
        FileName = "@pepel_product"
    },
    Discord = {
        Enabled = false,
        Invite = "noinvitelink",
        RememberJoins = true
    },
    KeySystem = false,
    Theme = "DarkBlue"
})

Rayfield:Notify({
    Title = "Loading",
    Content = "@pepel_product loaded successfully!",
    Duration = 10,
    Image = 6023426915
})

local CombatTab = Window:CreateTab("Combat", "sword")
CombatTab:CreateSection("Combat Features")

local hitboxEnabled = false
local hitboxList = {}

CombatTab:CreateToggle({
    Name = "Hitbox Expander",
    CurrentValue = false,
    Callback = function(Value)
        hitboxEnabled = Value
        if hitboxEnabled then
            task.spawn(function()
                while hitboxEnabled do task.wait()
                    for _,v in pairs(workspace:GetChildren()) do
                        if v:FindFirstChild("HumanoidRootPart") and not v:FindFirstChild("Fake") then
                            local FakeHead = Instance.new("Part")
                            FakeHead.CFrame = v.HumanoidRootPart.CFrame
                            FakeHead.Size = Vector3.new(10, 15, 10)
                            FakeHead.Transparency = 0.6
                            FakeHead.BrickColor = BrickColor.new("Grey")
                            FakeHead.Anchored = true
                            FakeHead.CanCollide = false
                            FakeHead.Name = "Fake"
                            FakeHead.Parent = v
                            table.insert(hitboxList, FakeHead)
                        end
                    end
                end
            end)
        else
            for _,v in pairs(hitboxList) do
                pcall(function() v:Destroy() end)
            end
            hitboxList = {}
        end
    end
})

local VisualsTab = Window:CreateTab("Visuals", "eye")
VisualsTab:CreateSection("Visuals Features")

local espEnabled = false
local espColor = Color3.fromRGB(255, 255, 255)
local espDrawings = {}

local function CreateESP(player)
    if not espDrawings[player] then
        local drawings = {
            Top = Drawing.new("Line"),
            Left = Drawing.new("Line"),
            Bottom = Drawing.new("Line"),
            Right = Drawing.new("Line")
        }
        
        for _, drawing in pairs(drawings) do
            drawing.Visible = false
            drawing.Thickness = 1
            drawing.Transparency = 1
            drawing.Color = espColor
        end
        
        espDrawings[player] = drawings
    end
end

local function UpdateESP(player)
    if not espEnabled or not espDrawings[player] then return end
    
    local drawings = espDrawings[player]
    local rootPart = player:FindFirstChild("HumanoidRootPart")
    local head = player:FindFirstChild("Head")
    
    if rootPart and head then
        local camera = workspace.CurrentCamera
        local screenPos, onScreen = camera:WorldToViewportPoint(rootPart.Position)

        if onScreen then
            local scale = head.Size.Y / 2
            local size = Vector3.new(2, 3, 0) * (scale * 2)
            
            local camCF = camera.CFrame
            local rootPos = rootPart.Position
            
            local TL = camera:WorldToViewportPoint((camCF * CFrame.new(size.X, size.Y, 0) + rootPos - camCF.Position).p)
            local TR = camera:WorldToViewportPoint((camCF * CFrame.new(-size.X, size.Y, 0) + rootPos - camCF.Position).p)
            local BL = camera:WorldToViewportPoint((camCF * CFrame.new(size.X, -size.Y, 0) + rootPos - camCF.Position).p)
            local BR = camera:WorldToViewportPoint((camCF * CFrame.new(-size.X, -size.Y, 0) + rootPos - camCF.Position).p)

            drawings.Top.From = Vector2.new(TL.X, TL.Y)
            drawings.Top.To = Vector2.new(TR.X, TR.Y)
            drawings.Left.From = Vector2.new(TL.X, TL.Y)
            drawings.Left.To = Vector2.new(BL.X, BL.Y)
            drawings.Right.From = Vector2.new(TR.X, TR.Y)
            drawings.Right.To = Vector2.new(BR.X, BR.Y)
            drawings.Bottom.From = Vector2.new(BL.X, BL.Y)
            drawings.Bottom.To = Vector2.new(BR.X, BR.Y)
            
            for _, drawing in pairs(drawings) do
                drawing.Visible = true
                drawing.Color = espColor
            end
            return
        end
    end
    
    for _, drawing in pairs(drawings) do
        drawing.Visible = false
    end
end

VisualsTab:CreateToggle({
    Name = "Box ESP",
    CurrentValue = false,
    Callback = function(Value)
        espEnabled = Value
        
        if espEnabled then
            for _, player in pairs(workspace:GetChildren()) do
                if player:IsA("Model") and player:FindFirstChild("HumanoidRootPart") then
                    CreateESP(player)
                end
            end
            
            workspace.DescendantAdded:Connect(function(child)
                if espEnabled and child:IsA("Model") and child:FindFirstChild("HumanoidRootPart") then
                    CreateESP(child)
                end
            end)
            
            task.spawn(function()
                while espEnabled do
                    for player, drawings in pairs(espDrawings) do
                        UpdateESP(player)
                    end
                    task.wait()
                end
                
                for player, drawings in pairs(espDrawings) do
                    for _, drawing in pairs(drawings) do
                        drawing:Remove()
                    end
                end
                espDrawings = {}
            end)
        else
            for player, drawings in pairs(espDrawings) do
                for _, drawing in pairs(drawings) do
                    drawing:Remove()
                end
            end
            espDrawings = {}
        end
    end
})

VisualsTab:CreateColorPicker({
    Name = "ESP Color",
    Color = espColor,
    Callback = function(Value)
        espColor = Value
        if espEnabled then
            for _, drawings in pairs(espDrawings) do
                for _, drawing in pairs(drawings) do
                    drawing.Color = Value
                end
            end
        end
    end
})

local MiscTab = Window:CreateTab("Misc", "settings")
MiscTab:CreateSection("Misc Features")

local crosshairEnabled = false
local crosshairColor = Color3.fromRGB(255, 255, 255)
local crosshairSettings = {
    thickness = 2,
    length = 5,
    opacity = 1,
    x_offset = 0,
    y_offset = 0
}

local crosshairX, crosshairY = {}, {}

local function UpdateCrosshair()
    local viewport = workspace.CurrentCamera.ViewportSize
    local center = Vector2.new(viewport.X/2 - crosshairSettings.x_offset, viewport.Y/2 - crosshairSettings.y_offset)
    
    if crosshairX.Line then
        crosshairX.Line.From = Vector2.new(center.X - crosshairSettings.length, center.Y)
        crosshairX.Line.To = Vector2.new(center.X + crosshairSettings.length, center.Y)
    end
    
    if crosshairY.Line then
        crosshairY.Line.From = Vector2.new(center.X, center.Y - crosshairSettings.length)
        crosshairY.Line.To = Vector2.new(center.X, center.Y + crosshairSettings.length)
    end
end

MiscTab:CreateToggle({
    Name = "Crosshair",
    CurrentValue = false,
    Callback = function(Value)
        crosshairEnabled = Value
        
        if crosshairEnabled then
            crosshairX.Line = Drawing.new("Line")
            crosshairX.Line.Visible = true
            crosshairX.Line.Color = crosshairColor
            crosshairX.Line.Thickness = crosshairSettings.thickness
            crosshairX.Line.Transparency = crosshairSettings.opacity
            
            crosshairY.Line = Drawing.new("Line")
            crosshairY.Line.Visible = true
            crosshairY.Line.Color = crosshairColor
            crosshairY.Line.Thickness = crosshairSettings.thickness
            crosshairY.Line.Transparency = crosshairSettings.opacity
            
            crosshairX.Connection = workspace.CurrentCamera:GetPropertyChangedSignal("ViewportSize"):Connect(UpdateCrosshair)
            UpdateCrosshair()
        else
            if crosshairX.Line then crosshairX.Line:Remove() end
            if crosshairY.Line then crosshairY.Line:Remove() end
            if crosshairX.Connection then crosshairX.Connection:Disconnect() end
        end
    end
})

MiscTab:CreateColorPicker({
    Name = "Crosshair Color",
    Color = crosshairColor,
    Callback = function(Value)
        crosshairColor = Value
        if crosshairX.Line then crosshairX.Line.Color = Value end
        if crosshairY.Line then crosshairY.Line.Color = Value end
    end
})

MiscTab:CreateButton({
    Name = "FPS Boost",
    Callback = function()
        Rayfield:Notify({
            Title = "FPS Boost",
            Content = "Loading FPS Booster...",
            Duration = 10,
            Image = 6022668888
        })
        
        if not _G.Ignore then
            _G.Ignore = {}
        end
        if not _G.WaitPerAmount then
            _G.WaitPerAmount = 500
        end

        if not _G.Settings then
            _G.Settings = {
                Players = {
                    ["Ignore Me"] = true,
                    ["Ignore Others"] = true,
                    ["Ignore Tools"] = true
                },
                Meshes = {
                    NoMesh = false,
                    NoTexture = false,
                    Destroy = false
                },
                Images = {
                    Invisible = true,
                    Destroy = false
                },
                Explosions = {
                    Smaller = true,
                    Invisible = false,
                    Destroy = false
                },
                Particles = {
                    Invisible = true,
                    Destroy = false
                },
                TextLabels = {
                    LowerQuality = false,
                    Invisible = false,
                    Destroy = false
                },
                MeshParts = {
                    LowerQuality = true,
                    Invisible = false,
                    NoTexture = false,
                    NoMesh = false,
                    Destroy = false
                },
                Other = {
                    ["FPS Cap"] = 240,
                    ["No Camera Effects"] = true,
                    ["No Clothes"] = true,
                    ["Low Water Graphics"] = true,
                    ["No Shadows"] = true,
                    ["Low Rendering"] = true,
                    ["Low Quality Parts"] = true,
                    ["Low Quality Models"] = true,
                    ["Reset Materials"] = true,
                    ["Lower Quality MeshParts"] = true
                }
            }
        end
        
        local Players, Lighting, MaterialService = game:GetService("Players"), game:GetService("Lighting"), game:GetService("MaterialService")
        local ME = Players.LocalPlayer
        
        local function PartOfCharacter(Instance)
            for i, v in pairs(Players:GetPlayers()) do
                if v ~= ME and v.Character and Instance:IsDescendantOf(v.Character) then
                    return true
                end
            end
            return false
        end
        
        local function DescendantOfIgnore(Instance)
            for i, v in pairs(_G.Ignore) do
                if Instance:IsDescendantOf(v) then
                    return true
                end
            end
            return false
        end
        
        local function CheckIfBad(Instance)
            if not Instance:IsDescendantOf(Players) and (_G.Settings.Players["Ignore Others"] and not PartOfCharacter(Instance) or not _G.Settings.Players["Ignore Others"]) and (_G.Settings.Players["Ignore Me"] and ME.Character and not Instance:IsDescendantOf(ME.Character) or not _G.Settings.Players["Ignore Me"]) and (_G.Settings.Players["Ignore Tools"] and not Instance:IsA("BackpackItem") and not Instance:FindFirstAncestorWhichIsA("BackpackItem") or not _G.Settings.Players["Ignore Tools"]) and (_G.Ignore and not table.find(_G.Ignore, Instance) and not DescendantOfIgnore(Instance) or (not _G.Ignore or type(_G.Ignore) ~= "table" or #_G.Ignore <= 0)) then
                if Instance:IsA("DataModelMesh") then
                    if _G.Settings.Meshes.NoMesh and Instance:IsA("SpecialMesh") then
                        Instance.MeshId = ""
                    end
                    if _G.Settings.Meshes.NoTexture and Instance:IsA("SpecialMesh") then
                        Instance.TextureId = ""
                    end
                    if _G.Settings.Meshes.Destroy then
                        Instance:Destroy()
                    end
                elseif Instance:IsA("FaceInstance") then
                    if _G.Settings.Images.Invisible then
                        Instance.Transparency = 1
                        Instance.Shiny = 1
                    end
                    if _G.Settings.Images.Destroy then
                        Instance:Destroy()
                    end
                elseif Instance:IsA("ShirtGraphic") then
                    if _G.Settings.Images.Invisible then
                        Instance.Graphic = ""
                    end
                    if _G.Settings.Images.Destroy then
                        Instance:Destroy()
                    end
                elseif table.find({"ParticleEmitter", "Trail", "Smoke", "Fire", "Sparkles"}, Instance.ClassName) then
                    if _G.Settings.Particles.Invisible then
                        Instance.Enabled = false
                    end
                    if _G.Settings.Particles.Destroy then
                        Instance:Destroy()
                    end
                elseif Instance:IsA("PostEffect") and _G.Settings.Other["No Camera Effects"] then
                    Instance.Enabled = false
                elseif Instance:IsA("Explosion") then
                    if _G.Settings.Explosions.Smaller then
                        Instance.BlastPressure = 1
                        Instance.BlastRadius = 1
                    end
                    if _G.Settings.Explosions.Invisible then
                        Instance.BlastPressure = 1
                        Instance.BlastRadius = 1
                        Instance.Visible = false
                    end
                    if _G.Settings.Explosions.Destroy then
                        Instance:Destroy()
                    end
                elseif (Instance:IsA("Clothing") or Instance:IsA("SurfaceAppearance") or Instance:IsA("BaseWrap")) and _G.Settings.Other["No Clothes"] then
                    Instance:Destroy()
                elseif Instance:IsA("BasePart") and not Instance:IsA("MeshPart") and _G.Settings.Other["Low Quality Parts"] then
                    Instance.Material = Enum.Material.Plastic
                    Instance.Reflectance = 0
                elseif Instance:IsA("TextLabel") and Instance:IsDescendantOf(workspace) then
                    if _G.Settings.TextLabels.LowerQuality then
                        Instance.Font = Enum.Font.SourceSans
                        Instance.TextScaled = false
                        Instance.RichText = false
                        Instance.TextSize = 14
                    end
                    if _G.Settings.TextLabels.Invisible then
                        Instance.Visible = false
                    end
                    if _G.Settings.TextLabels.Destroy then
                        Instance:Destroy()
                    end
                elseif Instance:IsA("Model") and _G.Settings.Other["Low Quality Models"] then
                    Instance.LevelOfDetail = 1
                elseif Instance:IsA("MeshPart") then
                    if _G.Settings.MeshParts.LowerQuality then
                        Instance.RenderFidelity = 2
                        Instance.Reflectance = 0
                        Instance.Material = Enum.Material.Plastic
                    end
                    if _G.Settings.MeshParts.Invisible then
                        Instance.Transparency = 1
                        Instance.RenderFidelity = 2
                        Instance.Reflectance = 0
                        Instance.Material = Enum.Material.Plastic
                    end
                    if _G.Settings.MeshParts.NoTexture then
                        Instance.TextureID = ""
                    end
                    if _G.Settings.MeshParts.NoMesh then
                        Instance.MeshId = ""
                    end
                    if _G.Settings.MeshParts.Destroy then
                        Instance:Destroy()
                    end
                end
            end
        end

        coroutine.wrap(pcall)(function()
            if _G.Settings.Other["Low Water Graphics"] then
                if not workspace:FindFirstChildOfClass("Terrain") then
                    repeat task.wait() until workspace:FindFirstChildOfClass("Terrain")
                end
                workspace:FindFirstChildOfClass("Terrain").WaterWaveSize = 0
                workspace:FindFirstChildOfClass("Terrain").WaterWaveSpeed = 0
                workspace:FindFirstChildOfClass("Terrain").WaterReflectance = 0
                workspace:FindFirstChildOfClass("Terrain").WaterTransparency = 0
                if sethiddenproperty then
                    sethiddenproperty(workspace:FindFirstChildOfClass("Terrain"), "Decoration", false)
                end
            end
        end)

        coroutine.wrap(pcall)(function()
            if _G.Settings.Other["No Shadows"] then
                Lighting.GlobalShadows = false
                Lighting.FogEnd = 9e9
                Lighting.ShadowSoftness = 0
                if sethiddenproperty then
                    sethiddenproperty(Lighting, "Technology", 2)
                end
            end
        end)

        coroutine.wrap(pcall)(function()
            if _G.Settings.Other["Low Rendering"] then
                settings().Rendering.QualityLevel = 1
                settings().Rendering.MeshPartDetailLevel = Enum.MeshPartDetailLevel.Level04
            end
        end)

        coroutine.wrap(pcall)(function()
            if _G.Settings.Other["Reset Materials"] then
                for i, v in pairs(MaterialService:GetChildren()) do
                    v:Destroy()
                end
                MaterialService.Use2022Materials = false
            end
        end)

        coroutine.wrap(pcall)(function()
            if _G.Settings.Other["FPS Cap"] then
                if setfpscap then
                    setfpscap(tonumber(_G.Settings.Other["FPS Cap"]))
                end
            end
        end)

        game.DescendantAdded:Connect(function(value)
            wait(_G.LoadedWait or 1)
            CheckIfBad(value)
        end)

        local Descendants = game:GetDescendants()
        local StartNumber = _G.WaitPerAmount or 500
        local WaitNumber = _G.WaitPerAmount or 500
        for i, v in pairs(Descendants) do
            CheckIfBad(v)
            if i == WaitNumber then
                task.wait()
                WaitNumber = WaitNumber + StartNumber
            end
        end

        Rayfield:Notify({
            Title = "FPS Boost",
            Content = "FPS Booster Loaded!",
            Duration = 10,
            Image = 6022668888
        })
    end
})

MiscTab:CreateButton({
    Name = "Destroy GUI",
    Callback = function()
        Rayfield:Destroy()
    end
})