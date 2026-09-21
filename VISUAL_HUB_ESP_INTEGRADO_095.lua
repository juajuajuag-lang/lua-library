-- VISUAL HUB V2
-- UI SOLAMENTE. Sin lógica de juego.
-- Usar como LocalScript en StarterPlayerScripts o StarterGui.

local Players=game:GetService("Players")
local UIS=game:GetService("UserInputService")
local player=Players.LocalPlayer
if not player then return end
local PlayerGui=player:WaitForChild("PlayerGui")
local LocalPlayer=player

-- MOTOR ESP 095 INTEGRADO
do
    if getgenv().KYS_VD_VisualESP_Cleanup then
        pcall(getgenv().KYS_VD_VisualESP_Cleanup)
    end

    local LP = LocalPlayer
    local KYS_Dead = false
    local KYS_ControlsAdded = false

    local KYS_ESPState = {
        PlayerMasterESP = false,
        WorldMasterESP = false,
        ESPFillTransparency = 0.95,
        ESPOutlineTransparency = 0.3,
        ESPTextSize = 12,

        SurvivorESP = false,
        KillerESP = false,
        SpectatorESP = false,
        Nametags = false,
        DistanceESP = false,
        SurvivorItemsESP = false,

        SurvivorColor = Color3.fromRGB(0, 255, 0),
        KillerColor = Color3.fromRGB(255, 0, 0),
        SpectatorColor = Color3.fromRGB(255, 255, 255),

        GeneratorESP = false,
        HookESP = false,
        GateESP = false,
        WindowESP = false,
        PalletESP = false,
        SCPZombieESP = false,
        WorldNametags = false,
        WorldDistanceESP = false,

        GeneratorColor = Color3.fromRGB(0, 170, 255),
        HookColor = Color3.fromRGB(255, 0, 0),
        GateColor = Color3.fromRGB(255, 225, 0),
        WindowColor = Color3.fromRGB(255, 255, 255),
        PalletColor = Color3.fromRGB(255, 140, 0),
        SCPZombieColor = Color3.fromRGB(128, 0, 128),
    }

    getgenv().KYS_VD_VisualESP_State = KYS_ESPState

    KYS_WorldReg = {
        Generator = {},
        Hook = {},
        Gate = {},
        Window = {},
        Palletwrong = {},
        SCPZombie = {},
    }

    local KYS_MapAdd, KYS_MapRem = {}, {}
    local KYS_PlayerConns = {}
    local KYS_Connections = {}
    local KYS_PalletState = setmetatable({}, { __mode = "k" })
    local KYS_WindowState = setmetatable({}, { __mode = "k" })
    local KYS_InstanceIds = setmetatable({}, { __mode = "k" })
    local KYS_KystId = 0
    local KYS_PlayerLoopThread = nil
    local KYS_WorldLoopThread = nil
    local KYS_ESPFolder = nil

    local KYS_DisplayNames = {
        ["Motion Tracker"] = true,
        ["Gate"] = true,
        ["Flashlight"] = true,
        ["Bandage"] = true,
        ["Parrying Dagger"] = true,
        ["Adrenaline Shot"] = true,
        ["Twist of Fate"] = true,
        ["Shadow Clone"] = true,
        ["Holy Water"] = true,
        ["WaxBound Candle"] = true,
        ["Riot Shield"] = true,
        ["Emperor"] = true,
        ["AWP"] = true,
    }

    local function KYS_Alive(inst)
        if not inst then return false end
        local ok, parent = pcall(function() return inst.Parent end)
        return ok and parent ~= nil
    end

    local function KYS_Clamp(n, lo, hi)
        n = tonumber(n) or lo
        if n < lo then return lo end
        if n > hi then return hi end
        return n
    end

    local function KYS_PlayerKey(player)
        local id = player and player.UserId
        if id and id ~= 0 then return tostring(id) end
        return tostring(player and player.Name or "Unknown")
    end

    local function KYS_EspId(inst)
        if not inst then return "nil" end
        local id = KYS_InstanceIds[inst]
        if id then return id end
        KYS_KystId = KYS_KystId + 1
        id = tostring(KYS_KystId)
        KYS_InstanceIds[inst] = id
        return id
    end

    local function KYS_GetESPParent()
        local okCore, core = pcall(function() return game:GetService("CoreGui") end)
        if okCore and core then return core end
        if gethui then
            local okHui, hui = pcall(gethui)
            if okHui and hui then return hui end
        end
        local playerGui = LP and LP:FindFirstChildOfClass("PlayerGui")
        if playerGui then return playerGui end
        return Workspace
    end

    local function KYS_GetESPFolder()
        if KYS_ESPFolder and KYS_ESPFolder.Parent then
            return KYS_ESPFolder
        end

        local parent = KYS_GetESPParent()
        local old = parent:FindFirstChild("KysHub_VisualESP") or parent:FindFirstChild("ZiaanHub_ESP")
        if old then old:Destroy() end

        local folder = Instance.new("Folder")
        folder.Name = "KysHub_VisualESP"
        folder.Parent = parent
        KYS_ESPFolder = folder
        return folder
    end

    local function KYS_ClearPrefix(prefix, keepName)
        local folder = KYS_GetESPFolder()
        local keptExact = false
        for _, child in ipairs(folder:GetChildren()) do
            if child.Name:sub(1, #prefix) == prefix then
                if child.Name == keepName and not keptExact then
                    keptExact = true
                else
                    child:Destroy()
                end
            end
        end
    end

    local function KYS_SafeNotify(title, content, duration)
        pcall(function()
            if Window and Window.Notify then
                Window:Notify({
                    Title = title,
                    Content = content,
                    Duration = duration or 2,
                    Icon = "lucide:info",
                })
            end
        end)
    end

    local function KYS_ValidPart(part)
        return part and KYS_Alive(part) and part:IsA("BasePart")
    end

    local function KYS_FirstBasePart(inst)
        if not KYS_Alive(inst) then return nil end
        if inst:IsA("BasePart") then return inst end
        if inst:IsA("Model") then
            if inst.PrimaryPart and inst.PrimaryPart:IsA("BasePart") and KYS_Alive(inst.PrimaryPart) then
                return inst.PrimaryPart
            end
            local part = inst:FindFirstChildWhichIsA("BasePart", true)
            if KYS_ValidPart(part) then return part end
        end
        if inst:IsA("Tool") then
            local handle = inst:FindFirstChild("Handle") or inst:FindFirstChildWhichIsA("BasePart")
            if KYS_ValidPart(handle) then return handle end
        end
        return nil
    end

    local function KYS_GetRole(player)
        local teamName = player.Team and player.Team.Name and player.Team.Name:lower() or ""
        if teamName:find("killer") then return "Killer" end
        if teamName:find("survivor") then return "Survivor" end
        if teamName:find("spect") then return "Spectator" end
        return "Survivor"
    end

    local function KYS_PlayerRoleEnabled(player)
        local role = KYS_GetRole(player)
        if role == "Killer" then return KYS_ESPState.KillerESP end
        if role == "Spectator" then return KYS_ESPState.SpectatorESP end
        return KYS_ESPState.SurvivorESP
    end

    local function KYS_PlayerColor(player)
        local role = KYS_GetRole(player)
        if role == "Killer" then return KYS_ESPState.KillerColor end
        if role == "Spectator" then return KYS_ESPState.SpectatorColor end
        return KYS_ESPState.SurvivorColor
    end

    getgenv().KYS_VD_VisualESP_HasPlayerText = function(player)
        if not player or player == LP then return false end
        return KYS_ESPState.PlayerMasterESP
            and KYS_PlayerRoleEnabled(player)
            and (KYS_ESPState.Nametags or KYS_ESPState.DistanceESP)
    end

    local function KYS_EnsureHighlight(name, adornee, color, isPlayer)
        if not (adornee and KYS_Alive(adornee)) then return nil end
        local folder = KYS_GetESPFolder()
        KYS_ClearPrefix(name, name)

        local hl = folder:FindFirstChild(name)
        if not hl then
            hl = Instance.new("Highlight")
            hl.Name = name
            hl.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
            hl.Parent = folder
        end

        hl.Adornee = adornee
        hl.FillColor = color
        hl.OutlineColor = color
        if isPlayer then
            hl.FillTransparency = KYS_ESPState.ESPFillTransparency
            hl.OutlineTransparency = KYS_ESPState.ESPOutlineTransparency
        else
            hl.FillTransparency = 0.98
            hl.OutlineTransparency = 0.5
        end
        hl.Enabled = true
        return hl
    end

    local function KYS_DestroyChild(name)
        local folder = KYS_GetESPFolder()
        local child = folder:FindFirstChild(name)
        if child then child:Destroy() end
    end

    local function KYS_ClearPlayerESP(player)
        if not player or player == LP then return end
        local key = KYS_PlayerKey(player)
        KYS_DestroyChild("KYS_PlayerHL_" .. key)
        KYS_DestroyChild("KYS_PlayerTag_" .. key)
        KYS_DestroyChild("KYS_PlayerItem_" .. key)
    end

    local function KYS_ClearAllPlayerESP()
        for _, player in ipairs(Players:GetPlayers()) do
            if player ~= LP then
                KYS_ClearPlayerESP(player)
            end
        end
    end

    local function KYS_GetSurvivorItem(player)
        local character = player.Character
        if not character then return nil end
        for _, obj in ipairs(character:GetDescendants()) do
            if obj:IsA("Tool") or obj:IsA("Accessory") or obj:IsA("Model") then
                if KYS_DisplayNames[obj.Name] then
                    return obj.Name
                end
            end
        end
        return nil
    end

    local function KYS_GetItemImageId(itemName)
        local itemsFolder = ReplicatedStorage:FindFirstChild("Items")
        if not itemsFolder then return nil end
        local itemObj = itemsFolder:FindFirstChild(itemName)
        if not itemObj then return nil end

        if itemObj:IsA("Decal") or itemObj:IsA("Texture") then return itemObj.Texture end
        local texture = itemObj:FindFirstChildWhichIsA("Decal", true) or itemObj:FindFirstChildWhichIsA("Texture", true)
        if texture then return texture.Texture end
        local namedTexture = itemObj:FindFirstChild("Texture", true)
        if namedTexture and (namedTexture:IsA("Decal") or namedTexture:IsA("Texture")) then
            return namedTexture.Texture
        end
        return nil
    end

    local function KYS_SetBillboardLine(parent, index, count, data)
        local label = parent:FindFirstChild("Line" .. index)
        if not label then
            label = Instance.new("TextLabel")
            label.Name = "Line" .. index
            label.BackgroundTransparency = 1
            label.BorderSizePixel = 0
            label.Font = Enum.Font.Gotham
            label.TextStrokeTransparency = 0.65
            label.TextStrokeColor3 = Color3.new(0, 0, 0)
            label.Parent = parent
        end
        label.Size = UDim2.new(1, 0, 1 / count, 0)
        label.Position = UDim2.new(0, 0, (index - 1) / count, 0)
        label.TextSize = KYS_ESPState.ESPTextSize
        label.TextColor3 = data.Color
        label.Text = data.Text
    end

    local function KYS_PruneBillboardLines(parent, count)
        for _, child in ipairs(parent:GetChildren()) do
            if child:IsA("TextLabel") then
                local index = tonumber(child.Name:match("%d+"))
                if index and index > count then
                    child:Destroy()
                end
            end
        end
    end

    local function KYS_UpdatePlayerTag(player, character, head, color)
        local key = KYS_PlayerKey(player)
        local tagName = "KYS_PlayerTag_" .. key
        local folder = KYS_GetESPFolder()
        KYS_ClearPrefix("KYS_PlayerTag_" .. key, tagName)

        if not KYS_ValidPart(head) then
            KYS_DestroyChild(tagName)
            return
        end

        local lines = {}
        local root = LP.Character and LP.Character:FindFirstChild("HumanoidRootPart")
        local targetRoot = character and character:FindFirstChild("HumanoidRootPart")
        local distanceText = ""
        if KYS_ESPState.DistanceESP and root and targetRoot then
            distanceText = "[" .. tostring(math.floor((root.Position - targetRoot.Position).Magnitude)) .. "m]"
        end

        local nameText = KYS_ESPState.Nametags and player.Name or ""
        local mainLine = ""
        if nameText ~= "" and distanceText ~= "" then
            mainLine = nameText .. " " .. distanceText
        elseif nameText ~= "" then
            mainLine = nameText
        elseif distanceText ~= "" then
            mainLine = distanceText
        end

        if mainLine ~= "" then
            table.insert(lines, { Text = mainLine, Color = color })
        end

        if #lines == 0 then
            KYS_DestroyChild(tagName)
            return
        end

        local tag = folder:FindFirstChild(tagName)
        if not tag then
            tag = Instance.new("BillboardGui")
            tag.Name = tagName
            tag.AlwaysOnTop = true
            tag.LightInfluence = 0
            tag.MaxDistance = 0
            tag.Parent = folder
        end

        tag.Adornee = head
        tag.Enabled = true
        tag.Size = UDim2.new(0, 220, 0, #lines * 20)
        tag.StudsOffset = Vector3.new(0, 2.65, 0)

        for i, data in ipairs(lines) do
            KYS_SetBillboardLine(tag, i, #lines, data)
        end
        KYS_PruneBillboardLines(tag, #lines)
    end

    local function KYS_UpdatePlayerItemIcon(player, torso)
        local key = KYS_PlayerKey(player)
        local iconName = "KYS_PlayerItem_" .. key
        local folder = KYS_GetESPFolder()
        KYS_ClearPrefix("KYS_PlayerItem_" .. key, iconName)

        if not KYS_ValidPart(torso) then
            KYS_DestroyChild(iconName)
            return
        end

        local itemName = KYS_GetSurvivorItem(player)
        local imageId = itemName and KYS_GetItemImageId(itemName) or nil
        if not imageId then
            KYS_DestroyChild(iconName)
            return
        end

        local icon = folder:FindFirstChild(iconName)
        if not icon then
            icon = Instance.new("BillboardGui")
            icon.Name = iconName
            icon.AlwaysOnTop = true
            icon.LightInfluence = 0
            icon.MaxDistance = 0
            icon.Size = UDim2.fromOffset(20, 20)
            icon.StudsOffset = Vector3.new(0, 0, -1.6)
            icon.Parent = folder

            local image = Instance.new("ImageLabel")
            image.Name = "ImageLabel"
            image.BackgroundTransparency = 1
            image.Size = UDim2.fromScale(1, 1)
            image.Parent = icon
        end

        icon.Adornee = torso
        icon.Enabled = true
        local image = icon:FindFirstChild("ImageLabel")
        if image then image.Image = imageId end
    end

    local KYS_ApplyPlayerESP
    KYS_ApplyPlayerESP = function(player)
        if KYS_Dead or not player or player == LP then return end
        local character = player.Character
        if not (character and KYS_Alive(character)) then
            KYS_ClearPlayerESP(player)
            return
        end

        local key = KYS_PlayerKey(player)
        local enabled = KYS_ESPState.PlayerMasterESP and KYS_PlayerRoleEnabled(player)
        if not enabled then
            KYS_ClearPlayerESP(player)
            return
        end

        local color = KYS_PlayerColor(player)
        local head = character:FindFirstChild("Head")
        local torso = character:FindFirstChild("HumanoidRootPart") or character:FindFirstChild("UpperTorso") or character:FindFirstChild("Torso")

        KYS_EnsureHighlight("KYS_PlayerHL_" .. key, character, color, true)
        KYS_UpdatePlayerTag(player, character, head, color)

        if KYS_GetRole(player) == "Survivor" and KYS_ESPState.SurvivorItemsESP then
            KYS_UpdatePlayerItemIcon(player, torso)
        else
            KYS_DestroyChild("KYS_PlayerItem_" .. key)
        end
    end

    local function KYS_RefreshAllPlayers()
        for _, player in ipairs(Players:GetPlayers()) do
            if player ~= LP then
                pcall(KYS_ApplyPlayerESP, player)
            end
        end
    end

    local function KYS_StartPlayerLoop()
        if KYS_PlayerLoopThread then return end
        KYS_PlayerLoopThread = task.spawn(function()
            while not KYS_Dead and KYS_ESPState.PlayerMasterESP do
                KYS_RefreshAllPlayers()
                task.wait(0.25)
            end
            KYS_PlayerLoopThread = nil
        end)
    end

    local function KYS_WatchPlayer(player)
        if player == LP then return end
        if KYS_PlayerConns[player] then
            for _, conn in ipairs(KYS_PlayerConns[player]) do
                if conn then pcall(function() conn:Disconnect() end) end
            end
        end

        KYS_PlayerConns[player] = {}
        table.insert(KYS_PlayerConns[player], player.CharacterAdded:Connect(function(char)
            KYS_ClearPlayerESP(player)
            task.delay(0.15, function()
                if not KYS_Dead then pcall(KYS_ApplyPlayerESP, player) end
            end)
        end))
        table.insert(KYS_PlayerConns[player], player.CharacterRemoving:Connect(function()
            KYS_ClearPlayerESP(player)
        end))
        table.insert(KYS_PlayerConns[player], player:GetPropertyChangedSignal("Team"):Connect(function()
            KYS_ClearPlayerESP(player)
            pcall(KYS_ApplyPlayerESP, player)
        end))

        if player.Character then
            pcall(KYS_ApplyPlayerESP, player)
        end
    end

    local function KYS_UnwatchPlayer(player)
        KYS_ClearPlayerESP(player)
        if KYS_PlayerConns[player] then
            for _, conn in ipairs(KYS_PlayerConns[player]) do
                if conn then pcall(function() conn:Disconnect() end) end
            end
        end
        KYS_PlayerConns[player] = nil
    end

    local function KYS_PickWorldPart(model, cat)
        if not (model and KYS_Alive(model)) then return nil end
        if cat == "Generator" then
            local hitbox = model:FindFirstChild("HitBox", true) or model:FindFirstChild("GeneratorPoint", true)
            if KYS_ValidPart(hitbox) then return hitbox end
        elseif cat == "Palletwrong" then
            local candidates = {
                model:FindFirstChild("HumanoidRootPart", true),
                model:FindFirstChild("PrimaryPartPallet", true),
                model:FindFirstChild("Primary1", true),
                model:FindFirstChild("Primary2", true),
                model:FindFirstChild("PalletPoint", true),
                model:FindFirstChild("PalletPointSlide", true),
            }
            for _, part in ipairs(candidates) do
                if KYS_ValidPart(part) then return part end
            end
        elseif cat == "Window" then
            local vault = model:FindFirstChild("VaultPoint", true) or model:FindFirstChild("VaultTrigger", true)
            if KYS_ValidPart(vault) then return vault end
        elseif cat == "SCPZombie" then
            local root = model:FindFirstChild("HumanoidRootPart", true)
            if KYS_ValidPart(root) then return root end
            local torso = model:FindFirstChild("UpperTorso", true) or model:FindFirstChild("Torso", true)
            if KYS_ValidPart(torso) then return torso end
            return nil
        end
        return KYS_FirstBasePart(model)
    end

    local function KYS_GeneratorLabel(model)
        local pct = tonumber(model:GetAttribute("RepairProgress")) or 0
        if pct >= 0 and pct <= 1.001 then pct = pct * 100 end
        pct = KYS_Clamp(pct, 0, 100)

        local repairers = tonumber(model:GetAttribute("PlayersRepairingCount")) or 0
        local paused = model:GetAttribute("ProgressPaused") == true
        local kickcount = tonumber(model:GetAttribute("kickcount")) or 0
        local abyss50 = model:GetAttribute("Abyss50Triggered") == true

        local parts = { "Gen " .. tostring(math.floor(pct + 0.5)) .. "%" }
        if repairers > 0 then table.insert(parts, "(" .. repairers .. "p)") end
        if paused then table.insert(parts, "Pause") end
        if abyss50 then table.insert(parts, "Warn") end
        if kickcount > 0 then table.insert(parts, "K:" .. kickcount) end

        local hue = KYS_Clamp((pct / 100) * 0.33, 0, 0.33)
        return table.concat(parts, " "), Color3.fromHSV(hue, 1, 1)
    end

    local function KYS_HasBasePart(model)
        if not (model and KYS_Alive(model)) then return false end
        return model:FindFirstChildWhichIsA("BasePart", true) ~= nil
    end

    local function KYS_IsPalletGone(model)
        if not KYS_Alive(model) then return true end
        if not model:IsDescendantOf(Workspace) then return true end
        if KYS_PalletState[model] == "DEST" then return true end
        local ok, destroyed = pcall(function() return model:GetAttribute("Destroyed") end)
        if ok and destroyed == true then return true end
        return not KYS_HasBasePart(model)
    end

    local function KYS_WorldKey(cat, model)
        return "KYS_World_" .. cat .. "_" .. KYS_EspId(model)
    end

    local function KYS_ClearWorldVisual(cat, model)
        if not model then return end
        KYS_DestroyChild(KYS_WorldKey(cat, model) .. "_HL")
        KYS_DestroyChild(KYS_WorldKey(cat, model) .. "_Tag")
    end

    local function KYS_RemoveWorldEntry(cat, model)
        if not KYS_WorldReg[cat] or not KYS_WorldReg[cat][model] then return end
        KYS_ClearWorldVisual(cat, model)
        KYS_WorldReg[cat][model] = nil
    end

    local function KYS_EnsureWorldEntry(cat, model)
        if not KYS_Alive(model) or not KYS_WorldReg[cat] or KYS_WorldReg[cat][model] then return end
        if cat == "Palletwrong" and KYS_IsPalletGone(model) then return end
        local part = KYS_PickWorldPart(model, cat)
        if not KYS_ValidPart(part) then return end
        KYS_WorldReg[cat][model] = { part = part }
    end

    local function KYS_RegisterWorldDescendant(obj)
        if not KYS_Alive(obj) then return end
        local validCats = { Generator = true, Hook = true, Gate = true, Window = true, Palletwrong = true }

        if obj:IsA("Model") then
            if validCats[obj.Name] then
                KYS_EnsureWorldEntry(obj.Name, obj)
                return
            end
            local lower = obj.Name:lower()
            if lower:find("scp") or lower:find("zombie") then
                KYS_EnsureWorldEntry("SCPZombie", obj)
            end
            return
        end

        if obj:IsA("BasePart") then
            local parent = obj.Parent
            while parent and parent ~= Workspace do
                if parent:IsA("Model") then
                    if validCats[parent.Name] then
                        KYS_EnsureWorldEntry(parent.Name, parent)
                        return
                    end
                    local lower = parent.Name:lower()
                    if lower:find("scp") or lower:find("zombie") then
                        KYS_EnsureWorldEntry("SCPZombie", parent)
                        return
                    end
                end
                parent = parent.Parent
            end
        end
    end

    local function KYS_UnregisterWorldDescendant(obj)
        if not obj then return end
        local validCats = { Generator = true, Hook = true, Gate = true, Window = true, Palletwrong = true }

        if obj:IsA("Model") then
            if validCats[obj.Name] then
                KYS_RemoveWorldEntry(obj.Name, obj)
                return
            end
            local lower = obj.Name:lower()
            if lower:find("scp") or lower:find("zombie") then
                KYS_RemoveWorldEntry("SCPZombie", obj)
            end
            return
        end

        if obj:IsA("BasePart") then
            for cat, models in pairs(KYS_WorldReg) do
                for model, entry in pairs(models) do
                    if entry.part == obj then
                        KYS_RemoveWorldEntry(cat, model)
                    end
                end
            end
        end
    end

    local function KYS_AttachESPRoot(root)
        if not root or KYS_MapAdd[root] then return end
        KYS_MapAdd[root] = root.DescendantAdded:Connect(KYS_RegisterWorldDescendant)
        KYS_MapRem[root] = root.DescendantRemoving:Connect(KYS_UnregisterWorldDescendant)
        for _, descendant in ipairs(root:GetDescendants()) do
            KYS_RegisterWorldDescendant(descendant)
        end
    end

    local function KYS_RefreshESPRoots()
        for _, conn in pairs(KYS_MapAdd) do
            if conn then pcall(function() conn:Disconnect() end) end
        end
        for _, conn in pairs(KYS_MapRem) do
            if conn then pcall(function() conn:Disconnect() end) end
        end
        KYS_MapAdd, KYS_MapRem = {}, {}

        for cat, models in pairs(KYS_WorldReg) do
            for model in pairs(models) do
                KYS_ClearWorldVisual(cat, model)
            end
            KYS_WorldReg[cat] = {}
        end

        local map = Workspace:FindFirstChild("Map")
        local map1 = Workspace:FindFirstChild("Map1")
        if map then KYS_AttachESPRoot(map) end
        if map1 then KYS_AttachESPRoot(map1) end
    end

    local function KYS_LabelForPallet(model)
        local state = KYS_PalletState[model] or "UP"
        if state == "DOWN" then return "Pallet (down)" end
        if state == "DEST" then return "Pallet (destroyed)" end
        if state == "SLIDE" then return "Pallet (slide)" end
        return "Pallet"
    end

    local function KYS_LabelForWindow(model)
        local state = KYS_WindowState[model] or "READY"
        if state == "BUSY" then return "Window (busy)" end
        return "Window"
    end

    local function KYS_AnyWorldEnabled()
        return KYS_ESPState.WorldMasterESP and (
            KYS_ESPState.GeneratorESP or
            KYS_ESPState.HookESP or
            KYS_ESPState.GateESP or
            KYS_ESPState.WindowESP or
            KYS_ESPState.PalletESP or
            KYS_ESPState.SCPZombieESP
        )
    end

    local function KYS_WorldCategoryData(cat)
        if cat == "Generator" then return KYS_ESPState.GeneratorESP, KYS_ESPState.GeneratorColor end
        if cat == "Hook" then return KYS_ESPState.HookESP, KYS_ESPState.HookColor end
        if cat == "Gate" then return KYS_ESPState.GateESP, KYS_ESPState.GateColor end
        if cat == "Window" then return KYS_ESPState.WindowESP, KYS_ESPState.WindowColor end
        if cat == "Palletwrong" then return KYS_ESPState.PalletESP, KYS_ESPState.PalletColor end
        if cat == "SCPZombie" then return KYS_ESPState.SCPZombieESP, KYS_ESPState.SCPZombieColor end
        return false, Color3.new(1, 1, 1)
    end

    local function KYS_UpdateWorldTag(cat, model, part, color)
        local key = KYS_WorldKey(cat, model)
        local tagName = key .. "_Tag"
        local folder = KYS_GetESPFolder()
        KYS_ClearPrefix(tagName, tagName)

        if not KYS_ValidPart(part) then
            KYS_DestroyChild(tagName)
            return
        end

        local lines = {}
        local root = LP.Character and LP.Character:FindFirstChild("HumanoidRootPart")
        local distanceText = ""
        if KYS_ESPState.WorldDistanceESP and root then
            distanceText = "[" .. tostring(math.floor((root.Position - part.Position).Magnitude)) .. "m]"
        end

        local nameText = ""
        local labelColor = color
        if KYS_ESPState.WorldNametags then
            if cat == "Generator" then
                local txt, genColor = KYS_GeneratorLabel(model)
                nameText = txt
                labelColor = genColor
            elseif cat == "Palletwrong" then
                nameText = KYS_LabelForPallet(model)
            elseif cat == "Window" then
                nameText = KYS_LabelForWindow(model)
            elseif cat == "SCPZombie" then
                nameText = model.Name
            else
                nameText = cat
            end
        end

        local mainLine = ""
        if nameText ~= "" and distanceText ~= "" then
            mainLine = nameText .. " " .. distanceText
        elseif nameText ~= "" then
            mainLine = nameText
        elseif distanceText ~= "" then
            mainLine = distanceText
        end

        if mainLine ~= "" then
            table.insert(lines, { Text = mainLine, Color = labelColor })
        end

        if #lines == 0 then
            KYS_DestroyChild(tagName)
            return
        end

        local tag = folder:FindFirstChild(tagName)
        if not tag then
            tag = Instance.new("BillboardGui")
            tag.Name = tagName
            tag.AlwaysOnTop = true
            tag.LightInfluence = 0
            tag.MaxDistance = 0
            tag.Parent = folder
        end

        tag.Adornee = part
        tag.Enabled = true
        tag.Size = UDim2.new(0, 220, 0, #lines * 20)
        tag.StudsOffset = Vector3.new(0, 2.5, 0)

        for i, data in ipairs(lines) do
            KYS_SetBillboardLine(tag, i, #lines, data)
        end
        KYS_PruneBillboardLines(tag, #lines)
    end

    local function KYS_ClearAllWorldESP()
        for cat, models in pairs(KYS_WorldReg) do
            for model in pairs(models) do
                KYS_ClearWorldVisual(cat, model)
            end
        end
    end

    local function KYS_StartWorldLoop()
        if KYS_WorldLoopThread then return end
        KYS_WorldLoopThread = task.spawn(function()
            while not KYS_Dead and KYS_AnyWorldEnabled() do
                for cat, models in pairs(KYS_WorldReg) do
                    local enabled, color = KYS_WorldCategoryData(cat)
                    if enabled and KYS_ESPState.WorldMasterESP then
                        local n = 0
                        for model, entry in pairs(models) do
                            if cat == "Palletwrong" and KYS_IsPalletGone(model) then
                                KYS_RemoveWorldEntry(cat, model)
                            elseif model and KYS_Alive(model) then
                                local part = entry.part
                                if not KYS_ValidPart(part) or (model:IsA("Model") and not part:IsDescendantOf(model)) then
                                    entry.part = KYS_PickWorldPart(model, cat)
                                    part = entry.part
                                end

                                if KYS_ValidPart(part) then
                                    local key = KYS_WorldKey(cat, model)
                                    KYS_EnsureHighlight(key .. "_HL", model, color, false)
                                    KYS_UpdateWorldTag(cat, model, part, color)
                                else
                                    KYS_RemoveWorldEntry(cat, model)
                                end
                            else
                                KYS_RemoveWorldEntry(cat, model)
                            end

                            n = n + 1
                            if n % 60 == 0 then task.wait() end
                        end
                    else
                        for model in pairs(models) do
                            KYS_ClearWorldVisual(cat, model)
                        end
                    end
                end
                task.wait(0.25)
            end
            KYS_WorldLoopThread = nil
        end)
    end

    local function KYS_Selected(selected, name)
        if type(selected) ~= "table" then return false end
        if selected[name] ~= nil then return selected[name] == true end
        for _, value in pairs(selected) do
            if value == name then return true end
        end
        return false
    end

    getgenv().KYS_ESP_RefreshAllPlayers = KYS_RefreshAllPlayers
    getgenv().KYS_ESP_ClearAllPlayerESP = KYS_ClearAllPlayerESP
    getgenv().KYS_ESP_StartPlayerLoop = KYS_StartPlayerLoop
    getgenv().KYS_ESP_RefreshESPRoots = KYS_RefreshESPRoots
    getgenv().KYS_ESP_ClearAllWorldESP = KYS_ClearAllWorldESP
    getgenv().KYS_ESP_StartWorldLoop = KYS_StartWorldLoop
end


local RefreshAllPlayers=function() return getgenv().KYS_ESP_RefreshAllPlayers() end
local ClearAllPlayerESP=function() return getgenv().KYS_ESP_ClearAllPlayerESP() end
local StartPlayerLoop=function() return getgenv().KYS_ESP_StartPlayerLoop() end
local RefreshESPRoots=function() return getgenv().KYS_ESP_RefreshESPRoots() end
local ClearAllWorldESP=function() return getgenv().KYS_ESP_ClearAllWorldESP() end
local StartWorldLoop=function() return getgenv().KYS_ESP_StartWorldLoop() end
local State=getgenv().KYS_VD_VisualESP_State

local old=PlayerGui:FindFirstChild("VISUAL_HUB")
if old then old:Destroy() end

local Gui=Instance.new("ScreenGui")
Gui.Name="VISUAL_HUB"
Gui.ResetOnSpawn=false
Gui.IgnoreGuiInset=true
Gui.ZIndexBehavior=Enum.ZIndexBehavior.Sibling
Gui.Parent=PlayerGui

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

local function Toggle(parent,name,callback)
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
        if callback then pcall(callback,enabled) end
    end)

    return row
end

local function Slider(parent,name,min,max,value,callback)
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
            if callback then pcall(callback,n) end
        end
    end)

    UIS.InputEnded:Connect(function(input)
        if input.UserInputType==Enum.UserInputType.MouseButton1 or input.UserInputType==Enum.UserInputType.Touch then
            dragging=false
        end
    end)

    return row
end

local function Dropdown(parent,name,items,callback,multi)
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
            ZIndex=51,
            Name=item
        })
        Corner(b,5)

        b.MouseButton1Click:Connect(function()
            if multi==false then
                for key in pairs(selected) do selected[key]=nil end
                for _,child in ipairs(list:GetChildren()) do
                    if child:IsA("TextButton") then
                        child.Text="□  "..child.Name
                    end
                end
            end
            selected[item]=not selected[item]
            b.Text=(selected[item] and "☑  " or "□  ")..item
            if callback then pcall(callback,selected,item) end
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
    {"Highlight ESP Settings",{
        {"s","ESP Fill Transparency",0,1,.95,function(v)
            State.ESPFillTransparency=v
            RefreshAllPlayers()
        end},
        {"s","ESP Outline Transparency",0,1,.3,function(v)
            State.ESPOutlineTransparency=v
            RefreshAllPlayers()
        end},
        {"s","ESP Text Size",8,22,12,function(v)
            State.ESPTextSize=v
            RefreshAllPlayers()
        end}
    }},
    {"Player Highlight ESP",{
        {"t","Enable Player ESP",function(v)
            State.PlayerMasterESP=v
            if v then
                StartPlayerLoop()
                RefreshAllPlayers()
            else
                ClearAllPlayerESP()
            end
        end},
        {"d","Select Player ESP",{"Survivor ESP","Killer ESP","Spectator ESP","Survivor Items ESP"},function(selected)
            State.SurvivorESP=selected["Survivor ESP"]==true
            State.KillerESP=selected["Killer ESP"]==true
            State.SpectatorESP=selected["Spectator ESP"]==true
            State.SurvivorItemsESP=selected["Survivor Items ESP"]==true
            if State.PlayerMasterESP then
                StartPlayerLoop()
                RefreshAllPlayers()
            end
        end,true},
        {"t","Player Nametags",function(v)
            State.Nametags=v
            RefreshAllPlayers()
        end},
        {"t","Player Distance ESP",function(v)
            State.DistanceESP=v
            RefreshAllPlayers()
        end}
    }},
    {"Colores de jugadores",{
        {"d","Survivor Color",{"Verde","Azul","Blanco"},function(selected)
            local map={Verde=Color3.fromRGB(0,255,0),Azul=Color3.fromRGB(0,170,255),Blanco=Color3.fromRGB(255,255,255)}
            for name,color in pairs(map) do if selected[name] then State.SurvivorColor=color break end end
            RefreshAllPlayers()
        end,false},
        {"d","Killer Color",{"Rojo","Morado","Naranja"},function(selected)
            local map={Rojo=Color3.fromRGB(255,0,0),Morado=Color3.fromRGB(170,0,255),Naranja=Color3.fromRGB(255,140,0)}
            for name,color in pairs(map) do if selected[name] then State.KillerColor=color break end end
            RefreshAllPlayers()
        end,false},
        {"d","Spectator Color",{"Blanco","Cian","Morado"},function(selected)
            local map={Blanco=Color3.fromRGB(255,255,255),Cian=Color3.fromRGB(0,255,255),Morado=Color3.fromRGB(170,0,255)}
            for name,color in pairs(map) do if selected[name] then State.SpectatorColor=color break end end
            RefreshAllPlayers()
        end,false}
    }},
    {"World Highlight ESP",{
        {"t","Enable World ESP",function(v)
            State.WorldMasterESP=v
            if v then
                RefreshESPRoots()
                StartWorldLoop()
            else
                ClearAllWorldESP()
            end
        end},
        {"d","Select World Objects",{"Generators","Hooks","Gates","Windows","Pallets","SCP / Zombie"},function(selected)
            State.GeneratorESP=selected["Generators"]==true
            State.HookESP=selected["Hooks"]==true
            State.GateESP=selected["Gates"]==true
            State.WindowESP=selected["Windows"]==true
            State.PalletESP=selected["Pallets"]==true
            State.SCPZombieESP=selected["SCP / Zombie"]==true
            if State.WorldMasterESP then
                RefreshESPRoots()
                StartWorldLoop()
            else
                ClearAllWorldESP()
            end
        end,true},
        {"t","World Nametags",function(v)
            State.WorldNametags=v
            if State.WorldMasterESP then StartWorldLoop() end
        end},
        {"t","World Distance ESP",function(v)
            State.WorldDistanceESP=v
            if State.WorldMasterESP then StartWorldLoop() end
        end}
    }},
    {"Colores del mundo",{
        {"d","Generator",{"Azul","Verde","Amarillo"},function(selected)
            local map={Azul=Color3.fromRGB(0,170,255),Verde=Color3.fromRGB(0,255,0),Amarillo=Color3.fromRGB(255,225,0)}
            for name,color in pairs(map) do if selected[name] then State.GeneratorColor=color break end end
            if State.WorldMasterESP then StartWorldLoop() end
        end,false},
        {"d","Hook",{"Rojo","Verde"},function(selected)
            local map={Rojo=Color3.fromRGB(255,0,0),Verde=Color3.fromRGB(0,255,0)}
            for name,color in pairs(map) do if selected[name] then State.HookColor=color break end end
            if State.WorldMasterESP then StartWorldLoop() end
        end,false},
        {"d","Gate",{"Amarillo","Azul"},function(selected)
            local map={Amarillo=Color3.fromRGB(255,225,0),Azul=Color3.fromRGB(0,170,255)}
            for name,color in pairs(map) do if selected[name] then State.GateColor=color break end end
            if State.WorldMasterESP then StartWorldLoop() end
        end,false},
        {"d","Window",{"Blanco","Cian"},function(selected)
            local map={Blanco=Color3.fromRGB(255,255,255),Cian=Color3.fromRGB(0,255,255)}
            for name,color in pairs(map) do if selected[name] then State.WindowColor=color break end end
            if State.WorldMasterESP then StartWorldLoop() end
        end,false},
        {"d","Pallet",{"Naranja","Morado"},function(selected)
            local map={Naranja=Color3.fromRGB(255,140,0),Morado=Color3.fromRGB(170,0,255)}
            for name,color in pairs(map) do if selected[name] then State.PalletColor=color break end end
            if State.WorldMasterESP then StartWorldLoop() end
        end,false},
        {"d","SCP / Zombie",{"Púrpura","Rojo"},function(selected)
            local map={Púrpura=Color3.fromRGB(128,0,128),Rojo=Color3.fromRGB(255,0,0)}
            for name,color in pairs(map) do if selected[name] then State.SCPZombieColor=color break end end
            if State.WorldMasterESP then StartWorldLoop() end
        end,false}
    }}
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
                Toggle(inner,item[2],item[3])
            elseif item[1]=="s" then
                Slider(inner,item[2],item[3],item[4],item[5],item[6])
            elseif item[1]=="d" then
                Dropdown(inner,item[2],item[3],item[4],item[5])
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

