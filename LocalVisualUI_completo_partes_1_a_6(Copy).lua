-- 
-- PARTE 1
-- Local Visual UI
-- Parte 1: Base, ventana Visual y arrastre

local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local Lighting = game:GetService("Lighting")

local LocalPlayer = Players.LocalPlayer
local PlayerGui = LocalPlayer:WaitForChild("PlayerGui")

local GUI_NAME = "LocalVisualUI"
local DISPLAY_ORDER = 999999

local old = PlayerGui:FindFirstChild(GUI_NAME)
if old then old:Destroy() end

local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = GUI_NAME
ScreenGui.ResetOnSpawn = false
ScreenGui.IgnoreGuiInset = true
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Global
ScreenGui.DisplayOrder = DISPLAY_ORDER
ScreenGui.Parent = PlayerGui

local VisualState = {
    EnablePlayerESP = false,
    SurvivorESP = false,
    KillerESP = false,
    SpectatorESP = false,
    SurvivorItemsESP = false,
    PlayerNametags = false,
    PlayerDistanceESP = false,
    KillerWarning = false,

    ESPFillTransparency = 0.85,
    ESPOutlineTransparency = 0.2,
    ESPTextSize = 12,

    SurvivorRainbow = false,
    SurvivorNormalColor = Color3.fromRGB(0,255,0),
    SurvivorInjuredColor = Color3.fromRGB(255,170,0),
    SurvivorDownedColor = Color3.fromRGB(255,0,0),

    KillerRainbow = false,
    KillerColor = Color3.fromRGB(255,0,0),

    SpectatorRainbow = false,
    SpectatorColor = Color3.fromRGB(255,255,255),

    WorldESP = false,
    WorldNametags = false,
    WorldDistanceESP = false,
    GeneratorESP = false,
    HookESP = false,
    GateESP = false,
    WindowESP = false,
    PalletESP = false,
    SCPZombieESP = false,

    GeneratorColor = Color3.fromRGB(0,170,255),
    HookColor = Color3.fromRGB(255,0,0),
    GateColor = Color3.fromRGB(255,225,0),
    WindowColor = Color3.fromRGB(255,255,255),
    PalletColor = Color3.fromRGB(255,140,0),
    SCPZombieColor = Color3.fromRGB(128,0,128),

    NoFog = false,
    Fullbright = false
}

local function Corner(parent, radius)
    local c = Instance.new("UICorner")
    c.CornerRadius = UDim.new(0,radius)
    c.Parent = parent
    return c
end

local function Stroke(parent, transparency)
    local s = Instance.new("UIStroke")
    s.Thickness = 1
    s.Transparency = transparency or 0
    s.Color = Color3.fromRGB(70,80,100)
    s.Parent = parent
    return s
end

local function Draggable(object, handle)
    handle = handle or object
    local dragging = false
    local startInput
    local startPos

    handle.InputBegan:Connect(function(input)
        if input.UserInputType ~= Enum.UserInputType.MouseButton1
            and input.UserInputType ~= Enum.UserInputType.Touch then
            return
        end
        dragging = true
        startInput = input.Position
        startPos = object.Position
        input.Changed:Connect(function()
            if input.UserInputState == Enum.UserInputState.End then
                dragging = false
            end
        end)
    end)

    UserInputService.InputChanged:Connect(function(input)
        if not dragging then return end
        if input.UserInputType ~= Enum.UserInputType.MouseMovement
            and input.UserInputType ~= Enum.UserInputType.Touch then
            return
        end
        local d = input.Position - startInput
        object.Position = UDim2.new(
            startPos.X.Scale,startPos.X.Offset+d.X,
            startPos.Y.Scale,startPos.Y.Offset+d.Y
        )
    end)
end

local MenuButton = Instance.new("TextButton")
MenuButton.Name = "MenuButton"
MenuButton.Size = UDim2.fromOffset(56,56)
MenuButton.Position = UDim2.new(0,25,0.5,-28)
MenuButton.BackgroundColor3 = Color3.fromRGB(20,20,26)
MenuButton.BorderSizePixel = 0
MenuButton.Text = "☰"
MenuButton.TextSize = 24
MenuButton.Font = Enum.Font.GothamBold
MenuButton.TextColor3 = Color3.new(1,1,1)
MenuButton.AutoButtonColor = false
MenuButton.ZIndex = 1000
MenuButton.Parent = ScreenGui
Corner(MenuButton,14)
Stroke(MenuButton,0.15)
Draggable(MenuButton)

local Window = Instance.new("Frame")
Window.Name = "Window"
Window.Size = UDim2.fromOffset(650,455)
Window.Position = UDim2.new(0.5,-325,0.5,-227)
Window.BackgroundColor3 = Color3.fromRGB(12,20,40)
Window.BorderSizePixel = 0
Window.Visible = false
Window.ZIndex = 10
Window.Parent = ScreenGui
Corner(Window,12)
Stroke(Window,0.1)

local Header = Instance.new("Frame")
Header.Size = UDim2.new(1,0,0,48)
Header.BackgroundColor3 = Color3.fromRGB(17,29,56)
Header.BorderSizePixel = 0
Header.ZIndex = 11
Header.Parent = Window
Corner(Header,12)
Draggable(Window,Header)

local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(1,-60,1,0)
Title.Position = UDim2.fromOffset(16,0)
Title.BackgroundTransparency = 1
Title.Text = "Local Visual UI"
Title.TextColor3 = Color3.fromRGB(240,244,255)
Title.TextSize = 16
Title.Font = Enum.Font.GothamBold
Title.TextXAlignment = Enum.TextXAlignment.Left
Title.ZIndex = 12
Title.Parent = Header

local Close = Instance.new("TextButton")
Close.Size = UDim2.fromOffset(34,30)
Close.Position = UDim2.new(1,-43,0,9)
Close.BackgroundColor3 = Color3.fromRGB(35,48,78)
Close.BorderSizePixel = 0
Close.Text = "×"
Close.TextColor3 = Color3.new(1,1,1)
Close.TextSize = 20
Close.Font = Enum.Font.GothamBold
Close.AutoButtonColor = false
Close.ZIndex = 13
Close.Parent = Header
Corner(Close,7)

local Tabs = Instance.new("Frame")
Tabs.Size = UDim2.new(0,145,1,-58)
Tabs.Position = UDim2.fromOffset(10,54)
Tabs.BackgroundColor3 = Color3.fromRGB(15,26,50)
Tabs.BorderSizePixel = 0
Tabs.ZIndex = 11
Tabs.Parent = Window
Corner(Tabs,9)

local VisualTab = Instance.new("TextButton")
VisualTab.Size = UDim2.new(1,-12,0,42)
VisualTab.Position = UDim2.fromOffset(6,8)
VisualTab.BackgroundColor3 = Color3.fromRGB(35,68,125)
VisualTab.BorderSizePixel = 0
VisualTab.Text = "Visual"
VisualTab.TextColor3 = Color3.new(1,1,1)
VisualTab.TextSize = 13
VisualTab.Font = Enum.Font.GothamBold
VisualTab.AutoButtonColor = false
VisualTab.ZIndex = 12
VisualTab.Parent = Tabs
Corner(VisualTab,7)

local VisualWindow = Instance.new("ScrollingFrame")
VisualWindow.Name = "Visual"
VisualWindow.Size = UDim2.new(1,-165,1,-58)
VisualWindow.Position = UDim2.fromOffset(155,54)
VisualWindow.BackgroundColor3 = Color3.fromRGB(15,26,50)
VisualWindow.BorderSizePixel = 0
VisualWindow.ScrollBarThickness = 5
VisualWindow.AutomaticCanvasSize = Enum.AutomaticSize.Y
VisualWindow.ZIndex = 11
VisualWindow.Parent = Window
Corner(VisualWindow,9)

local Padding = Instance.new("UIPadding")
Padding.PaddingTop = UDim.new(0,10)
Padding.PaddingBottom = UDim.new(0,10)
Padding.PaddingLeft = UDim.new(0,10)
Padding.PaddingRight = UDim.new(0,10)
Padding.Parent = VisualWindow

local Layout = Instance.new("UIListLayout")
Layout.Padding = UDim.new(0,8)
Layout.SortOrder = Enum.SortOrder.LayoutOrder
Layout.Parent = VisualWindow

MenuButton.MouseButton1Click:Connect(function()
    Window.Visible = not Window.Visible
end)

Close.MouseButton1Click:Connect(function()
    Window.Visible = false
end)

task.spawn(function()
    while ScreenGui.Parent do
        ScreenGui.DisplayOrder = DISPLAY_ORDER
        task.wait(0.5)
    end
end)


-- 
-- PARTE 2
-- Parte 2: Controles Visual

local Controls = {}
local ColorPickers = {}

local function Section(parent, title)
    local frame = Instance.new("Frame")
    frame.Size = UDim2.new(1,0,0,38)
    frame.BackgroundColor3 = Color3.fromRGB(20,34,67)
    frame.BorderSizePixel = 0
    frame.ZIndex = 20
    frame.Parent = parent
    Corner(frame,8)

    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(1,-20,1,0)
    label.Position = UDim2.fromOffset(10,0)
    label.BackgroundTransparency = 1
    label.Text = title
    label.TextColor3 = Color3.fromRGB(240,244,255)
    label.TextSize = 13
    label.Font = Enum.Font.GothamBold
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.ZIndex = 21
    label.Parent = frame
    return frame
end

local function Toggle(parent, text, key)
    local b = Instance.new("TextButton")
    b.Size = UDim2.new(1,0,0,38)
    b.BackgroundColor3 = Color3.fromRGB(20,34,67)
    b.BorderSizePixel = 0
    b.Text = ""
    b.AutoButtonColor = false
    b.ZIndex = 20
    b.Parent = parent
    Corner(b,7)

    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(1,-55,1,0)
    label.Position = UDim2.fromOffset(12,0)
    label.BackgroundTransparency = 1
    label.Text = text
    label.TextColor3 = Color3.fromRGB(225,230,242)
    label.TextSize = 12
    label.Font = Enum.Font.GothamMedium
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.ZIndex = 21
    label.Parent = b

    local dot = Instance.new("Frame")
    dot.Size = UDim2.fromOffset(18,18)
    dot.Position = UDim2.new(1,-30,0.5,-9)
    dot.BackgroundColor3 = Color3.fromRGB(65,75,95)
    dot.BorderSizePixel = 0
    dot.ZIndex = 21
    dot.Parent = b
    Corner(dot,9)

    local function refresh()
        dot.BackgroundColor3 = VisualState[key]
            and Color3.fromRGB(60,210,120)
            or Color3.fromRGB(65,75,95)
    end

    b.MouseButton1Click:Connect(function()
        VisualState[key] = not VisualState[key]
        refresh()
    end)

    refresh()
    Controls[key] = {Object=b, Refresh=refresh}
    return b
end

local function Slider(parent, text, key, min, max, default, step)
    VisualState[key] = VisualState[key] or default

    local frame = Instance.new("Frame")
    frame.Size = UDim2.new(1,0,0,58)
    frame.BackgroundColor3 = Color3.fromRGB(20,34,67)
    frame.BorderSizePixel = 0
    frame.ZIndex = 20
    frame.Parent = parent
    Corner(frame,7)

    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(1,-75,0,24)
    label.Position = UDim2.fromOffset(12,4)
    label.BackgroundTransparency = 1
    label.Text = text
    label.TextColor3 = Color3.fromRGB(225,230,242)
    label.TextSize = 11
    label.Font = Enum.Font.GothamMedium
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.ZIndex = 21
    label.Parent = frame

    local valueLabel = label:Clone()
    valueLabel.Name = "Value"
    valueLabel.Size = UDim2.fromOffset(60,24)
    valueLabel.Position = UDim2.new(1,-70,0,4)
    valueLabel.TextXAlignment = Enum.TextXAlignment.Right
    valueLabel.Parent = frame

    local bar = Instance.new("Frame")
    bar.Size = UDim2.new(1,-24,0,6)
    bar.Position = UDim2.fromOffset(12,37)
    bar.BackgroundColor3 = Color3.fromRGB(55,68,94)
    bar.BorderSizePixel = 0
    bar.ZIndex = 21
    bar.Parent = frame
    Corner(bar,3)

    local fill = Instance.new("Frame")
    fill.Size = UDim2.fromScale(0,1)
    fill.BackgroundColor3 = Color3.fromRGB(70,145,255)
    fill.BorderSizePixel = 0
    fill.ZIndex = 22
    fill.Parent = bar
    Corner(fill,3)

    local hit = Instance.new("TextButton")
    hit.Size = UDim2.new(1,18,0,24)
    hit.Position = UDim2.fromOffset(-9,-9)
    hit.BackgroundTransparency = 1
    hit.Text = ""
    hit.ZIndex = 23
    hit.Parent = bar

    local dragging = false

    local function setValue(v)
        v = math.clamp(v,min,max)
        if step and step > 0 then
            v = math.floor(v/step+0.5)*step
        end
        VisualState[key] = v
        local a = (v-min)/(max-min)
        fill.Size = UDim2.fromScale(a,1)
        valueLabel.Text = tostring(v)
    end

    local function update(input)
        local x = math.clamp(
            input.Position.X-bar.AbsolutePosition.X,
            0,bar.AbsoluteSize.X
        )
        setValue(min+(x/bar.AbsoluteSize.X)*(max-min))
    end

    hit.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1
            or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true
            update(input)
        end
    end)

    UserInputService.InputChanged:Connect(function(input)
        if dragging and (
            input.UserInputType == Enum.UserInputType.MouseMovement
            or input.UserInputType == Enum.UserInputType.Touch) then
            update(input)
        end
    end)

    UserInputService.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1
            or input.UserInputType == Enum.UserInputType.Touch then
            dragging = false
        end
    end)

    setValue(VisualState[key])
    Controls[key] = {Object=frame, Set=setValue}
    return frame
end

local function Dropdown(parent, text, values, key)
    local frame = Instance.new("Frame")
    frame.Size = UDim2.new(1,0,0,42)
    frame.BackgroundColor3 = Color3.fromRGB(20,34,67)
    frame.BorderSizePixel = 0
    frame.ZIndex = 20
    frame.Parent = parent
    Corner(frame,7)

    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(0.45,0,1,0)
    label.Position = UDim2.fromOffset(12,0)
    label.BackgroundTransparency = 1
    label.Text = text
    label.TextColor3 = Color3.fromRGB(225,230,242)
    label.TextSize = 11
    label.Font = Enum.Font.GothamMedium
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.ZIndex = 21
    label.Parent = frame

    local button = Instance.new("TextButton")
    button.Size = UDim2.new(0.48,-8,0,28)
    button.Position = UDim2.new(0.48,0,0.5,-14)
    button.BackgroundColor3 = Color3.fromRGB(31,47,82)
    button.BorderSizePixel = 0
    button.Text = values[1]
    button.TextColor3 = Color3.fromRGB(230,235,245)
    button.TextSize = 10
    button.Font = Enum.Font.GothamMedium
    button.ZIndex = 21
    button.Parent = frame
    Corner(button,6)

    local index = 1
    button.MouseButton1Click:Connect(function()
        index = index % #values + 1
        button.Text = values[index]
        VisualState[key] = values[index]
    end)

    VisualState[key] = VisualState[key] or values[1]
    button.Text = VisualState[key]
    return frame
end

Section(VisualWindow,"ESP Settings")
Toggle(VisualWindow,"Enable Player ESP","EnablePlayerESP")
Slider(VisualWindow,"ESP Fill Transparency","ESPFillTransparency",0,1,0.85,0.01)
Slider(VisualWindow,"ESP Outline Transparency","ESPOutlineTransparency",0,1,0.2,0.01)
Slider(VisualWindow,"ESP Text Size","ESPTextSize",8,30,12,1)

Section(VisualWindow,"Enable Player ESP")
Toggle(VisualWindow,"Survivor ESP","SurvivorESP")
Toggle(VisualWindow,"Killer ESP","KillerESP")
Toggle(VisualWindow,"Spectator ESP","SpectatorESP")
Toggle(VisualWindow,"Survivor Items ESP","SurvivorItemsESP")
Toggle(VisualWindow,"Player Nametags","PlayerNametags")
Toggle(VisualWindow,"Player Distance ESP","PlayerDistanceESP")
Toggle(VisualWindow,"Survivor Killer Warning","KillerWarning")

Section(VisualWindow,"Survivor Color")
Toggle(VisualWindow,"Survivor Rainbow","SurvivorRainbow")

Section(VisualWindow,"Killer Color")
Toggle(VisualWindow,"Killer rainbow","KillerRainbow")

Section(VisualWindow,"Spectator Color")
Toggle(VisualWindow,"Spectator Rainbow","SpectatorRainbow")

Section(VisualWindow,"World Highlight ESP")
Toggle(VisualWindow,"Enable World ESP","WorldESP")
Dropdown(
    VisualWindow,
    "Select World Objects",
    {"Generators","Hooks","Gates","Windows","Pallets","SCP / Zombie"},
    "WorldObject"
)
Toggle(VisualWindow,"World Nametags","WorldNametags")
Toggle(VisualWindow,"World Distance ESP","WorldDistanceESP")


-- 
-- PARTE 3
-- Parte 3: Paletas HSV reales

local ActivePicker = nil
local ActiveButton = nil

local function ClosePicker()
    if ActivePicker then ActivePicker:Destroy() end
    ActivePicker = nil
    ActiveButton = nil
end

local function ColorButton(parent,text,key)
    local frame = Instance.new("Frame")
    frame.Size = UDim2.new(1,0,0,42)
    frame.BackgroundColor3 = Color3.fromRGB(20,34,67)
    frame.BorderSizePixel = 0
    frame.ZIndex = 20
    frame.Parent = parent
    Corner(frame,7)

    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(1,-72,1,0)
    label.Position = UDim2.fromOffset(12,0)
    label.BackgroundTransparency = 1
    label.Text = text
    label.TextColor3 = Color3.fromRGB(225,230,242)
    label.TextSize = 11
    label.Font = Enum.Font.GothamMedium
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.ZIndex = 21
    label.Parent = frame

    local button = Instance.new("TextButton")
    button.Size = UDim2.fromOffset(42,25)
    button.Position = UDim2.new(1,-54,0.5,-12)
    button.BackgroundColor3 = VisualState[key]
    button.BorderSizePixel = 0
    button.Text = ""
    button.AutoButtonColor = false
    button.ZIndex = 22
    button.Parent = frame
    Corner(button,6)
    Stroke(button,0.2)

    button.MouseButton1Click:Connect(function()
        if ActiveButton == button then
            ClosePicker()
            return
        end

        ClosePicker()

        local picker = Instance.new("Frame")
        picker.Size = UDim2.fromOffset(270,300)
        picker.BackgroundColor3 = Color3.fromRGB(13,24,50)
        picker.BorderSizePixel = 0
        picker.ZIndex = 500
        picker.Parent = ScreenGui
        Corner(picker,10)
        Stroke(picker,0.15)

        ActivePicker = picker
        ActiveButton = button

        local p = button.AbsolutePosition
        local s = button.AbsoluteSize
        local vp = workspace.CurrentCamera.ViewportSize
        local x = p.X+s.X+8
        local y = p.Y
        if x+270 > vp.X-6 then x = p.X-278 end
        if x < 6 then x = 6 end
        if y+300 > vp.Y-6 then y = vp.Y-306 end
        if y < 6 then y = 6 end
        picker.Position = UDim2.fromOffset(x,y)

        local title = Instance.new("TextLabel")
        title.Size = UDim2.new(1,-20,0,25)
        title.Position = UDim2.fromOffset(10,7)
        title.BackgroundTransparency = 1
        title.Text = text
        title.TextColor3 = Color3.new(1,1,1)
        title.TextSize = 12
        title.Font = Enum.Font.GothamBold
        title.TextXAlignment = Enum.TextXAlignment.Left
        title.ZIndex = 501
        title.Parent = picker

        local hue,sat,val = Color3.toHSV(VisualState[key])

        local square = Instance.new("Frame")
        square.Size = UDim2.fromOffset(240,145)
        square.Position = UDim2.fromOffset(15,42)
        square.BackgroundColor3 = Color3.fromHSV(hue,1,1)
        square.BorderSizePixel = 0
        square.ZIndex = 502
        square.Parent = picker
        Corner(square,7)

        local white = Instance.new("Frame")
        white.Size = UDim2.fromScale(1,1)
        white.BackgroundColor3 = Color3.new(1,1,1)
        white.BorderSizePixel = 0
        white.ZIndex = 503
        white.Parent = square
        Corner(white,7)

        local wg = Instance.new("UIGradient")
        wg.Transparency = NumberSequence.new({
            NumberSequenceKeypoint.new(0,0),
            NumberSequenceKeypoint.new(1,1)
        })
        wg.Parent = white

        local black = Instance.new("Frame")
        black.Size = UDim2.fromScale(1,1)
        black.BackgroundColor3 = Color3.new(0,0,0)
        black.BorderSizePixel = 0
        black.ZIndex = 504
        black.Parent = square
        Corner(black,7)

        local bg = Instance.new("UIGradient")
        bg.Rotation = 90
        bg.Transparency = NumberSequence.new({
            NumberSequenceKeypoint.new(0,1),
            NumberSequenceKeypoint.new(1,0)
        })
        bg.Parent = black

        local sb = Instance.new("TextButton")
        sb.Size = UDim2.fromScale(1,1)
        sb.BackgroundTransparency = 1
        sb.Text = ""
        sb.ZIndex = 505
        sb.Parent = square

        local cursor = Instance.new("Frame")
        cursor.Size = UDim2.fromOffset(12,12)
        cursor.AnchorPoint = Vector2.new(.5,.5)
        cursor.BackgroundTransparency = 1
        cursor.BorderSizePixel = 2
        cursor.BorderColor3 = Color3.new(1,1,1)
        cursor.ZIndex = 506
        cursor.Parent = square
        Corner(cursor,6)

        local hueBar = Instance.new("Frame")
        hueBar.Size = UDim2.fromOffset(240,18)
        hueBar.Position = UDim2.fromOffset(15,198)
        hueBar.BorderSizePixel = 0
        hueBar.ZIndex = 502
        hueBar.Parent = picker
        Corner(hueBar,9)

        local hg = Instance.new("UIGradient")
        hg.Color = ColorSequence.new({
            ColorSequenceKeypoint.new(0,Color3.fromHSV(0,1,1)),
            ColorSequenceKeypoint.new(1/6,Color3.fromHSV(1/6,1,1)),
            ColorSequenceKeypoint.new(2/6,Color3.fromHSV(2/6,1,1)),
            ColorSequenceKeypoint.new(3/6,Color3.fromHSV(3/6,1,1)),
            ColorSequenceKeypoint.new(4/6,Color3.fromHSV(4/6,1,1)),
            ColorSequenceKeypoint.new(5/6,Color3.fromHSV(5/6,1,1)),
            ColorSequenceKeypoint.new(1,Color3.fromHSV(1,1,1))
        })
        hg.Parent = hueBar

        local hb = Instance.new("TextButton")
        hb.Size = UDim2.fromScale(1,1)
        hb.BackgroundTransparency = 1
        hb.Text = ""
        hb.ZIndex = 504
        hb.Parent = hueBar

        local hc = Instance.new("Frame")
        hc.Size = UDim2.fromOffset(5,24)
        hc.AnchorPoint = Vector2.new(.5,.5)
        hc.BackgroundColor3 = Color3.new(1,1,1)
        hc.BorderSizePixel = 0
        hc.ZIndex = 505
        hc.Parent = hueBar
        Corner(hc,2)

        local rgb = Instance.new("TextLabel")
        rgb.Size = UDim2.new(1,-30,0,22)
        rgb.Position = UDim2.fromOffset(15,225)
        rgb.BackgroundTransparency = 1
        rgb.TextColor3 = Color3.fromRGB(160,177,208)
        rgb.TextSize = 10
        rgb.Font = Enum.Font.GothamMedium
        rgb.TextXAlignment = Enum.TextXAlignment.Left
        rgb.ZIndex = 502
        rgb.Parent = picker

        local draggingSquare = false
        local draggingHue = false

        local function update()
            local color = Color3.fromHSV(hue,sat,val)
            VisualState[key] = color
            button.BackgroundColor3 = color
            square.BackgroundColor3 = Color3.fromHSV(hue,1,1)
            cursor.Position = UDim2.new(sat,0,1-val,0)
            hc.Position = UDim2.new(hue,0,.5,0)
            rgb.Text = string.format(
                "RGB: %d, %d, %d",
                math.floor(color.R*255+.5),
                math.floor(color.G*255+.5),
                math.floor(color.B*255+.5)
            )
        end

        local function squareUpdate(input)
            sat = math.clamp(
                (input.Position.X-square.AbsolutePosition.X) /
                square.AbsoluteSize.X,0,1
            )
            val = 1-math.clamp(
                (input.Position.Y-square.AbsolutePosition.Y) /
                square.AbsoluteSize.Y,0,1
            )
            update()
        end

        local function hueUpdate(input)
            hue = math.clamp(
                (input.Position.X-hueBar.AbsolutePosition.X) /
                hueBar.AbsoluteSize.X,0,1
            )
            update()
        end

        sb.InputBegan:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1
                or input.UserInputType == Enum.UserInputType.Touch then
                draggingSquare = true
                squareUpdate(input)
            end
        end)

        hb.InputBegan:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1
                or input.UserInputType == Enum.UserInputType.Touch then
                draggingHue = true
                hueUpdate(input)
            end
        end)

        UserInputService.InputChanged:Connect(function(input)
            if input.UserInputType ~= Enum.UserInputType.MouseMovement
                and input.UserInputType ~= Enum.UserInputType.Touch then
                return
            end
            if draggingSquare then squareUpdate(input) end
            if draggingHue then hueUpdate(input) end
        end)

        UserInputService.InputEnded:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1
                or input.UserInputType == Enum.UserInputType.Touch then
                draggingSquare = false
                draggingHue = false
            end
        end)

        update()
    end)
end

ColorButton(VisualWindow,"Survivor normal color","SurvivorNormalColor")
ColorButton(VisualWindow,"Survivor herido color","SurvivorInjuredColor")
ColorButton(VisualWindow,"Survivor derribado color","SurvivorDownedColor")
ColorButton(VisualWindow,"Killer color","KillerColor")
ColorButton(VisualWindow,"Spectator color","SpectatorColor")
ColorButton(VisualWindow,"Generator color","GeneratorColor")
ColorButton(VisualWindow,"Hook color","HookColor")
ColorButton(VisualWindow,"Gate color","GateColor")
ColorButton(VisualWindow,"Window color","WindowColor")
ColorButton(VisualWindow,"Pallet color","PalletColor")
ColorButton(VisualWindow,"SCP / Zombie color","SCPZombieColor")

UserInputService.InputBegan:Connect(function(input)
    if not ActivePicker then return end
    if input.UserInputType ~= Enum.UserInputType.MouseButton1
        and input.UserInputType ~= Enum.UserInputType.Touch then
        return
    end

    local p = input.Position
    local a = ActivePicker.AbsolutePosition
    local s = ActivePicker.AbsoluteSize

    if p.X >= a.X and p.X <= a.X+s.X
        and p.Y >= a.Y and p.Y <= a.Y+s.Y then
        return
    end

    ClosePicker()
end)


-- 
-- PARTE 4
-- Parte 4: Lógica Visual - Player ESP

local ESPFolder = Instance.new("Folder")
ESPFolder.Name = "VisualESPObjects"
ESPFolder.Parent = ScreenGui

local PlayerObjects = {}
local WarningObjects = {}

local YELLOW_WARNING = "rbxassetid://120753562298647"
local RED_WARNING = "rbxassetid://99499680507460"

local function roleOf(player)
    local team = player.Team
    if not team then return "Unknown" end
    local n = string.lower(team.Name)
    if string.find(n,"killer",1,true) then return "Killer" end
    if string.find(n,"spect",1,true) then return "Spectator" end
    if string.find(n,"survivor",1,true) then return "Survivor" end
    return "Survivor"
end

local function rootOf(char)
    return char and (
        char:FindFirstChild("HumanoidRootPart")
        or char:FindFirstChild("UpperTorso")
        or char:FindFirstChild("Torso")
    )
end

local function distanceTo(player)
    local a = rootOf(LocalPlayer.Character)
    local b = rootOf(player.Character)
    if not a or not b then return nil end
    return (a.Position-b.Position).Magnitude
end

local function colorFor(player)
    local role = roleOf(player)
    if role == "Killer" then
        return VisualState.KillerColor
    elseif role == "Spectator" then
        return VisualState.SpectatorColor
    end
    return VisualState.SurvivorNormalColor
end

local function rainbow(t)
    return Color3.fromHSV((os.clock()%t)/t,1,1)
end

local function clearPlayer(player)
    local data = PlayerObjects[player]
    if data then
        for _,object in pairs(data) do
            if typeof(object) == "Instance" then
                pcall(function() object:Destroy() end)
            end
        end
    end
    PlayerObjects[player] = nil
end

local function makeTag(player,head)
    local tag = Instance.new("BillboardGui")
    tag.Name = "PlayerTag_"..player.UserId
    tag.AlwaysOnTop = true
    tag.LightInfluence = 0
    tag.Size = UDim2.fromOffset(240,30)
    tag.StudsOffset = Vector3.new(0,2.6,0)
    tag.Adornee = head
    tag.Parent = ESPFolder

    local text = Instance.new("TextLabel")
    text.Size = UDim2.fromScale(1,1)
    text.BackgroundTransparency = 1
    text.Font = Enum.Font.GothamBold
    text.TextStrokeTransparency = .5
    text.TextSize = VisualState.ESPTextSize
    text.Parent = tag
    return tag,text
end

local function makeWarning(player,head)
    local gui = Instance.new("BillboardGui")
    gui.Name = "KillerWarning_"..player.UserId
    gui.AlwaysOnTop = true
    gui.LightInfluence = 0
    gui.Size = UDim2.fromOffset(30,30)
    gui.StudsOffset = Vector3.new(0,4,0)
    gui.Adornee = head
    gui.Parent = ESPFolder

    local image = Instance.new("ImageLabel")
    image.Size = UDim2.fromScale(1,1)
    image.BackgroundTransparency = 1
    image.Parent = gui
    return gui,image
end

local function updatePlayer(player)
    if player == LocalPlayer then return end

    local char = player.Character
    if not char then
        clearPlayer(player)
        return
    end

    local head = char:FindFirstChild("Head")
    if not head then return end

    if not VisualState.EnablePlayerESP then
        clearPlayer(player)
        return
    end

    local role = roleOf(player)
    local enabled =
        role == "Killer" and VisualState.KillerESP
        or role == "Spectator" and VisualState.SpectatorESP
        or role == "Survivor" and VisualState.SurvivorESP

    if not enabled then
        clearPlayer(player)
        return
    end

    local color = colorFor(player)

    if role == "Survivor" and VisualState.SurvivorRainbow then
        color = rainbow(3)
    elseif role == "Killer" and VisualState.KillerRainbow then
        color = rainbow(3)
    elseif role == "Spectator" and VisualState.SpectatorRainbow then
        color = rainbow(3)
    end

    PlayerObjects[player] = PlayerObjects[player] or {}

    local highlight = PlayerObjects[player].Highlight
    if not highlight then
        highlight = Instance.new("Highlight")
        highlight.Name = "PlayerHighlight_"..player.UserId
        highlight.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
        highlight.Parent = ESPFolder
        PlayerObjects[player].Highlight = highlight
    end

    highlight.Adornee = char
    highlight.FillColor = color
    highlight.OutlineColor = color
    highlight.FillTransparency =
        math.clamp(VisualState.ESPFillTransparency,0,1)
    highlight.OutlineTransparency =
        math.clamp(VisualState.ESPOutlineTransparency,0,1)

    local tag = PlayerObjects[player].Tag
    local text = PlayerObjects[player].Text

    if VisualState.PlayerNametags
        or VisualState.PlayerDistanceESP then

        if not tag then
            tag,text = makeTag(player,head)
            PlayerObjects[player].Tag = tag
            PlayerObjects[player].Text = text
        end

        local values = {}

        if VisualState.PlayerNametags then
            table.insert(values,player.Name)
        end

        if VisualState.PlayerDistanceESP then
            local d = distanceTo(player)
            if d then
                table.insert(
                    values,
                    "["..math.floor(d).." studs]"
                )
            end
        end

        text.Text = table.concat(values," ")
        text.TextColor3 = color
        text.TextSize = VisualState.ESPTextSize
    elseif tag then
        tag:Destroy()
        PlayerObjects[player].Tag = nil
        PlayerObjects[player].Text = nil
    end

    if VisualState.KillerWarning and role == "Killer" then
        local d = distanceTo(player)
        if d and d <= 60 then
            local gui = PlayerObjects[player].Warning
            local image = PlayerObjects[player].WarningImage
            if not gui then
                gui,image = makeWarning(player,head)
                PlayerObjects[player].Warning = gui
                PlayerObjects[player].WarningImage = image
            end
            image.Image = d <= 40 and RED_WARNING or YELLOW_WARNING
        elseif PlayerObjects[player].Warning then
            PlayerObjects[player].Warning:Destroy()
            PlayerObjects[player].Warning = nil
            PlayerObjects[player].WarningImage = nil
        end
    elseif PlayerObjects[player].Warning then
        PlayerObjects[player].Warning:Destroy()
        PlayerObjects[player].Warning = nil
        PlayerObjects[player].WarningImage = nil
    end
end

Players.PlayerAdded:Connect(function(player)
    player.CharacterAdded:Connect(function()
        task.wait(.2)
        updatePlayer(player)
    end)
end)

Players.PlayerRemoving:Connect(clearPlayer)

for _,player in ipairs(Players:GetPlayers()) do
    if player ~= LocalPlayer then
        player.CharacterAdded:Connect(function()
            task.wait(.2)
            updatePlayer(player)
        end)
    end
end

task.spawn(function()
    while ScreenGui.Parent do
        for _,player in ipairs(Players:GetPlayers()) do
            if player ~= LocalPlayer then
                pcall(updatePlayer,player)
            end
        end
        task.wait(.25)
    end
end)


-- 
-- PARTE 5
-- Parte 5: Lógica Visual - World ESP

local WorldFolder = Instance.new("Folder")
WorldFolder.Name = "WorldESPObjects"
WorldFolder.Parent = ScreenGui

local worldCache = {}

local WorldTypes = {
    Generators = {
        Key = "GeneratorESP",
        Color = "GeneratorColor",
        Names = {"generator","gen"}
    },
    Hooks = {
        Key = "HookESP",
        Color = "HookColor",
        Names = {"hook","gancho"}
    },
    Gates = {
        Key = "GateESP",
        Color = "GateColor",
        Names = {"gate","exit"}
    },
    Windows = {
        Key = "WindowESP",
        Color = "WindowColor",
        Names = {"window","vault"}
    },
    Pallets = {
        Key = "PalletESP",
        Color = "PalletColor",
        Names = {"pallet"}
    },
    ["SCP / Zombie"] = {
        Key = "SCPZombieESP",
        Color = "SCPZombieColor",
        Names = {"scp","zombie"}
    }
}

local function findWorldType(object)
    local name = string.lower(object.Name)
    for typeName,data in pairs(WorldTypes) do
        for _,needle in ipairs(data.Names) do
            if string.find(name,needle,1,true) then
                return typeName,data
            end
        end
    end
end

local function removeWorld(object)
    local data = worldCache[object]
    if not data then return end
    for _,v in pairs(data) do
        if typeof(v) == "Instance" then
            pcall(function() v:Destroy() end)
        end
    end
    worldCache[object] = nil
end

local function addWorld(object)
    if not VisualState.WorldESP then
        removeWorld(object)
        return
    end

    local typeName,data = findWorldType(object)
    if not typeName or not VisualState[data.Key] then
        removeWorld(object)
        return
    end

    local adornee = object
    if object:IsA("Model") then
        adornee = object.PrimaryPart
            or object:FindFirstChildWhichIsA("BasePart",true)
    end
    if not adornee then
        removeWorld(object)
        return
    end

    worldCache[object] = worldCache[object] or {}

    local h = worldCache[object].Highlight
    if not h then
        h = Instance.new("Highlight")
        h.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
        h.Parent = WorldFolder
        worldCache[object].Highlight = h
    end

    h.Adornee = object
    h.FillColor = VisualState[data.Color]
    h.OutlineColor = VisualState[data.Color]
    h.FillTransparency = VisualState.ESPFillTransparency
    h.OutlineTransparency = VisualState.ESPOutlineTransparency

    if VisualState.WorldNametags or VisualState.WorldDistanceESP then
        local tag = worldCache[object].Tag
        local text = worldCache[object].Text

        if not tag then
            tag = Instance.new("BillboardGui")
            tag.Size = UDim2.fromOffset(220,28)
            tag.AlwaysOnTop = true
            tag.LightInfluence = 0
            tag.StudsOffset = Vector3.new(0,3,0)
            tag.Adornee = adornee
            tag.Parent = WorldFolder

            text = Instance.new("TextLabel")
            text.Size = UDim2.fromScale(1,1)
            text.BackgroundTransparency = 1
            text.Font = Enum.Font.GothamBold
            text.TextStrokeTransparency = .5
            text.Parent = tag

            worldCache[object].Tag = tag
            worldCache[object].Text = text
        end

        local parts = {}
        if VisualState.WorldNametags then
            table.insert(parts,typeName)
        end

        if VisualState.WorldDistanceESP then
            local root = rootOf(LocalPlayer.Character)
            if root then
                local d
                if adornee:IsA("BasePart") then
                    d = (root.Position-adornee.Position).Magnitude
                end
                if d then
                    table.insert(parts,"["..math.floor(d).." studs]")
                end
            end
        end

        text.Text = table.concat(parts," ")
        text.TextColor3 = VisualState[data.Color]
        text.TextSize = VisualState.ESPTextSize
    elseif worldCache[object].Tag then
        worldCache[object].Tag:Destroy()
        worldCache[object].Tag = nil
        worldCache[object].Text = nil
    end
end

local function scanWorld()
    if not VisualState.WorldESP then
        for object in pairs(worldCache) do
            removeWorld(object)
        end
        return
    end

    for _,object in ipairs(workspace:GetDescendants()) do
        local typeName = findWorldType(object)
        if typeName then
            pcall(addWorld,object)
        end
    end
end

workspace.DescendantAdded:Connect(function(object)
    task.defer(function()
        if findWorldType(object) then
            pcall(addWorld,object)
        end
    end)
end)

workspace.DescendantRemoving:Connect(function(object)
    removeWorld(object)
end)

task.spawn(function()
    while ScreenGui.Parent do
        pcall(scanWorld)
        task.wait(1)
    end
end)


-- 
-- PARTE 6
-- Parte 6: Lighting y finalización de Visual

local savedLighting = {
    Brightness = Lighting.Brightness,
    ClockTime = Lighting.ClockTime,
    GlobalShadows = Lighting.GlobalShadows,
    OutdoorAmbient = Lighting.OutdoorAmbient,
    FogStart = Lighting.FogStart,
    FogEnd = Lighting.FogEnd
}

local function applyLighting()
    if VisualState.Fullbright then
        Lighting.Brightness = 2
        Lighting.ClockTime = 14
        Lighting.GlobalShadows = false
        Lighting.OutdoorAmbient = Color3.fromRGB(128,128,128)
    else
        Lighting.Brightness = savedLighting.Brightness
        Lighting.ClockTime = savedLighting.ClockTime
        Lighting.GlobalShadows = savedLighting.GlobalShadows
        Lighting.OutdoorAmbient = savedLighting.OutdoorAmbient
    end

    if VisualState.NoFog then
        Lighting.FogStart = 0
        Lighting.FogEnd = 100000
    else
        Lighting.FogStart = savedLighting.FogStart
        Lighting.FogEnd = savedLighting.FogEnd
    end

    for _,effect in ipairs(Lighting:GetChildren()) do
        if VisualState.NoFog then
            if effect:IsA("Atmosphere") then
                effect.Density = 0
                effect.Haze = 0
                effect.Glare = 0
            elseif effect:IsA("BlurEffect") then
                effect.Size = 0
            elseif effect:IsA("SunRaysEffect") then
                effect.Enabled = false
            end
        end
    end
end

Toggle(VisualWindow,"No Fog","NoFog")
Toggle(VisualWindow,"Fullbright","Fullbright")

task.spawn(function()
    while ScreenGui.Parent do
        pcall(applyLighting)
        task.wait(.25)
    end
end)

-- Actualización inmediata de controles de estado

for key,control in pairs(Controls) do
    if control.Object then
        control.Object:SetAttribute("StateKey",key)
    end
end

-- El botón Visual siempre abre la ventana Visual.

VisualTab.MouseButton1Click:Connect(function()
    VisualWindow.Visible = true
    VisualTab.BackgroundColor3 =
        Color3.fromRGB(35,68,125)
end)

-- La ventana empieza directamente en Visual.

VisualWindow.Visible = true

-- Protección contra interfaces del juego que cambien el orden.

task.spawn(function()
    while ScreenGui.Parent do
        ScreenGui.Enabled = true
        ScreenGui.DisplayOrder = DISPLAY_ORDER
        MenuButton.Visible = true
        task.wait(.5)
    end
end)

-- Limpiar objetos visuales al destruir la interfaz.

ScreenGui.Destroying:Connect(function()
    for player in pairs(PlayerObjects) do
        clearPlayer(player)
    end

    for object in pairs(worldCache) do
        removeWorld(object)
    end

    Lighting.Brightness = savedLighting.Brightness
    Lighting.ClockTime = savedLighting.ClockTime
    Lighting.GlobalShadows = savedLighting.GlobalShadows
    Lighting.OutdoorAmbient = savedLighting.OutdoorAmbient
    Lighting.FogStart = savedLighting.FogStart
    Lighting.FogEnd = savedLighting.FogEnd
end)

print("[LocalVisualUI] Visual UI + lógica Visual cargadas.")

-- PARTE 7
-- Parte 7: Player ESP - estados, health y Survivor Items

local function findHumanoid(character)
    return character and character:FindFirstChildOfClass("Humanoid")
end

local function survivorStateColor(player, character)
    local humanoid = findHumanoid(character)
    if not humanoid then
        return VisualState.SurvivorNormalColor
    end

    if humanoid.Health <= 0 then
        return VisualState.SurvivorDownedColor
    end

    if humanoid.Health < humanoid.MaxHealth then
        return VisualState.SurvivorInjuredColor
    end

    return VisualState.SurvivorNormalColor
end

local function updateSurvivorColor(player, character, highlight, text)
    if VisualState.SurvivorRainbow then
        local c = rainbow(3)
        highlight.FillColor = c
        highlight.OutlineColor = c
        if text then
            text.TextColor3 = c
        end
        return
    end

    local c = survivorStateColor(player, character)
    highlight.FillColor = c
    highlight.OutlineColor = c
    if text then
        text.TextColor3 = c
    end
end

local function itemIsVisible(object)
    if not object or not object.Parent then
        return false
    end

    local name = string.lower(object.Name)

    return string.find(name,"item",1,true)
        or string.find(name,"medkit",1,true)
        or string.find(name,"toolbox",1,true)
        or string.find(name,"flashlight",1,true)
        or string.find(name,"key",1,true)
end

local function updateSurvivorItem(player, character)
    if not VisualState.SurvivorItemsESP then
        return
    end

    local item = character:FindFirstChildWhichIsA(
        "Tool",
        true
    )

    if not item or not itemIsVisible(item) then
        return
    end

    local handle = item:FindFirstChild("Handle")
    if not handle or not handle:IsA("BasePart") then
        return
    end

    local key = player.UserId.."_item"
    local data = PlayerObjects[player]
        or {}

    PlayerObjects[player] = data

    local tag = data[key]

    if not tag then
        tag = Instance.new("BillboardGui")
        tag.Name = "SurvivorItem_"..player.UserId
        tag.Size = UDim2.fromOffset(180,24)
        tag.StudsOffset = Vector3.new(0,1.5,0)
        tag.AlwaysOnTop = true
        tag.LightInfluence = 0
        tag.Adornee = handle
        tag.Parent = ESPFolder

        local text = Instance.new("TextLabel")
        text.Size = UDim2.fromScale(1,1)
        text.BackgroundTransparency = 1
        text.Font = Enum.Font.GothamBold
        text.TextSize = VisualState.ESPTextSize
        text.TextStrokeTransparency = .5
        text.TextColor3 =
            VisualState.SurvivorNormalColor
        text.Parent = tag

        tag:SetAttribute("ItemTag",true)
        data[key] = tag
        data[key.."Text"] = text
    end

    local label = data[key.."Text"]

    if label then
        label.Text = "Item: "..item.Name
        label.TextSize = VisualState.ESPTextSize
    end
end

local function cleanupSurvivorItem(player)
    local data = PlayerObjects[player]
    if not data then
        return
    end

    for key,value in pairs(data) do
        if typeof(value) == "Instance"
            and value:IsA("BillboardGui")
            and value:GetAttribute("ItemTag") then
            value:Destroy()
            data[key] = nil
        elseif type(key) == "string"
            and string.find(key,"_itemText",1,true)
            and typeof(value) == "Instance" then
            value:Destroy()
            data[key] = nil
        end
    end
end

local oldUpdatePlayer = updatePlayer

updatePlayer = function(player)
    oldUpdatePlayer(player)

    local character = player.Character
    if not character then
        cleanupSurvivorItem(player)
        return
    end

    local role = roleOf(player)

    if role == "Survivor"
        and VisualState.EnablePlayerESP
        and VisualState.SurvivorESP then

        local data = PlayerObjects[player]
        if data and data.Highlight then
            updateSurvivorColor(
                player,
                character,
                data.Highlight,
                data.Text
            )
        end

        updateSurvivorItem(player,character)
    else
        cleanupSurvivorItem(player)
    end
end

task.spawn(function()
    while ScreenGui.Parent do
        if VisualState.SurvivorItemsESP then
            for _,player in ipairs(Players:GetPlayers()) do
                if player ~= LocalPlayer then
                    pcall(function()
                        updateSurvivorItem(
                            player,
                            player.Character
                        )
                    end)
                end
            end
        else
            for _,player in ipairs(Players:GetPlayers()) do
                if player ~= LocalPlayer then
                    cleanupSurvivorItem(player)
                end
            end
        end
        task.wait(.25)
    end
end)

-- PARTE 8
-- Parte 8: Player ESP - atualização de estado y Killer Warning

local function refreshAllPlayers()
    for _,player in ipairs(Players:GetPlayers()) do
        if player ~= LocalPlayer then
            pcall(updatePlayer,player)
        end
    end
end

local function bindVisualRefresh(key)
    local control = Controls[key]
    if not control or not control.Object then
        return
    end

    control.Object:GetPropertyChangedSignal("Visible"):Connect(
        refreshAllPlayers
    )
end

bindVisualRefresh("EnablePlayerESP")
bindVisualRefresh("SurvivorESP")
bindVisualRefresh("KillerESP")
bindVisualRefresh("SpectatorESP")
bindVisualRefresh("SurvivorItemsESP")
bindVisualRefresh("PlayerNametags")
bindVisualRefresh("PlayerDistanceESP")
bindVisualRefresh("KillerWarning")

task.spawn(function()
    while ScreenGui.Parent do
        refreshAllPlayers()
        task.wait(.5)
    end
end)

-- Actualización específica del Killer Warning.

local function updateKillerWarnings()
    for _,player in ipairs(Players:GetPlayers()) do
        if player ~= LocalPlayer
            and roleOf(player) == "Killer" then

            local data = PlayerObjects[player]
            local distance = distanceTo(player)

            if VisualState.KillerWarning
                and VisualState.EnablePlayerESP
                and VisualState.KillerESP
                and distance then

                local character = player.Character
                local head = character
                    and character:FindFirstChild("Head")

                if head and distance <= 60 then
                    if not data then
                        data = {}
                        PlayerObjects[player] = data
                    end

                    local gui = data.Warning
                    local image = data.WarningImage

                    if not gui then
                        gui,image =
                            makeWarning(player,head)
                        data.Warning = gui
                        data.WarningImage = image
                    end

                    image.Image =
                        distance <= 40
                        and RED_WARNING
                        or YELLOW_WARNING

                    gui.Adornee = head
                elseif data and data.Warning then
                    data.Warning:Destroy()
                    data.Warning = nil
                    data.WarningImage = nil
                end
            elseif data and data.Warning then
                data.Warning:Destroy()
                data.Warning = nil
                data.WarningImage = nil
            end
        end
    end
end

task.spawn(function()
    while ScreenGui.Parent do
        pcall(updateKillerWarnings)
        task.wait(.1)
    end
end)

-- Mantener tamaños de texto sincronizados.

task.spawn(function()
    while ScreenGui.Parent do
        for _,data in pairs(PlayerObjects) do
            local text = data.Text
            if text then
                text.TextSize =
                    VisualState.ESPTextSize
            end
        end
        task.wait(.2)
    end
end)

-- PARTE 9
-- Parte 9: World ESP - selección y colores

local function refreshWorld()
    for object in pairs(worldCache) do
        pcall(addWorld,object)
    end
end

local function worldSelectionChanged()
    local selected = VisualState.WorldObject

    for typeName,data in pairs(WorldTypes) do
        VisualState[data.Key] =
            selected == typeName
    end

    refreshWorld()
end

VisualState.WorldObject =
    VisualState.WorldObject or "Generators"

worldSelectionChanged()

local worldControl = Controls.WorldObject

if worldControl and worldControl.Object then
    worldControl.Object:SetAttribute(
        "WorldSelectionControl",
        true
    )
end

-- A seleção é lida continuamente para manter a lógica sincronizada.

task.spawn(function()
    local last = VisualState.WorldObject

    while ScreenGui.Parent do
        if VisualState.WorldObject ~= last then
            last = VisualState.WorldObject
            worldSelectionChanged()
        end

        task.wait(.1)
    end
end)

-- Colores de World ESP são aplicados sem alterar HSV original.

local worldColorKeys = {
    GeneratorColor = true,
    HookColor = true,
    GateColor = true,
    WindowColor = true,
    PalletColor = true,
    SCPZombieColor = true
}

task.spawn(function()
    while ScreenGui.Parent do
        if VisualState.WorldESP then
            for object in pairs(worldCache) do
                pcall(addWorld,object)
            end
        end
        task.wait(.35)
    end
end)

-- PARTE 10
-- Parte 10: Integração final e proteção

local function forceVisualState()
    VisualState.EnablePlayerESP =
        not not VisualState.EnablePlayerESP

    VisualState.SurvivorESP =
        not not VisualState.SurvivorESP

    VisualState.KillerESP =
        not not VisualState.KillerESP

    VisualState.SpectatorESP =
        not not VisualState.SpectatorESP

    VisualState.SurvivorItemsESP =
        not not VisualState.SurvivorItemsESP

    VisualState.PlayerNametags =
        not not VisualState.PlayerNametags

    VisualState.PlayerDistanceESP =
        not not VisualState.PlayerDistanceESP

    VisualState.KillerWarning =
        not not VisualState.KillerWarning

    VisualState.WorldESP =
        not not VisualState.WorldESP

    VisualState.WorldNametags =
        not not VisualState.WorldNametags

    VisualState.WorldDistanceESP =
        not not VisualState.WorldDistanceESP
end

forceVisualState()

-- Recalcular quando o personagem local reaparece.

LocalPlayer.CharacterAdded:Connect(function()
    task.wait(.5)
    refreshAllPlayers()
    refreshWorld()
end)

-- Se a janela for ocultada por alguma rotina externa,
-- o botão continua disponible para recuperarla.

MenuButton.Visible = true
MenuButton.Active = true

task.spawn(function()
    while ScreenGui.Parent do
        if not ScreenGui.Enabled then
            ScreenGui.Enabled = true
        end

        ScreenGui.DisplayOrder = DISPLAY_ORDER
        MenuButton.Visible = true

        task.wait(.5)
    end
end)

print("[LocalVisualUI] Partes 7-10 carregadas.")
