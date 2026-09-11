local UEHelpers = require("UEHelpers")

local savedPos = nil
local savedRot = nil
local savedVelocity = nil

-- NoClip & Flight Variables
local noclip = false
local moveStep = 240.0
local minStep = 20.0
local flightPitch = 0.0
local flightYaw = 0.0

local isUnlit = false
local showFloors = false

-- Sync current rotation when activating NoClip
local function SyncFlightRotation()
    local pawn = UEHelpers.GetPlayerController():K2_GetPawn()
    if pawn and pawn.SM_KartTracker and pawn.SM_KartTracker:IsValid() then
        flightPitch = 0.0
        flightYaw = pawn.SM_KartTracker.RelativeRotation.Yaw
    end
end

-- Logic for calculating flight direction
local function GetDirectionVectors()
    local yawRad = math.rad(flightYaw - 90)
    local pitchRad = math.rad(flightPitch)

    local forward = {
        X = math.cos(pitchRad) * math.cos(yawRad),
        Y = math.cos(pitchRad) * math.sin(yawRad),
        Z = math.sin(-pitchRad)
    }

    local right = {
        X = math.cos(yawRad + math.rad(90)),
        Y = math.sin(yawRad + math.rad(90)),
        Z = 0
    }
    return forward, right
end

-- Move function (WASDQE)
local function MoveOnce(direction)
    if not noclip then return end
    local pawn = UEHelpers.GetPlayerController():K2_GetPawn()
    if not (pawn and pawn:IsValid()) then return end

    local forward, right = GetDirectionVectors()
    local dx, dy, dz = 0, 0, 0

    if direction == "W" then dx, dy, dz = forward.X * moveStep, forward.Y * moveStep, forward.Z * moveStep
    elseif direction == "S" then dx, dy, dz = -forward.X * moveStep, -forward.Y * moveStep, -forward.Z * moveStep
    elseif direction == "D" then dx, dy = right.X * moveStep, right.Y * moveStep
    elseif direction == "A" then dx, dy = -right.X * moveStep, -right.Y * moveStep
    elseif direction == "Up" then dz = moveStep
    elseif direction == "Down" then dz = -moveStep
    end

    local loc = pawn:K2_GetActorLocation()
    pawn:K2_SetActorLocation({ X = loc.X + dx, Y = loc.Y + dy, Z = loc.Z + dz }, false, {}, true)
end


-- 4/6: Update Kart Rotation (Visual)
local function UpdateKartRotation(yawOffset)
    local pawn = UEHelpers.GetPlayerController():K2_GetPawn()
    if pawn and pawn.SM_KartTracker and pawn.SM_KartTracker:IsValid() then
        local rot = pawn.SM_KartTracker.RelativeRotation
        rot.Yaw = rot.Yaw + yawOffset
        pawn.SM_KartTracker.RelativeRotation = rot
        flightYaw = rot.Yaw -- Sync internal yaw
    end
end

-- 8/5: Update Flight Pitch (Movement direction only, no visual change)
local function UpdateFlightPitch(pitchOffset)
    flightPitch = flightPitch + pitchOffset
    print("Flight Pitch set to: " .. flightPitch)
end

local function GetCurrentLocalPlayerController()
    local GameInstance = UEHelpers.GetGameInstance()
    if GameInstance and GameInstance:IsValid() then
        local LocalPlayers = GameInstance.LocalPlayers
        if LocalPlayers and LocalPlayers[1] and LocalPlayers[1]:IsValid() then
            local livePC = LocalPlayers[1].PlayerController
            if livePC and livePC:IsValid() then
                return livePC
            end
        end
    end
    return nil
end

local function GetCurrentLocalPlayerController()
    local GameInstance = UEHelpers.GetGameInstance()
    if GameInstance and GameInstance:IsValid() then
        local LocalPlayers = GameInstance.LocalPlayers
        if LocalPlayers and LocalPlayers[1] and LocalPlayers[1]:IsValid() then
            local livePC = LocalPlayers[1].PlayerController
            if livePC and livePC:IsValid() then
                return livePC
            end
        end
    end
    return nil
end

-- INSERT: ToggleDebugCamera
RegisterKeyBind(Key.INS, function()
    ExecuteInGameThread(function()
        local KismetSystemLibrary = StaticFindObject("/Script/Engine.Default__KismetSystemLibrary")
        local livePC = GetCurrentLocalPlayerController()

        if livePC then
            print("Toggling on: " .. livePC:GetClass():GetFullName())
        end

        if KismetSystemLibrary and KismetSystemLibrary:IsValid() and livePC then
            KismetSystemLibrary:ExecuteConsoleCommand(livePC, "ToggleDebugCamera", livePC)
            print("Debug Camera Toggled")
        else
            print("Could not resolve current local player controller")
        end
    end)
end)

-- DELETE: Toggle Lit / Unlit
RegisterKeyBind(Key.DEL, function()
    ExecuteInGameThread(function()
        local KismetSystemLibrary = StaticFindObject("/Script/Engine.Default__KismetSystemLibrary")
        local livePC = GetCurrentLocalPlayerController()

        if not (KismetSystemLibrary and KismetSystemLibrary:IsValid() and livePC) then
            print("Could not resolve current local player controller")
            return
        end

        if not isUnlit then
            -- Lit -> Unlit, bypass restriction via prevviewmode
            KismetSystemLibrary:ExecuteConsoleCommand(livePC, "prevviewmode", livePC)
            isUnlit = true
            print("View mode: Unlit")
        else
            -- Unlit -> Lit, "viewmode Lit" is allowed directly
            KismetSystemLibrary:ExecuteConsoleCommand(livePC, "viewmode Lit", livePC)
            isUnlit = false
            print("View mode: Lit")
        end
    end)
end)

-- F12: Teleport (console command)
RegisterKeyBind(Key.F12, function()
    ExecuteInGameThread(function()
        local function GetCurrentLocalPlayerController()
            local GameInstance = UEHelpers.GetGameInstance()
            if GameInstance and GameInstance:IsValid() then
                local LocalPlayers = GameInstance.LocalPlayers
                if LocalPlayers and LocalPlayers[1] and LocalPlayers[1]:IsValid() then
                    local livePC = LocalPlayers[1].PlayerController
                    if livePC and livePC:IsValid() then
                        return livePC
                    end
                end
            end
            return nil
        end

        local KismetSystemLibrary = StaticFindObject("/Script/Engine.Default__KismetSystemLibrary")
        local livePC = GetCurrentLocalPlayerController()

        if KismetSystemLibrary and KismetSystemLibrary:IsValid() and livePC then
            KismetSystemLibrary:ExecuteConsoleCommand(livePC, "Teleport", livePC)
            print("Teleport Executed")
        else
            print("Could not resolve current local player controller")
        end
    end)
end)

-- F2: Save State
RegisterKeyBind(Key.F2, function ()
    local pawn = UEHelpers.GetPlayerController():K2_GetPawn()
    if pawn and pawn:IsValid() and pawn.SM_KartTracker and pawn.SM_KartTracker:IsValid() then
        local loc = pawn:K2_GetActorLocation()
        local rot = pawn.SM_KartTracker.RelativeRotation
        local vel = pawn:GetVelocity()
        savedPos = { X = loc.X, Y = loc.Y, Z = loc.Z }
        savedRot = { Pitch = rot.Pitch, Yaw = rot.Yaw, Roll = rot.Roll }
        savedVelocity = { X = vel.X, Y = vel.Y, Z = vel.Z }
        print(string.format("State Saved: Pos(%.0f, %.0f, %.0f)", savedPos.X, savedPos.Y, savedPos.Z))
    end
end)

-- F3: Restore State
RegisterKeyBind(Key.F3, function ()
    if not savedPos or not savedRot or not savedVelocity then return end
    local pawn = UEHelpers.GetPlayerController():K2_GetPawn()
    if pawn and pawn:IsValid() then
        pawn:K2_TeleportTo(savedPos, { Pitch = savedRot.Pitch, Yaw = savedRot.Yaw, Roll = savedRot.Roll })
        if pawn.SM_KartTracker and pawn.SM_KartTracker:IsValid() then
            pawn.SM_KartTracker.RelativeRotation = savedRot
        end
        if pawn.Sphere and pawn.Sphere:IsValid() then
            pawn.Sphere:SetPhysicsLinearVelocity(savedVelocity, false, FName("None"))
        end
        print("State Restored.")
    end
end)

-- F8: Reveal Components
RegisterKeyBind(Key.F8, function()
    ExecuteInGameThread(function()
        local components = FindAllOf("SceneComponent")
        for _, component in pairs(components) do
            local owner = component:GetOwner()
            if owner and owner:IsValid() then
                local name = owner:GetFullName()
                if not name:match("ReflectionCapture") and not name:match("WireCharacter") and not name:match("Audio") then
                    owner:SetActorHiddenInGame(false)
                    component:SetHiddenInGame(false, true)
                end
            end
        end
    end)
end)

-- F9: Hide Floor
RegisterKeyBind(Key.F9, function()
    ExecuteInGameThread(function()
        showFloors = not showFloors
        local meshes = FindAllOf("StaticMeshComponent")
        
        for _, mesh in pairs(meshes) do
            local owner = mesh:GetOwner()
            if owner and owner:IsValid() then
                mesh:SetHiddenInGame(not showFloors, true)
            end
        end
        print("Floor Visibility: " .. (showFloors and "ON" or "OFF"))
    end)
end)

-- Movement Bindings
RegisterKeyBind(Key.W, function() MoveOnce("W") end)
RegisterKeyBind(Key.S, function() MoveOnce("S") end)
RegisterKeyBind(Key.A, function() MoveOnce("A") end)
RegisterKeyBind(Key.D, function() MoveOnce("D") end)
RegisterKeyBind(Key.E, function() MoveOnce("Up") end)
RegisterKeyBind(Key.Q, function() MoveOnce("Down") end)

RegisterKeyBind(Key.NUM_FOUR,  function() UpdateKartRotation(-10) end)
RegisterKeyBind(Key.NUM_SIX,   function() UpdateKartRotation(10) end)
RegisterKeyBind(Key.NUM_FIVE,  function() UpdateFlightPitch(10) end)
RegisterKeyBind(Key.NUM_EIGHT, function() UpdateFlightPitch(-10) end)

-- Step Adjustment
RegisterKeyBind(Key.F4, function() moveStep = math.max(minStep, moveStep - 20.0); print("Step Decreased: " .. moveStep) end)
RegisterKeyBind(Key.F5, function() moveStep = moveStep + 20.0; print("Step Increased: " .. moveStep) end)

-- F1: Toggle NoClip
RegisterKeyBind(Key.F1, function()
    local pawn = UEHelpers.GetPlayerController():K2_GetPawn()
    if pawn and pawn:IsValid() then
        noclip = not noclip
        if noclip then SyncFlightRotation() end
        if pawn.Sphere and pawn.Sphere:IsValid() then
            pawn.Sphere:SetSimulatePhysics(not noclip)
        end
        print("NoClip: " .. (noclip and "ON" or "OFF"))
    end
end)
