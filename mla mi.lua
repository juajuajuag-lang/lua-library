local Players=game:GetService("Players")
local UIS=game:GetService("UserInputService")
local LP=Players.LocalPlayer

local GUI=Instance.new("ScreenGui")
GUI.Name="KysHub_LocalUI"
GUI.ResetOnSpawn=false
GUI.IgnoreGuiInset=true
GUI.ZIndexBehavior=Enum.ZIndexBehavior.Global
GUI.Parent=LP:WaitForChild("PlayerGui")

local RED=Color3.fromRGB(255,0,0)
local RED_DARK=Color3.fromRGB(100,0,0)
local BLACK=Color3.fromRGB(8,8,10)
local PANEL=Color3.fromRGB(20,22,27)
local PANEL2=Color3.fromRGB(15,17,21)
local WHITE=Color3.fromRGB(245,245,245)
local GRAY=Color3.fromRGB(165,165,170)

local function Corner(o,r)
    local c=Instance.new("UICorner")
    c.CornerRadius=UDim.new(0,r or 8)
    c.Parent=o
end

local function Stroke(o,color,thickness)
    local s=Instance.new("UIStroke")
    s.Color=color or RED_DARK
    s.Thickness=thickness or 1
    s.Transparency=.25
    s.Parent=o
end

local function Label(p,text,size,color,bold)
    local l=Instance.new("TextLabel")
    l.BackgroundTransparency=1
    l.Text=text
    l.TextColor3=color or WHITE
    l.TextSize=size or 14
    l.Font=bold and Enum.Font.GothamBold or Enum.Font.Gotham
    l.TextXAlignment=Enum.TextXAlignment.Left
    l.Parent=p
    return l
end

local function Button(p,text)
    local b=Instance.new("TextButton")
    b.AutoButtonColor=false
    b.BackgroundColor3=PANEL2
    b.Text=text
    b.TextColor3=WHITE
    b.TextSize=13
    b.Font=Enum.Font.GothamMedium
    b.Parent=p
    Corner(b,6)
    return b
end

local Scale=Instance.new("UIScale")
Scale.Scale=.85
Scale.Parent=GUI

local OpenButton=Instance.new("ImageButton")
OpenButton.Name="OpenButton"
OpenButton.Size=UDim2.fromOffset(48,48)
OpenButton.Position=UDim2.new(0,15,.5,-24)
OpenButton.BackgroundTransparency=1
OpenButton.Image="rbxassetid://80891639562743"
OpenButton.Visible=false
OpenButton.Active=true
OpenButton.Parent=GUI

local Main=Instance.new("Frame")
Main.Name="Main"
Main.Size=UDim2.fromOffset(500,320)
Main.Position=UDim2.new(.5,-250,.5,-160)
Main.BackgroundColor3=BLACK
Main.Parent=GUI
Corner(Main,10)
Stroke(Main,RED_DARK,1)

local Header=Instance.new("Frame")
Header.Size=UDim2.new(1,0,0,48)
Header.BackgroundColor3=PANEL
Header.Parent=Main
Corner(Header,10)

local Title=Label(
    Header,
    "KysHub CRACKED√ by <iry hub>",
    15,
    WHITE,
    true
)
Title.Position=UDim2.fromOffset(15,7)
Title.Size=UDim2.new(1,-110,0,20)

local ContentTitle=Label(
    Header,
    "Violence District v1.5.7",
    11,
    GRAY
)
ContentTitle.Position=UDim2.fromOffset(15,27)
ContentTitle.Size=UDim2.new(1,-110,0,16)

local Min=Button(Header,"—")
Min.Size=UDim2.fromOffset(32,28)
Min.Position=UDim2.new(1,-72,0,10)

local Close=Button(Header,"×")
Close.Size=UDim2.fromOffset(32,28)
Close.Position=UDim2.new(1,-36,0,10)

local Side=Instance.new("Frame")
Side.Name="Sidebar"
Side.Position=UDim2.fromOffset(0,48)
Side.Size=UDim2.new(0,112,1,-48)
Side.BackgroundColor3=PANEL2
Side.Parent=Main

local SideLayout=Instance.new("UIListLayout")
SideLayout.Padding=UDim.new(0,5)
SideLayout.HorizontalAlignment=Enum.HorizontalAlignment.Center
SideLayout.Parent=Side

local SidePad=Instance.new("UIPadding")
SidePad.PaddingTop=UDim.new(0,10)
SidePad.PaddingLeft=UDim.new(0,7)
SidePad.PaddingRight=UDim.new(0,7)
SidePad.Parent=Side

local Content=Instance.new("Frame")
Content.Name="Content"
Content.Position=UDim2.fromOffset(112,48)
Content.Size=UDim2.new(1,-112,1,-48)
Content.BackgroundColor3=BLACK
Content.Parent=Main

local Pages={}
local NavButtons={}

local function CreatePage(name)
    local p=Instance.new("ScrollingFrame")
    p.Name=name.."Page"
    p.Size=UDim2.new(1,0,1,0)
    p.BackgroundTransparency=1
    p.BorderSizePixel=0
    p.ScrollBarThickness=4
    p.ScrollBarImageColor3=RED
    p.CanvasSize=UDim2.new(0,0,0,0)
    p.AutomaticCanvasSize=Enum.AutomaticSize.Y
    p.Visible=false
    p.Parent=Content

    local pad=Instance.new("UIPadding")
    pad.PaddingTop=UDim.new(0,14)
    pad.PaddingLeft=UDim.new(0,12)
    pad.PaddingRight=UDim.new(0,12)
    pad.PaddingBottom=UDim.new(0,12)
    pad.Parent=p

    local layout=Instance.new("UIListLayout")
    layout.Padding=UDim.new(0,8)
    layout.Parent=p

    Pages[name]=p
    return p
end

local Dashboard=CreatePage("Dashboard")
local Visual=CreatePage("Visual")
local MainPage=CreatePage("Main")
local Aim=CreatePage("Aim")
local Mapping=CreatePage("Mapping")
local PlayerPage=CreatePage("Player")

local function AddSection(parent,title,height)
    local box=Instance.new("Frame")
    box.Size=UDim2.new(1,-4,0,height or 58)
    box.BackgroundColor3=PANEL
    box.Parent=parent
    Corner(box,7)
    Stroke(box,RED_DARK,1)

    local t=Label(box,title,14,WHITE,true)
    t.Position=UDim2.fromOffset(12,8)
    t.Size=UDim2.new(1,-24,0,20)

    return box
end

-- DASHBOARD

local DashTop=Instance.new("Frame")
DashTop.Size=UDim2.new(1,-4,0,8)
DashTop.BackgroundTransparency=1
DashTop.Parent=Dashboard

local Profile=Instance.new("Frame")
Profile.Size=UDim2.new(1,-4,0,100)
Profile.BackgroundColor3=PANEL
Profile.Parent=Dashboard
Corner(Profile,7)
Stroke(Profile,RED_DARK,1)

local ProfileTitle=Label(
    Profile,
    "Dashboard / Home",
    14,
    WHITE,
    true
)
ProfileTitle.Position=UDim2.fromOffset(12,8)
ProfileTitle.Size=UDim2.new(1,-24,0,20)

local Avatar=Instance.new("ImageLabel")
Avatar.BackgroundColor3=PANEL2
Avatar.Size=UDim2.fromOffset(52,52)
Avatar.Position=UDim2.fromOffset(12,37)
Avatar.Parent=Profile
Corner(Avatar,6)
Stroke(Avatar,RED_DARK,1)

local ok,img=pcall(function()
    return Players:GetUserThumbnailAsync(
        LP.UserId,
        Enum.ThumbnailType.AvatarBust,
        Enum.ThumbnailSize.Size150x150
    )
end)

if ok then
    Avatar.Image=img
end

local UserText=Label(
    Profile,
    LP.DisplayName,
    14,
    WHITE,
    true
)
UserText.Position=UDim2.fromOffset(76,37)
UserText.Size=UDim2.new(1,-88,0,18)

local Username=Label(
    Profile,
    "@"..LP.Name,
    11,
    GRAY
)
Username.Position=UDim2.fromOffset(76,56)
Username.Size=UDim2.new(1,-88,0,16)

local UserInfo=Label(
    Profile,
    "ID: "..LP.UserId.."   •   "..LP.AccountAge.." days",
    10,
    GRAY
)
UserInfo.Position=UDim2.fromOffset(76,74)
UserInfo.Size=UDim2.new(1,-88,0,16)

local Details=AddSection(Dashboard,"Details",70)

local DText=Label(
    Details,
    "KysHub crack Violence District Script\nVersion: v1.5.7",
    12,
    GRAY
)
DText.Position=UDim2.fromOffset(12,30)
DText.Size=UDim2.new(1,-24,0,35)

local Supported=AddSection(Dashboard,"Supported Executors",70)

local SText=Label(
    Supported,
    "Delta  •  Synapse X  •  Krnl\nCodex  •  Arceus X",
    12,
    GRAY
)
SText.Position=UDim2.fromOffset(12,30)
SText.Size=UDim2.new(1,-24,0,35)

local Unsupported=AddSection(Dashboard,"Unsupported",58)

local UText=Label(
    Unsupported,
    "Roblox Studio",
    12,
    GRAY
)
UText.Position=UDim2.fromOffset(12,31)
UText.Size=UDim2.new(1,-24,0,20)

-- PLACEHOLDER DE LAS DEMAS PAGINAS

local function EmptyPage(page,name)
    local box=AddSection(page,name,75)

    local text=Label(
        box,
        "Esta sección está preparada.\nSu contenido se agregará en la siguiente parte.",
        12,
        GRAY
    )
    text.Position=UDim2.fromOffset(12,30)
    text.Size=UDim2.new(1,-24,0,40)
end

EmptyPage(MainPage,"Main")
EmptyPage(Aim,"Aim")
EmptyPage(Mapping,"Mapping")
EmptyPage(PlayerPage,"Player")

local function SelectPage(name)
    for n,p in pairs(Pages) do
        p.Visible=(n==name)
    end

    for n,b in pairs(NavButtons) do
        if n==name then
            b.BackgroundColor3=RED_DARK
            b.TextColor3=WHITE
        else
            b.BackgroundColor3=PANEL2
            b.TextColor3=GRAY
        end
    end
end

local function AddNav(name)
    local b=Button(Side,name)
    b.Size=UDim2.new(1,0,0,34)
    NavButtons[name]=b

    b.MouseButton1Click:Connect(function()
        SelectPage(name)
    end)
end

AddNav("Dashboard")
AddNav("Visual")
AddNav("Main")
AddNav("Aim")
AddNav("Mapping")
AddNav("Player")

local function SetVisible(value)
    Main.Visible=value
    OpenButton.Visible=not value
end

Min.MouseButton1Click:Connect(function()
    SetVisible(false)
end)

Close.MouseButton1Click:Connect(function()
    GUI:Destroy()
end)

-- ARRASTRAR MENU

local dragging=false
local dragStart
local startPos

Header.InputBegan:Connect(function(input)
    if input.UserInputType~=Enum.UserInputType.MouseButton1
    and input.UserInputType~=Enum.UserInputType.Touch then
        return
    end

    dragging=true
    dragStart=input.Position
    startPos=Main.Position
end)

UIS.InputChanged:Connect(function(input)
    if not dragging then return end

    if input.UserInputType~=Enum.UserInputType.MouseMovement
    and input.UserInputType~=Enum.UserInputType.Touch then
        return
    end

    local delta=input.Position-dragStart

    Main.Position=UDim2.new(
        startPos.X.Scale,
        startPos.X.Offset+delta.X,
        startPos.Y.Scale,
        startPos.Y.Offset+delta.Y
    )
end)

UIS.InputEnded:Connect(function(input)
    if input.UserInputType==Enum.UserInputType.MouseButton1
    or input.UserInputType==Enum.UserInputType.Touch then
        dragging=false
    end
end)

-- ARRASTRAR BOTON DE APERTURA

local openDragging=false
local openMoved=false
local openInput
local openStart
local openStartPos

OpenButton.InputBegan:Connect(function(input)
    if input.UserInputType~=Enum.UserInputType.MouseButton1
    and input.UserInputType~=Enum.UserInputType.Touch then
        return
    end

    openDragging=true
    openMoved=false
    openInput=input
    openStart=input.Position
    openStartPos=OpenButton.Position
end)

UIS.InputChanged:Connect(function(input)
    if not openDragging then return end

    if input.UserInputType~=Enum.UserInputType.MouseMovement
    and input.UserInputType~=Enum.UserInputType.Touch then
        return
    end

    local delta=input.Position-openStart

    if math.abs(delta.X)>5 or math.abs(delta.Y)>5 then
        openMoved=true
    end

    OpenButton.Position=UDim2.new(
        openStartPos.X.Scale,
        openStartPos.X.Offset+delta.X,
        openStartPos.Y.Scale,
        openStartPos.Y.Offset+delta.Y
    )
end)

UIS.InputEnded:Connect(function(input)
    if not openDragging then return end

    if input==openInput
    or input.UserInputType==Enum.UserInputType.MouseButton1
    or input.UserInputType==Enum.UserInputType.Touch then

        if not openMoved then
            SetVisible(true)
        end

        openDragging=false
        openInput=nil
    end
end)

-- REDIMENSIONAR

local resizing=false
local resizeStart
local resizeScale

local Resize=Instance.new("TextButton")
Resize.Size=UDim2.fromOffset(18,18)
Resize.Position=UDim2.new(1,-18,1,-18)
Resize.BackgroundTransparency=1
Resize.Text="◢"
Resize.TextColor3=GRAY
Resize.TextSize=12
Resize.Parent=Main

Resize.InputBegan:Connect(function(input)
    if input.UserInputType~=Enum.UserInputType.MouseButton1
    and input.UserInputType~=Enum.UserInputType.Touch then
        return
    end

    resizing=true
    resizeStart=input.Position
    resizeScale=Scale.Scale
end)

UIS.InputChanged:Connect(function(input)
    if not resizing then return end

    if input.UserInputType~=Enum.UserInputType.MouseMovement
    and input.UserInputType~=Enum.UserInputType.Touch then
        return
    end

    local delta=input.Position-resizeStart
    local value=resizeScale+(delta.X+delta.Y)/500

    Scale.Scale=math.clamp(value,.7,1.5)
end)

UIS.InputEnded:Connect(function(input)
    if input.UserInputType==Enum.UserInputType.MouseButton1
    or input.UserInputType==Enum.UserInputType.Touch then
        resizing=false
    end
end)

SelectPage("Dashboard")
SetVisible(true)

--==================================================
-- PART 2 / 3
-- VISUAL > ESP / CAMERA / LIGHTING
-- PARTE 1/3
-- LOCAL UI ONLY
--==================================================

for _,obj in ipairs(Visual:GetChildren()) do
    obj:Destroy()
end

--==================================================
-- STATE
--==================================================

local VisualState={
    ESP={
        FillTransparency=.95,
        OutlineTransparency=.3,
        TextSize=12,

        PlayerESP=false,
        PlayerTypes={},
        Nametags=false,
        DistanceESP=false,
        KillerWarning=false,

        SurvivorColor=Color3.fromRGB(0,255,0),
        KillerColor=Color3.fromRGB(255,0,0),
        SpectatorColor=Color3.fromRGB(255,255,255),

        WorldESP=false,
        WorldTypes={},
        WorldNametags=false,
        WorldDistanceESP=false,

        GeneratorColor=Color3.fromRGB(0,170,255),
        HookColor=Color3.fromRGB(255,0,0),
        GateColor=Color3.fromRGB(255,225,0),
        WindowColor=Color3.fromRGB(255,255,255),
        PalletColor=Color3.fromRGB(255,140,0),
        SCPZombieColor=Color3.fromRGB(128,0,128)
    },

    Camera={
        FOVEnabled=false,
        FOV=70,
        ThirdPerson=false,
        ShiftLock=false,
        InfinityZoom=false,
        NoCutscene=false
    },

    Lighting={
        FullBright=false,
        NoFog=false,
        NoShadows=false,
        NoColorCorrection=false,
        RemoveAtmosphere=false,
        RemoveBloom=false,
        RemoveBlur=false,
        DisableWeather=false,
        Weather="Default",
        Sky="Default"
    }
}

getgenv().KYS_LocalVisualState=VisualState

--==================================================
-- SUB TABS
--==================================================

local SubTabs=Instance.new("Frame")
SubTabs.Name="VisualSubTabs"
SubTabs.Size=UDim2.new(1,-4,0,38)
SubTabs.BackgroundColor3=PANEL
SubTabs.Parent=Visual

Corner(SubTabs,7)
Stroke(SubTabs,RED_DARK,1)

local SubLayout=Instance.new("UIListLayout")
SubLayout.FillDirection=Enum.FillDirection.Horizontal
SubLayout.HorizontalAlignment=Enum.HorizontalAlignment.Center
SubLayout.VerticalAlignment=Enum.VerticalAlignment.Center
SubLayout.Padding=UDim.new(0,5)
SubLayout.Parent=SubTabs

local SubPad=Instance.new("UIPadding")
SubPad.PaddingLeft=UDim.new(0,6)
SubPad.PaddingRight=UDim.new(0,6)
SubPad.Parent=SubTabs

local VisualPages=Instance.new("Frame")
VisualPages.Name="VisualPages"
VisualPages.Size=UDim2.new(1,0,1,-46)
VisualPages.Position=UDim2.fromOffset(0,46)
VisualPages.BackgroundTransparency=1
VisualPages.ClipsDescendants=false
VisualPages.Parent=Visual

--==================================================
-- PAGE CREATOR
--==================================================

local function MakePage(name)
    local p=Instance.new("ScrollingFrame")
    p.Name=name
    p.Size=UDim2.new(1,0,1,0)
    p.BackgroundTransparency=1
    p.BorderSizePixel=0
    p.ScrollBarThickness=4
    p.ScrollBarImageColor3=RED
    p.AutomaticCanvasSize=Enum.AutomaticSize.Y
    p.CanvasSize=UDim2.new()
    p.ClipsDescendants=false
    p.Visible=true
    p.Parent=VisualPages

    local pad=Instance.new("UIPadding")
    pad.PaddingTop=UDim.new(0,8)
    pad.PaddingLeft=UDim.new(0,2)
    pad.PaddingRight=UDim.new(0,2)
    pad.PaddingBottom=UDim.new(0,10)
    pad.Parent=p

    local list=Instance.new("UIListLayout")
    list.Padding=UDim.new(0,8)
    list.Parent=p

    return p
end

local ESPPage=MakePage("ESP")
local CameraPage=MakePage("Camera")
local LightingPage=MakePage("Lighting")

CameraPage.Visible=false
LightingPage.Visible=false

--==================================================
-- SUB BUTTONS
--==================================================

local SubButtons={}

local function SubButton(name)
    local b=Button(SubTabs,name)

    b.Size=UDim2.fromOffset(90,28)

    SubButtons[name]=b

    return b
end

local ESPTab=SubButton("ESP")
local CameraTab=SubButton("Camera")
local LightingTab=SubButton("Lighting")

local function SelectSub(name)
    ESPPage.Visible=name=="ESP"
    CameraPage.Visible=name=="Camera"
    LightingPage.Visible=name=="Lighting"

    for n,b in pairs(SubButtons) do
        if n==name then
            b.BackgroundColor3=RED_DARK
            b.TextColor3=WHITE
        else
            b.BackgroundColor3=PANEL2
            b.TextColor3=GRAY
        end
    end
end

ESPTab.MouseButton1Click:Connect(function()
    SelectSub("ESP")
end)

CameraTab.MouseButton1Click:Connect(function()
    SelectSub("Camera")
end)

LightingTab.MouseButton1Click:Connect(function()
    SelectSub("Lighting")
end)

--==================================================
-- POPUP MANAGER
--==================================================

local ActivePopup=nil
local ActiveOwner=nil

local function ClosePopup()
    if ActivePopup then
        ActivePopup.Visible=false
    end

    ActivePopup=nil
    ActiveOwner=nil
end

local function OpenPopup(popup,owner)
    if ActivePopup and ActivePopup~=popup then
        ActivePopup.Visible=false
    end

    ActivePopup=popup
    ActiveOwner=owner
    popup.Visible=true
end

local function PointInside(gui,x,y)
    if not gui or not gui.Visible then
        return false
    end

    local p=gui.AbsolutePosition
    local s=gui.AbsoluteSize

    return x>=p.X
        and x<=p.X+s.X
        and y>=p.Y
        and y<=p.Y+s.Y
end

UIS.InputBegan:Connect(function(input)
    if input.UserInputType~=Enum.UserInputType.MouseButton1
    and input.UserInputType~=Enum.UserInputType.Touch then
        return
    end

    if not ActivePopup then
        return
    end

    local pos=input.Position

    if PointInside(ActivePopup,pos.X,pos.Y) then
        return
    end

    if ActiveOwner and PointInside(ActiveOwner,pos.X,pos.Y) then
        return
    end

    ClosePopup()
end)

--==================================================
-- SECTION
--==================================================

local function Section(page,title,height)
    local box=Instance.new("Frame")

    box.Size=UDim2.new(1,-4,0,height)
    box.BackgroundColor3=PANEL
    box.Parent=page

    Corner(box,7)
    Stroke(box,RED_DARK,1)

    local t=Label(box,title,14,WHITE,true)

    t.Position=UDim2.fromOffset(12,8)
    t.Size=UDim2.new(1,-24,0,20)

    return box
end

--==================================================
-- TOGGLE
--==================================================

local function Toggle(parent,text,y,callback)
    local b=Button(parent,"OFF  "..text)

    b.Position=UDim2.fromOffset(10,y)
    b.Size=UDim2.new(1,-20,0,28)

    local state=false

    b.MouseButton1Click:Connect(function()
        state=not state

        b.Text=(state and "ON   " or "OFF  ")..text
        b.BackgroundColor3=state and RED_DARK or PANEL2

        if callback then
            callback(state)
        end
    end)

    return b
end

--==================================================
-- SLIDER
--==================================================

local function Slider(parent,text,y,min,max,default,callback)
    local holder=Instance.new("Frame")

    holder.Size=UDim2.new(1,-20,0,45)
    holder.Position=UDim2.fromOffset(10,y)
    holder.BackgroundTransparency=1
    holder.Parent=parent

    local title=Label(holder,text,11,WHITE)

    title.Size=UDim2.new(1,-50,0,18)

    local value=Label(holder,tostring(default),11,GRAY)

    value.Position=UDim2.new(1,-45,0,0)
    value.Size=UDim2.fromOffset(45,18)
    value.TextXAlignment=Enum.TextXAlignment.Right

    local bar=Instance.new("Frame")

    bar.Position=UDim2.fromOffset(0,25)
    bar.Size=UDim2.new(1,0,0,7)
    bar.BackgroundColor3=PANEL2
    bar.Parent=holder

    Corner(bar,4)

    local fill=Instance.new("Frame")

    fill.BackgroundColor3=RED
    fill.Size=UDim2.new(
        math.clamp((default-min)/(max-min),0,1),
        0,1,0
    )
    fill.Parent=bar

    Corner(fill,4)

    local dragging=false

    local function Set(input)
        if bar.AbsoluteSize.X<=0 then
            return
        end

        local alpha=math.clamp(
            (input.Position.X-bar.AbsolutePosition.X)/
            bar.AbsoluteSize.X,
            0,1
        )

        local v=min+(max-min)*alpha

        if max<=1 then
            v=math.floor(v*100+.5)/100
        else
            v=math.floor(v+.5)
        end

        fill.Size=UDim2.new(
            math.clamp((v-min)/(max-min),0,1),
            0,1,0
        )

        value.Text=tostring(v)

        if callback then
            callback(v)
        end
    end

    bar.InputBegan:Connect(function(input)
        if input.UserInputType==Enum.UserInputType.MouseButton1
        or input.UserInputType==Enum.UserInputType.Touch then

            dragging=true
            Set(input)
        end
    end)

    UIS.InputChanged:Connect(function(input)
        if not dragging then
            return
        end

        if input.UserInputType==Enum.UserInputType.MouseMovement
        or input.UserInputType==Enum.UserInputType.Touch then

            Set(input)
        end
    end)

    UIS.InputEnded:Connect(function(input)
        if input.UserInputType==Enum.UserInputType.MouseButton1
        or input.UserInputType==Enum.UserInputType.Touch then

            dragging=false
        end
    end)

    return holder
end

--==================================================
-- PART 2 / 3
-- PARTE 2/3
-- DROPDOWNS + COLOR PICKER
--==================================================

--==================================================
-- MULTI SELECT DROPDOWN
--==================================================

local function MultiDropdown(parent,title,y,values,default,callback)

    local holder=Instance.new("Frame")

    holder.Size=UDim2.new(1,-20,0,34)
    holder.Position=UDim2.fromOffset(10,y)
    holder.BackgroundTransparency=1
    holder.Parent=parent

    local selected={}

    for _,v in ipairs(default or {}) do
        selected[v]=true
    end

    local button=Button(holder,title)

    button.Size=UDim2.new(1,0,0,32)
    button.TextXAlignment=Enum.TextXAlignment.Left

    --==============================================
    -- POPUP
    --==============================================

    local list=Instance.new("ScrollingFrame")

    list.Name="MultiDropdownPopup"
    list.Visible=false
    list.BackgroundColor3=PANEL
    list.BorderSizePixel=0
    list.ZIndex=100
    list.ScrollBarThickness=4
    list.ScrollBarImageColor3=RED
    list.CanvasSize=UDim2.new()
    list.AutomaticCanvasSize=Enum.AutomaticSize.Y
    list.ClipsDescendants=true
    list.Parent=VisualPages

    Corner(list,6)
    Stroke(list,RED_DARK,1)

    local layout=Instance.new("UIListLayout")

    layout.Padding=UDim.new(0,2)
    layout.Parent=list

    local pad=Instance.new("UIPadding")

    pad.PaddingTop=UDim.new(0,5)
    pad.PaddingBottom=UDim.new(0,5)
    pad.PaddingLeft=UDim.new(0,5)
    pad.PaddingRight=UDim.new(0,5)

    pad.Parent=list

    --==============================================
    -- TEXT
    --==============================================

    local function UpdateText()
        local chosen={}

        for _,v in ipairs(values) do
            if selected[v] then
                table.insert(chosen,v)
            end
        end

        if #chosen==0 then
            button.Text=title
        else
            button.Text=title.."  •  "..table.concat(chosen,", ")
        end
    end

    --==============================================
    -- OPTIONS
    --==============================================

    for _,option in ipairs(values) do

        local item=Button(
            list,
            (selected[option] and "✓  " or "    ")..option
        )

        item.Size=UDim2.new(1,0,0,28)
        item.ZIndex=101
        item.TextXAlignment=Enum.TextXAlignment.Left

        if selected[option] then
            item.BackgroundColor3=RED_DARK
        end

        item.MouseButton1Click:Connect(function()

            selected[option]=not selected[option]

            item.Text=
                (selected[option] and "✓  " or "    ")..
                option

            item.BackgroundColor3=
                selected[option]
                and RED_DARK
                or PANEL2

            UpdateText()

            if callback then
                callback(selected)
            end
        end)
    end

    --==============================================
    -- POSITION
    --==============================================

    local function PositionPopup()

        local bp=button.AbsolutePosition
        local bs=button.AbsoluteSize

        local vp=VisualPages.AbsolutePosition
        local vs=VisualPages.AbsoluteSize

        local width=math.max(bs.X,200)

        -- máximo visible para Android
        local maxHeight=190

        local wantedHeight=#values*30+10
        local height=math.min(wantedHeight,maxHeight)

        local x=bp.X-vp.X
        local y=bp.Y-vp.Y+bs.Y+4

        if y+height>vs.Y then
            y=bp.Y-vp.Y-height-4
        end

        if x+width>vs.X then
            x=vs.X-width-4
        end

        if x<0 then
            x=0
        end

        if y<0 then
            y=0
        end

        list.Size=UDim2.fromOffset(width,height)
        list.Position=UDim2.fromOffset(x,y)
    end

    --==============================================
    -- OPEN / CLOSE
    --==============================================

    button.MouseButton1Click:Connect(function()

        if list.Visible then
            ClosePopup()
            return
        end

        PositionPopup()
        OpenPopup(list,holder)
    end)

    UpdateText()

    return holder
end

--==================================================
-- COLOR PICKER
--==================================================

local function ColorPicker(parent,name,y,default,callback)

    local holder=Instance.new("Frame")

    holder.Size=UDim2.new(1,-20,0,38)
    holder.Position=UDim2.fromOffset(10,y)
    holder.BackgroundTransparency=1
    holder.Parent=parent

    --==============================================
    -- NAME BUTTON
    --==============================================

    local labelButton=Button(holder,name)

    labelButton.Size=UDim2.new(1,-48,0,32)
    labelButton.TextXAlignment=Enum.TextXAlignment.Left

    -- El texto NO abre el picker.

    --==============================================
    -- COLOR SWATCH
    --==============================================

    local preview=Instance.new("TextButton")

    preview.Name="ColorPreview"
    preview.AutoButtonColor=false
    preview.Text=""
    preview.Size=UDim2.fromOffset(32,32)
    preview.Position=UDim2.new(1,-32,0,0)
    preview.BackgroundColor3=default
    preview.BorderSizePixel=0
    preview.Parent=holder

    Corner(preview,6)
    Stroke(preview,WHITE,1)

    --==============================================
    -- POPUP
    --==============================================

    local popup=Instance.new("Frame")

    popup.Name="CompactColorPicker"
    popup.Visible=false
    popup.Size=UDim2.fromOffset(194,178)
    popup.BackgroundColor3=PANEL
    popup.BorderSizePixel=0
    popup.ZIndex=120
    popup.Parent=VisualPages

    Corner(popup,7)
    Stroke(popup,RED_DARK,1)

    --==============================================
    -- SV SQUARE
    --==============================================

    local sat=Instance.new("Frame")

    sat.Name="SaturationValue"
    sat.Size=UDim2.fromOffset(150,150)
    sat.Position=UDim2.fromOffset(8,9)
    sat.BorderSizePixel=0
    sat.BackgroundColor3=Color3.fromRGB(255,0,0)
    sat.ZIndex=121
    sat.Parent=popup

    -- Blanco: izquierda -> derecha
    local white=Instance.new("Frame")

    white.Size=UDim2.fromScale(1,1)
    white.BackgroundColor3=Color3.new(1,1,1)
    white.BorderSizePixel=0
    white.ZIndex=122
    white.Parent=sat

    local whiteGradient=Instance.new("UIGradient")

    whiteGradient.Rotation=0

    whiteGradient.Transparency=NumberSequence.new{
        NumberSequenceKeypoint.new(0,0),
        NumberSequenceKeypoint.new(1,1)
    }

    whiteGradient.Parent=white

    -- Negro: arriba transparente -> abajo negro
    local black=Instance.new("Frame")

    black.Size=UDim2.fromScale(1,1)
    black.BackgroundColor3=Color3.new(0,0,0)
    black.BorderSizePixel=0
    black.ZIndex=123
    black.Parent=sat

    local blackGradient=Instance.new("UIGradient")

    blackGradient.Rotation=90

    blackGradient.Transparency=NumberSequence.new{
        NumberSequenceKeypoint.new(0,1),
        NumberSequenceKeypoint.new(1,0)
    }

    blackGradient.Parent=black

    --==============================================
    -- HUE BAR
    -- SIN UIGRADIENT
    -- COLORES HSV REALES
    --==============================================

    local hue=Instance.new("Frame")

    hue.Name="Hue"
    hue.Size=UDim2.fromOffset(18,150)
    hue.Position=UDim2.fromOffset(168,9)
    hue.BackgroundTransparency=1
    hue.BorderSizePixel=0
    hue.ZIndex=121
    hue.Parent=popup

    local HueSteps=90

    for i=1,HueSteps do

        local strip=Instance.new("Frame")

        strip.Name="Hue_"..i

        strip.BorderSizePixel=0

        strip.Size=UDim2.new(
            1,0,
            1/HueSteps,0
        )

        strip.Position=UDim2.new(
            0,0,
            (i-1)/HueSteps,0
        )

        -- 0 = rojo
        -- 1/6 = amarillo
        -- 1/3 = verde
        -- 1/2 = cyan
        -- 2/3 = azul
        -- 5/6 = magenta
        -- 1 = rojo

        local hueValue=1-((i-1)/(HueSteps-1))

        strip.BackgroundColor3=
            Color3.fromHSV(hueValue,1,1)

        strip.ZIndex=121
        strip.Parent=hue
    end

    --==============================================
    -- MARKERS
    --==============================================

    local marker=Instance.new("Frame")

    marker.Name="SVMarker"
    marker.Size=UDim2.fromOffset(10,10)
    marker.AnchorPoint=Vector2.new(.5,.5)
    marker.BackgroundTransparency=1
    marker.BorderSizePixel=2
    marker.BorderColor3=WHITE
    marker.ZIndex=125
    marker.Parent=sat

    local hueMarker=Instance.new("Frame")

    hueMarker.Name="HueMarker"
    hueMarker.Size=UDim2.new(1,6,0,3)
    hueMarker.Position=UDim2.new(0,-3,0,-1)
    hueMarker.BackgroundColor3=WHITE
    hueMarker.BorderSizePixel=0
    hueMarker.ZIndex=125
    hueMarker.Parent=hue

    --==============================================
    -- COLOR STATE
    --==============================================

    local h,s,v=default:ToHSV()

    local function Apply()

        local color=Color3.fromHSV(h,s,v)

        preview.BackgroundColor3=color

        if callback then
            callback(color)
        end
    end

    local function UpdateVisuals()

        sat.BackgroundColor3=
            Color3.fromHSV(h,1,1)

        marker.Position=
            UDim2.new(s,0,1-v,0)

        hueMarker.Position=
            UDim2.new(0,-3,1-h,-1)
    end

    --==============================================
    -- SV INPUT
    --==============================================

    local function SetSV(input)

        local x=math.clamp(
            (input.Position.X-sat.AbsolutePosition.X)/
            sat.AbsoluteSize.X,
            0,1
        )

        local y=math.clamp(
            (input.Position.Y-sat.AbsolutePosition.Y)/
            sat.AbsoluteSize.Y,
            0,1
        )

        s=x
        v=1-y

        UpdateVisuals()
        Apply()
    end

    --==============================================
    -- HUE INPUT
    --==============================================

    local function SetHue(input)

        local y=math.clamp(
            (input.Position.Y-hue.AbsolutePosition.Y)/
            hue.AbsoluteSize.Y,
            0,1
        )

        h=1-y

        UpdateVisuals()
        Apply()
    end

    local satDrag=false
    local hueDrag=false

    --==============================================
    -- SV TOUCH / MOUSE
    --==============================================

    sat.InputBegan:Connect(function(input)

        if input.UserInputType==Enum.UserInputType.MouseButton1
        or input.UserInputType==Enum.UserInputType.Touch then

            satDrag=true
            SetSV(input)
        end
    end)

    --==============================================
    -- HUE TOUCH / MOUSE
    --==============================================

    hue.InputBegan:Connect(function(input)

        if input.UserInputType==Enum.UserInputType.MouseButton1
        or input.UserInputType==Enum.UserInputType.Touch then

            hueDrag=true
            SetHue(input)
        end
    end)

    --==============================================
    -- DRAG
    --==============================================

    UIS.InputChanged:Connect(function(input)

        if input.UserInputType~=Enum.UserInputType.MouseMovement
        and input.UserInputType~=Enum.UserInputType.Touch then
            return
        end

        if satDrag then
            SetSV(input)

        elseif hueDrag then
            SetHue(input)
        end
    end)

    UIS.InputEnded:Connect(function(input)

        if input.UserInputType==Enum.UserInputType.MouseButton1
        or input.UserInputType==Enum.UserInputType.Touch then

            satDrag=false
            hueDrag=false
        end
    end)

    --==============================================
    -- POSITION POPUP
    --==============================================

    local function PositionPopup()

        local bp=preview.AbsolutePosition
        local bs=preview.AbsoluteSize

        local vp=VisualPages.AbsolutePosition
        local vs=VisualPages.AbsoluteSize

        local width=194
        local height=178

        local x=bp.X-vp.X
        local y=bp.Y-vp.Y+bs.Y+4

        if y+height>vs.Y then
            y=bp.Y-vp.Y-height-4
        end

        if x+width>vs.X then
            x=vs.X-width-4
        end

        if x<0 then
            x=0
        end

        if y<0 then
            y=0
        end

        popup.Position=UDim2.fromOffset(x,y)
    end

    --==============================================
    -- ONLY SWATCH OPENS PICKER
    --==============================================

    preview.MouseButton1Click:Connect(function()

        if popup.Visible then
            ClosePopup()
            return
        end

        PositionPopup()
        UpdateVisuals()
        OpenPopup(popup,holder)
    end)

    UpdateVisuals()

    return holder
end

--==================================================
-- SINGLE DROPDOWN
--==================================================

local function SingleDropdown(parent,title,y,values,getValue,setValue)

    local holder=Instance.new("Frame")

    holder.Size=UDim2.new(1,-20,0,34)
    holder.Position=UDim2.fromOffset(10,y)
    holder.BackgroundTransparency=1
    holder.Parent=parent

    local b=Button(
        holder,
        title.."  •  "..getValue()
    )

    b.Size=UDim2.new(1,0,0,32)
    b.TextXAlignment=Enum.TextXAlignment.Left

    --==============================================
    -- POPUP
    --==============================================

    local list=Instance.new("ScrollingFrame")

    list.Name="SingleDropdownPopup"
    list.Visible=false
    list.BackgroundColor3=PANEL
    list.BorderSizePixel=0
    list.ZIndex=110
    list.ScrollBarThickness=4
    list.ScrollBarImageColor3=RED
    list.AutomaticCanvasSize=Enum.AutomaticSize.Y
    list.CanvasSize=UDim2.new()
    list.ClipsDescendants=true
    list.Parent=VisualPages

    Corner(list,6)
    Stroke(list,RED_DARK,1)

    local layout=Instance.new("UIListLayout")

    layout.Padding=UDim.new(0,2)
    layout.Parent=list

    local pad=Instance.new("UIPadding")

    pad.PaddingTop=UDim.new(0,4)
    pad.PaddingBottom=UDim.new(0,4)
    pad.PaddingLeft=UDim.new(0,4)
    pad.PaddingRight=UDim.new(0,4)

    pad.Parent=list

    --==============================================
    -- OPTIONS
    --==============================================

    for _,option in ipairs(values) do

        local item=Button(list,option)

        item.Size=UDim2.new(1,0,0,27)
        item.ZIndex=111
        item.TextXAlignment=Enum.TextXAlignment.Left

        item.MouseButton1Click:Connect(function()

            setValue(option)

            b.Text=title.."  •  "..option

            ClosePopup()
        end)
    end

    --==============================================
    -- POSITION
    --==============================================

    local function PositionPopup()

        local bp=b.AbsolutePosition
        local bs=b.AbsoluteSize

        local vp=VisualPages.AbsolutePosition
        local vs=VisualPages.AbsoluteSize

        local width=math.max(bs.X,170)
        local height=math.min(#values*29+10,180)

        local x=bp.X-vp.X
        local y=bp.Y-vp.Y+bs.Y+4

        if y+height>vs.Y then
            y=bp.Y-vp.Y-height-4
        end

        if x+width>vs.X then
            x=vs.X-width-4
        end

        if x<0 then
            x=0
        end

        if y<0 then
            y=0
        end

        list.Size=UDim2.fromOffset(width,height)
        list.Position=UDim2.fromOffset(x,y)
    end

    b.MouseButton1Click:Connect(function()

        if list.Visible then
            ClosePopup()
            return
        end

        PositionPopup()
        OpenPopup(list,holder)
    end)

    return holder
end

--==================================================
-- PART 2 / 3
-- PARTE 3/3
-- ESP + CAMERA + LIGHTING
--==================================================

--==================================================
-- ESP
--==================================================

local Settings=Section(
    ESPPage,
    "Highlight ESP Settings",
    175
)

Slider(
    Settings,
    "ESP Fill Transparency",
    32,
    0,
    1,
    VisualState.ESP.FillTransparency,
    function(v)
        VisualState.ESP.FillTransparency=v
    end
)

Slider(
    Settings,
    "ESP Outline Transparency",
    77,
    0,
    1,
    VisualState.ESP.OutlineTransparency,
    function(v)
        VisualState.ESP.OutlineTransparency=v
    end
)

Slider(
    Settings,
    "ESP Text Size",
    122,
    8,
    22,
    VisualState.ESP.TextSize,
    function(v)
        VisualState.ESP.TextSize=v
    end
)

--==================================================
-- PLAYER ESP
--==================================================

local Player=Section(
    ESPPage,
    "Player Highlight ESP",
    205
)

Toggle(
    Player,
    "Enable Player ESP",
    32,
    function(v)
        VisualState.ESP.PlayerESP=v
    end
)

MultiDropdown(
    Player,
    "Select Player ESP",
    68,
    {
        "Survivor ESP",
        "Killer ESP",
        "Spectator ESP",
        "Survivor Items ESP"
    },
    {},
    function(selected)
        VisualState.ESP.PlayerTypes=selected
    end
)

Toggle(
    Player,
    "Player Nametags",
    108,
    function(v)
        VisualState.ESP.Nametags=v
    end
)

Toggle(
    Player,
    "Player Distance ESP",
    142,
    function(v)
        VisualState.ESP.DistanceESP=v
    end
)

Toggle(
    Player,
    "Survivor Killer Warning (!)",
    176,
    function(v)
        VisualState.ESP.KillerWarning=v
    end
)

--==================================================
-- PLAYER COLORS
--==================================================

local PlayerColors=Section(
    ESPPage,
    "Player ESP Colors",
    170
)

ColorPicker(
    PlayerColors,
    "Survivor Color",
    32,
    VisualState.ESP.SurvivorColor,
    function(c)
        VisualState.ESP.SurvivorColor=c
    end
)

ColorPicker(
    PlayerColors,
    "Killer Color",
    70,
    VisualState.ESP.KillerColor,
    function(c)
        VisualState.ESP.KillerColor=c
    end
)

ColorPicker(
    PlayerColors,
    "Spectator Color",
    108,
    VisualState.ESP.SpectatorColor,
    function(c)
        VisualState.ESP.SpectatorColor=c
    end
)

--==================================================
-- WORLD ESP
--==================================================

local World=Section(
    ESPPage,
    "World Highlight ESP",
    205
)

Toggle(
    World,
    "Enable World ESP",
    32,
    function(v)
        VisualState.ESP.WorldESP=v
    end
)

MultiDropdown(
    World,
    "Select World Objects",
    68,
    {
        "Generators",
        "Hooks",
        "Gates",
        "Windows",
        "Pallets",
        "SCP / Zombie"
    },
    {},
    function(selected)
        VisualState.ESP.WorldTypes=selected
    end
)

Toggle(
    World,
    "World Nametags",
    108,
    function(v)
        VisualState.ESP.WorldNametags=v
    end
)

Toggle(
    World,
    "World Distance ESP",
    142,
    function(v)
        VisualState.ESP.WorldDistanceESP=v
    end
)

--==================================================
-- WORLD COLORS
--==================================================

local WorldColors=Section(
    ESPPage,
    "World ESP Colors",
    250
)

ColorPicker(
    WorldColors,
    "Generator Color",
    32,
    VisualState.ESP.GeneratorColor,
    function(c)
        VisualState.ESP.GeneratorColor=c
    end
)

ColorPicker(
    WorldColors,
    "Hook Color",
    70,
    VisualState.ESP.HookColor,
    function(c)
        VisualState.ESP.HookColor=c
    end
)

ColorPicker(
    WorldColors,
    "Gate Color",
    108,
    VisualState.ESP.GateColor,
    function(c)
        VisualState.ESP.GateColor=c
    end
)

ColorPicker(
    WorldColors,
    "Window Color",
    146,
    VisualState.ESP.WindowColor,
    function(c)
        VisualState.ESP.WindowColor=c
    end
)

ColorPicker(
    WorldColors,
    "Pallet Color",
    184,
    VisualState.ESP.PalletColor,
    function(c)
        VisualState.ESP.PalletColor=c
    end
)

ColorPicker(
    WorldColors,
    "SCP / Zombie Color",
    222,
    VisualState.ESP.SCPZombieColor,
    function(c)
        VisualState.ESP.SCPZombieColor=c
    end
)

--==================================================
-- CAMERA
--==================================================

local Camera=Section(
    CameraPage,
    "Camera",
    255
)

Toggle(
    Camera,
    "Enable Camera FOV override",
    32,
    function(v)
        VisualState.Camera.FOVEnabled=v
    end
)

Slider(
    Camera,
    "Camera FOV",
    70,
    30,
    140,
    VisualState.Camera.FOV,
    function(v)
        VisualState.Camera.FOV=v
    end
)

Toggle(
    Camera,
    "Third Person (Killer only)",
    118,
    function(v)
        VisualState.Camera.ThirdPerson=v
    end
)

Toggle(
    Camera,
    "Shift Lock (auto face camera)",
    152,
    function(v)
        VisualState.Camera.ShiftLock=v
    end
)

Toggle(
    Camera,
    "Infinity Zoom Out",
    186,
    function(v)
        VisualState.Camera.InfinityZoom=v
    end
)

Toggle(
    Camera,
    "No Cutscene",
    220,
    function(v)
        VisualState.Camera.NoCutscene=v
    end
)

--==================================================
-- LIGHTING DROPDOWN
--==================================================

local function LightingDropdown(
    page,
    title,
    contentHeight,
    defaultOpen
)

    local holder=Instance.new("Frame")

    local visibleHeight=
        math.min(contentHeight,220)

    holder.Size=UDim2.new(
        1,-4,
        0,
        defaultOpen
        and 34+visibleHeight+4
        or 34
    )

    holder.BackgroundTransparency=1
    holder.Parent=page

    --==================================================
    -- HEADER
    --==================================================

    local header=Button(
        holder,
        title.."  "..(
            defaultOpen
            and "▲"
            or "▼"
        )
    )

    header.Size=UDim2.new(1,0,0,34)
    header.Position=UDim2.fromOffset(0,0)

    header.TextXAlignment=
        Enum.TextXAlignment.Left

    header.BackgroundColor3=PANEL

    Corner(header,7)
    Stroke(header,RED_DARK,1)

    --==================================================
    -- SCROLL CONTENT
    --==================================================

    local content=Instance.new("ScrollingFrame")

    content.Name="LightingContent"

    content.Position=
        UDim2.fromOffset(0,38)

    content.Size=UDim2.new(
        1,0,
        0,visibleHeight
    )

    content.BackgroundColor3=PANEL
    content.BorderSizePixel=0

    content.ScrollBarThickness=4
    content.ScrollBarImageColor3=RED

    content.ScrollingDirection=
        Enum.ScrollingDirection.Y

    content.AutomaticCanvasSize=
        Enum.AutomaticSize.Y

    content.CanvasSize=UDim2.new()

    content.ClipsDescendants=true
    content.Parent=holder

    Corner(content,7)
    Stroke(content,RED_DARK,1)

    --==================================================
    -- PADDING
    --==================================================

    local pad=Instance.new("UIPadding")

    pad.PaddingTop=UDim.new(0,2)
    pad.PaddingBottom=UDim.new(0,8)
    pad.PaddingLeft=UDim.new(0,2)
    pad.PaddingRight=UDim.new(0,2)

    pad.Parent=content

    local opened=defaultOpen

    --==================================================
    -- UPDATE
    --==================================================

    local function Update()

        if opened then

            holder.Size=UDim2.new(
                1,-4,
                0,
                34+visibleHeight+4
            )

            content.Visible=true

            header.Text=title.."  ▲"

        else

            holder.Size=UDim2.new(
                1,-4,
                0,
                34
            )

            content.Visible=false

            header.Text=title.."  ▼"

        end
    end

    --==================================================
    -- TOGGLE
    --==================================================

    header.MouseButton1Click:Connect(function()

        opened=not opened

        Update()
    end)

    Update()

    return content
end

--==================================================
-- LIGHTING SETTINGS
--==================================================

local LightingSettings=LightingDropdown(
    LightingPage,
    "Lighting Settings",
    312,
    true
)

Toggle(
    LightingSettings,
    "Full Bright",
    32,
    function(v)
        VisualState.Lighting.FullBright=v
    end
)

Toggle(
    LightingSettings,
    "No Fog",
    66,
    function(v)
        VisualState.Lighting.NoFog=v
    end
)

Toggle(
    LightingSettings,
    "No Shadows",
    100,
    function(v)
        VisualState.Lighting.NoShadows=v
    end
)

Toggle(
    LightingSettings,
    "No Color Correction",
    134,
    function(v)
        VisualState.Lighting.NoColorCorrection=v
    end
)

Toggle(
    LightingSettings,
    "Remove Atmosphere",
    168,
    function(v)
        VisualState.Lighting.RemoveAtmosphere=v
    end
)

Toggle(
    LightingSettings,
    "Remove Bloom",
    202,
    function(v)
        VisualState.Lighting.RemoveBloom=v
    end
)

Toggle(
    LightingSettings,
    "Remove Blur",
    236,
    function(v)
        VisualState.Lighting.RemoveBlur=v
    end
)

Toggle(
    LightingSettings,
    "Disable Weather Effects",
    270,
    function(v)
        VisualState.Lighting.DisableWeather=v
    end
)

--==================================================
-- WEATHER
--==================================================

local WeatherValues={
    "Default",
    "Sunny",
    "Night",
    "Storm"
}

local WeatherSelected="Default"

local Weather=LightingDropdown(
    LightingPage,
    "Weather Theme",
    90,
    false
)

SingleDropdown(
    Weather,
    "Weather",
    10,
    WeatherValues,
    function()
        return WeatherSelected
    end,
    function(v)

        WeatherSelected=v

        VisualState.Lighting.Weather=v
    end
)

--==================================================
-- SKY
--==================================================

local SkyValues={
    "Default",
    "Blue",
    "Purple",
    "Night"
}

local SkySelected="Default"

local Sky=LightingDropdown(
    LightingPage,
    "Sky Theme",
    90,
    false
)

SingleDropdown(
    Sky,
    "Sky",
    10,
    SkyValues,
    function()
        return SkySelected
    end,
    function(v)

        SkySelected=v

        VisualState.Lighting.Sky=v
    end
)

--==================================================
-- INITIAL
--==================================================

SelectSub("ESP")

print(
    "[KysHub LocalUI] Part 2/3 loaded"
)

--==================================================
-- PART 4 / 3
-- VISUAL LOGIC
-- PLAYER ESP
-- NO MODIFICA LA UI
--==================================================

local Players=game:GetService("Players")
local ReplicatedStorage=game:GetService("ReplicatedStorage")
local RunService=game:GetService("RunService")

local LP=Players.LocalPlayer
local State=getgenv().KYS_LocalVisualState

if not State then
    warn("[KysHub] VisualState no encontrado")
    return
end

--==================================================
-- CONFIG
--==================================================

local ESPFolder=nil
local PlayerConnections={}
local PlayerLoop=nil

local KILLER_WARNING_YELLOW="rbxassetid://120753562298647"
local KILLER_WARNING_RED="rbxassetid://99499680507460"

local SPECTATOR_ICON="rbxassetid://85623975924363"

--==================================================
-- SURVIVOR ITEMS
-- ORIGINAL DEL ARCHIVO
--==================================================

local DisplayNames={
    ["Motion Tracker"]=true,
    ["Gate"]=true,
    ["Flashlight"]=true,
    ["Bandage"]=true,
    ["Parrying Dagger"]=true,
    ["Adrenaline Shot"]=true,
    ["Twist of Fate"]=true,
    ["Shadow Clone"]=true,
    ["Holy Water"]=true,
    ["WaxBound Candle"]=true,
    ["Riot Shield"]=true,
    ["Emperor"]=true,
    ["AWP"]=true
}

--==================================================
-- HELPERS
--==================================================

local function Alive(obj)
    return obj and obj.Parent~=nil
end

local function PlayerKey(player)
    return tostring(player.UserId)
end

local function GetESPFolder()

    if ESPFolder and Alive(ESPFolder) then
        return ESPFolder
    end

    local old=workspace:FindFirstChild("KysHub_VisualESP")

    if old then
        old:Destroy()
    end

    ESPFolder=Instance.new("Folder")
    ESPFolder.Name="KysHub_VisualESP"
    ESPFolder.Parent=workspace

    return ESPFolder
end

local function Destroy(name)

    if not ESPFolder then
        return
    end

    local obj=ESPFolder:FindFirstChild(name)

    if obj then
        obj:Destroy()
    end
end

--==================================================
-- ROLE
--==================================================

local function GetRole(player)

    local teamName=
        player.Team
        and player.Team.Name
        and player.Team.Name:lower()
        or ""

    if teamName:find("killer") then
        return "Killer"
    end

    if teamName:find("survivor") then
        return "Survivor"
    end

    if teamName:find("spect") then
        return "Spectator"
    end

    return "Survivor"
end

local function RoleEnabled(player)

    local role=GetRole(player)

    if role=="Killer" then
        return State.ESP.PlayerTypes["Killer ESP"]==true
    end

    if role=="Spectator" then
        return State.ESP.PlayerTypes["Spectator ESP"]==true
    end

    return State.ESP.PlayerTypes["Survivor ESP"]==true
end

local function RoleColor(player)

    local role=GetRole(player)

    if role=="Killer" then
        return State.ESP.KillerColor
    end

    if role=="Spectator" then
        return State.ESP.SpectatorColor
    end

    return State.ESP.SurvivorColor
end

--==================================================
-- HIGHLIGHT
--==================================================

local function ApplyHighlight(player,character)

    local key=PlayerKey(player)
    local name="KYS_PlayerHL_"..key

    local hl=ESPFolder:FindFirstChild(name)

    if not hl then

        hl=Instance.new("Highlight")
        hl.Name=name
        hl.DepthMode=Enum.HighlightDepthMode.AlwaysOnTop
        hl.Parent=ESPFolder

    end

    hl.Adornee=character
    hl.FillColor=RoleColor(player)
    hl.OutlineColor=RoleColor(player)

    hl.FillTransparency=
        math.clamp(
            State.ESP.FillTransparency,
            0,
            1
        )

    hl.OutlineTransparency=
        math.clamp(
            State.ESP.OutlineTransparency,
            0,
            1
        )

    hl.Enabled=true
end

--==================================================
-- PLAYER TEXT
--==================================================

local function ApplyPlayerTag(player,character)

    local key=PlayerKey(player)

    local name="KYS_PlayerTag_"..key

    local head=character:FindFirstChild("Head")

    if not head then
        Destroy(name)
        return
    end

    if not State.ESP.Nametags
    and not State.ESP.DistanceESP then

        Destroy(name)
        return
    end

    local tag=ESPFolder:FindFirstChild(name)

    if not tag then

        tag=Instance.new("BillboardGui")
        tag.Name=name
        tag.AlwaysOnTop=true
        tag.LightInfluence=0
        tag.MaxDistance=0
        tag.Size=UDim2.fromOffset(180,45)
        tag.StudsOffset=Vector3.new(0,3,0)
        tag.Parent=ESPFolder

        local text=Instance.new("TextLabel")
        text.Name="Text"
        text.BackgroundTransparency=1
        text.Size=UDim2.fromScale(1,1)
        text.TextStrokeTransparency=.25
        text.TextYAlignment=Enum.TextYAlignment.Center
        text.Parent=tag
    end

    tag.Adornee=head
    tag.Enabled=true

    local text=tag:FindFirstChild("Text")

    if not text then
        return
    end

    text.TextSize=State.ESP.TextSize
    text.TextColor3=RoleColor(player)

    local result={}

    if State.ESP.Nametags then
        table.insert(result,player.DisplayName)
    end

    if State.ESP.DistanceESP then

        local myChar=LP.Character
        local myRoot=
            myChar
            and myChar:FindFirstChild("HumanoidRootPart")

        local root=
            character:FindFirstChild("HumanoidRootPart")

        if myRoot and root then

            local distance=
                math.floor(
                    (myRoot.Position-root.Position).Magnitude
                )

            table.insert(
                result,
                tostring(distance).."m"
            )
        end
    end

    text.Text=table.concat(result,"  •  ")
end

--==================================================
-- SURVIVOR ITEM
--==================================================

local function GetSurvivorItem(player)

    local character=player.Character

    if not character then
        return nil
    end

    for _,obj in ipairs(character:GetDescendants()) do

        if obj:IsA("Tool")
        or obj:IsA("Accessory")
        or obj:IsA("Model") then

            if DisplayNames[obj.Name] then
                return obj.Name
            end

        end

    end

    return nil
end

--==================================================
-- ITEM IMAGE
--==================================================

local function GetItemImageId(itemName)

    local itemsFolder=
        ReplicatedStorage:FindFirstChild("Items")

    if not itemsFolder then
        return nil
    end

    local itemObj=
        itemsFolder:FindFirstChild(itemName)

    if not itemObj then
        return nil
    end

    if itemObj:IsA("Decal")
    or itemObj:IsA("Texture") then

        return itemObj.Texture
    end

    local texture=
        itemObj:FindFirstChildWhichIsA(
            "Decal",
            true
        )
        or
        itemObj:FindFirstChildWhichIsA(
            "Texture",
            true
        )

    if texture then
        return texture.Texture
    end

    local namedTexture=
        itemObj:FindFirstChild(
            "Texture",
            true
        )

    if namedTexture
    and (
        namedTexture:IsA("Decal")
        or
        namedTexture:IsA("Texture")
    ) then

        return namedTexture.Texture
    end

    return nil
end

--==================================================
-- ITEM ICON
--==================================================

local function ApplyItemIcon(player,character)

    local key=PlayerKey(player)

    local name="KYS_PlayerItem_"..key

    if GetRole(player)~="Survivor"
    or not State.ESP.PlayerTypes["Survivor Items ESP"] then

        Destroy(name)
        return
    end

    local torso=
        character:FindFirstChild("HumanoidRootPart")
        or character:FindFirstChild("UpperTorso")
        or character:FindFirstChild("Torso")

    if not torso then
        Destroy(name)
        return
    end

    local itemName=GetSurvivorItem(player)

    local imageId=
        itemName
        and GetItemImageId(itemName)
        or nil

    if not imageId then
        Destroy(name)
        return
    end

    local icon=ESPFolder:FindFirstChild(name)

    if not icon then

        icon=Instance.new("BillboardGui")
        icon.Name=name
        icon.AlwaysOnTop=true
        icon.LightInfluence=0
        icon.MaxDistance=0
        icon.Size=UDim2.fromOffset(20,20)
        icon.StudsOffset=Vector3.new(0,0,-1.6)
        icon.Parent=ESPFolder

        local image=Instance.new("ImageLabel")
        image.Name="ImageLabel"
        image.BackgroundTransparency=1
        image.Size=UDim2.fromScale(1,1)
        image.Parent=icon

    end

    icon.Adornee=torso
    icon.Enabled=true

    local image=icon:FindFirstChild("ImageLabel")

    if image then
        image.Image=imageId
    end
end

--==================================================
-- KILLER WARNING
-- TODOS LOS SURVIVIENTES
--==================================================

local WARNING_YELLOW=
    "rbxassetid://120753562298647"

local WARNING_RED=
    "rbxassetid://99499680507460"

local WARNING_MAX_DISTANCE=60
local WARNING_DANGER_DISTANCE=40

local WarningRunning=false

--==================================================
-- WARNING NAME
--==================================================

local function WarningName(player)

    return "KYS_SurvivorKillerWarn_"
        ..tostring(player.UserId)

end

--==================================================
-- CLEAR WARNING
--==================================================

local function ClearKillerWarning(player)

    if not player then
        return
    end

    local character=
        player.Character

    if not character then
        return
    end

    local root=
        character:FindFirstChild(
            "HumanoidRootPart"
        )

    if not root then
        return
    end

    local old=
        root:FindFirstChild(
            WarningName(player)
        )

    if old then
        old:Destroy()
    end
end

--==================================================
-- CLEAR ALL WARNINGS
--==================================================

local function ClearAllKillerWarnings()

    for _,player in ipairs(
        Players:GetPlayers()
    ) do

        ClearKillerWarning(player)

    end
end

--==================================================
-- NEAREST KILLER
--==================================================

local function GetNearestKillerDistance(
    survivor
)

    local character=
        survivor.Character

    local root=
        character
        and character:FindFirstChild(
            "HumanoidRootPart"
        )

    if not root then
        return math.huge
    end

    local nearest=math.huge

    for _,player in ipairs(
        Players:GetPlayers()
    ) do

        if player~=survivor
        and GetRole(player)=="Killer" then

            local killerCharacter=
                player.Character

            local killerRoot=
                killerCharacter
                and killerCharacter:FindFirstChild(
                    "HumanoidRootPart"
                )

            local humanoid=
                killerCharacter
                and killerCharacter:FindFirstChildOfClass(
                    "Humanoid"
                )

            if killerRoot
            and humanoid
            and humanoid.Health>0 then

                local distance=
                    (
                        root.Position
                        -
                        killerRoot.Position
                    ).Magnitude

                if distance<nearest then
                    nearest=distance
                end

            end
        end
    end

    return nearest
end

--==================================================
-- CREATE WARNING
--==================================================

local function CreateKillerWarning(
    survivor
)

    local character=
        survivor.Character

    local root=
        character
        and character:FindFirstChild(
            "HumanoidRootPart"
        )

    if not root then
        return nil
    end

    local name=
        WarningName(survivor)

    local existing=
        root:FindFirstChild(name)

    if existing then
        return existing
    end

    local warn=
        Instance.new("BillboardGui")

    warn.Name=name
    warn.Adornee=root
    warn.AlwaysOnTop=true
    warn.LightInfluence=0
    warn.Size=
        UDim2.fromOffset(76,44)

    warn.StudsOffset=
        Vector3.new(0,4.8,0)

    warn.MaxDistance=2000
    warn.Parent=root

    local image=
        Instance.new("ImageLabel")

    image.Name="WarningImage"
    image.BackgroundTransparency=1
    image.Size=
        UDim2.fromScale(1,1)

    image.Position=
        UDim2.fromScale(0,0)

    image.ScaleType=
        Enum.ScaleType.Fit

    image.Image=
        WARNING_YELLOW

    image.Parent=warn

    return warn
end

--==================================================
-- UPDATE ONE SURVIVOR
--==================================================

local function UpdateSurvivorWarning(
    survivor
)

    if not survivor then
        return
    end

    -- Solo Survivors
    if GetRole(survivor)~="Survivor" then

        ClearKillerWarning(survivor)
        return

    end

    local character=
        survivor.Character

    local root=
        character
        and character:FindFirstChild(
            "HumanoidRootPart"
        )

    local humanoid=
        character
        and character:FindFirstChildOfClass(
            "Humanoid"
        )

    if not root
    or not humanoid
    or humanoid.Health<=0 then

        ClearKillerWarning(survivor)
        return

    end

    local distance=
        GetNearestKillerDistance(
            survivor
        )

    -- Killer fuera de rango
    if distance>
        WARNING_MAX_DISTANCE then

        ClearKillerWarning(survivor)
        return

    end

    local warn=
        CreateKillerWarning(
            survivor
        )

    if not warn then
        return
    end

    local image=
        warn:FindFirstChild(
            "WarningImage"
        )

    if image then

        if distance<=
            WARNING_DANGER_DISTANCE then

            image.Image=
                WARNING_RED

        else

            image.Image=
                WARNING_YELLOW

        end

    end

    warn.Enabled=true
end

--==================================================
-- UPDATE ALL SURVIVORS
--==================================================

local function UpdateKillerWarning()

    if not State.ESP.KillerWarning then

        ClearAllKillerWarnings()
        return

    end

    for _,player in ipairs(
        Players:GetPlayers()
    ) do

        pcall(
            UpdateSurvivorWarning,
            player
        )

    end
end

--==================================================
-- WARNING LOOP
--==================================================

local function StartKillerWarning()

    if WarningRunning then
        return
    end

    WarningRunning=true

    task.spawn(function()

        while WarningRunning
        and GUI
        and GUI.Parent do

            pcall(
                UpdateKillerWarning
            )

            task.wait(.15)

        end

        ClearAllKillerWarnings()

    end)
end

--==================================================
-- STOP
--==================================================

local function StopKillerWarning()

    WarningRunning=false

    ClearAllKillerWarnings()

end

--==================================================
-- PLAYER ADDED
--==================================================

Players.PlayerAdded:Connect(
    function(player)

        player.CharacterAdded:Connect(
            function()

                task.wait(.5)

                if WarningRunning then

                    pcall(
                        UpdateSurvivorWarning,
                        player
                    )

                end

            end
        )

    end
)

--==================================================
-- PLAYER REMOVING
--==================================================

Players.PlayerRemoving:Connect(
    function(player)

        ClearKillerWarning(player)

    end
)

--==================================================
-- START
--==================================================

StartKillerWarning()

print(
    "[KysHub] Killer Warning loaded - ALL SURVIVORS"
)

--==================================================
-- WORLD ESP V3
-- DETECCION AMPLIADA
--==================================================

local WorldReg={
    Generator={},
    Hook={},
    Gate={},
    Window={},
    Palletwrong={},
    SCPZombie={}
}

local WorldConns={}
local WorldLoop=nil

local function WorldAlive(obj)
    return obj and obj.Parent~=nil
end

local function ValidWorldPart(obj)
    return obj
    and obj:IsA("BasePart")
    and obj.Parent~=nil
end

local function FirstWorldPart(model)
    if not WorldAlive(model) then
        return nil
    end

    if model:IsA("BasePart") then
        return model
    end

    return model:FindFirstChildWhichIsA(
        "BasePart",
        true
    )
end

--==================================================
-- BUSQUEDA DE PART PRINCIPAL
--==================================================

local function PickWorldPart(model,cat)

    if not WorldAlive(model) then
        return nil
    end

    if cat=="Generator" then

        local part=
            model:FindFirstChild("HitBox",true)
            or
            model:FindFirstChild("GeneratorPoint",true)

        if ValidWorldPart(part) then
            return part
        end

    elseif cat=="Palletwrong" then

        local candidates={
            model:FindFirstChild("HumanoidRootPart",true),
            model:FindFirstChild("PrimaryPartPallet",true),
            model:FindFirstChild("Primary1",true),
            model:FindFirstChild("Primary2",true),
            model:FindFirstChild("PalletPoint",true),
            model:FindFirstChild("PalletPointSlide",true)
        }

        for _,part in ipairs(candidates) do

            if ValidWorldPart(part) then
                return part
            end

        end

    elseif cat=="Window" then

        local part=
            model:FindFirstChild("VaultPoint",true)
            or
            model:FindFirstChild("VaultTrigger",true)

        if ValidWorldPart(part) then
            return part
        end

    elseif cat=="SCPZombie" then

        local part=
            model:FindFirstChild("HumanoidRootPart",true)
            or
            model:FindFirstChild("UpperTorso",true)
            or
            model:FindFirstChild("Torso",true)

        if ValidWorldPart(part) then
            return part
        end

    end

    return FirstWorldPart(model)
end

--==================================================
-- NORMALIZAR NOMBRE
--==================================================

local function NormalizeWorldName(name)

    return tostring(name)
        :lower()
        :gsub("[%s_%-%./]+","")
end

--==================================================
-- DETECTAR CATEGORIA
--==================================================

local function DetectWorldCategory(model)

    if not model then
        return nil
    end

    local raw=tostring(model.Name)
    local name=NormalizeWorldName(raw)

    -- Nombres exactos primero
    if raw=="Generator"
    or raw=="GeneratorPoint" then
        return "Generator"
    end

    if raw=="Hook" then
        return "Hook"
    end

    if raw=="Gate" then
        return "Gate"
    end

    if raw=="Window" then
        return "Window"
    end

    if raw=="Pallet"
    or raw=="Palletwrong" then
        return "Palletwrong"
    end

    -- SCP / Zombie
    if name:find("scp",1,true)
    or name:find("zombie",1,true) then
        return "SCPZombie"
    end

    -- Generadores
    if name:find("generator",1,true) then
        return "Generator"
    end

    -- Hooks
    if name:find("hook",1,true) then
        return "Hook"
    end

    -- Gates
    if name:find("gate",1,true)
    or name:find("exitgate",1,true) then
        return "Gate"
    end

    -- Ventanas
    if name:find("window",1,true)
    or name:find("vault",1,true) then
        return "Window"
    end

    -- Pallets
    if name:find("pallet",1,true) then
        return "Palletwrong"
    end

    return nil
end

--==================================================
-- REGISTRAR OBJETO
--==================================================

local function EnsureWorldEntry(cat,model)

    if not cat
    or not WorldReg[cat]
    or not WorldAlive(model) then
        return
    end

    if WorldReg[cat][model] then
        return
    end

    if cat=="Palletwrong" then

        if model:GetAttribute("Destroyed")==true then
            return
        end

    end

    local part=PickWorldPart(model,cat)

    if not ValidWorldPart(part) then
        return
    end

    WorldReg[cat][model]={
        part=part
    }
end

--==================================================
-- BUSQUEDA DE ANCESTROS
--==================================================

local function RegisterWorld(obj)

    if not WorldAlive(obj) then
        return
    end

    local model=nil

    if obj:IsA("Model") then

        model=obj

    elseif obj:IsA("BasePart") then

        local parent=obj.Parent

        while parent
        and parent~=workspace do

            if parent:IsA("Model") then

                local cat=
                    DetectWorldCategory(parent)

                if cat then
                    EnsureWorldEntry(cat,parent)
                    return
                end

            end

            parent=parent.Parent
        end

        return
    end

    if not model then
        return
    end

    local cat=DetectWorldCategory(model)

    if cat then
        EnsureWorldEntry(cat,model)
        return
    end

    -- Algunos objetos pueden estar dentro
    -- de un modelo que contiene el nombre real.
    local parent=model.Parent

    while parent
    and parent~=workspace do

        if parent:IsA("Model") then

            cat=DetectWorldCategory(parent)

            if cat then
                EnsureWorldEntry(cat,parent)
                return
            end

        end

        parent=parent.Parent
    end
end

--==================================================
-- LIMPIAR VISUAL
--==================================================

local function WorldKey(cat,model)

    return "KYS_World_"
        ..cat
        .."_"
        ..tostring(model:GetDebugId())
end

local function ClearWorldVisual(cat,model)

    if not model then
        return
    end

    local key=WorldKey(cat,model)

    Destroy(key.."_HL")
    Destroy(key.."_Tag")
end

--==================================================
-- ELIMINAR REGISTRO
--==================================================

local function UnregisterWorld(obj)

    if not obj then
        return
    end

    if obj:IsA("Model") then

        for cat,models in pairs(WorldReg) do

            if models[obj] then

                ClearWorldVisual(cat,obj)
                models[obj]=nil

            end

        end

        return
    end

    if obj:IsA("BasePart") then

        for cat,models in pairs(WorldReg) do

            for model,entry in pairs(models) do

                if entry.part==obj then

                    ClearWorldVisual(cat,model)
                    models[model]=nil

                end

            end

        end

    end
end

--==================================================
-- ROOTS DEL MAPA
--==================================================

local function AttachWorldRoot(root)

    if not root
    or WorldConns[root] then
        return
    end

    WorldConns[root]={}

    WorldConns[root].add=
        root.DescendantAdded:Connect(
            RegisterWorld
        )

    WorldConns[root].rem=
        root.DescendantRemoving:Connect(
            UnregisterWorld
        )

    for _,obj in ipairs(root:GetDescendants()) do
        RegisterWorld(obj)
    end
end

local function RefreshWorldRoots()

    for root,connections in pairs(WorldConns) do

        if connections.add then
            pcall(function()
                connections.add:Disconnect()
            end)
        end

        if connections.rem then
            pcall(function()
                connections.rem:Disconnect()
            end)
        end

    end

    WorldConns={}

    for cat,models in pairs(WorldReg) do

        for model in pairs(models) do
            ClearWorldVisual(cat,model)
        end

        WorldReg[cat]={}

    end

    local map=workspace:FindFirstChild("Map")
    local map1=workspace:FindFirstChild("Map1")

    if map then
        AttachWorldRoot(map)
    end

    if map1 then
        AttachWorldRoot(map1)
    end
end

--==================================================
-- ESTADO / COLOR
--==================================================

local function WorldSelected(cat)

    local selected=VisualState.ESP.WorldTypes

    local names={
        Generator="Generators",
        Hook="Hooks",
        Gate="Gates",
        Window="Windows",
        Palletwrong="Pallets",
        SCPZombie="SCP / Zombie"
    }

    return selected[names[cat]]==true
end

local function WorldColor(cat)

    if cat=="Generator" then
        return VisualState.ESP.GeneratorColor
    end

    if cat=="Hook" then
        return VisualState.ESP.HookColor
    end

    if cat=="Gate" then
        return VisualState.ESP.GateColor
    end

    if cat=="Window" then
        return VisualState.ESP.WindowColor
    end

    if cat=="Palletwrong" then
        return VisualState.ESP.PalletColor
    end

    if cat=="SCPZombie" then
        return VisualState.ESP.SCPZombieColor
    end

    return Color3.new(1,1,1)
end

--==================================================
-- WORLD HIGHLIGHT
--==================================================

local function ApplyWorldHighlight(cat,model)

    if not VisualState.ESP.WorldESP then
        return
    end

    if not WorldSelected(cat) then
        return
    end

    local entry=WorldReg[cat][model]

    if not entry then
        return
    end

    local part=entry.part

    if not ValidWorldPart(part)
    or not part:IsDescendantOf(model) then

        part=PickWorldPart(model,cat)
        entry.part=part

    end

    if not ValidWorldPart(part) then
        return
    end

    local key=WorldKey(cat,model)

    local hl=ESPFolder:FindFirstChild(
        key.."_HL"
    )

    if not hl then

        hl=Instance.new("Highlight")
        hl.Name=key.."_HL"
        hl.DepthMode=Enum.HighlightDepthMode.AlwaysOnTop
        hl.Parent=ESPFolder

    end

    hl.Adornee=model
    hl.FillColor=WorldColor(cat)
    hl.OutlineColor=WorldColor(cat)

    hl.FillTransparency=
        math.clamp(
            VisualState.ESP.FillTransparency,
            0,
            1
        )

    hl.OutlineTransparency=
        math.clamp(
            VisualState.ESP.OutlineTransparency,
            0,
            1
        )

    hl.Enabled=true
end

--==================================================
-- WORLD NAME / DISTANCE
--==================================================

local function ApplyWorldTag(cat,model)

    local entry=WorldReg[cat][model]

    if not entry then
        return
    end

    local part=entry.part

    if not ValidWorldPart(part) then
        return
    end

    local nameText=""

    if VisualState.ESP.WorldNametags then

        if cat=="Palletwrong" then
            nameText="Pallet"
        elseif cat=="SCPZombie" then
            nameText=model.Name
        else
            nameText=cat
        end

    end

    local distanceText=""

    if VisualState.ESP.WorldDistanceESP then

        local char=LP.Character
        local root=
            char
            and char:FindFirstChild(
                "HumanoidRootPart"
            )

        if root then

            local distance=math.floor(
                (root.Position-part.Position).Magnitude
            )

            distanceText=
                "["..distance.."m]"

        end

    end

    local text=nameText

    if text~=""
    and distanceText~="" then

        text=text.."  "..distanceText

    elseif distanceText~="" then

        text=distanceText

    end

    local key=WorldKey(cat,model)
    local tagName=key.."_Tag"

    if text=="" then

        Destroy(tagName)
        return
    end

    local tag=ESPFolder:FindFirstChild(tagName)

    if not tag then

        tag=Instance.new("BillboardGui")
        tag.Name=tagName
        tag.AlwaysOnTop=true
        tag.LightInfluence=0
        tag.MaxDistance=0
        tag.Size=UDim2.fromOffset(220,22)
        tag.StudsOffset=Vector3.new(0,2.5,0)
        tag.Parent=ESPFolder

        local textLabel=Instance.new("TextLabel")
        textLabel.Name="Text"
        textLabel.BackgroundTransparency=1
        textLabel.Size=UDim2.fromScale(1,1)
        textLabel.Font=Enum.Font.GothamBold
        textLabel.TextStrokeTransparency=.25
        textLabel.Parent=tag

    end

    tag.Adornee=part
    tag.Enabled=true

    local textLabel=tag:FindFirstChild("Text")

    if textLabel then

        textLabel.Text=text
        textLabel.TextSize=
            VisualState.ESP.TextSize

        textLabel.TextColor3=
            WorldColor(cat)

    end
end

--==================================================
-- WORLD CLEAR
--==================================================

local function ClearWorld()

    for cat,models in pairs(WorldReg) do

        for model in pairs(models) do
            ClearWorldVisual(cat,model)
        end

    end
end

--==================================================
-- WORLD LOOP
--==================================================

local function StartWorldESP()

    if WorldLoop then
        return
    end

    RefreshWorldRoots()

    WorldLoop=task.spawn(function()

        while GUI
        and GUI.Parent do

            if VisualState.ESP.WorldESP then

                for cat,models in pairs(WorldReg) do

                    if WorldSelected(cat) then

                        for model,entry in pairs(models) do

                            if not WorldAlive(model) then

                                ClearWorldVisual(cat,model)
                                models[model]=nil

                            else

                                if cat=="Palletwrong"
                                and model:GetAttribute("Destroyed")==true then

                                    ClearWorldVisual(cat,model)
                                    models[model]=nil

                                else

                                    ApplyWorldHighlight(
                                        cat,
                                        model
                                    )

                                    ApplyWorldTag(
                                        cat,
                                        model
                                    )

                                end

                            end

                        end

                    else

                        for model in pairs(models) do
                            ClearWorldVisual(cat,model)
                        end

                    end

                end

            else

                ClearWorld()

            end

            task.wait(.25)
        end

        WorldLoop=nil
    end)
end

StartWorldESP()

workspace.ChildAdded:Connect(function(obj)

    if obj.Name=="Map"
    or obj.Name=="Map1" then

        task.wait(.15)
        RefreshWorldRoots()

    end

end)

workspace.ChildRemoved:Connect(function(obj)

    if obj.Name=="Map"
    or obj.Name=="Map1" then

        task.wait(.1)
        RefreshWorldRoots()

    end

end)

print("[KysHub] World ESP V3 loaded")

--==================================================
-- CLEAR PLAYER
--==================================================

local function ClearPlayer(player)

    local key=PlayerKey(player)

    Destroy("KYS_PlayerHL_"..key)
    Destroy("KYS_PlayerTag_"..key)
    Destroy("KYS_PlayerItem_"..key)
    Destroy("KYS_KillerWarning_"..key)
end

--==================================================
-- APPLY PLAYER
--==================================================

local function ApplyPlayer(player)

    if player==LP then
        return
    end

    local character=player.Character

    if not character then
        ClearPlayer(player)
        return
    end

    if not State.ESP.PlayerESP then
        ClearPlayer(player)
        return
    end

    if not RoleEnabled(player) then
        ClearPlayer(player)
        return
    end

    ApplyHighlight(
        player,
        character
    )

    ApplyPlayerTag(
        player,
        character
    )

    ApplyItemIcon(
        player,
        character
    )

    ApplyKillerWarning(
        player,
        character
    )
end

--==================================================
-- CLEAR ALL
--==================================================

local function ClearAll()

    if not ESPFolder then
        return
    end

    for _,obj in ipairs(ESPFolder:GetChildren()) do

        if obj.Name:sub(1,10)=="KYS_Player"
        or obj.Name:sub(1,18)=="KYS_KillerWarning" then

            obj:Destroy()
        end

    end
end

--==================================================
-- REFRESH
--==================================================

local function Refresh()

    if not State.ESP.PlayerESP then
        ClearAll()
        return
    end

    GetESPFolder()

    for _,player in ipairs(Players:GetPlayers()) do

        if player~=LP then
            pcall(
                ApplyPlayer,
                player
            )
        end

    end
end

--==================================================
-- PLAYER WATCH
--==================================================

local function WatchPlayer(player)

    if player==LP then
        return
    end

    if PlayerConnections[player] then

        for _,connection in pairs(PlayerConnections[player]) do
            pcall(function()
                connection:Disconnect()
            end)
        end

    end

    PlayerConnections[player]={}

    table.insert(
        PlayerConnections[player],
        player.CharacterAdded:Connect(function()
            task.wait(.15)
            ApplyPlayer(player)
        end)
    )

    table.insert(
        PlayerConnections[player],
        player.CharacterRemoving:Connect(function()
            ClearPlayer(player)
        end)
    )

    table.insert(
        PlayerConnections[player],
        player:GetPropertyChangedSignal("Team"):Connect(function()
            task.wait()
            ApplyPlayer(player)
        end)
    )

    ApplyPlayer(player)
end

--==================================================
-- PLAYER ADDED
--==================================================

for _,player in ipairs(Players:GetPlayers()) do
    WatchPlayer(player)
end

Players.PlayerAdded:Connect(function(player)
    WatchPlayer(player)
end)

Players.PlayerRemoving:Connect(function(player)

    ClearPlayer(player)

    if PlayerConnections[player] then

        for _,connection in pairs(PlayerConnections[player]) do
            pcall(function()
                connection:Disconnect()
            end)

        end

        PlayerConnections[player]=nil
    end
end)

--==================================================
-- LOOP
--==================================================

if PlayerLoop then
    pcall(function()
        task.cancel(PlayerLoop)
    end)
end

PlayerLoop=task.spawn(function()

    while GUI
    and GUI.Parent do

        if State.ESP.PlayerESP then
            pcall(Refresh)
        else
            ClearAll()
        end

        task.wait(.25)
    end

end)

print("[KysHub] Player ESP logic loaded")

-- =====================================================
-- CAMERA LOGIC V2
-- =====================================================

local Camera=workspace.CurrentCamera

local CameraOriginalFOV=nil
local CameraOriginalType=nil
local CameraOriginalOffset=nil
local CameraOriginalMinZoom=nil
local CameraOriginalMaxZoom=nil

local CameraBound=false

local function GetCamera()

    Camera=workspace.CurrentCamera

    return Camera

end

--==================================================
-- FOV
--==================================================

local function UpdateCameraFOV()

    local cam=GetCamera()

    if not cam then
        return
    end

    if State.Camera.FOVEnabled then

        if CameraOriginalFOV==nil then

            CameraOriginalFOV=
                cam.FieldOfView

        end

        cam.FieldOfView=
            math.clamp(
                tonumber(State.Camera.FOV) or 70,
                30,
                140
            )

    else

        if CameraOriginalFOV~=nil then

            cam.FieldOfView=
                CameraOriginalFOV

            CameraOriginalFOV=nil

        end
    end
end

--==================================================
-- THIRD PERSON
--==================================================

local function UpdateThirdPerson()

    local char=LP.Character

    local humanoid=
        char
        and char:FindFirstChildOfClass(
            "Humanoid"
        )

    local cam=GetCamera()

    if not humanoid
    or not cam then
        return
    end

    local enabled=
        State.Camera.ThirdPerson
        and GetRole(LP)=="Killer"

    if enabled then

        if CameraOriginalType==nil then

            CameraOriginalType=
                cam.CameraType

        end

        if CameraOriginalOffset==nil then

            CameraOriginalOffset=
                humanoid.CameraOffset

        end

        cam.CameraType=
            Enum.CameraType.Custom

        humanoid.CameraOffset=
            Vector3.new(2,1,0)

    else

        if CameraOriginalOffset~=nil then

            humanoid.CameraOffset=
                CameraOriginalOffset

            CameraOriginalOffset=nil

        end

        if CameraOriginalType~=nil then

            cam.CameraType=
                CameraOriginalType

            CameraOriginalType=nil

        end
    end
end

--==================================================
-- SHIFT LOCK
--==================================================

local function UpdateShiftLock()

    local char=LP.Character

    if not char then
        return
    end

    local humanoid=
        char:FindFirstChildOfClass(
            "Humanoid"
        )

    local root=
        char:FindFirstChild(
            "HumanoidRootPart"
        )

    local cam=GetCamera()

    if not humanoid
    or not root
    or not cam then
        return
    end

    if State.Camera.ShiftLock then

        humanoid.AutoRotate=false

        local look=
            cam.CFrame.LookVector

        local flat=
            Vector3.new(
                look.X,
                0,
                look.Z
            )

        if flat.Magnitude>0.001 then

            root.CFrame=
                CFrame.new(
                    root.Position,
                    root.Position+flat
                )

        end

    else

        humanoid.AutoRotate=true

    end
end

--==================================================
-- INFINITY ZOOM
--==================================================

local function UpdateInfinityZoom()

    if CameraOriginalMinZoom==nil then

        CameraOriginalMinZoom=
            LP.CameraMinZoomDistance

    end

    if CameraOriginalMaxZoom==nil then

        CameraOriginalMaxZoom=
            LP.CameraMaxZoomDistance

    end

    if State.Camera.InfinityZoom then

        LP.CameraMinZoomDistance=0.5
        LP.CameraMaxZoomDistance=100000

    else

        if CameraOriginalMinZoom~=nil then

            LP.CameraMinZoomDistance=
                CameraOriginalMinZoom

        end

        if CameraOriginalMaxZoom~=nil then

            LP.CameraMaxZoomDistance=
                CameraOriginalMaxZoom

        end
    end
end

--==================================================
-- NO CUTSCENE
--==================================================

local function ApplyNoCutscene()

    if not State.Camera.NoCutscene then
        return
    end

    local cam=GetCamera()

    if not cam then
        return
    end

    cam.CameraType=
        Enum.CameraType.Custom

    cam.FieldOfView=70

    UIS.MouseIconEnabled=true
end

--==================================================
-- CAMERA UPDATE
--==================================================

local function UpdateCamera()

    if not GUI
    or not GUI.Parent then
        return
    end

    UpdateCameraFOV()
    UpdateThirdPerson()
    UpdateShiftLock()
    UpdateInfinityZoom()
    ApplyNoCutscene()

end

--==================================================
-- RENDER CONNECTION
--==================================================

if not CameraBound then

    CameraBound=true

    RunService:BindToRenderStep(
        "KysHub_Camera",
        Enum.RenderPriority.Camera.Value+1,
        UpdateCamera
    )

end

--==================================================
-- RESPAWN
--==================================================

LP.CharacterAdded:Connect(
    function()

        CameraOriginalFOV=nil
        CameraOriginalType=nil
        CameraOriginalOffset=nil

        task.wait(1)

        UpdateCamera()

    end
)

--==================================================
-- CAMERA CHANGED
--==================================================

workspace:GetPropertyChangedSignal(
    "CurrentCamera"
):Connect(
    function()

        Camera=workspace.CurrentCamera

        CameraOriginalFOV=nil
        CameraOriginalType=nil
        CameraOriginalOffset=nil

        task.wait()

        UpdateCamera()

    end
)

print("[KysHub] Camera V2 loaded")

-- =====================================================
-- PROTECCIÓN DEL MENÚ CONTRA CINEMÁTICAS
-- =====================================================

GUI.ResetOnSpawn=false
GUI.IgnoreGuiInset=true
GUI.DisplayOrder=999999
GUI.ZIndexBehavior=Enum.ZIndexBehavior.Global

local function ProtectMenu()
    if GUI and GUI.Parent then
        GUI.Enabled=true
        GUI.ResetOnSpawn=false
        GUI.IgnoreGuiInset=true
        GUI.DisplayOrder=999999
    end
end

GUI:GetPropertyChangedSignal("Enabled"):Connect(function()
    if not GUI.Enabled then
        task.defer(function()
            if GUI and GUI.Parent then
                GUI.Enabled=true
            end
        end)
    end
end)

GUI.AncestryChanged:Connect(function(_,parent)
    if not parent then
        task.defer(function()
            local playerGui=LP:FindFirstChildOfClass("PlayerGui")

            if playerGui and GUI then
                GUI.Parent=playerGui
                ProtectMenu()
            end
        end)
    end
end)

LP.CharacterAdded:Connect(function()
    task.wait(0.5)

    local playerGui=LP:FindFirstChildOfClass("PlayerGui")

    if playerGui and GUI then
        GUI.Parent=playerGui
        ProtectMenu()
    end
end)

ProtectMenu()

--==================================================
-- WORLD ESP V2
--==================================================

local WorldReg={
    Generator={},
    Hook={},
    Gate={},
    Window={},
    Palletwrong={},
    SCPZombie={}
}

local WorldConnections={}
local WorldLoop=nil

--==================================================
-- PART FINDER
--==================================================

local function WorldPart(model,cat)

    if not model or not model.Parent then
        return nil
    end

    if cat=="Generator" then

        local part=
            model:FindFirstChild("HitBox",true)
            or model:FindFirstChild("GeneratorPoint",true)

        if part and part:IsA("BasePart") then
            return part
        end

    elseif cat=="Palletwrong" then

        local candidates={
            model:FindFirstChild("HumanoidRootPart",true),
            model:FindFirstChild("PrimaryPartPallet",true),
            model:FindFirstChild("Primary1",true),
            model:FindFirstChild("Primary2",true),
            model:FindFirstChild("PalletPoint",true),
            model:FindFirstChild("PalletPointSlide",true)
        }

        for _,part in ipairs(candidates) do
            if part and part:IsA("BasePart") then
                return part
            end
        end

    elseif cat=="Window" then

        local part=
            model:FindFirstChild("VaultPoint",true)
            or model:FindFirstChild("VaultTrigger",true)

        if part and part:IsA("BasePart") then
            return part
        end

    elseif cat=="SCPZombie" then

        local part=
            model:FindFirstChild("HumanoidRootPart",true)
            or model:FindFirstChild("UpperTorso",true)
            or model:FindFirstChild("Torso",true)

        if part and part:IsA("BasePart") then
            return part
        end
    end

    return model:FindFirstChildWhichIsA(
        "BasePart",
        true
    )
end

--==================================================
-- CATEGORY
--==================================================

local function WorldSelected(cat)

    local selected=State.ESP.WorldTypes

    if type(selected)~="table" then
        return false
    end

    local names={
        Generator="Generators",
        Hook="Hooks",
        Gate="Gates",
        Window="Windows",
        Palletwrong="Pallets",
        SCPZombie="SCP / Zombie"
    }

    local wanted=names[cat]

    if selected[wanted]~=nil then
        return selected[wanted]==true
    end

    for _,value in pairs(selected) do
        if value==wanted then
            return true
        end
    end

    return false
end

local function WorldColor(cat)

    if cat=="Generator" then
        return State.ESP.GeneratorColor
    elseif cat=="Hook" then
        return State.ESP.HookColor
    elseif cat=="Gate" then
        return State.ESP.GateColor
    elseif cat=="Window" then
        return State.ESP.WindowColor
    elseif cat=="Palletwrong" then
        return State.ESP.PalletColor
    elseif cat=="SCPZombie" then
        return State.ESP.SCPZombieColor
    end

    return WHITE
end

--==================================================
-- KEY
--==================================================

local function WorldKey(cat,model)

    return "KYS_World_"
        ..cat
        .."_"
        ..tostring(model):gsub(
            "[^%w]",
            "_"
        )
end

--==================================================
-- CLEAR
--==================================================

local function ClearWorld(cat,model)

    local key=WorldKey(cat,model)

    Destroy(key.."_HL")
    Destroy(key.."_Tag")
end

local function RemoveWorld(cat,model)

    ClearWorld(cat,model)

    if WorldReg[cat] then
        WorldReg[cat][model]=nil
    end
end

--==================================================
-- REGISTER
--==================================================

local function RegisterWorld(obj)

    if not obj or not obj.Parent then
        return
    end

    local valid={
        Generator=true,
        Hook=true,
        Gate=true,
        Window=true,
        Palletwrong=true,
        Pallet=true
    }

    if obj:IsA("Model") then

        local cat=obj.Name

        if cat=="Pallet" then
            cat="Palletwrong"
        end

        if valid[obj.Name] then

            local part=WorldPart(obj,cat)

            if part then
                WorldReg[cat][obj]={
                    model=obj,
                    part=part
                }
            end

            return
        end

        local lower=obj.Name:lower()

        if lower:find("scp")
        or lower:find("zombie") then

            local part=WorldPart(
                obj,
                "SCPZombie"
            )

            if part then
                WorldReg.SCPZombie[obj]={
                    model=obj,
                    part=part
                }
            end
        end

        return
    end

    if obj:IsA("BasePart") then

        local parent=obj.Parent

        while parent
        and parent~=workspace do

            if parent:IsA("Model") then

                local cat=parent.Name

                if cat=="Pallet" then
                    cat="Palletwrong"
                end

                if valid[parent.Name] then

                    local part=WorldPart(
                        parent,
                        cat
                    )

                    if part then
                        WorldReg[cat][parent]={
                            model=parent,
                            part=part
                        }
                    end

                    return
                end

                local lower=parent.Name:lower()

                if lower:find("scp")
                or lower:find("zombie") then

                    local part=WorldPart(
                        parent,
                        "SCPZombie"
                    )

                    if part then
                        WorldReg.SCPZombie[parent]={
                            model=parent,
                            part=part
                        }
                    end

                    return
                end
            end

            parent=parent.Parent
        end
    end
end

--==================================================
-- UNREGISTER
--==================================================

local function UnregisterWorld(obj)

    if not obj then
        return
    end

    local valid={
        Generator=true,
        Hook=true,
        Gate=true,
        Window=true,
        Palletwrong=true,
        Pallet=true
    }

    if obj:IsA("Model") then

        local cat=obj.Name

        if cat=="Pallet" then
            cat="Palletwrong"
        end

        if valid[obj.Name] then

            RemoveWorld(
                cat,
                obj
            )

            return
        end

        local lower=obj.Name:lower()

        if lower:find("scp")
        or lower:find("zombie") then

            RemoveWorld(
                "SCPZombie",
                obj
            )
        end

        return
    end

    if obj:IsA("BasePart") then

        for cat,models in pairs(WorldReg) do

            for model,entry in pairs(models) do

                if entry.part==obj then

                    RemoveWorld(
                        cat,
                        model
                    )

                end
            end
        end
    end
end

--==================================================
-- MAP WATCH
--==================================================

local function AttachWorldRoot(root)

    if not root
    or WorldConnections[root] then
        return
    end

    WorldConnections[root]={
        root.DescendantAdded:Connect(
            RegisterWorld
        ),

        root.DescendantRemoving:Connect(
            UnregisterWorld
        )
    }

    for _,obj in ipairs(
        root:GetDescendants()
    ) do

        RegisterWorld(obj)

    end
end

local function RefreshWorldRoots()

    for _,connections in pairs(
        WorldConnections
    ) do

        for _,connection in ipairs(
            connections
        ) do

            pcall(function()
                connection:Disconnect()
            end)

        end
    end

    WorldConnections={}

    for cat,models in pairs(WorldReg) do

        for model in pairs(models) do
            ClearWorld(cat,model)
        end

        WorldReg[cat]={}
    end

    local map=
        workspace:FindFirstChild("Map")

    local map1=
        workspace:FindFirstChild("Map1")

    if map then
        AttachWorldRoot(map)
    end

    if map1 then
        AttachWorldRoot(map1)
    end
end

--==================================================
-- HIGHLIGHT
--==================================================

local function ApplyWorldHighlight(
    cat,
    model,
    entry
)

    if not model
    or not model.Parent then

        RemoveWorld(
            cat,
            model
        )

        return
    end

    if not State.ESP.WorldESP
    or not WorldSelected(cat) then

        ClearWorld(
            cat,
            model
        )

        return
    end

    local part=entry.part

    if not part
    or not part.Parent
    or not part:IsDescendantOf(model) then

        part=WorldPart(
            model,
            cat
        )

        entry.part=part
    end

    if not part then
        return
    end

    GetESPFolder()

    local key=WorldKey(
        cat,
        model
    )

    local color=WorldColor(cat)

    local hl=ESPFolder:FindFirstChild(
        key.."_HL"
    )

    if not hl then

        hl=Instance.new("Highlight")
        hl.Name=key.."_HL"

        hl.DepthMode=
            Enum.HighlightDepthMode.AlwaysOnTop

        hl.Parent=ESPFolder
    end

    -- IMPORTANTE:
    -- usar el MODEL como Adornee,
    -- no solamente el HitBox/part.

    hl.Adornee=model

    hl.FillColor=color
    hl.OutlineColor=color

    hl.FillTransparency=
        math.clamp(
            State.ESP.FillTransparency,
            0,
            1
        )

    hl.OutlineTransparency=
        math.clamp(
            State.ESP.OutlineTransparency,
            0,
            1
        )

    hl.Enabled=true
end

--==================================================
-- WORLD TAG
--==================================================

local function ApplyWorldTag(
    cat,
    model,
    part
)

    local key=WorldKey(
        cat,
        model
    )

    local tagName=
        key.."_Tag"

    if not State.ESP.WorldNametags
    and not State.ESP.WorldDistanceESP then

        Destroy(tagName)
        return
    end

    if not part then
        Destroy(tagName)
        return
    end

    local tag=
        ESPFolder:FindFirstChild(
            tagName
        )

    if not tag then

        tag=Instance.new("BillboardGui")
        tag.Name=tagName
        tag.AlwaysOnTop=true
        tag.LightInfluence=0
        tag.MaxDistance=0
        tag.Size=UDim2.fromOffset(
            180,
            45
        )
        tag.StudsOffset=
            Vector3.new(0,3,0)

        tag.Parent=ESPFolder

        local text=Instance.new(
            "TextLabel"
        )

        text.Name="Text"
        text.BackgroundTransparency=1
        text.Size=UDim2.fromScale(
            1,
            1
        )
        text.TextStrokeTransparency=.25
        text.Parent=tag
    end

    tag.Adornee=part
    tag.Enabled=true

    local text=
        tag:FindFirstChild("Text")

    if not text then
        return
    end

    local names={
        Generator="Generator",
        Hook="Hook",
        Gate="Gate",
        Window="Window",
        Palletwrong="Pallet",
        SCPZombie="SCP / Zombie"
    }

    local lines={}

    if State.ESP.WorldNametags then
        table.insert(
            lines,
            names[cat] or cat
        )
    end

    if State.ESP.WorldDistanceESP then

        local char=LP.Character

        local root=
            char
            and char:FindFirstChild(
                "HumanoidRootPart"
            )

        if root then

            local distance=math.floor(
                (
                    root.Position
                    -part.Position
                ).Magnitude
            )

            table.insert(
                lines,
                "["..distance.."m]"
            )
        end
    end

    text.Text=table.concat(
        lines,
        " "
    )

    text.TextSize=
        State.ESP.TextSize

    text.TextColor3=
        WorldColor(cat)
end

--==================================================
-- REFRESH
--==================================================

local function RefreshWorld()

    if not State.ESP.WorldESP then

        if ESPFolder then

            for cat,models in pairs(
                WorldReg
            ) do

                for model in pairs(models) do
                    ClearWorld(
                        cat,
                        model
                    )
                end
            end
        end

        return
    end

    GetESPFolder()

    for cat,models in pairs(
        WorldReg
    ) do

        for model,entry in pairs(models) do

            if WorldSelected(cat) then

                pcall(
                    ApplyWorldHighlight,
                    cat,
                    model,
                    entry
                )

                pcall(
                    ApplyWorldTag,
                    cat,
                    model,
                    entry.part
                )

            else

                ClearWorld(
                    cat,
                    model
                )

            end
        end
    end
end

--==================================================
-- START
--==================================================

RefreshWorldRoots()

if WorldLoop then
    pcall(function()
        task.cancel(WorldLoop)
    end)
end

WorldLoop=task.spawn(function()

    while GUI
    and GUI.Parent do

        pcall(
            RefreshWorld
        )

        task.wait(.25)
    end

end)

workspace.ChildAdded:Connect(
    function(child)

        if child.Name=="Map"
        or child.Name=="Map1" then

            task.wait(.2)

            AttachWorldRoot(child)
            RefreshWorld()

        end
    end
)

workspace.ChildRemoved:Connect(
    function(child)

        if child.Name=="Map"
        or child.Name=="Map1" then

            RefreshWorldRoots()

        end
    end
)

print(
    "[KysHub] World ESP V2 loaded"
)