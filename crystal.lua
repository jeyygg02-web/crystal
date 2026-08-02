-- ============================================================
-- AUTO COLLECT SHATTERSTAR CRYSTAL — RADIUS 99999
-- GitHub Version — Delta Executor
-- ============================================================

local Player = game:GetService("Players").LocalPlayer
local Workspace = game:GetService("Workspace")
local VirtualUser = game:GetService("VirtualUser")
local StarterGui = game:GetService("StarterGui")

-- ===== KONFIGURASI =====
local CRYSTAL_NAME = "Shatterstar Crystal"
local RADIUS = 99999
local WALK_SPEED = 100

-- ===== TUNGGU KARAKTER =====
local Character = Player.Character or Player.CharacterAdded:Wait()
local Humanoid = Character:WaitForChild("Humanoid")
local RootPart = Character:WaitForChild("HumanoidRootPart")
Humanoid.WalkSpeed = WALK_SPEED

-- ===== NOTIFIKASI =====
local function Notify(text)
    pcall(function()
        StarterGui:SetCore("SendNotification", {
            Title = "💎 Crystal Bot",
            Text = text,
            Duration = 2
        })
    end)
end

Notify("🚀 BOT STARTED! Radius: 99999")

-- ===== BOT LOGIC =====
local collected = 0
local isCollecting = false
local isRunning = true

local function FindNearestCrystal()
    local nearest = nil
    local nearestDist = RADIUS
    for _, obj in pairs(Workspace:GetDescendants()) do
        if obj:IsA("Part") and obj.Name == CRYSTAL_NAME then
            local dist = (obj.Position - RootPart.Position).Magnitude
            if dist < nearestDist then
                nearest = obj
                nearestDist = dist
            end
        end
    end
    return nearest
end

local function CollectCrystal(crystal)
    if not crystal or isCollecting then return end
    isCollecting = true
    local pos = crystal.Position
    local dist = (pos - RootPart.Position).Magnitude
    if dist > 5 then
        Humanoid:MoveTo(pos)
        Humanoid.WalkSpeed = WALK_SPEED
        isCollecting = false
        return
    end
    local cd = crystal:FindFirstChild("ClickDetector")
    if cd then cd:FireServer() else VirtualUser:ClickButton1(Vector2.new(0, 0)) end
    collected = collected + 1
    Notify("✅ " .. collected)
    print("[+] Collected: " .. collected)
    isCollecting = false
end

print("[+] Bot Started! Radius: 99999")

while isRunning do
    pcall(function()
        VirtualUser:CaptureController()
        VirtualUser:ClickButton2(Vector2.new())
    end)
    local crystal = FindNearestCrystal()
    if crystal then CollectCrystal(crystal) end
    wait(0.3)
end
