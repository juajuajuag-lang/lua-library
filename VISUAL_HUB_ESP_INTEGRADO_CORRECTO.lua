-- VISUAL HUB V2
-- UI SOLAMENTE. Sin lógica de juego.
-- Usar como LocalScript en StarterPlayerScripts o StarterGui.

local Players=game:GetService("Players")
local UIS=game:GetService("UserInputService")
local player=Players.LocalPlayer
if not player then return end
local PlayerGui=player:WaitForChild("PlayerGui")

local old=PlayerGui:FindFirstChild("VISUAL_HUB")
if old then old:Destroy() end

local Gui=Instance.new("ScreenGui")
Gui.Name="VISUAL_HUB"
Gui.ResetOnSpawn=false
Gui.IgnoreGuiInset=true
Gui.ZIndexBehavior=Enum.ZIndexBehavior.Sibling
Gui.Parent=PlayerGui

local ESPState={PlayerMasterESP=false,WorldMasterESP=false,SurvivorESP=false,KillerESP=false,SpectatorESP=false,SurvivorItemsESP=false,PlayerNametags=false,PlayerDistanceESP=false,WarnKiller=false,WorldNametags=false,WorldDistanceESP=false,World={Generator=false,Hook=false,Gate=false,Window=false,Pallet=false,SCPZombie=false},Colors={Survivor=Color3.fromRGB(0,255,0),Killer=Color3.fromRGB(255,0,0),Spectator=Color3.fromRGB(255,255,255),Generator=Color3.fromRGB(0,170,255),Hook=Color3.fromRGB(255,0,0),Gate=Color3.fromRGB(255,225,0),Window=Color3.fromRGB(255,255,255),Pallet=Color3.fromRGB(255,140,0),SCPZombie=Color3.fromRGB(128,0,128)},FillTransparency=.95,OutlineTransparency=.3,TextSize=12}
local ESPFolder=Instance.new("Folder",Gui);ESPFolder.Name="IntegratedESP"
local function ESPBind(n,v)
 if n=="Enable Player ESP" then ESPState.PlayerMasterESP=v elseif n=="Survivor ESP" then ESPState.SurvivorESP=v elseif n=="Killer ESP" then ESPState.KillerESP=v elseif n=="Spectator ESP" then ESPState.SpectatorESP=v elseif n=="Survivor Items ESP" then ESPState.SurvivorItemsESP=v elseif n=="Player Nametags" then ESPState.PlayerNametags=v elseif n=="Player Distance ESP" then ESPState.PlayerDistanceESP=v elseif n=="Survivor Killer Warning" then ESPState.WarnKiller=v elseif n=="Enable World ESP" then ESPState.WorldMasterESP=v elseif n=="Generators" then ESPState.World.Generator=v elseif n=="Hooks" then ESPState.World.Hook=v elseif n=="Gates" then ESPState.World.Gate=v elseif n=="Windows" then ESPState.World.Window=v elseif n=="Pallets" then ESPState.World.Pallet=v elseif n=="SCP / Zombie" then ESPState.World.SCPZombie=v elseif n=="World Nametags" then ESPState.WorldNametags=v elseif n=="World Distance ESP" then ESPState.WorldDistanceESP=v elseif n=="ESP Fill Transparency" then ESPState.FillTransparency=v elseif n=="ESP Outline Transparency" then ESPState.OutlineTransparency=v elseif n=="ESP Text Size" then ESPState.TextSize=v end
 if Refresh then pcall(Refresh) end
end

-- ESP folder
local ESPFolder=Instance.new("Folder")
ESPFolder.Name="IntegratedESP"
ESPFolder.Parent=GUI

local function clearESP()
	for _,v in ipairs(ESPFolder:GetChildren()) do v:Destroy() end
end

local function rootPart(model)
	if not model then return nil end
	if model:IsA("BasePart") then return model end
	return model:FindFirstChild("HumanoidRootPart",true)
		or model:FindFirstChild("PrimaryPart",true)
		or model:FindFirstChildWhichIsA("BasePart",true)
end

local function roleColor(p)
	if p.Team and p.Team.Name=="Killer" then return ESPState.Colors.Killer end
	if p.Team and p.Team.Name=="Survivors" then return ESPState.Colors.Survivor end
	return ESPState.Colors.Spectator
end

local function playerEnabled(p)
	if not ESPState.PlayerMasterESP then return false end
	if p.Team and p.Team.Name=="Killer" then return ESPState.KillerESP end
	if p.Team and p.Team.Name=="Survivors" then return ESPState.SurvivorESP end
	return ESPState.SpectatorESP
end

local PlayerVisuals={}
local function removePlayerVisual(p)
 local v=PlayerVisuals[p]
 if v then if v.h then v.h:Destroy() end if v.bb then v.bb:Destroy() end PlayerVisuals[p]=nil end
end
local function updatePlayerVisual(p)
 if p==LP or not ESPState.PlayerMasterESP or not playerEnabled(p) or not p.Character then removePlayerVisual(p); return end
 local c=p.Character
 local col=roleColor(p)
 local v=PlayerVisuals[p] or {}
 if not v.h then v.h=Instance.new("Highlight");v.h.Name="PlayerESP_"..p.Name;v.h.DepthMode=Enum.HighlightDepthMode.AlwaysOnTop;v.h.Parent=ESPFolder end
 v.h.Adornee=c;v.h.FillColor=col;v.h.OutlineColor=col;v.h.FillTransparency=ESPState.FillTransparency;v.h.OutlineTransparency=ESPState.OutlineTransparency
 local root=rootPart(c)
 local needTag=ESPState.PlayerNametags or ESPState.PlayerDistanceESP
 if needTag and root then
  if not v.bb then
   v.bb=Instance.new("BillboardGui");v.bb.Name="PlayerTag_"..p.Name;v.bb.Size=UDim2.fromOffset(180,45);v.bb.StudsOffset=Vector3.new(0,3,0);v.bb.AlwaysOnTop=true;v.bb.Parent=ESPFolder
   v.t=Instance.new("TextLabel");v.t.Size=UDim2.fromScale(1,1);v.t.BackgroundTransparency=1;v.t.Font=Enum.Font.GothamBold;v.t.Parent=v.bb
  end
  v.bb.Adornee=root;v.t.TextColor3=col;v.t.TextSize=ESPState.TextSize
  local txt=ESPState.PlayerNametags and p.Name or ""
  local lroot=LP.Character and rootPart(LP.Character)
  if ESPState.PlayerDistanceESP and lroot then local d=(root.Position-lroot.Position).Magnitude;txt=txt..(txt~="" and "\n" or "")..math.floor(d).." studs" end
  v.t.Text=txt
 elseif v.bb then v.bb:Destroy();v.bb=nil;v.t=nil end
 PlayerVisuals[p]=v
end
local function updatePlayerESP()
 for _,p in ipairs(Players:GetPlayers()) do updatePlayerVisual(p) end
 for p in pairs(PlayerVisuals) do if p.Parent~=Players or not ESPState.PlayerMasterESP or not playerEnabled(p) then removePlayerVisual(p) end end
end

-- Killer Warning
local function isKiller(p) return p and p.Team and p.Team.Name=="Killer" end
local function isSurvivor(p) return p and p.Team and p.Team.Name=="Survivors" end

local function warningFor(survivor)
	if not ESPState.WarnKiller or not isSurvivor(survivor) then return end
	local sr=rootPart(survivor.Character)
	if not sr then return end
	local nearest
	for _,p in ipairs(Players:GetPlayers()) do
		if isKiller(p) then
			local kr=rootPart(p.Character)
			if kr then
				local d=(sr.Position-kr.Position).Magnitude
				if not nearest or d<nearest then nearest=d end
			end
		end
	end
	local old=ESPFolder:FindFirstChild("Warn_"..survivor.Name)
	if not nearest or nearest>60 then
		if old then old:Destroy() end
		return
	end
	local bb=old or Instance.new("BillboardGui")
	bb.Name="Warn_"..survivor.Name
	bb.Adornee=sr
	bb.Size=UDim2.fromOffset(80,80)
	bb.StudsOffset=Vector3.new(0,4,0)
	bb.AlwaysOnTop=true
	bb.Parent=ESPFolder
	local img=bb:FindFirstChild("Icon") or Instance.new("ImageLabel")
	img.Name="Icon"
	img.Size=UDim2.fromScale(1,1)
	img.BackgroundTransparency=1
	img.ScaleType=Enum.ScaleType.Fit
	img.Parent=bb
	img.Image=nearest<=40 and Images.KillerWarningPurple or Images.KillerWarningYellow
end

-- World ESP: lógica reconstruida siguiendo la arquitectura original de (096).txt
local WorldReg={
	Generator={},Hook={},Gate={},Window={},Palletwrong={},SCPZombie={}
}
local WorldConns={}
local WorldLoopThread=nil

local function worldAlive(x)
	return x and x.Parent~=nil
end
local function validPart(x)
	return x and x:IsA("BasePart") and x.Parent~=nil
end
local function firstBasePart(model)
	if not worldAlive(model) then return nil end
	if model:IsA("BasePart") then return model end
	return model:FindFirstChildWhichIsA("BasePart",true)
end
local function pickWorldPart(model,cat)
	if not worldAlive(model) then return nil end
	if cat=="Generator" then
		local hitbox=model:FindFirstChild("HitBox",true) or model:FindFirstChild("GeneratorPoint",true)
		if validPart(hitbox) then return hitbox end
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
			if validPart(part) then return part end
		end
	elseif cat=="Window" then
		local vault=model:FindFirstChild("VaultPoint",true) or model:FindFirstChild("VaultTrigger",true)
		if validPart(vault) then return vault end
	elseif cat=="SCPZombie" then
		local root=model:FindFirstChild("HumanoidRootPart",true)
		if validPart(root) then return root end
		local torso=model:FindFirstChild("UpperTorso",true) or model:FindFirstChild("Torso",true)
		if validPart(torso) then return torso end
		return nil
	end
	return firstBasePart(model)
end
local function worldKey(cat,model)
	return "KYS_World_"..cat.."_"..tostring(model:GetDebugId())
end
local function destroyWorld(name)
	local x=ESPFolder:FindFirstChild(name)
	if x then x:Destroy() end
end
local function clearWorldVisual(cat,model)
	if not model then return end
	local key=worldKey(cat,model)
	destroyWorld(key.."_HL")
	destroyWorld(key.."_Tag")
end
local function palletGone(model)
	if not worldAlive(model) or not model:IsDescendantOf(workspace) then return true end
	if model:GetAttribute("Destroyed")==true then return true end
	return firstBasePart(model)==nil
end
local function ensureWorldEntry(cat,model)
	if not worldAlive(model) or not WorldReg[cat] or WorldReg[cat][model] then return end
	if cat=="Palletwrong" and palletGone(model) then return end
	local part=pickWorldPart(model,cat)
	if not validPart(part) then return end
	WorldReg[cat][model]={part=part}
end
local function registerWorld(obj)
	if not worldAlive(obj) then return end
	local validCats={Generator=true,Hook=true,Gate=true,Window=true,Palletwrong=true}
	if obj:IsA("Model") then
		if validCats[obj.Name] then
			ensureWorldEntry(obj.Name,obj)
			return
		end
		local lower=obj.Name:lower()
		if lower:find("scp",1,true) or lower:find("zombie",1,true) then
			ensureWorldEntry("SCPZombie",obj)
		end
		return
	end
	if obj:IsA("BasePart") then
		local parent=obj.Parent
		while parent and parent~=workspace do
			if parent:IsA("Model") then
				if validCats[parent.Name] then
					ensureWorldEntry(parent.Name,parent)
					return
				end
				local lower=parent.Name:lower()
				if lower:find("scp",1,true) or lower:find("zombie",1,true) then
					ensureWorldEntry("SCPZombie",parent)
					return
				end
			end
			parent=parent.Parent
		end
	end
end
local function unregisterWorld(obj)
	if not obj then return end
	local validCats={Generator=true,Hook=true,Gate=true,Window=true,Palletwrong=true}
	if obj:IsA("Model") then
		if validCats[obj.Name] then
			local e=WorldReg[obj.Name] and WorldReg[obj.Name][obj]
			if e then clearWorldVisual(obj.Name,obj); WorldReg[obj.Name][obj]=nil end
			return
		end
		local lower=obj.Name:lower()
		if lower:find("scp",1,true) or lower:find("zombie",1,true) then
			local e=WorldReg.SCPZombie[obj]
			if e then clearWorldVisual("SCPZombie",obj); WorldReg.SCPZombie[obj]=nil end
		end
		return
	end
	if obj:IsA("BasePart") then
		for cat,models in pairs(WorldReg) do
			for model,entry in pairs(models) do
				if entry.part==obj then
					clearWorldVisual(cat,model)
					models[model]=nil
				end
			end
		end
	end
end
local function attachWorldRoot(root)
	if not root or WorldConns[root] then return end
	WorldConns[root]={}
	WorldConns[root].add=root.DescendantAdded:Connect(registerWorld)
	WorldConns[root].rem=root.DescendantRemoving:Connect(unregisterWorld)
	for _,desc in ipairs(root:GetDescendants()) do registerWorld(desc) end
end
local function refreshWorldRoots()
	for root,c in pairs(WorldConns) do
		if c.add then pcall(function() c.add:Disconnect() end) end
		if c.rem then pcall(function() c.rem:Disconnect() end) end
	end
	WorldConns={}
	for cat,models in pairs(WorldReg) do
		for model in pairs(models) do clearWorldVisual(cat,model) end
		WorldReg[cat]={}
	end
	local map=workspace:FindFirstChild("Map")
	local map1=workspace:FindFirstChild("Map1")
	if map then attachWorldRoot(map) end
	if map1 then attachWorldRoot(map1) end
end
local function worldData(cat)
	if cat=="Generator" then return ESPState.World.Generator,ESPState.Colors.Generator end
	if cat=="Hook" then return ESPState.World.Hook,ESPState.Colors.Hook end
	if cat=="Gate" then return ESPState.World.Gate,ESPState.Colors.Gate end
	if cat=="Window" then return ESPState.World.Window,ESPState.Colors.Window end
	if cat=="Palletwrong" then return ESPState.World.Pallet,ESPState.Colors.Pallet end
	if cat=="SCPZombie" then return ESPState.World.SCPZombie,ESPState.Colors.SCPZombie end
	return false,Color3.new(1,1,1)
end
local function ensureWorldHighlight(cat,model,color)
	if not worldAlive(model) then return end
	local key=worldKey(cat,model)
	local name=key.."_HL"
	local hl=ESPFolder:FindFirstChild(name)
	if not hl then
		hl=Instance.new("Highlight")
		hl.Name=name
		hl.DepthMode=Enum.HighlightDepthMode.AlwaysOnTop
		hl.Parent=ESPFolder
	end
	hl.Adornee=model
	hl.FillColor=color
	hl.OutlineColor=color
	hl.FillTransparency=.98
	hl.OutlineTransparency=.5
	hl.Enabled=true
end
local function worldTag(cat,model,part,color)
	if not validPart(part) then return end
	local key=worldKey(cat,model)
	local tagName=key.."_Tag"
	local nameText=""
	if ESPState.WorldNametags then
		if cat=="Generator" then nameText="Generator"
		elseif cat=="Palletwrong" then nameText="Pallet"
		elseif cat=="Window" then nameText="Window"
		elseif cat=="SCPZombie" then nameText=model.Name
		else nameText=cat end
	end
	local distanceText=""
	local me=LP.Character and rootPart(LP.Character)
	if ESPState.WorldDistanceESP and me then
		distanceText="["..math.floor((me.Position-part.Position).Magnitude).."m]"
	end
	local text=nameText
	if text~="" and distanceText~="" then text=text.." "..distanceText
	elseif distanceText~="" then text=distanceText end
	if text=="" then destroyWorld(tagName); return end
	local tag=ESPFolder:FindFirstChild(tagName)
	if not tag then
		tag=Instance.new("BillboardGui")
		tag.Name=tagName
		tag.AlwaysOnTop=true
		tag.LightInfluence=0
		tag.MaxDistance=0
		tag.Parent=ESPFolder
	end
	tag.Adornee=part
	tag.Enabled=true
	tag.Size=UDim2.fromOffset(220,20)
	tag.StudsOffset=Vector3.new(0,2.5,0)
	local line=tag:FindFirstChild("Line") or Instance.new("TextLabel")
	line.Name="Line"
	line.Size=UDim2.fromScale(1,1)
	line.BackgroundTransparency=1
	line.TextColor3=color
	line.TextSize=ESPState.TextSize
	line.Font=Enum.Font.GothamBold
	line.Text= text
	line.Parent=tag
end
local function anyWorld()
	return ESPState.WorldMasterESP and (
		ESPState.World.Generator or ESPState.World.Hook or ESPState.World.Gate or
		ESPState.World.Window or ESPState.World.Pallet or ESPState.World.SCPZombie
	)
end
local function clearAllWorld()
	for cat,models in pairs(WorldReg) do
		for model in pairs(models) do clearWorldVisual(cat,model) end
	end
end
local function startWorldLoop()
	if WorldLoopThread then return end
	WorldLoopThread=task.spawn(function()
		while ESPState.WorldMasterESP do
			for cat,models in pairs(WorldReg) do
				local enabled,color=worldData(cat)
				if enabled then
					for model,entry in pairs(models) do
						if cat=="Palletwrong" and palletGone(model) then
							clearWorldVisual(cat,model)
							models[model]=nil
						elseif worldAlive(model) then
							local part=entry.part
							if not validPart(part) or (model:IsA("Model") and not part:IsDescendantOf(model)) then
								part=pickWorldPart(model,cat)
								entry.part=part
							end
							if validPart(part) then
								ensureWorldHighlight(cat,model,color)
								worldTag(cat,model,part,color)
							else
								clearWorldVisual(cat,model)
								models[model]=nil
							end
						else
							clearWorldVisual(cat,model)
							models[model]=nil
						end
					end
				else
					for model in pairs(models) do clearWorldVisual(cat,model) end
				end
			end
			task.wait(.25)
		end
		WorldLoopThread=nil
		clearAllWorld()
	end)
end
local function worldESP()
	refreshWorldRoots()
	if anyWorld() then startWorldLoop() end
end

-- Refresh central: todos los controles llaman a esta función.
-- Primero limpia las visuales anteriores y luego aplica exactamente
-- el estado actual de cada módulo.
local function updateWarnings()
 for _,p in ipairs(Players:GetPlayers()) do
  if isSurvivor(p) then warningFor(p) else local old=ESPFolder:FindFirstChild("Warn_"..p.Name);if old then old:Destroy() end end
 end
 if not ESPState.WarnKiller then
  for _,x in ipairs(ESPFolder:GetChildren()) do if x.Name:sub(1,5)=="Warn_" then x:Destroy() end end
 end
end
local WorldActive=false
local function setWorldEnabled(v)
 if v then
  if not WorldActive then refreshWorldRoots();WorldActive=true end
  if anyWorld() then startWorldLoop() end
 else
  WorldActive=false;clearAllWorld()
 end
end
local function Refresh()
 updatePlayerESP()
 updateWarnings()
 setWorldEnabled(ESPState.WorldMasterESP)
end


-- Registro de desplegables abiertos.
local OpenDropdowns={}

local function CloseAllDropdowns(except)
    for popup in pairs(OpenDropdowns) do
        if popup~=except and popup.Parent then
            popup.Visible=false
        end
        if popup~=except then
            OpenDropdowns[popup]=nil
        end
    end
end

local function New(class,parent,props)
    local o=Instance.new(class)
    o.Parent=parent
    for k,v in pairs(props or {}) do o[k]=v end
    return o
end

local function Corner(o,r)
    New("UICorner",o,{CornerRadius=UDim.new(0,r or 7)})
end

local function Border(o)
    New("UIStroke",o,{Color=Color3.fromRGB(116,91,185),Transparency=.28,Thickness=1})
end

local function Text(parent,value,size,bold)
    return New("TextLabel",parent,{
        BackgroundTransparency=1,
        Text=value,
        TextSize=size or 12,
        Font=bold and Enum.Font.GothamBold or Enum.Font.Gotham,
        TextColor3=Color3.fromRGB(225,228,240),
        TextXAlignment=Enum.TextXAlignment.Left,
        TextYAlignment=Enum.TextYAlignment.Center
    })
end

local Window=New("Frame",Gui,{
    Size=UDim2.fromOffset(820,560),
    Position=UDim2.new(.5,-410,.5,-280),
    BackgroundColor3=Color3.fromRGB(10,9,20),
    BorderSizePixel=0,
    Active=true,
    ClipsDescendants=true
})
-- FONDO DEL MENÚ
local Background=New("ImageLabel",Window,{
    Name="Background",
    Size=UDim2.fromScale(1,1),
    Position=UDim2.fromScale(0,0),
    BackgroundTransparency=1,
    Image="rbxassetid://78841600806718",
    ImageTransparency=0.12,
    ScaleType=Enum.ScaleType.Crop,
    BorderSizePixel=0,
    ZIndex=0
})

local BackgroundShade=New("Frame",Window,{
    Name="BackgroundShade",
    Size=UDim2.fromScale(1,1),
    Position=UDim2.fromScale(0,0),
    BackgroundColor3=Color3.fromRGB(8,7,18),
    BackgroundTransparency=0.68,
    BorderSizePixel=0,
    ZIndex=0
})

Corner(Window,10)
Border(Window)

local Header=New("Frame",Window,{
    Size=UDim2.new(1,0,0,54),
    BackgroundColor3=Color3.fromRGB(22,19,38),
    BorderSizePixel=0,
    Active=true
,
    ZIndex=2})
Corner(Header,10)

local title=Text(Header,"◈  VISUAL HUB",16,true)
title.Position=UDim2.fromOffset(18,2)
title.Size=UDim2.fromOffset(300,28)

local sub=Text(Header,"INTERFAZ DE CONFIGURACIÓN",9,false)
sub.Position=UDim2.fromOffset(19,30)
sub.Size=UDim2.fromOffset(300,18)
sub.TextColor3=Color3.fromRGB(125,135,165)

local Min=New("TextButton",Header,{
    Size=UDim2.fromOffset(38,34),
    Position=UDim2.new(1,-88,0,10),
    Text="—",
    TextSize=18,
    Font=Enum.Font.GothamBold,
    TextColor3=Color3.fromRGB(235,235,240),
    BackgroundColor3=Color3.fromRGB(38,39,52),
    BorderSizePixel=0
})
Corner(Min,6)

local Close=New("TextButton",Header,{
    Size=UDim2.fromOffset(38,34),
    Position=UDim2.new(1,-44,0,10),
    Text="×",
    TextSize=22,
    Font=Enum.Font.GothamBold,
    TextColor3=Color3.fromRGB(235,235,240),
    BackgroundColor3=Color3.fromRGB(38,39,52),
    BorderSizePixel=0
})
Corner(Close,6)

local Sidebar=New("Frame",Window,{
    Position=UDim2.fromOffset(10,64),
    Size=UDim2.new(0,180,1,-74),
    BackgroundColor3=Color3.fromRGB(20,17,34),
    BackgroundTransparency=0.20,
    BorderSizePixel=0
,
    ZIndex=2})
Corner(Sidebar,8)
Border(Sidebar)

local SideScroll=New("ScrollingFrame",Sidebar,{
    Position=UDim2.fromOffset(6,6),
    Size=UDim2.new(1,-12,1,-12),
    BackgroundTransparency=1,
    BorderSizePixel=0,
    ScrollBarThickness=3,
    CanvasSize=UDim2.new(0,0,0,0),
    AutomaticCanvasSize=Enum.AutomaticSize.Y
})
New("UIListLayout",SideScroll,{
    Padding=UDim.new(0,5),
    SortOrder=Enum.SortOrder.LayoutOrder
})

local Content=New("Frame",Window,{
    Position=UDim2.fromOffset(200,64),
    Size=UDim2.new(1,-210,1,-74),
    BackgroundColor3=Color3.fromRGB(17,15,31),
    BackgroundTransparency=0.16,
    BorderSizePixel=0
,
    ZIndex=2})
Corner(Content,8)
Border(Content)

local TabScroll=New("ScrollingFrame",Content,{
    Position=UDim2.fromOffset(8,8),
    Size=UDim2.new(1,-16,0,38),
    BackgroundTransparency=1,
    BorderSizePixel=0,
    ScrollBarThickness=0,
    CanvasSize=UDim2.new(0,0,0,0),
    AutomaticCanvasSize=Enum.AutomaticSize.X
})
New("UIListLayout",TabScroll,{
    FillDirection=Enum.FillDirection.Horizontal,
    Padding=UDim.new(0,6)
})

local Body=New("ScrollingFrame",Content,{
    Position=UDim2.fromOffset(8,54),
    Size=UDim2.new(1,-16,1,-62),
    BackgroundTransparency=1,
    BorderSizePixel=0,
    ScrollBarThickness=4,
    CanvasSize=UDim2.new(0,0,0,0),
    AutomaticCanvasSize=Enum.AutomaticSize.Y
})
New("UIListLayout",Body,{
    Padding=UDim.new(0,8),
    SortOrder=Enum.SortOrder.LayoutOrder
})

local function Clear(parent)
    for _,o in ipairs(parent:GetChildren()) do
        if not o:IsA("UIListLayout") and not o:IsA("UIPadding") then
            o:Destroy()
        end
    end
end

local function Toggle(parent,name)
    local row=New("Frame",parent,{
        Size=UDim2.new(1,0,0,38),
        BackgroundColor3=Color3.fromRGB(24,20,42),
        BackgroundTransparency=0.10,
        BorderSizePixel=0
    })
    Corner(row,6)

    local txt=Text(row,name,12,false)
    txt.Position=UDim2.fromOffset(10,0)
    txt.Size=UDim2.new(1,-72,1,0)

    local button=New("TextButton",row,{
        Size=UDim2.fromOffset(48,24),
        Position=UDim2.new(1,-58,.5,-12),
        Text="OFF",
        TextSize=10,
        Font=Enum.Font.GothamBold,
        TextColor3=Color3.fromRGB(235,235,240),
        BackgroundColor3=Color3.fromRGB(48,39,70),
        BorderSizePixel=0
    })
    Corner(button,12)

    local enabled=false
    button.MouseButton1Click:Connect(function()
        enabled=not enabled
        button.Text=enabled and "ON" or "OFF"
        button.BackgroundColor3=enabled and Color3.fromRGB(125,76,220) or Color3.fromRGB(48,39,70)
        if ESPBind then ESPBind(name,enabled) end
    end)

    return row
end

local function Slider(parent,name,min,max,value)
    local row=New("Frame",parent,{
        Size=UDim2.new(1,0,0,54),
        BackgroundColor3=Color3.fromRGB(24,20,42),
        BackgroundTransparency=0.10,
        BorderSizePixel=0
    })
    Corner(row,6)

    local txt=Text(row,name,12,false)
    txt.Position=UDim2.fromOffset(10,2)
    txt.Size=UDim2.new(1,-80,0,22)

    local valueText=Text(row,tostring(value),10,true)
    valueText.Position=UDim2.new(1,-65,0,2)
    valueText.Size=UDim2.fromOffset(55,22)
    valueText.TextXAlignment=Enum.TextXAlignment.Right

    local bar=New("Frame",row,{
        Position=UDim2.fromOffset(10,35),
        Size=UDim2.new(1,-20,0,4),
        BackgroundColor3=Color3.fromRGB(47,38,68),
        BorderSizePixel=0
    })
    Corner(bar,3)

    local fill=New("Frame",bar,{
        Size=UDim2.new(math.clamp((value-min)/(max-min),0,1),0,1,0),
        BackgroundColor3=Color3.fromRGB(132,82,230),
        BorderSizePixel=0
    })
    Corner(fill,3)

    local hit=New("TextButton",row,{
        Position=UDim2.fromOffset(5,25),
        Size=UDim2.new(1,-10,0,22),
        Text="",
        BackgroundTransparency=1
    })

    local dragging=false

    hit.MouseButton1Down:Connect(function()
        dragging=true
    end)

    UIS.InputChanged:Connect(function(input)
        if dragging and (input.UserInputType==Enum.UserInputType.MouseMovement or input.UserInputType==Enum.UserInputType.Touch) then
            local p=math.clamp((input.Position.X-bar.AbsolutePosition.X)/bar.AbsoluteSize.X,0,1)
            local n=min+(max-min)*p
            n=math.floor(n*100+.5)/100
            fill.Size=UDim2.new(p,0,1,0)
            valueText.Text=tostring(n)
            if ESPBind then ESPBind(name,n) end
        end
    end)

    UIS.InputEnded:Connect(function(input)
        if input.UserInputType==Enum.UserInputType.MouseButton1 or input.UserInputType==Enum.UserInputType.Touch then
            dragging=false
        end
    end)

    return row
end

local function Dropdown(parent,name,items)
    local row=New("Frame",parent,{
        Size=UDim2.new(1,0,0,38),
        BackgroundColor3=Color3.fromRGB(24,20,42),
        BackgroundTransparency=0.10,
        BorderSizePixel=0,
        Active=true
    })
    Corner(row,6)

    local txt=Text(row,name,12,false)
    txt.Position=UDim2.fromOffset(10,0)
    txt.Size=UDim2.new(1,-125,1,0)

    local button=New("TextButton",row,{
        Size=UDim2.fromOffset(105,26),
        Position=UDim2.new(1,-113,.5,-13),
        Text="Seleccionar",
        TextSize=10,
        Font=Enum.Font.Gotham,
        TextColor3=Color3.fromRGB(225,225,235),
        BackgroundColor3=Color3.fromRGB(39,31,58),
        BorderSizePixel=0,
        Active=true,
        ZIndex=10
    })
    Corner(button,6)

    local popup=New("Frame",Gui,{
        Visible=false,
        Size=UDim2.fromOffset(180,math.min(230,10+#items*31)),
        BackgroundColor3=Color3.fromRGB(27,22,48),
        BorderSizePixel=0,
        Active=true,
        ZIndex=50
    })
    Corner(popup,7)
    Border(popup)

    local list=New("ScrollingFrame",popup,{
        Position=UDim2.fromOffset(5,5),
        Size=UDim2.new(1,-10,1,-10),
        BackgroundTransparency=1,
        BorderSizePixel=0,
        ScrollBarThickness=3,
        CanvasSize=UDim2.new(0,0,0,0),
        AutomaticCanvasSize=Enum.AutomaticSize.Y,
        Active=true,
        ZIndex=50
    })
    New("UIListLayout",list,{Padding=UDim.new(0,3)})

    local selected={}

    for _,item in ipairs(items) do
        local b=New("TextButton",list,{
            Size=UDim2.new(1,-3,0,28),
            Text="□  "..item,
            TextSize=10,
            Font=Enum.Font.Gotham,
            TextXAlignment=Enum.TextXAlignment.Left,
            TextColor3=Color3.fromRGB(220,220,230),
            BackgroundColor3=Color3.fromRGB(35,28,57),
            BorderSizePixel=0,
            Active=true,
            ZIndex=51
        })
        Corner(b,5)

        b.MouseButton1Click:Connect(function()
            selected[item]=not selected[item]
            b.Text=(selected[item] and "☑  " or "□  ")..item
            if selected[item] and ESPState then
                local C={Verde=Color3.fromRGB(0,255,0),Azul=Color3.fromRGB(0,170,255),Blanco=Color3.fromRGB(255,255,255),Rojo=Color3.fromRGB(255,0,0),Morado=Color3.fromRGB(170,0,255),Naranja=Color3.fromRGB(255,140,0),Cian=Color3.fromRGB(0,255,255),Amarillo=Color3.fromRGB(255,225,0),Púrpura=Color3.fromRGB(128,0,128)}
                local map={["Survivor Color"]="Survivor",["Killer Color"]="Killer",["Spectator Color"]="Spectator",["Generator Color"]="Generator",["Hook Color"]="Hook",["Gate Color"]="Gate",["Window Color"]="Window",["Pallet Color"]="Pallet",["SCP / Zombie Color"]="SCPZombie"}
                local k=map[name];if k and C[item] then ESPState.Colors[k]=C[item];if Refresh then pcall(Refresh) end end
            end
        end)
    end

    local function PositionPopup()
        local x=button.AbsolutePosition.X+button.AbsoluteSize.X-popup.AbsoluteSize.X
        local y=button.AbsolutePosition.Y+button.AbsoluteSize.Y+4
        local camera=workspace.CurrentCamera
        if camera then
            local vp=camera.ViewportSize
            x=math.clamp(x,4,vp.X-popup.AbsoluteSize.X-4)
            y=math.clamp(y,4,vp.Y-popup.AbsoluteSize.Y-4)
        end
        popup.Position=UDim2.fromOffset(x,y)
    end

    button.MouseButton1Click:Connect(function()
        if popup.Visible then
            popup.Visible=false
            OpenDropdowns[popup]=nil
        else
            CloseAllDropdowns(popup)
            PositionPopup()
            popup.Visible=true
            OpenDropdowns[popup]=true
        end
    end)

    return row
end
local function Section(parent,name)
    local box=New("Frame",parent,{
        Size=UDim2.new(1,0,0,48),
        BackgroundColor3=Color3.fromRGB(22,19,38),
        BorderSizePixel=0,
        ClipsDescendants=true
    })
    Corner(box,7)
    Border(box)

    local header=New("TextButton",box,{
        Size=UDim2.new(1,0,0,40),
        Text="▼  "..name,
        TextSize=12,
        Font=Enum.Font.GothamBold,
        TextColor3=Color3.fromRGB(205,210,230),
        TextXAlignment=Enum.TextXAlignment.Left,
        BackgroundTransparency=1
    })

    local inner=New("Frame",box,{
        Position=UDim2.fromOffset(8,46),
        Size=UDim2.new(1,-16,0,0),
        BackgroundTransparency=1
    })
    New("UIListLayout",inner,{
        Padding=UDim.new(0,6)
    })

    local open=true

    local function Refresh()
        local h=0
        for _,o in ipairs(inner:GetChildren()) do
            if o:IsA("GuiObject") then
                h=h+o.Size.Y.Offset+6
            end
        end
        inner.Size=UDim2.new(1,-16,0,h)
        box.Size=UDim2.new(1,0,0,open and h+54 or 48)
        header.Text=(open and "▼  " or "▶  ")..name
    end

    header.MouseButton1Click:Connect(function()
        open=not open
        Refresh()
    end)

    return inner,Refresh
end

local Categories={
    "🏠  PRINCIPAL",
    "👤  JUGADOR",
    "👁  VISUAL",
    "📷  CÁMARA",
    "☀  ILUMINACIÓN",
    "🧍  SUPERVIVIENTE",
    "🔪  ASESINO",
    "🗺  MAPA",
    "🧩  MISCELÁNEA",
    "⚙  AJUSTES"
}

local Tabs={
    ["🏠  PRINCIPAL"]={"APUNTADO","APUNTADO ASESINO","APUNTADO SUPERVIVIENTE"},
    ["👤  JUGADOR"]={"MOVIMIENTO","FLING","EMOTE","STATS","STREAMER","AVATAR"},
    ["👁  VISUAL"]={"ESP","CÁMARA","ILUMINACIÓN"},
    ["📷  CÁMARA"]={"GENERAL"},
    ["☀  ILUMINACIÓN"]={"GENERAL"},
    ["🧍  SUPERVIVIENTE"]={"GENERAL"},
    ["🔪  ASESINO"]={"GENERAL"},
    ["🗺  MAPA"]={"TELEPORT","RADAR"},
    ["🧩  MISCELÁNEA"]={"MISC","AJUSTES"},
    ["⚙  AJUSTES"]={"GENERAL"}
}

local Pages={}

Pages["APUNTADO"]={
    {"Configuración",{
        {"t","Activar Aimbot"},
        {"t","Usar RMB para apuntar"},
        {"t","Mostrar círculo FOV"},
        {"s","Tamaño FOV",0,500,120},
        {"s","Suavidad",0,1,.3},
        {"t","Comprobación de visibilidad"},
        {"t","Predicción"}
    }},
    {"Crosshair avanzado",{
        {"t","Activar Crosshair"},
        {"d","Color del Crosshair",{"Blanco","Cian","Morado","Rojo"}},
        {"d","Estilo del Crosshair",{"Punto","Cruz","Círculo"}},
        {"s","Tamaño",1,10,3},
        {"s","Grosor",1,10,4},
        {"s","Separación",0,20,6},
        {"s","Offset X",-100,100,0},
        {"s","Offset Y",-100,100,0}
    }}
}

Pages["APUNTADO ASESINO"]={
    {"Aimbot Spear (Veil)",{
        {"t","Spear Aimbot"},
        {"s","Spear Gravity",0,100,20},
        {"s","Spear Speed",0,300,100},
        {"d","Tecla de activación",{"None","Q","E","R","F"}}
    }},
    {"Silent Aim (Veil)",{
        {"t","Silent Aim Spear (Veil)"},
        {"t","Mostrar círculo FOV"},
        {"t","Mostrar Target Laser"},
        {"s","Radio FOV",0,500,120},
        {"t","Auto Predict"},
        {"s","Spear Speed",0,300,100},
        {"s","Gravity",0,100,20},
        {"s","Horizontal Vector",-100,100,0},
        {"d","Target Part",{"Torso","Head","Root"}}
    }},
    {"Silent Aim Flask (Cure)",{
        {"t","Silent Aim Flask (Cure)"},
        {"t","Flask Laser (Cure)"}
    }},
    {"Twist Of Fate",{
        {"t","Silent Aim Twist Of Fate"},
        {"t","ToF Laser"},
        {"t","ToF Wall Check"},
        {"t","ToF Block When Knocked"},
        {"d","ToF Target Mode",{"Killer","Survivors","Zombie"}},
        {"d","Silent Aim Key",{"None","Q","E","R","T","F","G","H","J","K","L","X","Z"}}
    }},
    {"Flashlight",{
        {"t","Silent Aim Flashlight"},
        {"t","Flashlight Laser"},
        {"d","Flashlight Target Part",{"Head","Torso","Root"}},
        {"s","Flashlight Range",0,100,30},
        {"s","Flashlight Smoothness",0,1,.3}
    }}
}

Pages["APUNTADO SUPERVIVIENTE"]={
    {"Objetivo",{
        {"t","Target Lock"},
        {"s","Target Lock Max Distance",0,1000,100},
        {"t","Predicción"},
        {"t","Comprobación de visibilidad"}
    }}
}

Pages["ESP"]={
 {"Highlight ESP Settings",{{"s","ESP Fill Transparency",0,1,.95},{"s","ESP Outline Transparency",0,1,.3},{"s","ESP Text Size",8,22,12}}},
 {"Player Highlight ESP",{{"t","Enable Player ESP"},{"t","Survivor ESP"},{"t","Killer ESP"},{"t","Spectator ESP"},{"t","Survivor Items ESP"},{"t","Player Nametags"},{"t","Player Distance ESP"},{"t","Survivor Killer Warning"}}},
 {"Player Colors",{{"d","Survivor Color",{"Verde","Azul","Blanco"}},{"d","Killer Color",{"Rojo","Morado","Naranja"}},{"d","Spectator Color",{"Blanco","Cian","Morado"}}}},
 {"World Highlight ESP",{{"t","Enable World ESP"},{"t","Generators"},{"t","Hooks"},{"t","Gates"},{"t","Windows"},{"t","Pallets"},{"t","SCP / Zombie"},{"t","World Nametags"},{"t","World Distance ESP"}}},
 {"World Colors",{{"d","Generator Color",{"Azul","Verde","Amarillo"}},{"d","Hook Color",{"Rojo","Verde"}},{"d","Gate Color",{"Amarillo","Azul"}},{"d","Window Color",{"Blanco","Cian"}},{"d","Pallet Color",{"Naranja","Morado"}},{"d","SCP / Zombie Color",{"Púrpura","Rojo"}}}}
}

Pages["CÁMARA"]={
    {"Cámara",{
        {"t","Enable Camera FOV override"},
        {"s","Camera FOV",30,140,70},
        {"t","Third Person (Killer only)"},
        {"t","Shift Lock (auto face camera)"},
        {"t","Infinity Zoom Out"},
        {"t","No Cutscene"}
    }}
}

Pages["ILUMINACIÓN"]={
    {"Iluminación",{
        {"t","Full Bright"},
        {"t","No Fog"},
        {"d","Weather Theme",{"Default","Sunny","Night","Storm"}},
        {"d","Sky Theme",{"Default","Blue","Purple","Night"}}
    }}
}

Pages["MOVIMIENTO"]={
    {"Movimiento",{
        {"t","Auto Crouch BETA"},
        {"t","Speed Hack"},
        {"s","Speed Value",0,300,100},
        {"t","Jump Hack"},
        {"s","Jump Power",0,300,50},
        {"t","Infinite Jump"},
        {"t","Anti Fall Damage"},
        {"t","Noclip"},
        {"t","Moonwalk"},
        {"t","Lock Moonwalk Button"},
        {"s","Moonwalk Zigzag Speed",0,100,10},
        {"s","Moonwalk Boost Power",0,100,10},
        {"t","Invisible Not Visual"},
        {"s","Invisible Speed",0,100,16},
        {"t","Anti AFK"}
    }}
}

Pages["FLING"]={
    {"Fling",{
        {"t","Enable Fling"},
        {"s","Fling Strength",0,500,100},
        {"t","Fling Nearest"},
        {"t","Fling All"}
    }}
}

Pages["EMOTE"]={
    {"Emotes",{
        {"t","Enable Emote"},
        {"d","Seleccionar Emote",{
            "Friday Night","WarCry","24 Hour Cinderella","Applause",
            "Arm Swing","Backflip","California Girls","Christmas Spirit",
            "Floating Rest","Ghoul","Griddy","Kyoufuu","OnePlays","Vulnerable"
        }}
    }}
}

Pages["STATS"]={
    {"Spoof Stats",{
        {"s","Set Level",0,100,1},
        {"s","Set Gears",0,100,1},
        {"s","Set Screws",0,100,1},
        {"t","Apply Spoof Data"}
    }}
}

Pages["STREAMER"]={
    {"Streamer Mode",{
        {"t","Hide Name"}
    }}
}

Pages["AVATAR"]={
    {"Avatar Tools",{
        {"t","Korless Morph"},
        {"t","APPLY KORLESS"},
        {"t","RESET KORLESS"},
        {"d","Select Player",{"Player 1","Player 2","Player 3"}},
        {"t","Apply Ava"},
        {"t","Reset Ava"}
    }}
}

Pages["GENERAL"]={
    {"Configuración",{
        {"t","Activar función"},
        {"t","Mostrar información"}
    }}
}

Pages["TELEPORT"]={
    {"Teleport",{
        {"d","Select Player to Teleport",{"Player 1","Player 2","Player 3"}},
        {"t","Refresh Players"},
        {"t","Teleport to Player"},
        {"t","TP to Gen"},
        {"t","TP to Gate"},
        {"t","TP to Hook"}
    }}
}

Pages["RADAR"]={
    {"Radar Configuration",{
        {"t","Radar Enabled"},
        {"s","Radar Size",50,500,200},
        {"s","Radar Range",50,2000,500},
        {"s","Radar Transparency",0,1,.3},
        {"t","Radar Circle Mode"}
    }},
    {"Radar Filters",{
        {"t","Show Killer"},
        {"t","Show Survivor"},
        {"t","Show Generator"},
        {"t","Show Pallet"},
        {"t","Show Hook"},
        {"t","Show Gate"},
        {"t","Show Window"},
        {"t","Show Zombie"}
    }}
}

Pages["MISC"]={
    {"General",{
        {"t","God Mode"},
        {"t","No Clip"},
        {"t","Invisible"},
        {"t","Teleport to Spawn"},
        {"t","Rejoin"},
        {"t","Server Hop"},
        {"t","Chat Bypass"}
    }},
    {"Game",{
        {"t","Remove UI"},
        {"t","Full Bright"},
        {"t","No Fog"},
        {"t","FPS Unlock"}
    }},
    {"Fun",{
        {"t","Ragdoll"},
        {"t","Spin"},
        {"t","Btools"},
        {"t","Walk on Water"},
        {"t","Skybox"}
    }},
    {"Other",{
        {"t","Show Hitbox"},
        {"t","Show Ping"},
        {"t","Show FPS"},
        {"t","Show Coordinates"}
    }}
}

Pages["AJUSTES"]={
    {"Ajustes",{
        {"t","Show Ping & FPS"},
        {"t","Show Hook Counter"},
        {"t","Enable Spectator Counter"},
        {"t","Killer Perks Display"},
        {"t","Kyst Killer Display"},
        {"t","Predict Map"}
    }}
}

local sideButtons={}
local tabButtons={}

local function Render(tab)
    Clear(Body)

    local page=Pages[tab] or Pages["GENERAL"]

    for _,sectionData in ipairs(page) do
        local inner,refresh=Section(Body,sectionData[1])

        for _,item in ipairs(sectionData[2]) do
            if item[1]=="t" then
                Toggle(inner,item[2])
            elseif item[1]=="s" then
                Slider(inner,item[2],item[3],item[4],item[5])
            elseif item[1]=="d" then
                Dropdown(inner,item[2],item[3])
            end
        end

        task.defer(refresh)
    end
end

local function ShowCategory(category)
    Clear(TabScroll)
    tabButtons={}

    local list=Tabs[category]
    local first=list[1]

    for _,tabName in ipairs(list) do
        local button=New("TextButton",TabScroll,{
            Size=UDim2.fromOffset(math.max(112,#tabName*7+30),34),
            Text=tabName,
            TextSize=10,
            Font=Enum.Font.GothamBold,
            TextColor3=Color3.fromRGB(220,220,235),
            BackgroundColor3=tabName==first and Color3.fromRGB(125,76,220) or Color3.fromRGB(30,25,50),
            BorderSizePixel=0
        })
        Corner(button,6)
        tabButtons[tabName]=button

        button.MouseButton1Click:Connect(function()
            for _,b in pairs(tabButtons) do
                b.BackgroundColor3=Color3.fromRGB(30,25,50)
            end
            button.BackgroundColor3=Color3.fromRGB(125,76,220)
            Render(tabName)
        end)
    end

    Render(first)
end

for index,category in ipairs(Categories) do
    local button=New("TextButton",SideScroll,{
        LayoutOrder=index,
        Size=UDim2.new(1,0,0,40),
        Text=category,
        TextSize=11,
        Font=Enum.Font.GothamBold,
        TextXAlignment=Enum.TextXAlignment.Left,
        TextColor3=Color3.fromRGB(205,208,225),
        BackgroundColor3=Color3.fromRGB(28,23,47),
        BorderSizePixel=0
    })
    Corner(button,6)
    sideButtons[category]=button

    button.MouseButton1Click:Connect(function()
        for _,b in pairs(sideButtons) do
            b.BackgroundColor3=Color3.fromRGB(28,23,47)
        end
        button.BackgroundColor3=Color3.fromRGB(125,76,220)
        ShowCategory(category)
    end)
end

sideButtons["🏠  PRINCIPAL"].BackgroundColor3=Color3.fromRGB(125,76,220)
ShowCategory("🏠  PRINCIPAL")

-- CERRAR DESPLEGABLES AL TOCAR FUERA
UIS.InputBegan:Connect(function(input)
    if input.UserInputType~=Enum.UserInputType.MouseButton1
        and input.UserInputType~=Enum.UserInputType.Touch then
        return
    end

    local pos=input.Position
    for popup in pairs(OpenDropdowns) do
        if popup.Visible then
            local insidePopup=
                pos.X>=popup.AbsolutePosition.X and
                pos.X<=popup.AbsolutePosition.X+popup.AbsoluteSize.X and
                pos.Y>=popup.AbsolutePosition.Y and
                pos.Y<=popup.AbsolutePosition.Y+popup.AbsoluteSize.Y

            if not insidePopup then
                popup.Visible=false
                OpenDropdowns[popup]=nil
            end
        end
    end
end)

-- ARRastrar ventana
local dragging=false
local dragInput=nil
local dragStart
local windowStart

Header.InputBegan:Connect(function(input)
    if input.UserInputType==Enum.UserInputType.MouseButton1
        or input.UserInputType==Enum.UserInputType.Touch then
        dragging=true
        dragInput=input
        dragStart=input.Position
        windowStart=Window.Position
    end
end)

Header.InputEnded:Connect(function(input)
    if input==dragInput or input.UserInputType==Enum.UserInputType.MouseButton1
        or input.UserInputType==Enum.UserInputType.Touch then
        dragging=false
        dragInput=nil
    end
end)

UIS.InputChanged:Connect(function(input)
    if not dragging then return end
    if input.UserInputType~=Enum.UserInputType.MouseMovement
        and input.UserInputType~=Enum.UserInputType.Touch then
        return
    end

    local delta=input.Position-dragStart
    Window.Position=UDim2.new(
        windowStart.X.Scale,
        windowStart.X.Offset+delta.X,
        windowStart.Y.Scale,
        windowStart.Y.Offset+delta.Y
    )
end)

-- MINIMIZAR / RESTAURAR
local Resize
local minimized=false
local normalSize=Window.Size

Min.MouseButton1Click:Connect(function()
    minimized=not minimized
    CloseAllDropdowns()

    if minimized then
        normalSize=Window.Size
        Sidebar.Visible=false
        Content.Visible=false
        Resize.Visible=false
        Window.Size=UDim2.new(normalSize.X.Scale,normalSize.X.Offset,0,54)
    else
        Sidebar.Visible=true
        Content.Visible=true
        Resize.Visible=true
        Window.Size=normalSize
    end
end)

-- BOTÓN FLOTANTE PARA MOSTRAR EL MENÚ DESPUÉS DE CERRARLO
local ToggleGui=New("ScreenGui",PlayerGui,{
    Name="VISUAL_HUB_TOGGLE",
    ResetOnSpawn=false,
    IgnoreGuiInset=true,
    ZIndexBehavior=Enum.ZIndexBehavior.Global
})

local ShowButton=New("TextButton",ToggleGui,{
    Size=UDim2.fromOffset(58,58),
    Position=UDim2.new(0,18,0.5,-29),
    Text="◈",
    TextSize=24,
    Font=Enum.Font.GothamBold,
    TextColor3=Color3.fromRGB(235,235,245),
    BackgroundColor3=Color3.fromRGB(43,31,70),
    BorderSizePixel=0,
    Visible=false,
    Active=true
})
Corner(ShowButton,29)
Border(ShowButton)

ShowButton.MouseButton1Click:Connect(function()
    Gui.Enabled=true
    ToggleGui.Enabled=true
    ShowButton.Visible=false
    Window.Visible=true
    minimized=false
    Sidebar.Visible=true
    Content.Visible=true
    Resize.Visible=true
    Window.Size=normalSize
end)

-- CERRAR: oculta el menú, pero deja el botón flotante para volver a mostrarlo.
Close.MouseButton1Click:Connect(function()
    CloseAllDropdowns()
    Gui.Enabled=true
    Window.Visible=false
    ShowButton.Visible=true
end)

-- REDIMENSIONAR CON MOUSE Y TOUCH
Resize=New("TextButton",Window,{
    Size=UDim2.fromOffset(34,34),
    Position=UDim2.new(1,-34,1,-34),
    AnchorPoint=Vector2.new(0,0),
    Text="◢",
    TextSize=19,
    Font=Enum.Font.GothamBold,
    TextColor3=Color3.fromRGB(135,110,235),
    BackgroundTransparency=0.65,
    BackgroundColor3=Color3.fromRGB(24,22,38),
    BorderSizePixel=0,
    Active=true,
    AutoButtonColor=false,
    ZIndex=20
})
Corner(Resize,6)

local resizing=false
local resizeInput=nil
local resizeStart
local startSize

Resize.InputBegan:Connect(function(input)
    if input.UserInputType==Enum.UserInputType.MouseButton1
        or input.UserInputType==Enum.UserInputType.Touch then
        resizing=true
        resizeInput=input
        resizeStart=input.Position
        startSize=Window.AbsoluteSize
    end
end)

Resize.InputEnded:Connect(function(input)
    if input==resizeInput
        or input.UserInputType==Enum.UserInputType.MouseButton1
        or input.UserInputType==Enum.UserInputType.Touch then
        resizing=false
        resizeInput=nil
        normalSize=Window.Size
    end
end)

UIS.InputChanged:Connect(function(input)
    if not resizing then return end
    if input.UserInputType~=Enum.UserInputType.MouseMovement
        and input.UserInputType~=Enum.UserInputType.Touch then
        return
    end

    local delta=input.Position-resizeStart
    local minW,minH=620,420
    local maxW,maxH=1100,800
    local newW=math.clamp(startSize.X+delta.X,minW,maxW)
    local newH=math.clamp(startSize.Y+delta.Y,minH,maxH)

    Window.Size=UDim2.fromOffset(newW,newH)
    normalSize=Window.Size
end)

