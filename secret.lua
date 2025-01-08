getgenv().Game = game
getgenv().JobID = getgenv().Game.JobId
getgenv().PlaceID = getgenv().Game.PlaceId

if getgenv().Script_Ran then
    return 
end

getgenv().Service_Wrap = function(serviceName)
    if cloneref then
        return cloneref(getgenv().Game:GetService(serviceName))
    else
        return getgenv().Game:GetService(serviceName)
    end
end

getgenv().Players = getgenv().Service_Wrap("Players")
getgenv().LocalPlayer = getgenv().Players.LocalPlayer
getgenv().TextChatService = getgenv().Service_Wrap("TextChatService")
getgenv().RBXGeneral = getgenv().TextChatService:WaitForChild("TextChannels"):WaitForChild("RBXGeneral")

local PlayerGui = game.Players.LocalPlayer:WaitForChild("PlayerGui")
if PlayerGui:FindFirstChild("FULLSCREEN_GUI") then
    print("Found.")
else
    local Players = game:GetService("Players")
    local player = Players.LocalPlayer

    local screenGui = Instance.new("ScreenGui")
    screenGui.Name = "FULLSCREEN_GUI"
    screenGui.IgnoreGuiInset = true
    screenGui.Enabled = false
    screenGui.ResetOnSpawn = false

    local fullScreenFrame = Instance.new("Frame")
    fullScreenFrame.Size = UDim2.new(1, 0, 1, 0)
    fullScreenFrame.Position = UDim2.new(0, 0, 0, 0)
    fullScreenFrame.BackgroundColor3 = Color3.new(1, 1, 1)
    fullScreenFrame.BorderSizePixel = 0
    fullScreenFrame.Parent = screenGui
    fullScreenFrame.Visible = true

    screenGui.Parent = player:WaitForChild("PlayerGui")
end

print("Started.")

if game:GetService("Workspace"):FindFirstChild("Camera"):FindFirstChild("VISION") then
    print("Effect found.")
    wait(0.2)
    local blur = game:GetService("Workspace"):FindFirstChild("Camera"):FindFirstChild("VISION")
    blur.Enabled = true
else
    local blur = Instance.new("BlurEffect")
    blur.Name = "VISION"
    blur.Parent = game:GetService("Workspace"):FindFirstChild("Camera")
    blur.Size = 0
    blur.Enabled = true
end

getgenv().Players = getgenv().Service_Wrap("Players")
local cmdp = getgenv().Players
local cmdlp = cmdp.LocalPlayer

function findplr(args, tbl)
    local players = tbl or cmdp:GetPlayers()
    if args == "me" then
        return cmdlp
    elseif args == "random" then 
        return players[math.random(1, #players)]
    else 
        for _, v in pairs(players) do
            if v.Name:lower():find(args:lower()) or v.DisplayName:lower():find(args:lower()) then
                return v
            end
        end
    end
    return nil
end

getgenv().ReplicatedStorage = getgenv().Service_Wrap("ReplicatedStorage")

if not getgenv().ReplicatedStorage:FindFirstChild("Replicate-Players") then
    local Folder_Inst = Instance.new("Folder")
    Folder_Inst.Name = "Replicate-Players"
    Folder_Inst.Parent = getgenv().ReplicatedStorage
end

local function ensureBoolValue(playerName)
    local folder = getgenv().ReplicatedStorage:FindFirstChild("Replicate-Players")
    if folder then
        local boolValue = folder:FindFirstChild("Select-" .. playerName)
        if not boolValue then
            boolValue = Instance.new("BoolValue")
            boolValue.Name = "Select-" .. playerName
            boolValue.Parent = folder
        end
        return boolValue
    end
    return nil
end

local validCommands = {".bring", ".kill", ".freeze", ".unfreeze", ".users", ".promote", ".jail", ".unjail", ".mute", ".unmute", ".emote", ".nobooth", ".blur", ".unblur", ".hide", ".unhide", ".sit", ".jump", ".noclip", ".clip", ".spawn", ".permspawn", ".nospawn"}

local function handleCommand(command, playerName)
    local player = findplr(playerName)
    if not player then
        warn("Player not found: " .. playerName)
        return
    end

    local boolValue = ensureBoolValue(player.Name)
    if not boolValue then
        warn("Failed to create or find BoolValue for player: " .. player.Name)
        return
    end

    boolValue.Value = true

    if command == ".kick" then
        if player then
            local kickReason = reason or "You have been kicked by the script owner."
            player:Kick(kickReason)
        else
            warn("Player not found!")
        end
    elseif command == ".bring" then
        local owner = cmdp:FindFirstChild("izzkhalifahpro") or cmdp:FindFirstChild("izzkhalifahpro") or cmdp:FindFirstChild("izzkhalifahpro")
        if owner and owner.Character and player.Character then
            local targetHRP = player.Character:FindFirstChild("HumanoidRootPart")
            local ownerHRP = owner.Character:FindFirstChild("HumanoidRootPart")
            if targetHRP and ownerHRP then
                targetHRP.CFrame = ownerHRP.CFrame
            else
                warn("HumanoidRootPart missing for target or owner.")
            end
        else
            warn("Owner or target character is missing.")
        end
    elseif command == ".kill" then
        if player.Character then
            local humanoid = player.Character:FindFirstChildWhichIsA("Humanoid")
            if humanoid then
                humanoid.Health = 0
            end
        else
            return warn("Player (Character): "..tostring(player)..", was not found!")
        end
    elseif command == ".freeze" then
        if player.Character then
            local Character = player.Character
            local HumanoidRootPart = Character:WaitForChild("HumanoidRootPart")
            
            HumanoidRootPart.Anchored = true
        else
            return warn("Player (Character): "..tostring(player)..", was not found!")
        end
    elseif command == ".unfreeze" then
        if player.Character then
            local Character = player.Character
            local HumanoidRootPart = Character:WaitForChild("HumanoidRootPart")
            
            HumanoidRootPart.Anchored = false
        else
            return warn("Player (Character): "..tostring(player)..", was not found!")
        end
    elseif command == ".users" then
        getgenv().TextChatService:FindFirstChild("TextChannels"):FindFirstChild("RBXGeneral"):SendAsync("I'm Using MYS.CLIENT")
    elseif command == ".promote" then
        local speeches = {
            "Ivan Is The Best",
            "SFC Clan Is The Best",
            "SFC Is a 10/10 Clan!",
            "We WIll Be The Best! - SFC CLAN IS THE BEST",
            "SFC CLAN HOLDS ME!",
            "I can vouch for this SFC CLAN!",
            "Best CLAN for this game!"
        }
    
        local randomSpeech = speeches[math.random(1, #speeches)]
        getgenv().TextChatService:FindFirstChild("TextChannels"):FindFirstChild("RBXGeneral"):SendAsync(randomSpeech)
    elseif command == ".jail" then
        if player then
            getgenv().cageEnabled = true
            getgenv().heartbeatConnection = nil
            
            local Players = game:GetService("Players")
            local Workspace = game:GetService("Workspace")
            local RunService = game:GetService("RunService")
            local TweenService = game:GetService("TweenService")
            local Lighting = game:GetService("Lighting")

            local camera = Workspace.CurrentCamera
            
            local Necessary_Folder = Workspace:FindFirstChild("parts_stuff") or Instance.new("Folder", Workspace)
            Necessary_Folder.Name = "parts_stuff"
            
            local function createCage()
                local cageSize = Vector3.new(10, 10, 10)
                local transparency = 0.5
                local centerPosition
                local cageModel = Instance.new("Model")
                cageModel.Name = "Cage"
                cageModel.Parent = Necessary_Folder
            end
            
            local function createPart(size, position)
                local part = Instance.new("Part")
                part.Size = size
                part.Position = position
                part.Anchored = true
                part.CanCollide = true
                part.Transparency = transparency
                part.Material = Enum.Material.Neon
                part.BrickColor = BrickColor.new("White")
                part.Parent = cageModel
                return part
            end
        
            local function setupCage(humanoidRootPart)
                centerPosition = humanoidRootPart.Position
                if cageModel or game:GetService("Workspace"):FindFirstChild("parts_stuff") then
                    for _, part in cageModel:GetChildren() do
                        part:Destroy()
                    end
                else
                    return warn("CageModel - Not Found!")
                end
                wait(0.2)
                createPart(Vector3.new(cageSize.X, 1, cageSize.Z), centerPosition - Vector3.new(0, cageSize.Y / 2, 0))
                createPart(Vector3.new(cageSize.X, 1, cageSize.Z), centerPosition + Vector3.new(0, cageSize.Y / 2, 0))
                createPart(Vector3.new(cageSize.X, cageSize.Y, 1), centerPosition + Vector3.new(0, 0, cageSize.Z / 2))
                createPart(Vector3.new(cageSize.X, cageSize.Y, 1), centerPosition - Vector3.new(0, 0, cageSize.Z / 2))
                createPart(Vector3.new(1, cageSize.Y, cageSize.Z), centerPosition - Vector3.new(cageSize.X / 2, 0, 0))
                createPart(Vector3.new(1, cageSize.Y, cageSize.Z), centerPosition + Vector3.new(cageSize.X / 2, 0, 0))
            end
        
            local function enforceCage(humanoidRootPart)
                RunService.Heartbeat:Connect(function()
                    if getgenv().cageEnabled and humanoidRootPart and centerPosition then
                        local position = humanoidRootPart.Position
                        local minBound = centerPosition - cageSize / 2
                        local maxBound = centerPosition + cageSize / 2
                        if position.X < minBound.X or position.X > maxBound.X or
                            position.Y < minBound.Y or position.Y > maxBound.Y or
                            position.Z < minBound.Z or position.Z > maxBound.Z then
                            humanoidRootPart.CFrame = CFrame.new(centerPosition)
                        end
                    end
                end)
            end
            
            local function handleCharacter(character)
                local humanoidRootPart = character:WaitForChild("HumanoidRootPart")
                setupCage(humanoidRootPart)
                enforceCage(humanoidRootPart)
            end
        
            local function updateLighting()
                if getgenv().heartbeatConnection then
                    getgenv().heartbeatConnection:Disconnect()
                    getgenv().heartbeatConnection = nil
                end
                getgenv().heartbeatConnection = RunService.Heartbeat:Connect(function()
                    if camera and centerPosition then
                        local cameraPosition = camera.CFrame.Position
                        local minBound = centerPosition - cageSize / 2
                        local maxBound = centerPosition + cageSize / 2
                        Lighting.ClockTime = (cameraPosition.X < minBound.X or cameraPosition.X > maxBound.X or
                                                cameraPosition.Y < minBound.Y or cameraPosition.Y > maxBound.Y or
                                                cameraPosition.Z < minBound.Z or cameraPosition.Z > maxBound.Z) and 0 or 14
                    end
                end)
            end
        
            if player.Character then
                handleCharacter(player.Character)
            end
            player.CharacterAdded:Connect(handleCharacter)
            updateLighting()
            
            createCage()
        end
    elseif command == ".unjail" then
        if player then
            getgenv().cageEnabled = false
            local Workspace = game:GetService("Workspace")
            local Lighting = game:GetService("Lighting")
            local TweenService = game:GetService("TweenService")

            getgenv().heartbeatConnection:Disconnect()
            getgenv().heartbeatConnection = nil

            local Necessary_Folder = Workspace:FindFirstChild("parts_stuff")
            if Necessary_Folder then
                Necessary_Folder:Destroy()
            end

            Lighting.ClockTime = 14

            for _, tween in pairs(TweenService:GetChildren()) do
                if tween:IsA("Tween") then
                    tween:Cancel()
                end
            end
        end
    elseif command == ".mute" then
        if player then
            local audio_device = player:FindFirstChildOfClass("AudioDeviceInput")

            audio_device.Muted = true
        else
            warn("Player: "..tostring(player)..", was not found!")
        end
    elseif command == ".unmute" then
        if player then
            local audio_device = player:FindFirstChildOfClass("AudioDeviceInput")

            audio_device.Muted = false
        else
            warn("Player: "..tostring(player)..", was not found!")
        end
    elseif command == ".emote" then
        if player then
            getgenv().Emotes = {
                17360720445,
                5917570207,
                18526338976,
                15698511500,
                4689362868,
                5104377791,
                3994130516,
                3576719440,
                15123050663,
                3934986896,
                17746270218,
                6865013133,
                3576721660,
                14548709888,
                15506496093,
                13071993910
            }
    
            local randomEmote = getgenv().Emotes[math.random(1, #getgenv().Emotes)]
            local get_char = player.Character or player.CharacterAdded:Wait()
            local char_hum = get_char:WaitForChild("Humanoid") or get_char:FindFirstChildWhichIsA("Humanoid")
    
            char_hum:PlayEmoteAndGetAnimTrackById(tonumber(randomEmote))
        else
            warn("Player: "..tostring(player)..", was not found!")
        end
    elseif command == ".nobooth" then
        if player then
            game:GetService("ReplicatedStorage"):FindFirstChild("DeleteBoothOwnership"):FireServer()
        else
            warn("Player: "..tostring(player)..", was not found!")
        end
    elseif command == ".blur" then
        if player then
            if game:GetService("Workspace"):FindFirstChild("Camera"):FindFirstChild("VISION") then
                local blur = game:GetService("Workspace"):FindFirstChild("Camera"):FindFirstChild("VISION")
                blur.Enabled = true
                blur.Size = 24
            else
                local blur = Instance.new("BlurEffect")
                blur.Name = "VISION"
                blur.Parent = game:GetService("Workspace"):FindFirstChild("Camera")
                blur.Size = 24
                blur.Enabled = true
            end
        else
            warn("Player: "..tostring(player)..", was not found!")
        end
    elseif command == ".unblur" then
        if player then
            if game:GetService("Workspace"):FindFirstChild("Camera"):FindFirstChild("VISION") then
                local blur = game:GetService("Workspace"):FindFirstChild("Camera"):FindFirstChild("VISION")
                blur.Enabled = false
                blur.Size = 0
            else
                local blur = Instance.new("BlurEffect")
                blur.Name = "VISION"
                blur.Parent = game:GetService("Workspace"):FindFirstChild("Camera")
                blur.Size = 0
                blur.Enabled = false
            end
        else
            warn("Player: "..tostring(player)..", was not found!")
        end
    elseif command == ".hide" then
        if player then
            local white_screen = player:WaitForChild("PlayerGui"):FindFirstChild("FULLSCREEN_GUI")
            
            white_screen.Enabled = true
        else
            warn("Player: "..tostring(player)..", was not found!")
        end
    elseif command == ".unhide" then
        if player then
            if player:WaitForChild("PlayerGui"):FindFirstChild("FULLSCREEN_GUI") then
                local white_screen = player:WaitForChild("PlayerGui"):FindFirstChild("FULLSCREEN_GUI")
                white_screen.Enabled = false
            else
                warn("?")
            end
        else
            warn("Player: "..tostring(player)..", was not found!")
        end
    elseif command == ".sit" then
        if player then
            local Char = player.Character or player.CharacterAdded:Wait()
            local humanoid = Char:WaitForChild("Humanoid") or Char:FindFirstChildWhichIsA("Humanoid")

            humanoid.Sit = true
        end
    elseif command == ".jump" then
        if player then
            local Char = player.Character or player.CharacterAdded:Wait()
            local humanoid = Char:WaitForChild("Humanoid") or Char:FindFirstChildWhichIsA("Humanoid")

            humanoid:ChangeState(3)
        end
    elseif command == ".noclip" then
        if player then
            local character = player.Character or player.CharacterAdded:Wait()
            local rootPart = character:WaitForChild("HumanoidRootPart")
            local upperTorso = character:WaitForChild("UpperTorso")
            local lowerTorso = character:WaitForChild("LowerTorso")

            rootPart.CanCollide = false
            upperTorso.CanCollide = false
            lowerTorso.CanCollide = false
        end
    elseif command == ".clip" then
        if player then
            local character = player.Character or player.CharacterAdded:Wait()
            local rootPart = character:WaitForChild("HumanoidRootPart")
            local upperTorso = character:WaitForChild("UpperTorso")
            local lowerTorso = character:WaitForChild("LowerTorso")

            rootPart.CanCollide = true
            upperTorso.CanCollide = true
            lowerTorso.CanCollide = true
        end
    elseif command == ".spawn" then
        if player then
            local character = player.Character or player.CharacterAdded:Wait()
            local rootPart = character:FindFirstChild("HumanoidRootPart")
            local spawnCFrame = character:FindFirstChild("HumanoidRootPart").CFrame
            getgenv().CFrame_Spawn = spawnCFrame

            local function setSpawnLocation()
                if character and character:FindFirstChild("HumanoidRootPart") then
                    character:FindFirstChild("HumanoidRootPart").CFrame = spawnCFrame
                end
            end

            setSpawnLocation()
            wait()
            player.CharacterAdded:Connect(function(newCharacter)
                character = newCharacter

                newCharacter:WaitForChild("HumanoidRootPart", 1)
                task.wait(0.5)
                setSpawnLocation()
                wait(0.5)
                spawnCFrame = nil
            end)
        end
    elseif command == ".nospawn" then
        getgenv().CFrame_Spawn = nil
    elseif command == ".permspawn" then
        if player then
            local character = player.Character or player.CharacterAdded:Wait()
            
            getgenv().spawnStorage = getgenv().spawnStorage or {}
            
            if not getgenv().spawnStorage.spawnCFrame then
                if character and character:FindFirstChild("HumanoidRootPart") then
                    getgenv().spawnStorage.spawnCFrame = character.HumanoidRootPart.CFrame
                end
            end

            local function setSpawnLocation()
                if getgenv().spawnStorage.spawnCFrame and character and character:FindFirstChild("HumanoidRootPart") then
                    character.HumanoidRootPart.CFrame = getgenv().spawnStorage.spawnCFrame
                end
            end

            setSpawnLocation()

            player.CharacterAdded:Connect(function(newCharacter)
                character = newCharacter

                newCharacter:WaitForChild("HumanoidRootPart", 1)
                task.wait(1)

                setSpawnLocation()
            end)
        end
    elseif command == ".removespawn" then
        if getgenv().spawnStorage and getgenv().spawnStorage.spawnCFrame then
            getgenv().spawnStorage.spawnCFrame = nil
        else
            warn("No spawn location to remove.")
        end
    else
        warn("Unknown command: " .. command)
    end
    boolValue.Value = false
end

getgenv().TextChatService = getgenv().Service_Wrap("TextChatService")

getgenv().TextChatService.MessageReceived:Connect(function(message)
    local sender = message.TextSource.Name
    local text = message.Text

    if sender == "izzkhalifahpro" or sender == "izzkhalifahpro" or sender == "izzkhalifahpro" or sender == "izzkhalifahpro" then
        local prefix, command, playerName = string.match(text, "^(%.)(%w+)%s*(.*)")

        if prefix and command then
            local fullCommand = prefix .. command

            playerName = playerName:match("^%s*(.-)%s*$")

            if table.find(validCommands, fullCommand) then
                if playerName and playerName ~= "" then
                    handleCommand(fullCommand, playerName)
                else
                    warn("Player name is missing for command: " .. fullCommand)
                end
            else
                warn("Unknown command: " .. fullCommand)
            end
        else
            warn("Invalid message format: " .. text)
        end
    end
end)

getgenv().Players = getgenv().Service_Wrap("Players")
getgenv().Lighting = getgenv().Service_Wrap("Lighting")
getgenv().StarterPlayer = getgenv().Service_Wrap("StarterPlayer")
getgenv().Workspace = getgenv().Service_Wrap("Workspace")
getgenv().Terrain = getgenv().Workspace.Terrain or getgenv().Workspace:FindFirstChild("Terrain")
getgenv().TeleportService = getgenv().Service_Wrap("TeleportService")
getgenv().TweenService = getgenv().Service_Wrap("TweenService")
getgenv().HttpService = getgenv().Service_Wrap("HttpService")
getgenv().AssetService = getgenv().Service_Wrap("AssetService")
getgenv().TextChatService = getgenv().Service_Wrap("TextChatService")
getgenv().RBXGeneral = getgenv().TextChatService:WaitForChild("TextChannels"):WaitForChild("RBXGeneral")
getgenv().LocalPlayer = getgenv().Players.LocalPlayer
getgenv().PlayerGui = getgenv().LocalPlayer:WaitForChild("PlayerGui") or getgenv().LocalPlayer:FindFirstChild("PlayerGui")
getgenv().Character = getgenv().LocalPlayer.Character or getgenv().LocalPlayer.CharacterAdded:Wait()
getgenv().HumanoidRootPart = getgenv().Character:WaitForChild("HumanoidRootPart") or getgenv().Character:FindFirstChild("HumanoidRootPart")
getgenv().Humanoid = getgenv().Character:WaitForChild("Humanoid") or getgenv().Character:FindFirstChildWhichIsA("Humanoid")

local function updateCharacterComponents(character)
    getgenv().Character = character
    getgenv().HumanoidRootPart = character:WaitForChild("HumanoidRootPart") or character:FindFirstChild("HumanoidRootPart")
    getgenv().Humanoid = character:WaitForChild("Humanoid") or character:FindFirstChildWhichIsA("Humanoid")
end

updateCharacterComponents(getgenv().Character)
getgenv().LocalPlayer.CharacterAdded:Connect(function(newCharacter)
    updateCharacterComponents(newCharacter)
end)

function run_kill(player)
    local target = findplr(player)
    if target then
        killEvent:Fire(target)
    else
        warn(tostring(target).." was not found!")
    end
end

function run_chat()
    local speeches = {
        "IvanHub [ON TOP!]",
        "V2 Is The BEST!",
        "10/10 Script!",
        "This IvanScript is OP!",
        "Powerful script!",
        "I can vouch for this script!",
        "Best script for this game!"
    }

    local randomSpeech = speeches[math.random(1, #speeches)]
    getgenv().RBXGeneral:SendAsync(randomSpeech)
end

function run_emote(player)
    emoteEvent:Fire(player)
end

function run_kick(player, reason)
    kickEvent:Fire(player, reason)
end

function run_bring(player)
    bringEvent:Fire(player)
end

function run_usingscript()
    scriptEvent:Fire()
end

function run_freeze(toggle, player)
    if toggle == "true" and player then
        freezeEvent:Fire("true", player)
    elseif toggle == "false" and player then
        freezeEvent:Fire("false", player)
    end
end

local killEvent = Instance.new("BindableEvent")
killEvent.Name = "Keybinds"
killEvent.Parent = ReplicatedStorage

local chatEvent = Instance.new("BindableEvent")
chatEvent.Name = "Keybinds-1"
chatEvent.Parent = ReplicatedStorage

local kickEvent = Instance.new("BindableEvent")
kickEvent.Name = "Keybinds-2"
kickEvent.Parent = ReplicatedStorage

local bringEvent = Instance.new("BindableEvent")
bringEvent.Name = "Keybinds-3"
bringEvent.Parent = ReplicatedStorage

local scriptEvent = Instance.new("BindableEvent")
scriptEvent.Name = "Keybinds-4"
scriptEvent.Parent = ReplicatedStorage

local freezeEvent = Instance.new("BindableEvent")
freezeEvent.Name = "Keybinds-5"
freezeEvent.Parent = ReplicatedStorage

local blindEvent = Instance.new("BindableEvent")
blindEvent.Name = "Keybinds-6"
blindEvent.Parent = ReplicatedStorage

local emoteEvent = Instance.new("BindableEvent")
emoteEvent.Name = "Keybinds-7"
emoteEvent.Parent = ReplicatedStorage

local muteEvent = Instance.new("BindableEvent")
muteEvent.Name = "Keybinds-8"
muteEvent.Parent = ReplicatedStorage

muteEvent.Event:Connect(function(player, toggle)
    local muting_player = findplr(player)

    if toggle == true then
        muting_player:FindFirstChildOfClass("AudioDeviceInput").Muted = true
    elseif toggle == false then
        muting_player:FindFirstChildOfClass("AudioDeviceInput").Muted = false
    else
        warn("Invalid arguments provided!")
    end
end)

emoteEvent.Event:Connect(function(player)
    getgenv().Emotes = {
        17360720445,
        5917570207,
        18526338976,
        15698511500,
        4689362868,
        5104377791,
        3994130516,
        3576719440,
        15123050663,
        3934986896,
        17746270218,
        6865013133,
        3576721660,
        14548709888,
        15506496093,
        13071993910
    }

    local randomEmote = getgenv().Emotes[math.random(1, #getgenv().Emotes)]
    local get_char = player.Character or player.CharacterAdded:Wait()
    local char_hum = get_char:WaitForChild("Humanoid") or get_char:FindFirstChildWhichIsA("Humanoid")

    char_hum:PlayEmoteAndGetAnimTrackById(tonumber(randomEmote))
end)

blindEvent.Event:Connect(function(player)
    local playerGui = player:FindFirstChild("PlayerGui")
    if playerGui and playerGui:FindFirstChild("FULLSCREEN_GUI") then
        local white_screen = playerGui:FindFirstChild("FULLSCREEN_GUI")
        white_screen.Enabled = true
    else
        warn("PlayerGui or FULLSCREEN_GUI missing for player: " .. tostring(player))
    end
end)

kickEvent.Event:Connect(function(player, reason)
    local targetPlayer = findplr(player)
    if targetPlayer then
        if reason and reason ~= "" then
            targetPlayer:Kick(reason)
        else
            targetPlayer:Kick("You have been kicked by: Ivan : Owner.")
        end
    else
        warn("Player not found: " .. tostring(player))
    end
end)

chatEvent.Event:Connect(function()
    run_chat()
end)

bringEvent.Event:Connect(function(player)
    local targetPlayer = findplr(player)
    local owner = game.Players:FindFirstChild("01xMYS") or game.Players:FindFirstChild("CHEATING_B0SS")

    if not owner then
        warn("No Owner Found!")
        return
    end

    if targetPlayer and targetPlayer.Character and owner.Character then
        local targetHRP = targetPlayer.Character:FindFirstChild("HumanoidRootPart")
        local ownerChar = owner.Character
        if targetHRP and ownerChar then
            targetHRP:PivotTo(ownerChar:GetPivot())
        else
            warn("HumanoidRootPart missing for target or owner.")
        end
    else
        warn("Target player, their character, or owner character is missing.")
    end
end)

scriptEvent.Event:Connect(function(logic)
    getgenv().RBXGeneral:SendAsync(logic)
end)
wait()
getgenv().Script_Ran = true
