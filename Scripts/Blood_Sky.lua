local Lighting = game:GetService("Lighting")

local sky = Lighting:FindFirstChildOfClass("Sky") or Instance.new("Sky", Lighting)

Lighting.Atmosphere.Density = 0.3
Lighting.Atmosphere.Offset = 0.25
Lighting.Atmosphere.Color = Color3.fromRGB(150, 0, 0)
Lighting.Atmosphere.Decay = Color3.fromRGB(100, 0, 0)
Lighting.Atmosphere.Glare = 0.5
Lighting.Atmosphere.Haze = 0.2

sky.SkyboxBk = "rbxassetid://401664839"
sky.SkyboxDn = "rbxassetid://401664862"
sky.SkyboxFt = "rbxassetid://401664960"
sky.SkyboxLf = "rbxassetid://401664881"
sky.SkyboxRt = "rbxassetid://401664901"
sky.SkyboxUp = "rbxassetid://401664936"

Lighting.OutdoorAmbient = Color3.fromRGB(80, 0, 0)
Lighting.ColorShift_Top = Color3.fromRGB(120, 0, 0)
Lighting.ColorShift_Bottom = Color3.fromRGB(60, 0, 0)
Lighting.Brightness = 1.5
Lighting.GlobalShadows = true
Lighting.ExposureCompensation = 0.3

Lighting.SunRays.Intensity = 0.1
Lighting.SunRays.Spread = 0.5