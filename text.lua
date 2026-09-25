local Players=game:GetService("Players")
local UserInputService=game:GetService("UserInputService")
local ContextActionService=game:GetService("ContextActionService")
local TweenService=game:GetService("TweenService")
local RunService=game:GetService("RunService")

local LocalPlayer=Players.LocalPlayer
local PlayerGui=LocalPlayer:WaitForChild("PlayerGui")

local IDS={
	Floating="rbxassetid://97723259169310",
	Background="rbxassetid://106827487721783",
	WarningYellow="rbxassetid://120753562298647",
	WarningRed="rbxassetid://99499680507460",
	SpectatorEye="rbxassetid://85623975924363",
	Dashboard="rbxassetid://76923384537622",
	Visual="rbxassetid://128369431495583",
	Main="rbxassetid://122076438981661",
	Aim="rbxassetid://131216405316082",
	Mapping="rbxassetid://136230310763744",
	Player="rbxassetid://116226775614038",
	Config="rbxassetid://121240983643471",
	KillerESP="rbxassetid://82556507969698",
	SurvivorESP="rbxassetid://92090688433136",
	SpectatorESP="rbxassetid://104530403779064",
	WorldESP="rbxassetid://80375500569065",
	Camera="rbxassetid://79839886609854",
	Lighting="rbxassetid://104097867732816",
	GameInfo="rbxassetid://112396000138405",
	Survivor="rbxassetid://98668024380623",
	Killer="rbxassetid://72284651806372",
	Automation="rbxassetid://100548873375720",
	Utilities="rbxassetid://87830132220340",
	Others="rbxassetid://99927158255777",
	Info="rbxassetid://120447678741132",
	Aimbot="rbxassetid://129000867872009",
	KillerAim="rbxassetid://108474847929998",
	SurvivorAim="rbxassetid://88408405954370",
	Crosshair="rbxassetid://97809427353730",
	Spear="rbxassetid://92465630897125",
	Flask="rbxassetid://87415718393828",
	Teleport="rbxassetid://106629339497075",
	Radar="rbxassetid://121934977788749",
	System="rbxassetid://104806511010721",
	Filters="rbxassetid://71708933906334",
	Movement="rbxassetid://98668024380623",
	Fling="rbxassetid://140146718588465",
	Emote="rbxassetid://108329282586807",
	AvatarTools="rbxassetid://88408405954370",
	Fun="rbxassetid://90409197187623",
	Save="rbxassetid://116784199187284",
	List="rbxassetid://115200960959757",
	AutoSave="rbxassetid://71690311330962",
	Format="rbxassetid://116109407768752",
}

local Colors={
	Background=Color3.fromRGB(8,12,27),
	Panel=Color3.fromRGB(13,19,39),
	Panel2=Color3.fromRGB(18,25,48),
	Border=Color3.fromRGB(67,82,125),
	Text=Color3.fromRGB(235,239,255),
	SubText=Color3.fromRGB(158,169,202),
	Gold=Color3.fromRGB(255,202,75),
	GoldSoft=Color3.fromRGB(220,172,55),
	White=Color3.fromRGB(255,255,255),
	Black=Color3.fromRGB(0,0,0),
}

local Hooks={
	Toggle=function(name,value) end,
	Slider=function(name,value) end,
	Dropdown=function(name,value) end,
	Color=function(name,value) end,
	Button=function(name) end,
}

local Gui=Instance.new("ScreenGui")
Gui.Name="PerfectMenuUI"
Gui.ResetOnSpawn=false
Gui.IgnoreGuiInset=true
Gui.DisplayOrder=100000
Gui.ZIndexBehavior=Enum.ZIndexBehavior.Sibling
Gui.Parent=PlayerGui

local Closed=false

task.spawn(function()
	while not Closed and Gui.Parent do
		Gui.Enabled=true
		if Gui.Parent~=PlayerGui then Gui.Parent=PlayerGui end
		if Gui.DisplayOrder<100000 then Gui.DisplayOrder=100000 end
		task.wait(.15)
	end
end)

local function New(class,parent,props)
	local obj=Instance.new(class)
	if props then
		for property,value in pairs(props) do obj[property]=value end
	end
	obj.Parent=parent
	return obj
end

local Floating=New("ImageButton",Gui,{
	Name="FloatingButton",
	Size=UDim2.fromOffset(54,54),
	Position=UDim2.new(0,20,.5,-27),
	BackgroundTransparency=1,
	Image=IDS.Floating,
	AutoButtonColor=false,
	BorderSizePixel=0,
	Active=true,
	ZIndex=100,
})

New("UICorner",Floating,{CornerRadius=UDim.new(0,12)})

local Menu=New("Frame",Gui,{
	Name="Menu",
	Size=UDim2.fromOffset(850,560),
	Position=UDim2.new(.5,-425,.5,-280),
	BackgroundColor3=Colors.Background,
	BackgroundTransparency=.08,
	BorderSizePixel=0,
	Visible=false,
	Active=true,
	ZIndex=10,
	ClipsDescendants=true,
})

New("UICorner",Menu,{CornerRadius=UDim.new(0,14)})
New("UIStroke",Menu,{Color=Colors.Border,Thickness=1,Transparency=.25})

local MenuScale=New("UIScale",Menu,{Scale=1})

local Background=New("ImageLabel",Menu,{
	Name="MenuBackground",
	Size=UDim2.fromScale(1,1),
	BackgroundTransparency=1,
	Image=IDS.Background,
	ImageTransparency=.08,
	ScaleType=Enum.ScaleType.Crop,
	ZIndex=10,
})

New("UICorner",Background,{CornerRadius=UDim.new(0,14)})

local BackgroundShade=New("Frame",Menu,{
	Name="BackgroundShade",
	Size=UDim2.fromScale(1,1),
	BackgroundColor3=Colors.Background,
	BackgroundTransparency=.55,
	BorderSizePixel=0,
	ZIndex=11,
})

New("UICorner",BackgroundShade,{CornerRadius=UDim.new(0,14)})

local Header=New("Frame",Menu,{
	Name="Header",
	Size=UDim2.new(1,0,0,62),
	BackgroundColor3=Colors.Panel,
	BackgroundTransparency=.22,
	BorderSizePixel=0,
	Active=true,
	ZIndex=20,
})

New("UICorner",Header,{CornerRadius=UDim.new(0,14)})

New("TextLabel",Header,{
	Name="Title",
	Size=UDim2.new(1,-120,1,0),
	Position=UDim2.fromOffset(22,0),
	BackgroundTransparency=1,
	Text="The stars invite me to dream",
	TextColor3=Colors.Text,
	TextSize=20,
	Font=Enum.Font.GothamSemibold,
	TextXAlignment=Enum.TextXAlignment.Left,
	TextYAlignment=Enum.TextYAlignment.Center,
	ZIndex=21,
})

local Minimize=New("TextButton",Header,{
	Name="Minimize",
	Size=UDim2.fromOffset(38,38),
	Position=UDim2.new(1,-84,.5,-19),
	BackgroundColor3=Colors.Panel2,
	BackgroundTransparency=.1,
	Text="−",
	TextColor3=Colors.Text,
	TextSize=24,
	Font=Enum.Font.GothamBold,
	AutoButtonColor=false,
	BorderSizePixel=0,
	Active=true,
	ZIndex=22,
})

New("UICorner",Minimize,{CornerRadius=UDim.new(0,9)})

local Close=New("TextButton",Header,{
	Name="Close",
	Size=UDim2.fromOffset(38,38),
	Position=UDim2.new(1,-42,.5,-19),
	BackgroundColor3=Colors.Panel2,
	BackgroundTransparency=.1,
	Text="×",
	TextColor3=Colors.Text,
	TextSize=23,
	Font=Enum.Font.GothamBold,
	AutoButtonColor=false,
	BorderSizePixel=0,
	Active=true,
	ZIndex=22,
})

New("UICorner",Close,{CornerRadius=UDim.new(0,9)})

local Body=New("Frame",Menu,{
	Name="Body",
	Size=UDim2.new(1,-20,1,-74),
	Position=UDim2.fromOffset(10,68),
	BackgroundTransparency=1,
	BorderSizePixel=0,
	ZIndex=20,
})

local Sidebar=New("Frame",Body,{
	Name="Sidebar",
	Size=UDim2.new(0,190,1,0),
	BackgroundColor3=Colors.Panel,
	BackgroundTransparency=.18,
	BorderSizePixel=0,
	ZIndex=25,
})

New("UICorner",Sidebar,{CornerRadius=UDim.new(0,11)})

New("UIPadding",Sidebar,{
	PaddingTop=UDim.new(0,10),
	PaddingBottom=UDim.new(0,10),
	PaddingLeft=UDim.new(0,10),
	PaddingRight=UDim.new(0,10),
})

New("UIListLayout",Sidebar,{
	SortOrder=Enum.SortOrder.LayoutOrder,
	Padding=UDim.new(0,7),
})

local Content=New("Frame",Body,{
	Name="Content",
	Size=UDim2.new(1,-200,1,0),
	Position=UDim2.fromOffset(200,0),
	BackgroundColor3=Colors.Panel,
	BackgroundTransparency=.20,
	BorderSizePixel=0,
	ZIndex=25,
})

New("UICorner",Content,{CornerRadius=UDim.new(0,11)})

local ContentTitle=New("TextLabel",Content,{
	Name="ContentTitle",
	Size=UDim2.new(1,-30,0,45),
	Position=UDim2.fromOffset(15,8),
	BackgroundTransparency=1,
	Text="Dashboard",
	TextColor3=Colors.Text,
	TextSize=18,
	Font=Enum.Font.GothamSemibold,
	TextXAlignment=Enum.TextXAlignment.Left,
	TextYAlignment=Enum.TextYAlignment.Center,
	ZIndex=26,
})

New("Frame",Content,{
	Name="ContentLine",
	Size=UDim2.new(1,-30,0,1),
	Position=UDim2.fromOffset(15,53),
	BackgroundColor3=Colors.Border,
	BackgroundTransparency=.35,
	BorderSizePixel=0,
	ZIndex=26,
})

local SubContainer=New("ScrollingFrame",Content,{
	Name="SubContainer",
	Size=UDim2.new(1,-30,0,52),
	Position=UDim2.fromOffset(15,62),
	BackgroundTransparency=1,
	BorderSizePixel=0,
	ScrollBarThickness=3,
	CanvasSize=UDim2.new(),
	AutomaticCanvasSize=Enum.AutomaticSize.X,
	ScrollingDirection=Enum.ScrollingDirection.X,
	Visible=false,
	ZIndex=29,
})

New("UIListLayout",SubContainer,{
	FillDirection=Enum.FillDirection.Horizontal,
	SortOrder=Enum.SortOrder.LayoutOrder,
	Padding=UDim.new(0,6),
})

local ControlArea=New("ScrollingFrame",Content,{
	Name="ControlArea",
	Size=UDim2.new(1,-30,1,-125),
	Position=UDim2.fromOffset(15,120),
	BackgroundTransparency=1,
	BorderSizePixel=0,
	ScrollBarThickness=4,
	CanvasSize=UDim2.new(),
	AutomaticCanvasSize=Enum.AutomaticSize.Y,
	ScrollingDirection=Enum.ScrollingDirection.Y,
	ZIndex=29,
})

New("UIPadding",ControlArea,{
	PaddingTop=UDim.new(0,5),
	PaddingBottom=UDim.new(0,10),
})

New("UIListLayout",ControlArea,{
	SortOrder=Enum.SortOrder.LayoutOrder,
	Padding=UDim.new(0,8),
})

local ScaleHandle=New("TextButton",Menu,{
	Name="ScaleHandle",
	Size=UDim2.fromOffset(32,32),
	Position=UDim2.new(1,-34,1,-34),
	BackgroundTransparency=1,
	Text="↗",
	TextColor3=Colors.SubText,
	TextSize=19,
	Font=Enum.Font.GothamBold,
	AutoButtonColor=false,
	BorderSizePixel=0,
	Active=true,
	ZIndex=100,
})

local function SinkCamera()
	return Enum.ContextActionResult.Sink
end

local function LockCamera()
	ContextActionService:BindActionAtPriority(
		"PerfectMenu_BlockCamera",
		SinkCamera,
		false,
		Enum.ContextActionPriority.High.Value,
		Enum.UserInputType.MouseMovement,
		Enum.UserInputType.MouseButton1,
		Enum.UserInputType.Touch
	)
end

local function UnlockCamera()
	ContextActionService:UnbindAction("PerfectMenu_BlockCamera")
end

local function DragObject(object,getPosition,setPosition)
	local dragging=false
	local startInput
	local startPosition
	local dragInput

	object.InputBegan:Connect(function(input)
		if input.UserInputType==Enum.UserInputType.MouseButton1
		or input.UserInputType==Enum.UserInputType.Touch then
			dragging=true
			startInput=input.Position
			startPosition=getPosition()
			dragInput=input
			LockCamera()

			input.Changed:Connect(function()
				if input.UserInputState==Enum.UserInputState.End then
					dragging=false
					UnlockCamera()
				end
			end)
		end
	end)

	object.InputChanged:Connect(function(input)
		if input.UserInputType==Enum.UserInputType.MouseMovement
		or input.UserInputType==Enum.UserInputType.Touch then
			dragInput=input
		end
	end)

	UserInputService.InputChanged:Connect(function(input)
		if dragging and input==dragInput then
			local delta=input.Position-startInput
			setPosition(startPosition,delta)
		end
	end)
end

DragObject(
	Floating,
	function()
		return Floating.Position
	end,
	function(start,delta)
		Floating.Position=UDim2.new(
			start.X.Scale,start.X.Offset+delta.X,
			start.Y.Scale,start.Y.Offset+delta.Y
		)
	end
)

DragObject(
	Header,
	function()
		return Menu.Position
	end,
	function(start,delta)
		Menu.Position=UDim2.new(
			start.X.Scale,start.X.Offset+delta.X,
			start.Y.Scale,start.Y.Offset+delta.Y
		)
	end
)

local resizing=false
local resizeStart
local initialScale

ScaleHandle.InputBegan:Connect(function(input)
	if input.UserInputType==Enum.UserInputType.MouseButton1
	or input.UserInputType==Enum.UserInputType.Touch then
		resizing=true
		resizeStart=input.Position
		initialScale=MenuScale.Scale
		LockCamera()

		input.Changed:Connect(function()
			if input.UserInputState==Enum.UserInputState.End then
				resizing=false
				UnlockCamera()
			end
		end)
	end
end)

UserInputService.InputChanged:Connect(function(input)
	if not resizing then return end

	if input.UserInputType==Enum.UserInputType.MouseMovement
	or input.UserInputType==Enum.UserInputType.Touch then
		local delta=input.Position-resizeStart
		local amount=(delta.X+delta.Y)/700

		MenuScale.Scale=math.clamp(
			initialScale+amount,
			.65,
			1.35
		)
	end
end)

Floating.MouseButton1Click:Connect(function()
	Menu.Visible=not Menu.Visible
	Floating.Visible=not Menu.Visible
end)

Minimize.MouseButton1Click:Connect(function()
	Menu.Visible=false
	Floating.Visible=true
end)

Close.MouseButton1Click:Connect(function()
	Closed=true
	UnlockCamera()
	Gui:Destroy()
end)

local function ButtonHover(button)
	button.MouseEnter:Connect(function()
		TweenService:Create(button,TweenInfo.new(.15),{
			BackgroundTransparency=.05
		}):Play()
	end)

	button.MouseLeave:Connect(function()
		TweenService:Create(button,TweenInfo.new(.15),{
			BackgroundTransparency=.18
		}):Play()
	end)
end

ButtonHover(Minimize)
ButtonHover(Close)

local MainWindows={
	{Name="Dashboard",Title="Dashboard",Icon=IDS.Dashboard},
	{Name="Visual",Title="Visual",Icon=IDS.Visual},
	{Name="Main",Title="Main",Icon=IDS.Main},
	{Name="Aim",Title="Aim",Icon=IDS.Aim},
	{Name="Mapping",Title="Mapping",Icon=IDS.Mapping},
	{Name="Player",Title="Player",Icon=IDS.Player},
	{Name="Config",Title="Config",Icon=IDS.Config},
}

local SubWindows={
	Visual={
		{Name="KillerESP",Title="Killer ESP",Icon=IDS.KillerESP},
		{Name="SurvivorESP",Title="Survivor ESP",Icon=IDS.SurvivorESP},
		{Name="SpectatorESP",Title="Espectador ESP",Icon=IDS.SpectatorESP},
		{Name="WorldESP",Title="World ESP",Icon=IDS.WorldESP},
		{Name="Camera",Title="Cámara",Icon=IDS.Camera},
		{Name="Lighting",Title="Iluminación",Icon=IDS.Lighting},
		{Name="GameInfo",Title="Game Info Panel",Icon=IDS.GameInfo},
	},
	Main={
		{Name="Survivor",Title="Survivor",Icon=IDS.Survivor},
		{Name="Killer",Title="Killer",Icon=IDS.Killer},
		{Name="Automation",Title="Automatización",Icon=IDS.Automation},
		{Name="Utilities",Title="Utilidades",Icon=IDS.Utilities},
		{Name="Others",Title="Otros",Icon=IDS.Others},
		{Name="Info",Title="Info",Icon=IDS.Info},
	},
	Aim={
		{Name="Aimbot",Title="Aimbot",Icon=IDS.Aimbot},
		{Name="KillerAim",Title="Killer Aim",Icon=IDS.KillerAim},
		{Name="SurvivorAim",Title="Survivor Aim",Icon=IDS.SurvivorAim},
		{Name="Crosshair",Title="Advanced Crosshair",Icon=IDS.Crosshair},
		{Name="Spear",Title="Silent Aim Spear",Icon=IDS.Spear},
		{Name="Flask",Title="Silent Aim Flask",Icon=IDS.Flask},
	},
	Mapping={
		{Name="Teleport",Title="Teleport",Icon=IDS.Teleport},
		{Name="Radar",Title="Radar",Icon=IDS.Radar},
		{Name="System",Title="Sistema",Icon=IDS.System},
		{Name="Filters",Title="Filtros",Icon=IDS.Filters},
	},
	Player={
		{Name="Movement",Title="Movimiento",Icon=IDS.Movement},
		{Name="Fling",Title="Fling",Icon=IDS.Fling},
		{Name="Emote",Title="Emote",Icon=IDS.Emote},
		{Name="AvatarTools",Title="Avatar Tools",Icon=IDS.AvatarTools},
		{Name="Fun",Title="Fun",Icon=IDS.Fun},
	},
	Config={
		{Name="Save",Title="Guardar",Icon=IDS.Save},
		{Name="List",Title="Lista",Icon=IDS.List},
		{Name="AutoSave",Title="Auto Save",Icon=IDS.AutoSave},
		{Name="Format",Title="Formato",Icon=IDS.Format},
	},
}

local CurrentMain="Dashboard"
local CurrentSub=nil
local MainButtons={}
local SubButtons={}

local function CreateIcon(parent,imageId,size)
	return New("ImageLabel",parent,{
		Name="Icon",
		Size=UDim2.fromOffset(size,size),
		BackgroundTransparency=1,
		Image=imageId or "",
		ImageTransparency=imageId and 0 or 1,
		ImageColor3=Colors.White,
		ScaleType=Enum.ScaleType.Fit,
		ZIndex=parent.ZIndex+2,
	})
end

local function SetButtonState(button,selected)
	local label=button:FindFirstChild("Label")
	local icon=button:FindFirstChild("Icon")

	button.BackgroundColor3=selected and Colors.Gold or Colors.Panel2
	button.BackgroundTransparency=selected and .08 or .32

	if label then
		label.TextColor3=selected and Colors.Black or Colors.Text
	end

	if icon then
		icon.ImageColor3=Colors.White
	end
end

local function CreateMainButton(data,index)
	local button=New("TextButton",Sidebar,{
		Name=data.Name.."Button",
		Size=UDim2.new(1,0,0,50),
		BackgroundColor3=Colors.Panel2,
		BackgroundTransparency=.32,
		Text="",
		AutoButtonColor=false,
		BorderSizePixel=0,
		LayoutOrder=index,
		ZIndex=26,
	})

	New("UICorner",button,{CornerRadius=UDim.new(0,9)})

	local icon=CreateIcon(button,data.Icon,26)
	icon.Position=UDim2.fromOffset(12,12)

	New("TextLabel",button,{
		Name="Label",
		Size=UDim2.new(1,-52,1,0),
		Position=UDim2.fromOffset(48,0),
		BackgroundTransparency=1,
		Text=data.Title,
		TextColor3=Colors.Text,
		TextSize=14,
		Font=Enum.Font.GothamMedium,
		TextXAlignment=Enum.TextXAlignment.Left,
		TextYAlignment=Enum.TextYAlignment.Center,
		ZIndex=27,
	})

	MainButtons[data.Name]=button

	button.MouseEnter:Connect(function()
		if CurrentMain~=data.Name then
			TweenService:Create(button,TweenInfo.new(.12),{
				BackgroundTransparency=.12
			}):Play()
		end
	end)

	button.MouseLeave:Connect(function()
		if CurrentMain~=data.Name then
			TweenService:Create(button,TweenInfo.new(.12),{
				BackgroundTransparency=.32
			}):Play()
		end
	end)

	button.MouseButton1Click:Connect(function()
		SelectMainWindow(data.Name)
	end)

	return button
end

local function CreateSubButton(data,index)
	local button=New("TextButton",SubContainer,{
		Name=data.Name.."SubButton",
		Size=UDim2.fromOffset(145,44),
		BackgroundColor3=Colors.Panel2,
		BackgroundTransparency=.32,
		Text="",
		AutoButtonColor=false,
		BorderSizePixel=0,
		LayoutOrder=index,
		ZIndex=31,
	})

	New("UICorner",button,{CornerRadius=UDim.new(0,8)})

	local icon=CreateIcon(button,data.Icon,22)
	icon.Position=UDim2.fromOffset(9,11)

	New("TextLabel",button,{
		Name="Label",
		Size=UDim2.new(1,-39,1,0),
		Position=UDim2.fromOffset(37,0),
		BackgroundTransparency=1,
		Text=data.Title,
		TextColor3=Colors.Text,
		TextSize=12,
		Font=Enum.Font.GothamMedium,
		TextXAlignment=Enum.TextXAlignment.Left,
		TextYAlignment=Enum.TextYAlignment.Center,
		TextTruncate=Enum.TextTruncate.AtEnd,
		ZIndex=32,
	})

	SubButtons[data.Name]=button

	button.MouseEnter:Connect(function()
		if CurrentSub~=data.Name then
			TweenService:Create(button,TweenInfo.new(.12),{
				BackgroundTransparency=.12
			}):Play()
		end
	end)

	button.MouseLeave:Connect(function()
		if CurrentSub~=data.Name then
			TweenService:Create(button,TweenInfo.new(.12),{
				BackgroundTransparency=.32
			}):Play()
		end
	end)

	button.MouseButton1Click:Connect(function()
		SelectSubWindow(data.Name)
	end)

	return button
end

local function ClearSubWindows()
	for _,button in pairs(SubButtons) do
		if button then
			button:Destroy()
		end
	end
	SubButtons={}
end

local function ClearControls()
	for _,child in ipairs(ControlArea:GetChildren()) do
		if child:IsA("GuiObject")
		and child.Name~="UIListLayout"
		and child.Name~="UIPadding" then
			child:Destroy()
		end
	end
end

local function BuildSubWindows(mainName)
	ClearSubWindows()

	local list=SubWindows[mainName]

	if not list then
		SubContainer.Visible=false
		return
	end

	SubContainer.Visible=true

	for index,data in ipairs(list) do
		CreateSubButton(data,index)
	end
end

local function CreatePlaceholder(title,description)
	local card=New("Frame",ControlArea,{
		Name="Placeholder",
		Size=UDim2.new(1,0,0,82),
		BackgroundColor3=Colors.Panel2,
		BackgroundTransparency=.30,
		BorderSizePixel=0,
		ZIndex=31,
	})

	New("UICorner",card,{CornerRadius=UDim.new(0,10)})

	New("UIStroke",card,{
		Color=Colors.Border,
		Transparency=.55,
		Thickness=1,
	})

	New("TextLabel",card,{
		Name="Title",
		Size=UDim2.new(1,-24,0,27),
		Position=UDim2.fromOffset(12,8),
		BackgroundTransparency=1,
		Text=title,
		TextColor3=Colors.Text,
		TextSize=14,
		Font=Enum.Font.GothamSemibold,
		TextXAlignment=Enum.TextXAlignment.Left,
		ZIndex=32,
	})

	New("TextLabel",card,{
		Name="Description",
		Size=UDim2.new(1,-24,0,35),
		Position=UDim2.fromOffset(12,38),
		BackgroundTransparency=1,
		Text=description,
		TextColor3=Colors.SubText,
		TextSize=12,
		Font=Enum.Font.Gotham,
		TextWrapped=true,
		TextXAlignment=Enum.TextXAlignment.Left,
		TextYAlignment=Enum.TextYAlignment.Top,
		ZIndex=32,
	})
end

function SelectSubWindow(name)
	CurrentSub=name

	for buttonName,button in pairs(SubButtons) do
		SetButtonState(button,buttonName==name)
	end

	ClearControls()
	ContentTitle.Text=name

	CreatePlaceholder(
		name,
		"Controles preparados para recibir opciones y lógica."
	)
end

function SelectMainWindow(name)
	CurrentMain=name
	CurrentSub=nil

	for buttonName,button in pairs(MainButtons) do
		SetButtonState(button,buttonName==name)
	end

	BuildSubWindows(name)
	ContentTitle.Text=name
	ClearControls()

	local list=SubWindows[name]

	if list and #list>0 then
		SelectSubWindow(list[1].Name)
	else
		CreatePlaceholder(
			name,
			"Esta ventana está preparada para recibir su contenido."
		)
	end
end

for index,data in ipairs(MainWindows) do
	CreateMainButton(data,index)
end

SelectMainWindow("Dashboard")

local function CreateCard(title,height)
	local card=New("Frame",ControlArea,{
		Name="Card_"..title:gsub("%s+",""),
		Size=UDim2.new(1,0,0,height or 70),
		BackgroundColor3=Colors.Panel2,
		BackgroundTransparency=.30,
		BorderSizePixel=0,
		ZIndex=31,
	})
	New("UICorner",card,{CornerRadius=UDim.new(0,10)})
	New("UIStroke",card,{
		Color=Colors.Border,
		Transparency=.55,
		Thickness=1,
	})
	New("TextLabel",card,{
		Name="Title",
		Size=UDim2.new(1,-24,0,26),
		Position=UDim2.fromOffset(12,6),
		BackgroundTransparency=1,
		Text=title,
		TextColor3=Colors.Text,
		TextSize=13,
		Font=Enum.Font.GothamSemibold,
		TextXAlignment=Enum.TextXAlignment.Left,
		ZIndex=32,
	})
	return card
end

local function CreateLabel(parent,text,size,pos)
	return New("TextLabel",parent,{
		Size=size or UDim2.new(1,0,0,24),
		Position=pos or UDim2.fromOffset(0,0),
		BackgroundTransparency=1,
		Text=text,
		TextColor3=Colors.SubText,
		TextSize=12,
		Font=Enum.Font.Gotham,
		TextXAlignment=Enum.TextXAlignment.Left,
		TextYAlignment=Enum.TextYAlignment.Center,
		ZIndex=33,
	})
end

local function CreateToggle(parent,name,default,callback)
	local state=default==true
	local button=New("TextButton",parent,{
		Name=name.."Toggle",
		Size=UDim2.fromOffset(52,26),
		BackgroundColor3=state and Colors.Gold or Colors.Panel,
		BackgroundTransparency=.05,
		Text="",
		AutoButtonColor=false,
		BorderSizePixel=0,
		ZIndex=34,
	})
	New("UICorner",button,{CornerRadius=UDim.new(1,0)})

	local knob=New("Frame",button,{
		Name="Knob",
		Size=UDim2.fromOffset(20,20),
		Position=state and UDim2.new(1,-23,.5,-10) or UDim2.fromOffset(3,3),
		BackgroundColor3=state and Colors.Black or Colors.Text,
		BorderSizePixel=0,
		ZIndex=35,
	})
	New("UICorner",knob,{CornerRadius=UDim.new(1,0)})

	local function SetState(value,fire)
		state=value==true
		TweenService:Create(button,TweenInfo.new(.12),{
			BackgroundColor3=state and Colors.Gold or Colors.Panel
		}):Play()
		TweenService:Create(knob,TweenInfo.new(.12),{
			Position=state and UDim2.new(1,-23,.5,-10) or UDim2.fromOffset(3,3),
			BackgroundColor3=state and Colors.Black or Colors.Text
		}):Play()
		if fire and callback then callback(state) end
	end

	button.MouseButton1Click:Connect(function()
		SetState(not state,true)
	end)

	return {
		Object=button,
		Get=function() return state end,
		Set=function(value) SetState(value,true) end,
		SetSilent=function(value) SetState(value,false) end,
	}
end

local function CreateToggleOption(title,default,callback)
	local card=CreateCard(title,58)
	local label=CreateLabel(card,title,UDim2.new(1,-82,1,0),UDim2.fromOffset(12,0))
	local toggle=CreateToggle(card,"Toggle",default,callback)
	toggle.Object.Position=UDim2.new(1,-64,.5,-13)
	return card,toggle,label
end

local function CreateButtonOption(title,text,callback)
	local card=CreateCard(title,62)
	CreateLabel(card,title,UDim2.new(1,-145,1,0),UDim2.fromOffset(12,0))

	local button=New("TextButton",card,{
		Name="ActionButton",
		Size=UDim2.fromOffset(115,32),
		Position=UDim2.new(1,-127,.5,-16),
		BackgroundColor3=Colors.Gold,
		BackgroundTransparency=.05,
		Text=text or "Ejecutar",
		TextColor3=Colors.Black,
		TextSize=12,
		Font=Enum.Font.GothamSemibold,
		AutoButtonColor=false,
		BorderSizePixel=0,
		ZIndex=34,
	})
	New("UICorner",button,{CornerRadius=UDim.new(0,8)})

	button.MouseEnter:Connect(function()
		TweenService:Create(button,TweenInfo.new(.12),{
			BackgroundTransparency=0
		}):Play()
	end)

	button.MouseLeave:Connect(function()
		TweenService:Create(button,TweenInfo.new(.12),{
			BackgroundTransparency=.05
		}):Play()
	end)

	button.MouseButton1Click:Connect(function()
		if callback then callback() end
	end)

	return card,button
end

local function CreateDropdownOption(title,values,default,callback)
	local card=CreateCard(title,66)
	CreateLabel(card,title,UDim2.new(1,-160,1,0),UDim2.fromOffset(12,0))

	local current=default or values[1]
	local button=New("TextButton",card,{
		Name="Dropdown",
		Size=UDim2.fromOffset(135,32),
		Position=UDim2.new(1,-147,.5,-16),
		BackgroundColor3=Colors.Panel,
		BackgroundTransparency=.05,
		Text=tostring(current),
		TextColor3=Colors.Text,
		TextSize=11,
		Font=Enum.Font.GothamMedium,
		AutoButtonColor=false,
		BorderSizePixel=0,
		ZIndex=34,
	})
	New("UICorner",button,{CornerRadius=UDim.new(0,8)})

	local index=1
	for i,value in ipairs(values) do
		if value==current then
			index=i
			break
		end
	end

	local function SetValue(value,fire)
		current=value
		button.Text=tostring(value)
		if fire and callback then callback(value) end
	end

	button.MouseButton1Click:Connect(function()
		if #values==0 then return end
		index=index%#values+1
		SetValue(values[index],true)
	end)

	return card,{
		Object=button,
		Get=function() return current end,
		Set=function(value) SetValue(value,true) end,
		SetSilent=function(value) SetValue(value,false) end,
	}
end

local function CreateSliderOption(title,min,max,default,callback)
	local card=CreateCard(title,72)
	CreateLabel(card,title,UDim2.new(1,0,0,24),UDim2.fromOffset(12,4))

	local value=math.clamp(default or min,min,max)
	local valueLabel=New("TextLabel",card,{
		Name="Value",
		Size=UDim2.fromOffset(70,24),
		Position=UDim2.new(1,-82,0,4),
		BackgroundTransparency=1,
		Text=tostring(value),
		TextColor3=Colors.Gold,
		TextSize=12,
		Font=Enum.Font.GothamSemibold,
		TextXAlignment=Enum.TextXAlignment.Right,
		ZIndex=33,
	})

	local bar=New("Frame",card,{
		Name="Bar",
		Size=UDim2.new(1,-24,0,6),
		Position=UDim2.fromOffset(12,46),
		BackgroundColor3=Colors.Panel,
		BorderSizePixel=0,
		ZIndex=33,
	})
	New("UICorner",bar,{CornerRadius=UDim.new(1,0)})

	local fill=New("Frame",bar,{
		Name="Fill",
		Size=UDim2.new((value-min)/(max-min),0,1,0),
		BackgroundColor3=Colors.Gold,
		BorderSizePixel=0,
		ZIndex=34,
	})
	New("UICorner",fill,{CornerRadius=UDim.new(1,0)})

	local dragging=false

	local function SetValue(newValue,fire)
		value=math.clamp(newValue,min,max)
		local alpha=(value-min)/(max-min)
		fill.Size=UDim2.new(alpha,0,1,0)
		valueLabel.Text=tostring(math.floor(value*100)/100)
		if fire and callback then callback(value) end
	end

	bar.InputBegan:Connect(function(input)
		if input.UserInputType==Enum.UserInputType.MouseButton1
		or input.UserInputType==Enum.UserInputType.Touch then
			dragging=true
			local x=(input.Position.X-bar.AbsolutePosition.X)/bar.AbsoluteSize.X
			SetValue(min+(max-min)*math.clamp(x,0,1),true)
		end
	end)

	UserInputService.InputChanged:Connect(function(input)
		if not dragging then return end
		if input.UserInputType==Enum.UserInputType.MouseMovement
		or input.UserInputType==Enum.UserInputType.Touch then
			local x=(input.Position.X-bar.AbsolutePosition.X)/bar.AbsoluteSize.X
			SetValue(min+(max-min)*math.clamp(x,0,1),true)
		end
	end)

	UserInputService.InputEnded:Connect(function(input)
		if input.UserInputType==Enum.UserInputType.MouseButton1
		or input.UserInputType==Enum.UserInputType.Touch then
			dragging=false
		end
	end)

	return card,{
		Object=bar,
		Get=function() return value end,
		Set=function(v) SetValue(v,true) end,
		SetSilent=function(v) SetValue(v,false) end,
	}
end

local function CreateColorOption(title,colors,default,callback)
	local card=CreateCard(title,66)
	CreateLabel(card,title,UDim2.new(1,-145,1,0),UDim2.fromOffset(12,0))

	local current=default or colors[1]
	local button=New("TextButton",card,{
		Name="ColorButton",
		Size=UDim2.fromOffset(125,32),
		Position=UDim2.new(1,-137,.5,-16),
		BackgroundColor3=current,
		Text="",
		AutoButtonColor=false,
		BorderSizePixel=0,
		ZIndex=34,
	})
	New("UICorner",button,{CornerRadius=UDim.new(0,8)})

	local index=1
	for i,color in ipairs(colors) do
		if color==current then
			index=i
			break
		end
	end

	local function SetColor(color,fire)
		current=color
		button.BackgroundColor3=color
		if fire and callback then callback(color) end
	end

	button.MouseButton1Click:Connect(function()
		if #colors==0 then return end
		index=index%#colors+1
		SetColor(colors[index],true)
	end)

	return card,{
		Object=button,
		Get=function() return current end,
		Set=function(color) SetColor(color,true) end,
		SetSilent=function(color) SetColor(color,false) end,
	}
end

local function ClearControlsOnly()
	for _,child in ipairs(ControlArea:GetChildren()) do
		if child:IsA("GuiObject")
		and child.Name~="UIListLayout"
		and child.Name~="UIPadding" then
			child:Destroy()
		end
	end
end

local UI={
	NewCard=CreateCard,
	Label=CreateLabel,
	Toggle=CreateToggleOption,
	Button=CreateButtonOption,
	Dropdown=CreateDropdownOption,
	Slider=CreateSliderOption,
	Color=CreateColorOption,
	Clear=ClearControlsOnly,
}

local function GetPlayerThumbnail()
	local success,image=pcall(function()
		return Players:GetUserThumbnailAsync(
			LocalPlayer.UserId,
			Enum.ThumbnailType.HeadShot,
			Enum.ThumbnailSize.Size420x420
		)
	end)
	return success and image or ""
end

local function CreateDashboardProfile()
	local card=New("Frame",ControlArea,{
		Name="PlayerProfile",
		Size=UDim2.new(1,0,0,170),
		BackgroundColor3=Colors.Panel2,
		BackgroundTransparency=.18,
		BorderSizePixel=0,
		ZIndex=31,
	})
	New("UICorner",card,{CornerRadius=UDim.new(0,12)})
	New("UIStroke",card,{
		Color=Colors.Border,
		Transparency=.35,
		Thickness=1,
	})

	local avatar=New("ImageLabel",card,{
		Name="Avatar",
		Size=UDim2.fromOffset(120,120),
		Position=UDim2.fromOffset(18,25),
		BackgroundColor3=Colors.Panel,
		BackgroundTransparency=.05,
		Image=GetPlayerThumbnail(),
		ScaleType=Enum.ScaleType.Crop,
		BorderSizePixel=0,
		ZIndex=33,
	})
	New("UICorner",avatar,{CornerRadius=UDim.new(0,12)})

	local info=New("Frame",card,{
		Name="PlayerInfo",
		Size=UDim2.new(1,-165,1,-20),
		Position=UDim2.fromOffset(155,10),
		BackgroundTransparency=1,
		ZIndex=32,
	})

	New("TextLabel",info,{
		Name="DisplayName",
		Size=UDim2.new(1,0,0,30),
		Position=UDim2.fromOffset(0,5),
		BackgroundTransparency=1,
		Text=LocalPlayer.DisplayName,
		TextColor3=Colors.Text,
		TextSize=20,
		Font=Enum.Font.GothamBold,
		TextXAlignment=Enum.TextXAlignment.Left,
		ZIndex=33,
	})

	New("TextLabel",info,{
		Name="Username",
		Size=UDim2.new(1,0,0,24),
		Position=UDim2.fromOffset(0,35),
		BackgroundTransparency=1,
		Text="@"..LocalPlayer.Name,
		TextColor3=Colors.Gold,
		TextSize=13,
		Font=Enum.Font.GothamMedium,
		TextXAlignment=Enum.TextXAlignment.Left,
		ZIndex=33,
	})

	New("TextLabel",info,{
		Name="UserId",
		Size=UDim2.new(1,0,0,24),
		Position=UDim2.fromOffset(0,65),
		BackgroundTransparency=1,
		Text="User ID: "..tostring(LocalPlayer.UserId),
		TextColor3=Colors.SubText,
		TextSize=12,
		Font=Enum.Font.Gotham,
		TextXAlignment=Enum.TextXAlignment.Left,
		ZIndex=33,
	})

	New("TextLabel",info,{
		Name="Status",
		Size=UDim2.new(1,0,0,24),
		Position=UDim2.fromOffset(0,91),
		BackgroundTransparency=1,
		Text="● Jugador activo",
		TextColor3=Colors.Gold,
		TextSize=12,
		Font=Enum.Font.GothamMedium,
		TextXAlignment=Enum.TextXAlignment.Left,
		ZIndex=33,
	})

	New("TextLabel",info,{
		Name="AccountType",
		Size=UDim2.new(1,0,0,24),
		Position=UDim2.fromOffset(0,117),
		BackgroundTransparency=1,
		Text="Perfil local",
		TextColor3=Colors.SubText,
		TextSize=11,
		Font=Enum.Font.Gotham,
		TextXAlignment=Enum.TextXAlignment.Left,
		ZIndex=33,
	})
end

local function CreateDashboardStats()
	local card=CreateCard("Resumen",115)

	local totalSub=0
	for _,list in pairs(SubWindows) do
		totalSub+=#list
	end

	local stats={
		{"Ventanas",#MainWindows},
		{"Subventanas",totalSub},
		{"Controles","Listos"},
	}

	for i,data in ipairs(stats) do
		local x=(i-1)/3
		local box=New("Frame",card,{
			Name="Stat"..i,
			Size=UDim2.new(1/3,-8,0,58),
			Position=UDim2.new(x,4,0,43),
			BackgroundColor3=Colors.Panel,
			BackgroundTransparency=.18,
			BorderSizePixel=0,
			ZIndex=32,
		})
		New("UICorner",box,{CornerRadius=UDim.new(0,8)})

		New("TextLabel",box,{
			Size=UDim2.new(1,0,0,25),
			Position=UDim2.fromOffset(0,5),
			BackgroundTransparency=1,
			Text=tostring(data[2]),
			TextColor3=Colors.Gold,
			TextSize=16,
			Font=Enum.Font.GothamBold,
			TextXAlignment=Enum.TextXAlignment.Center,
			ZIndex=33,
		})

		New("TextLabel",box,{
			Size=UDim2.new(1,0,0,20),
			Position=UDim2.fromOffset(0,31),
			BackgroundTransparency=1,
			Text=data[1],
			TextColor3=Colors.SubText,
			TextSize=10,
			Font=Enum.Font.Gotham,
			TextXAlignment=Enum.TextXAlignment.Center,
			ZIndex=33,
		})
	end
end

local function CreateDashboardInfo()
	local card=CreateCard("The stars invite me to dream",88)

	New("TextLabel",card,{
		Name="Description",
		Size=UDim2.new(1,-24,0,42),
		Position=UDim2.fromOffset(12,36),
		BackgroundTransparency=1,
		Text="Interfaz principal preparada para organizar las funciones, configuraciones y herramientas del menú.",
		TextColor3=Colors.SubText,
		TextSize=12,
		Font=Enum.Font.Gotham,
		TextWrapped=true,
		TextXAlignment=Enum.TextXAlignment.Left,
		TextYAlignment=Enum.TextYAlignment.Top,
		ZIndex=32,
	})
end

local function BuildDashboard()
	UI.Clear()
	CreateDashboardProfile()
	CreateDashboardStats()
	CreateDashboardInfo()
end

_G.PerfectMenuUI={
	Gui=ScreenGui,
	Menu=Menu,
	Content=Content,
	ControlArea=ControlArea,
	Sidebar=Sidebar,
	SubContainer=SubContainer,
	Colors=Colors,
	IDS=IDS,
	UI=UI,
	SelectMain=SelectMainWindow,
	SelectSub=SelectSubWindow,
}

function SelectMainWindow(name)
	CurrentMain=name
	CurrentSub=nil

	for buttonName,button in pairs(MainButtons) do
		SetButtonState(button,buttonName==name)
	end

	BuildSubWindows(name)
	ContentTitle.Text=name
	UI.Clear()

	if name=="Dashboard" then
		BuildDashboard()
		return
	end

	local list=SubWindows[name]

	if list and #list>0 then
		SelectSubWindow(list[1].Name)
	else
		CreatePlaceholder(
			name,
			"Esta ventana está preparada para recibir su contenido."
		)
	end
end

SelectMainWindow("Dashboard")

local KillerColors={
	{Name="Rojo intenso",Value=Color3.fromRGB(220,35,35)},
	{Name="Azul marino",Value=Color3.fromRGB(20,45,110)},
	{Name="Verde militar",Value=Color3.fromRGB(55,85,45)},
	{Name="Amarillo mostaza",Value=Color3.fromRGB(210,170,45)},
	{Name="Naranja vibrante",Value=Color3.fromRGB(255,120,25)},
	{Name="Morado oscuro",Value=Color3.fromRGB(85,35,120)},
	{Name="Fucsia",Value=Color3.fromRGB(220,35,150)},
	{Name="Negro",Value=Color3.fromRGB(20,20,20)},
	{Name="Café oscuro",Value=Color3.fromRGB(75,45,25)},
	{Name="Turquesa oscuro",Value=Color3.fromRGB(20,105,105)},
}

local function AddToggle(title,default,callback)
	return UI.Toggle(title,default,callback)
end

local function AddColor(title,list,default,callback)
	local values={}
	for _,data in ipairs(list) do
		values[#values+1]=data.Value
	end
	return UI.Color(title,values,default,callback)
end

local function BuildKillerESP()
	UI.Clear()

	AddToggle("ESP General",false,function(value)
		-- Lógica futura
	end)

	AddColor("Color del Killer",KillerColors,KillerColors[1].Value,function(color)
		-- Lógica futura
	end)

	AddToggle("Mostrar nombre",true,function(value)
		-- Lógica futura
	end)

	AddToggle("Mostrar distancia",true,function(value)
		-- Lógica futura
	end)

	AddToggle("Mostrar contorno",true,function(value)
		-- Lógica futura
	end)

	AddToggle("Mostrar relleno",true,function(value)
		-- Lógica futura
	end)

	AddToggle("Mostrar advertencia",true,function(value)
		-- Lógica futura
	end)
end

local function BuildSurvivorESP()
	UI.Clear()

	AddToggle("ESP General",false,function(value)
		-- Lógica futura
	end)

	UI.Dropdown(
		"Estado del Survivor",
		{"Normal","Herido","Derribado"},
		"Normal",
		function(state)
			-- Lógica futura
		end
	)

	AddColor(
		"Color Normal",
		{
			{Name="Verde",Value=Color3.fromRGB(90,220,110)},
			{Name="Azul",Value=Color3.fromRGB(60,180,255)},
			{Name="Blanco",Value=Color3.fromRGB(255,255,255)}
		},
		Color3.fromRGB(90,220,110),
		function(color)
			-- Lógica futura
		end
	)

	AddColor(
		"Color Herido",
		{
			{Name="Amarillo",Value=Color3.fromRGB(255,190,55)},
			{Name="Naranja",Value=Color3.fromRGB(255,120,40)},
			{Name="Rojo claro",Value=Color3.fromRGB(255,80,80)}
		},
		Color3.fromRGB(255,190,55),
		function(color)
			-- Lógica futura
		end
	)

	AddColor(
		"Color Derribado",
		{
			{Name="Rojo",Value=Color3.fromRGB(230,55,55)},
			{Name="Rojo oscuro",Value=Color3.fromRGB(180,40,40)},
			{Name="Rosa",Value=Color3.fromRGB(255,80,100)}
		},
		Color3.fromRGB(230,55,55),
		function(color)
			-- Lógica futura
		end
	)

	AddToggle("Mostrar nombre",true,function(value)
		-- Lógica futura
	end)

	AddToggle("Mostrar distancia",true,function(value)
		-- Lógica futura
	end)

	AddToggle("Mostrar contorno",true,function(value)
		-- Lógica futura
	end)

	AddToggle("Mostrar relleno",true,function(value)
		-- Lógica futura
	end)
end

local function BuildSpectatorESP()
	UI.Clear()

	AddToggle("ESP General",false,function(value)
		-- Lógica futura
	end)

	AddToggle("Mostrar nombre",true,function(value)
		-- Lógica futura
	end)

	AddToggle("Mostrar distancia",true,function(value)
		-- Lógica futura
	end)

	AddToggle("Mostrar contorno",true,function(value)
		-- Lógica futura
	end)
end

local function BuildWorldESP()
	UI.Clear()

	AddToggle("World ESP General",false,function(value)
		-- Lógica futura
	end)

	AddToggle("Generadores",true,function(value)
		-- Lógica futura
	end)

	AddToggle("Objetos",true,function(value)
		-- Lógica futura
	end)

	AddToggle("Salidas",true,function(value)
		-- Lógica futura
	end)

	AddToggle("Otros elementos",true,function(value)
		-- Lógica futura
	end)
end

local function BuildCamera()
	UI.Clear()

	AddToggle("Cámara personalizada",false,function(value)
		-- Lógica futura
	end)

	UI.Slider("Campo de visión",40,120,70,function(value)
		-- Lógica futura
	end)

	AddToggle("Cámara libre",false,function(value)
		-- Lógica futura
	end)

	AddToggle("Bloqueo de cámara",false,function(value)
		-- Lógica futura
	end)

	UI.Button("Restablecer cámara","Restablecer",function()
		-- Lógica futura
	end)
end

local function BuildLighting()
	UI.Clear()

	AddToggle("Iluminación personalizada",false,function(value)
		-- Lógica futura
	end)

	UI.Slider("Brillo",0,10,1,function(value)
		-- Lógica futura
	end)

	UI.Slider("Hora",0,24,12,function(value)
		-- Lógica futura
	end)

	AddToggle("Ambiente personalizado",false,function(value)
		-- Lógica futura
	end)

	UI.Button("Restablecer iluminación","Restablecer",function()
		-- Lógica futura
	end)
end

local function BuildGameInfo()
	UI.Clear()

	AddToggle("Game Info Panel",false,function(value)
		-- Lógica futura
	end)

	AddToggle("Mostrar jugadores",true,function(value)
		-- Lógica futura
	end)

	AddToggle("Mostrar estado de partida",true,function(value)
		-- Lógica futura
	end)

	AddToggle("Mostrar tiempo",true,function(value)
		-- Lógica futura
	end)

	AddToggle("Mostrar mapa",true,function(value)
		-- Lógica futura
	end)
end

local SubBuilders={
	KillerESP=BuildKillerESP,
	SurvivorESP=BuildSurvivorESP,
	SpectatorESP=BuildSpectatorESP,
	WorldESP=BuildWorldESP,
	Camera=BuildCamera,
	Lighting=BuildLighting,
	GameInfo=BuildGameInfo,
}

function SelectSubWindow(name)
	CurrentSub=name

	for buttonName,button in pairs(SubButtons) do
		SetButtonState(button,buttonName==name)
	end

	ContentTitle.Text=name
	UI.Clear()

	local builder=SubBuilders[name]

	if builder then
		builder()
	else
		CreatePlaceholder(
			name,
			"Controles preparados para recibir opciones y lógica."
		)
	end
end