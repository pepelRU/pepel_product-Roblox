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

local MainTab = Window:CreateTab("Main", "info")
MainTab:CreateSection("Main Features")

local supported = (game.PlaceId == 117289497495248) or (game.PlaceId == 13253735473)
local statusText = supported and "Supported" or "Unsupported"
local statusColor = supported and Color3.fromRGB(0, 255, 0) or Color3.fromRGB(255, 0, 0)

MainTab:CreateLabel("Place status: "..statusText)

if supported then
    MainTab:CreateButton({
        Name = "Load Script",
        Callback = function()
            loadstring(game:HttpGet("https://raw.githubusercontent.com/pepelRU/pepel_product-Roblox/refs/heads/main/Scripts/Trident.lua", true))()
            Rayfield:Destroy()
        end
    })
end

MainTab:CreateButton({
    Name = "Destroy GUI",
    Callback = function()
        Rayfield:Destroy()
    end
})

local UniversalTab = Window:CreateTab("Universal", "settings")
UniversalTab:CreateSection("Universal Features")

UniversalTab:CreateButton({
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