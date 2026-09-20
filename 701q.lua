-- VISUAL > ESP
-- Reconstruccion local basada en (096).txt
-- UI local, sin ModernV2 ni HttpGet.
-- Esta version contiene la estructura completa de VISUAL > ESP.
-- La logica real del motor ESP se conecta en la siguiente etapa.

local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")

local Player = Players.LocalPlayer

local LocalPlayer = Player

-- =====================================================
-- VISUAL HIGHLIGHT ESP V2 (Player + World)
-- Stabil, anti double nametag, anti duplicate highlight, dan safe re-execute.
-- Kontrol ditambahkan ke tab Visual lewat getgenv().KYS_AddVisualESPControls.
-- =====================================================
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

local function RefreshAllPlayers() return getgenv().KYS_ESP_RefreshAllPlayers() end
local function ClearAllPlayerESP() return getgenv().KYS_ESP_ClearAllPlayerESP() end
local function StartPlayerLoop() return getgenv().KYS_ESP_StartPlayerLoop() end
local function RefreshESPRoots() return getgenv().KYS_ESP_RefreshESPRoots() end
local function ClearAllWorldESP() return getgenv().KYS_ESP_ClearAllWorldESP() end
local function StartWorldLoop() return getgenv().KYS_ESP_StartWorldLoop() end

local State = getgenv().KYS_VD_VisualESP_State

local Images = {
    KillerWarningYellow = "rbxassetid://120753562298647",
    KillerWarningPurple = "rbxassetid://99499680507460",
}

local GUI = Instance.new("ScreenGui")
GUI.Name = "ESP_UI_TEST"
GUI.ResetOnSpawn = false
GUI.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
GUI.Parent = Player:WaitForChild("PlayerGui")

local Main = Instance.new("Frame")
Main.Size = UDim2.fromOffset(390,500)
Main.Position = UDim2.new(0.5,-195,0.5,-250)
Main.BackgroundColor3 = Color3.fromRGB(18,18,22)
Main.BorderSizePixel = 0
Main.ClipsDescendants = true
Main.Parent = GUI

Instance.new("UICorner",Main).CornerRadius = UDim.new(0,10)

local Stroke = Instance.new("UIStroke")
Stroke.Color = Color3.fromRGB(55,55,65)
Stroke.Thickness = 1
Stroke.Parent = Main

local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(1,-45,0,42)
Title.Position = UDim2.fromOffset(15,0)
Title.BackgroundTransparency = 1
Title.Text = "VISUAL › ESP"
Title.TextColor3 = Color3.fromRGB(255,255,255)
Title.TextSize = 17
Title.Font = Enum.Font.GothamBold
Title.TextXAlignment = Enum.TextXAlignment.Left
Title.Parent = Main

local Minimize = Instance.new("TextButton")
Minimize.Size = UDim2.fromOffset(32,32)
Minimize.Position = UDim2.new(1,-38,0,5)
Minimize.BackgroundColor3 = Color3.fromRGB(35,35,42)
Minimize.Text = "—"
Minimize.TextColor3 = Color3.fromRGB(255,255,255)
Minimize.TextSize = 18
Minimize.Font = Enum.Font.GothamBold
Minimize.Parent = Main
Instance.new("UICorner",Minimize).CornerRadius = UDim.new(0,7)

local Scroll = Instance.new("ScrollingFrame")
Scroll.Size = UDim2.new(1,-12,1,-50)
Scroll.Position = UDim2.fromOffset(6,45)
Scroll.BackgroundTransparency = 1
Scroll.BorderSizePixel = 0
Scroll.ScrollBarThickness = 4
Scroll.ScrollBarImageColor3 = Color3.fromRGB(90,90,100)
Scroll.AutomaticCanvasSize = Enum.AutomaticSize.Y
Scroll.ClipsDescendants = true
Scroll.Parent = Main

local Padding = Instance.new("UIPadding")
Padding.PaddingLeft = UDim.new(0,7)
Padding.PaddingRight = UDim.new(0,7)
Padding.PaddingTop = UDim.new(0,5)
Padding.PaddingBottom = UDim.new(0,10)
Padding.Parent = Scroll

local Layout = Instance.new("UIListLayout")
Layout.Padding = UDim.new(0,7)
Layout.SortOrder = Enum.SortOrder.LayoutOrder
Layout.Parent = Scroll

local CurrentSection

local function Section(Name)
    local Holder = Instance.new("Frame")
    Holder.Size = UDim2.new(1,0,0,40)
    Holder.BackgroundColor3 = Color3.fromRGB(25,25,31)
    Holder.BorderSizePixel = 0
    Holder.AutomaticSize = Enum.AutomaticSize.Y
    Holder.ClipsDescendants = true
    Holder.Parent = Scroll
    Instance.new("UICorner",Holder).CornerRadius = UDim.new(0,8)

    local Header = Instance.new("TextButton")
    Header.Size = UDim2.new(1,0,0,40)
    Header.BackgroundTransparency = 1
    Header.Text = "▶  "..Name
    Header.TextColor3 = Color3.fromRGB(235,235,240)
    Header.TextSize = 13
    Header.Font = Enum.Font.GothamBold
    Header.TextXAlignment = Enum.TextXAlignment.Left
    Header.Parent = Holder

    local HP = Instance.new("UIPadding")
    HP.PaddingLeft = UDim.new(0,12)
    HP.Parent = Header

    local Content = Instance.new("Frame")
    Content.Size = UDim2.new(1,0,0,0)
    Content.BackgroundTransparency = 1
    Content.AutomaticSize = Enum.AutomaticSize.Y
    Content.Visible = false
    Content.Parent = Holder

    local CL = Instance.new("UIListLayout")
    CL.Padding = UDim.new(0,5)
    CL.SortOrder = Enum.SortOrder.LayoutOrder
    CL.Parent = Content

    local CP = Instance.new("UIPadding")
    CP.PaddingLeft = UDim.new(0,8)
    CP.PaddingRight = UDim.new(0,8)
    CP.PaddingBottom = UDim.new(0,8)
    CP.Parent = Content

    local Open = false

    Header.MouseButton1Click:Connect(function()
        Open = not Open
        Content.Visible = Open
        Header.Text = (Open and "▼  " or "▶  ")..Name
    end)

    return Content
end

local function AddLabel(Text)
    local L = Instance.new("TextLabel")
    L.Size = UDim2.new(1,0,0,26)
    L.BackgroundTransparency = 1
    L.Text = Text
    L.TextColor3 = Color3.fromRGB(170,170,180)
    L.TextSize = 11
    L.Font = Enum.Font.GothamMedium
    L.TextXAlignment = Enum.TextXAlignment.Left
    L.Parent = CurrentSection
    return L
end

local function AddToggle(Text,Default,Callback)
    local Button = Instance.new("TextButton")
    Button.Size = UDim2.new(1,0,0,36)
    Button.BackgroundColor3 = Color3.fromRGB(32,32,39)
    Button.Text = ""
    Button.Parent = CurrentSection
    Instance.new("UICorner",Button).CornerRadius = UDim.new(0,7)

    local Name = Instance.new("TextLabel")
    Name.Size = UDim2.new(1,-55,1,0)
    Name.Position = UDim2.fromOffset(10,0)
    Name.BackgroundTransparency = 1
    Name.Text = Text
    Name.TextColor3 = Color3.fromRGB(225,225,230)
    Name.TextSize = 12
    Name.Font = Enum.Font.GothamMedium
    Name.TextXAlignment = Enum.TextXAlignment.Left
    Name.Parent = Button

    local Switch = Instance.new("Frame")
    Switch.Size = UDim2.fromOffset(34,18)
    Switch.Position = UDim2.new(1,-44,0.5,-9)
    Switch.BackgroundColor3 = Default and Color3.fromRGB(70,180,100) or Color3.fromRGB(65,65,75)
    Switch.Parent = Button
    Instance.new("UICorner",Switch).CornerRadius = UDim.new(1,0)

    local Dot = Instance.new("Frame")
    Dot.Size = UDim2.fromOffset(14,14)
    Dot.Position = Default and UDim2.new(1,-16,0.5,-7) or UDim2.fromOffset(2,2)
    Dot.BackgroundColor3 = Color3.fromRGB(255,255,255)
    Dot.Parent = Switch
    Instance.new("UICorner",Dot).CornerRadius = UDim.new(1,0)

    local Value = Default

    Button.MouseButton1Click:Connect(function()
        Value = not Value
        Switch.BackgroundColor3 = Value and Color3.fromRGB(70,180,100) or Color3.fromRGB(65,65,75)
        Dot.Position = Value and UDim2.new(1,-16,0.5,-7) or UDim2.fromOffset(2,2)
        if Callback then Callback(Value) end
    end)

    return Button
end

local function AddSlider(Text,Min,Max,Default,Increment,Callback)
    local Holder = Instance.new("Frame")
    Holder.Size = UDim2.new(1,0,0,55)
    Holder.BackgroundTransparency = 1
    Holder.Parent = CurrentSection

    local Name = Instance.new("TextLabel")
    Name.Size = UDim2.new(1,-60,0,22)
    Name.BackgroundTransparency = 1
    Name.Text = Text
    Name.TextColor3 = Color3.fromRGB(225,225,230)
    Name.TextSize = 12
    Name.Font = Enum.Font.GothamMedium
    Name.TextXAlignment = Enum.TextXAlignment.Left
    Name.Parent = Holder

    local ValueLabel = Instance.new("TextLabel")
    ValueLabel.Size = UDim2.fromOffset(55,22)
    ValueLabel.Position = UDim2.new(1,-55,0,0)
    ValueLabel.BackgroundTransparency = 1
    ValueLabel.TextColor3 = Color3.fromRGB(170,170,180)
    ValueLabel.TextSize = 11
    ValueLabel.Font = Enum.Font.GothamMedium
    ValueLabel.TextXAlignment = Enum.TextXAlignment.Right
    ValueLabel.Parent = Holder

    local Bar = Instance.new("Frame")
    Bar.Size = UDim2.new(1,0,0,7)
    Bar.Position = UDim2.fromOffset(0,31)
    Bar.BackgroundColor3 = Color3.fromRGB(55,55,65)
    Bar.Parent = Holder
    Instance.new("UICorner",Bar).CornerRadius = UDim.new(1,0)

    local Fill = Instance.new("Frame")
    Fill.Size = UDim2.new(math.clamp((Default-Min)/(Max-Min),0,1),0,1,0)
    Fill.BackgroundColor3 = Color3.fromRGB(100,150,255)
    Fill.Parent = Bar
    Instance.new("UICorner",Fill).CornerRadius = UDim.new(1,0)

    local Value = Default
    local Dragging = false

    local function SetValue(X)
        local Percent = math.clamp((X-Bar.AbsolutePosition.X)/Bar.AbsoluteSize.X,0,1)
        Value = Min + (Max-Min)*Percent
        Value = math.floor(Value/Increment+0.5)*Increment
        Value = math.clamp(Value,Min,Max)

        Fill.Size = UDim2.new((Value-Min)/(Max-Min),0,1,0)
        ValueLabel.Text = Increment < 1 and string.format("%.2f",Value) or tostring(Value)

        if Callback then Callback(Value) end
    end

    ValueLabel.Text = Increment < 1 and string.format("%.2f",Default) or tostring(Default)

    Bar.InputBegan:Connect(function(Input)
        if Input.UserInputType == Enum.UserInputType.MouseButton1
        or Input.UserInputType == Enum.UserInputType.Touch then
            Dragging = true
            SetValue(Input.Position.X)
        end
    end)

    UserInputService.InputChanged:Connect(function(Input)
        if Dragging and (Input.UserInputType == Enum.UserInputType.MouseMovement
        or Input.UserInputType == Enum.UserInputType.Touch) then
            SetValue(Input.Position.X)
        end
    end)

    UserInputService.InputEnded:Connect(function(Input)
        if Input.UserInputType == Enum.UserInputType.MouseButton1
        or Input.UserInputType == Enum.UserInputType.Touch then
            Dragging = false
        end
    end)

    return Holder
end

local function AddMultiDropdown(Text,Options,Default,Callback)
    local Holder = Instance.new("Frame")
    Holder.Size = UDim2.new(1,0,0,40)
    Holder.BackgroundColor3 = Color3.fromRGB(32,32,39)
    Holder.ClipsDescendants = true
    Holder.Parent = CurrentSection
    Instance.new("UICorner",Holder).CornerRadius = UDim.new(0,7)

    local Button = Instance.new("TextButton")
    Button.Size = UDim2.new(1,0,0,40)
    Button.BackgroundTransparency = 1
    Button.Text = Text.."  ▼"
    Button.TextColor3 = Color3.fromRGB(225,225,230)
    Button.TextSize = 12
    Button.Font = Enum.Font.GothamMedium
    Button.TextXAlignment = Enum.TextXAlignment.Left
    Button.Parent = Holder

    local Pad = Instance.new("UIPadding")
    Pad.PaddingLeft = UDim.new(0,10)
    Pad.Parent = Button

    local OptionsFrame = Instance.new("Frame")
    OptionsFrame.Size = UDim2.new(1,0,0,0)
    OptionsFrame.Position = UDim2.fromOffset(0,40)
    OptionsFrame.BackgroundTransparency = 1
    OptionsFrame.AutomaticSize = Enum.AutomaticSize.Y
    OptionsFrame.Parent = Holder

    local List = Instance.new("UIListLayout")
    List.Padding = UDim.new(0,2)
    List.Parent = OptionsFrame

    local Selected = {}
    for _,v in ipairs(Default or {}) do Selected[v] = true end

    local function UpdateTitle()
        local Names = {}
        for _,Option in ipairs(Options) do
            if Selected[Option] then table.insert(Names,Option) end
        end
        Button.Text = #Names == 0 and Text.."  ▼" or Text..": "..table.concat(Names,", ").."  ▼"
    end

    for _,Option in ipairs(Options) do
        local OptionButton = Instance.new("TextButton")
        OptionButton.Size = UDim2.new(1,-12,0,30)
        OptionButton.Position = UDim2.fromOffset(6,0)
        OptionButton.BackgroundColor3 = Color3.fromRGB(42,42,50)
        OptionButton.TextColor3 = Color3.fromRGB(210,210,215)
        OptionButton.TextSize = 11
        OptionButton.Font = Enum.Font.GothamMedium
        OptionButton.TextXAlignment = Enum.TextXAlignment.Left
        OptionButton.Text = "   "..Option
        OptionButton.Parent = OptionsFrame
        Instance.new("UICorner",OptionButton).CornerRadius = UDim.new(0,6)

        OptionButton.MouseButton1Click:Connect(function()
            Selected[Option] = not Selected[Option]

            if Selected[Option] then
                OptionButton.Text = "   ✓ "..Option
                OptionButton.TextColor3 = Color3.fromRGB(100,220,130)
            else
                OptionButton.Text = "   "..Option
                OptionButton.TextColor3 = Color3.fromRGB(210,210,215)
            end

            local Result = {}
            for _,Name in ipairs(Options) do
                if Selected[Name] then table.insert(Result,Name) end
            end

            UpdateTitle()
            if Callback then Callback(Result) end
        end)
    end

    local Open = false

    Button.MouseButton1Click:Connect(function()
        Open = not Open
        Holder.Size = Open
            and UDim2.new(1,0,0,40+(#Options*32))
            or UDim2.new(1,0,0,40)
        Button.Text = Text..(Open and "  ▲" or "  ▼")
    end)

    UpdateTitle()
    return Holder
end

local function AddDivider(Text)
    local D = Instance.new("TextLabel")
    D.Size = UDim2.new(1,0,0,25)
    D.BackgroundTransparency = 1
    D.Text = "—  "..Text.."  —"
    D.TextColor3 = Color3.fromRGB(120,120,130)
    D.TextSize = 10
    D.Font = Enum.Font.GothamBold
    D.Parent = CurrentSection
end

local OpenColorPickers = {}

local function AddColorPicker(Text,Default,Callback)
    local Holder = Instance.new("Frame")
    Holder.Size = UDim2.new(1,0,0,38)
    Holder.BackgroundColor3 = Color3.fromRGB(32,32,39)
    Holder.ClipsDescendants = true
    Holder.Parent = CurrentSection
    Instance.new("UICorner",Holder).CornerRadius = UDim.new(0,7)

    local Name = Instance.new("TextLabel")
    Name.Size = UDim2.new(1,-55,1,0)
    Name.Position = UDim2.fromOffset(10,0)
    Name.BackgroundTransparency = 1
    Name.Text = Text
    Name.TextColor3 = Color3.fromRGB(225,225,230)
    Name.TextSize = 12
    Name.Font = Enum.Font.GothamMedium
    Name.TextXAlignment = Enum.TextXAlignment.Left
    Name.Parent = Holder

    local Preview = Instance.new("TextButton")
    Preview.Size = UDim2.fromOffset(32,22)
    Preview.Position = UDim2.new(1,-42,0.5,-11)
    Preview.BackgroundColor3 = Default
    Preview.Text = ""
    Preview.Parent = Holder
    Instance.new("UICorner",Preview).CornerRadius = UDim.new(0,5)

    local Picker = Instance.new("Frame")
    Picker.Size = UDim2.new(1,0,0,259)
    Picker.Position = UDim2.fromOffset(0,42)
    Picker.BackgroundColor3 = Color3.fromRGB(24,24,29)
    Picker.Visible = false
    Picker.ZIndex = 20
    Picker.Parent = Holder
    Instance.new("UICorner",Picker).CornerRadius = UDim.new(0,8)

    local Close = Instance.new("TextButton")
    Close.Name = "ClosePicker"
    Close.Size = UDim2.fromOffset(24,24)
    Close.Position = UDim2.new(1,-30,0,5)
    Close.BackgroundColor3 = Color3.fromRGB(42,42,50)
    Close.Text = "X"
    Close.TextColor3 = Color3.fromRGB(235,235,240)
    Close.TextSize = 11
    Close.Font = Enum.Font.GothamBold
    Close.ZIndex = 30
    Close.Parent = Picker
    Instance.new("UICorner",Close).CornerRadius = UDim.new(0,6)

    local SV = Instance.new("Frame")
    SV.Size = UDim2.new(1,-20,0,155)
    SV.Position = UDim2.fromOffset(10,34)
    SV.BorderSizePixel = 0
    SV.ClipsDescendants = true
    SV.ZIndex = 21
    SV.Parent = Picker
    Instance.new("UICorner",SV).CornerRadius = UDim.new(0,6)

    local SVColor = Instance.new("Frame")
    SVColor.Size = UDim2.fromScale(1,1)
    SVColor.BorderSizePixel = 0
    SVColor.ZIndex = 21
    SVColor.Parent = SV

    local WhiteGradient = Instance.new("UIGradient")
    WhiteGradient.Color = ColorSequence.new(Color3.new(1,1,1))
    WhiteGradient.Transparency = NumberSequence.new{
        NumberSequenceKeypoint.new(0,0),
        NumberSequenceKeypoint.new(1,1)
    }
    WhiteGradient.Rotation = 0
    WhiteGradient.Parent = SVColor

    local BlackOverlay = Instance.new("Frame")
    BlackOverlay.Size = UDim2.fromScale(1,1)
    BlackOverlay.BackgroundColor3 = Color3.new(0,0,0)
    BlackOverlay.BorderSizePixel = 0
    BlackOverlay.ZIndex = 22
    BlackOverlay.Parent = SV

    local BlackGradient = Instance.new("UIGradient")
    BlackGradient.Transparency = NumberSequence.new{
        NumberSequenceKeypoint.new(0,1),
        NumberSequenceKeypoint.new(1,0)
    }
    BlackGradient.Rotation = 90
    BlackGradient.Parent = BlackOverlay

    local SVMarker = Instance.new("Frame")
    SVMarker.Size = UDim2.fromOffset(12,12)
    SVMarker.AnchorPoint = Vector2.new(0.5,0.5)
    SVMarker.BackgroundTransparency = 1
    SVMarker.ZIndex = 25
    SVMarker.Parent = SV

    local MS = Instance.new("UIStroke")
    MS.Color = Color3.new(1,1,1)
    MS.Thickness = 2
    MS.Parent = SVMarker
    Instance.new("UICorner",SVMarker).CornerRadius = UDim.new(1,0)

    local Hue = Instance.new("Frame")
    Hue.Size = UDim2.new(1,-20,0,18)
    Hue.Position = UDim2.fromOffset(10,199)
    Hue.BorderSizePixel = 0
    Hue.ZIndex = 21
    Hue.Parent = Picker
    Instance.new("UICorner",Hue).CornerRadius = UDim.new(1,0)

    local HueGradient = Instance.new("UIGradient")
    HueGradient.Color = ColorSequence.new{
        ColorSequenceKeypoint.new(0,Color3.fromRGB(255,0,0)),
        ColorSequenceKeypoint.new(1/6,Color3.fromRGB(255,255,0)),
        ColorSequenceKeypoint.new(2/6,Color3.fromRGB(0,255,0)),
        ColorSequenceKeypoint.new(3/6,Color3.fromRGB(0,255,255)),
        ColorSequenceKeypoint.new(4/6,Color3.fromRGB(0,0,255)),
        ColorSequenceKeypoint.new(5/6,Color3.fromRGB(255,0,255)),
        ColorSequenceKeypoint.new(1,Color3.fromRGB(255,0,0))
    }
    HueGradient.Parent = Hue

    local HueMarker = Instance.new("Frame")
    HueMarker.Size = UDim2.fromOffset(8,22)
    HueMarker.AnchorPoint = Vector2.new(0.5,0.5)
    HueMarker.BackgroundColor3 = Color3.new(1,1,1)
    HueMarker.ZIndex = 25
    HueMarker.Parent = Hue
    Instance.new("UICorner",HueMarker).CornerRadius = UDim.new(0,3)

    local H,S,V = Color3.toHSV(Default)

    local function UpdateColor()
        local Color = Color3.fromHSV(H,S,V)
        Preview.BackgroundColor3 = Color
        SVColor.BackgroundColor3 = Color3.fromHSV(H,1,1)
        SVMarker.Position = UDim2.new(S,0,1-V,0)
        HueMarker.Position = UDim2.new(H,0,0.5,0)
        if Callback then Callback(Color) end
    end

    local SVDragging = false
    local HueDragging = false

    local function SetSV(X,Y)
        S = math.clamp((X-SV.AbsolutePosition.X)/SV.AbsoluteSize.X,0,1)
        V = 1-math.clamp((Y-SV.AbsolutePosition.Y)/SV.AbsoluteSize.Y,0,1)
        UpdateColor()
    end

    local function SetHue(X)
        H = math.clamp((X-Hue.AbsolutePosition.X)/Hue.AbsoluteSize.X,0,1)
        UpdateColor()
    end

    SV.InputBegan:Connect(function(Input)
        if Input.UserInputType == Enum.UserInputType.MouseButton1
        or Input.UserInputType == Enum.UserInputType.Touch then
            SVDragging = true
            SetSV(Input.Position.X,Input.Position.Y)
        end
    end)

    Hue.InputBegan:Connect(function(Input)
        if Input.UserInputType == Enum.UserInputType.MouseButton1
        or Input.UserInputType == Enum.UserInputType.Touch then
            HueDragging = true
            SetHue(Input.Position.X)
        end
    end)

    UserInputService.InputChanged:Connect(function(Input)
        if Input.UserInputType == Enum.UserInputType.MouseMovement
        or Input.UserInputType == Enum.UserInputType.Touch then
            if SVDragging then SetSV(Input.Position.X,Input.Position.Y) end
            if HueDragging then SetHue(Input.Position.X) end
        end
    end)

    UserInputService.InputEnded:Connect(function(Input)
        if Input.UserInputType == Enum.UserInputType.MouseButton1
        or Input.UserInputType == Enum.UserInputType.Touch then
            SVDragging = false
            HueDragging = false
        end
    end)

    local Open = false
    local SetOpen

    SetOpen = function(Value)
        Open = Value == true
        if Open then
            for otherSetOpen in pairs(OpenColorPickers) do
                if otherSetOpen ~= SetOpen then pcall(otherSetOpen, false) end
            end
            OpenColorPickers[SetOpen] = true
        else
            OpenColorPickers[SetOpen] = nil
        end
        Picker.Visible = Open
        Holder.Size = Open and UDim2.new(1,0,0,309) or UDim2.new(1,0,0,38)
    end

    Preview.MouseButton1Click:Connect(function()
        SetOpen(not Open)
    end)

    Close.MouseButton1Click:Connect(function()
        SetOpen(false)
    end)

    UpdateColor()
    return Holder
end

--------------------------------------------------
-- VISUAL > ESP
--------------------------------------------------

CurrentSection = Section("Highlight ESP Settings")

AddSlider("ESP Fill Transparency",0,1,State.ESPFillTransparency,0.01,function(Value)
    State.ESPFillTransparency = Value
    RefreshAllPlayers()
end)

AddSlider("ESP Outline Transparency",0,1,State.ESPOutlineTransparency,0.01,function(Value)
    State.ESPOutlineTransparency = Value
    RefreshAllPlayers()
end)

AddSlider("ESP Text Size",8,22,State.ESPTextSize,1,function(Value)
    State.ESPTextSize = Value
    RefreshAllPlayers()
end)

CurrentSection = Section("Player Highlight ESP")

AddToggle("Enable Player ESP",false,function(Value)
    State.PlayerMasterESP = Value
    if Value then
        StartPlayerLoop()
        RefreshAllPlayers()
    else
        ClearAllPlayerESP()
    end
end)

AddMultiDropdown(
    "Select Player ESP",
    {"Survivor ESP","Killer ESP","Spectator ESP","Survivor Items ESP"},
    {},
    function(Selected)
        PlayerESPSelection = Selected

        State.SurvivorESP = false
        State.KillerESP = false
        State.SpectatorESP = false
        State.SurvivorItemsESP = false

        for _,Value in ipairs(Selected) do
            if Value == "Survivor ESP" then
                State.SurvivorESP = true
            elseif Value == "Killer ESP" then
                State.KillerESP = true
            elseif Value == "Spectator ESP" then
                State.SpectatorESP = true
            elseif Value == "Survivor Items ESP" then
                State.SurvivorItemsESP = true
            end
        end

        if State.PlayerMasterESP then
            StartPlayerLoop()
            RefreshAllPlayers()
        else
            ClearAllPlayerESP()
        end
    end
)

AddToggle("Player Nametags",false,function(Value)
    State.Nametags = Value
    if State.PlayerMasterESP then
        StartPlayerLoop()
        RefreshAllPlayers()
    else
        ClearAllPlayerESP()
    end
end)

AddToggle("Player Distance ESP",false,function(Value)
    State.DistanceESP = Value
    if State.PlayerMasterESP then
        StartPlayerLoop()
        RefreshAllPlayers()
    else
        ClearAllPlayerESP()
    end
end)

AddToggle("Survivor Killer Warning (!)",false,function(Value)
    State.SurvivorKillerWarning = Value
    if not Value then ClearWarningGui() else UpdateKillerWarning() end
end)

AddDivider("Colors")

AddColorPicker("Survivor Color",State.SurvivorColor,function(Color)
    State.SurvivorColor = Color
    RefreshAllPlayers()
end)

AddColorPicker("Killer Color",State.KillerColor,function(Color)
    State.KillerColor = Color
    RefreshAllPlayers()
end)

AddColorPicker("Spectator Color",State.SpectatorColor,function(Color)
    State.SpectatorColor = Color
    RefreshAllPlayers()
end)

CurrentSection = Section("World Highlight ESP")

AddToggle("Enable World ESP",false,function(Value)
    State.WorldMasterESP = Value
    if Value then
        RefreshESPRoots()
        if AnyWorldEnabled() then
            StartWorldLoop()
        end
    else
        ClearAllWorldESP()
    end
end)

AddMultiDropdown(
    "Select World Objects",
    {"Generators","Hooks","Gates","Windows","Pallets","SCP / Zombie"},
    {},
    function(Selected)
        WorldESPSelection = Selected

        State.GeneratorESP = false
        State.HookESP = false
        State.GateESP = false
        State.WindowESP = false
        State.PalletESP = false
        State.SCPZombieESP = false

        for _,Value in ipairs(Selected) do
            if Value == "Generators" then
                State.GeneratorESP = true
            elseif Value == "Hooks" then
                State.HookESP = true
            elseif Value == "Gates" then
                State.GateESP = true
            elseif Value == "Windows" then
                State.WindowESP = true
            elseif Value == "Pallets" then
                State.PalletESP = true
            elseif Value == "SCP / Zombie" then
                State.SCPZombieESP = true
            end
        end

        if State.WorldMasterESP and AnyWorldEnabled() then
            RefreshESPRoots()
            StartWorldLoop()
        else
            ClearAllWorldESP()
        end
    end
)

AddToggle("World Nametags",false,function(Value)
    State.WorldNametags = Value
    if State.WorldMasterESP and AnyWorldEnabled() then
        StartWorldLoop()
    else
        ClearAllWorldESP()
    end
end)

AddToggle("World Distance ESP",false,function(Value)
    State.WorldDistanceESP = Value
    if State.WorldMasterESP and AnyWorldEnabled() then
        StartWorldLoop()
    else
        ClearAllWorldESP()
    end
end)

AddDivider("Colors")

AddColorPicker("Generator Color",State.GeneratorColor,function(Color)
    State.GeneratorColor = Color
end)

AddColorPicker("Hook Color",State.HookColor,function(Color)
    State.HookColor = Color
end)

AddColorPicker("Gate Color",State.GateColor,function(Color)
    State.GateColor = Color
end)

AddColorPicker("Window Color",State.WindowColor,function(Color)
    State.WindowColor = Color
end)

AddColorPicker("Pallet Color",State.PalletColor,function(Color)
    State.PalletColor = Color
end)

AddColorPicker("SCP / Zombie Color",State.SCPZombieColor,function(Color)
    State.SCPZombieColor = Color
end)

--------------------------------------------------
-- SURVIVOR KILLER WARNING
--------------------------------------------------
local WarningConnections = {}
local WarningActive = false

local function IsKillerForWarning(P)
    return P and P.Team and P.Team.Name == "Killer"
end

local function IsSurvivorForWarning(P)
    return P and P.Team and P.Team.Name == "Survivor"
end

local function ClearWarningGui()
    for _, P in ipairs(Players:GetPlayers()) do
        local Char = P.Character
        local Root = Char and Char:FindFirstChild("HumanoidRootPart")
        local Warn = Root and Root:FindFirstChild("KYS_SurvivorKillerWarn")
        if Warn then Warn:Destroy() end
    end
end

local function UpdateKillerWarning()
    if not State.SurvivorKillerWarning then
        if WarningActive then ClearWarningGui(); WarningActive = false end
        return
    end
    WarningActive = true

    local Killers = {}
    for _, P in ipairs(Players:GetPlayers()) do
        if P ~= Player and IsKillerForWarning(P) and P.Character then
            local Root = P.Character:FindFirstChild("HumanoidRootPart")
            local Hum = P.Character:FindFirstChildOfClass("Humanoid")
            if Root and Hum and Hum.Health > 0 then table.insert(Killers, Root) end
        end
    end

    for _, P in ipairs(Players:GetPlayers()) do
        if IsSurvivorForWarning(P) and P.Character then
            local Root = P.Character:FindFirstChild("HumanoidRootPart")
            local Hum = P.Character:FindFirstChildOfClass("Humanoid")
            if Root and Hum and Hum.Health > 0 then
                local Nearest = math.huge
                for _, KillerRoot in ipairs(Killers) do
                    Nearest = math.min(Nearest, (Root.Position - KillerRoot.Position).Magnitude)
                end
                local Warn = Root:FindFirstChild("KYS_SurvivorKillerWarn")
                if Nearest <= 60 then
                    local Danger = Nearest <= 40
                    if not Warn then
                        Warn = Instance.new("BillboardGui")
                        Warn.Name = "KYS_SurvivorKillerWarn"
                        Warn.Adornee = Root
                        Warn.AlwaysOnTop = true
                        Warn.Size = UDim2.fromOffset(76,56)
                        Warn.StudsOffset = Vector3.new(0,4.8,0)
                        Warn.MaxDistance = 2000
                        Warn.Parent = Root
                        local Yellow = Instance.new("ImageLabel")
                        Yellow.Name = "YellowIcon"
                        Yellow.BackgroundTransparency = 1
                        Yellow.ScaleType = Enum.ScaleType.Fit
                        Yellow.Parent = Warn
                        local Purple = Instance.new("ImageLabel")
                        Purple.Name = "PurpleIcon"
                        Purple.BackgroundTransparency = 1
                        Purple.ScaleType = Enum.ScaleType.Fit
                        Purple.Parent = Warn
                    end
                    local Yellow = Warn:FindFirstChild("YellowIcon")
                    local Purple = Warn:FindFirstChild("PurpleIcon")
                    Warn.Size = Danger and UDim2.fromOffset(76,56) or UDim2.fromOffset(56,56)
                    if Yellow then
                        Yellow.Image = Images.KillerWarningYellow
                        Yellow.Position = UDim2.fromScale(0,0)
                        Yellow.Size = Danger and UDim2.fromScale(0.62,1) or UDim2.fromScale(1,1)
                        Yellow.Visible = true
                    end
                    if Purple then
                        Purple.Image = Images.KillerWarningPurple
                        Purple.Position = UDim2.fromScale(0.38,0)
                        Purple.Size = UDim2.fromScale(0.62,1)
                        Purple.Visible = Danger
                    end
                elseif Warn then
                    Warn:Destroy()
                end
            end
        end
    end
end

WarningConnections[#WarningConnections+1] = game:GetService("RunService").Heartbeat:Connect(function()
    if State.SurvivorKillerWarning then UpdateKillerWarning() end
end)

--------------------------------------------------
-- DRAG
--------------------------------------------------

local Dragging = false
local DragStart
local StartPosition

Title.InputBegan:Connect(function(Input)
    if Input.UserInputType == Enum.UserInputType.MouseButton1
    or Input.UserInputType == Enum.UserInputType.Touch then
        Dragging = true
        DragStart = Input.Position
        StartPosition = Main.Position
    end
end)

UserInputService.InputChanged:Connect(function(Input)
    if Dragging and (Input.UserInputType == Enum.UserInputType.MouseMovement
    or Input.UserInputType == Enum.UserInputType.Touch) then
        local Delta = Input.Position-DragStart
        Main.Position = UDim2.new(
            StartPosition.X.Scale,
            StartPosition.X.Offset+Delta.X,
            StartPosition.Y.Scale,
            StartPosition.Y.Offset+Delta.Y
        )
    end
end)

UserInputService.InputEnded:Connect(function(Input)
    if Input.UserInputType == Enum.UserInputType.MouseButton1
    or Input.UserInputType == Enum.UserInputType.Touch then
        Dragging = false
    end
end)

local Minimized = false

Minimize.MouseButton1Click:Connect(function()
    Minimized = not Minimized
    Scroll.Visible = not Minimized
    Main.Size = Minimized and UDim2.fromOffset(390,50) or UDim2.fromOffset(390,500)
    Minimize.Text = Minimized and "+" or "—"
end)
