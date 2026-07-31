-- Локальный скрипт (LocalScript)
-- Использует BodyVelocity для управления

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")

local player = Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()
local rootPart = character:WaitForChild("HumanoidRootPart")

-- НИК ЦЕЛИ (измените на нужный)
local TARGET_NAME = "Dima_nark" -- <-- СЮДА ВСТАВЬТЕ НИК

local targetPlayer = nil
local phase = 0 -- 0: взлет, 1: полет к цели, 2: посадка
local targetPos = nil
local speed = 300

-- Создаем BodyVelocity
local bodyVelocity = Instance.new("BodyVelocity")
bodyVelocity.MaxForce = Vector3.new(1e6, 1e6, 1e6)
bodyVelocity.Velocity = Vector3.new(0, 0, 0)
bodyVelocity.Parent = rootPart

-- Поиск игрока
for _, plr in ipairs(Players:GetPlayers()) do
	if plr.Name == TARGET_NAME or plr.DisplayName == TARGET_NAME then
		targetPlayer = plr
		break
	end
end

if not targetPlayer then
	warn("Игрок не найден!")
	bodyVelocity:Destroy()
	return
end

-- Ждем появления персонажа цели
repeat wait() until targetPlayer.Character and targetPlayer.Character:FindFirstChild("HumanoidRootPart")

local targetRoot = targetPlayer.Character.HumanoidRootPart
targetPos = targetRoot.Position

-- Основной цикл
RunService.Heartbeat:Connect(function()
	if not targetPlayer.Character then return end
	
	local currentPos = rootPart.Position
	local targetRootPos = targetPlayer.Character.HumanoidRootPart.Position
	
	if phase == 0 then
		-- ВЗЛЕТАЕМ ВВЕРХ
		bodyVelocity.Velocity = Vector3.new(0, 1000, 0)
		
		if currentPos.Y >= targetRootPos.Y + 40 then
			phase = 1
			print("Взлетели, летим к цели")
		end
		
	elseif phase == 1 then
		-- ЛЕТИМ ПО XZ НАД ЦЕЛЬЮ
		local targetXZ = Vector3.new(targetRootPos.X, currentPos.Y, targetRootPos.Z)
		local dir = (targetXZ - currentPos).Unit
		local dist = Vector3.new(currentPos.X - targetRootPos.X, 0, currentPos.Z - targetRootPos.Z).Magnitude
		
		if dist > 2 then
			bodyVelocity.Velocity = dir * speed
		else
			phase = 2
			print("Над целью, начинаем спуск")
		end
		
	elseif phase == 2 then
		-- ОПУСКАЕМСЯ
		local targetY = targetRootPos.Y + 2
		local target = Vector3.new(targetRootPos.X, targetY, targetRootPos.Z)
		local dir = (target - currentPos).Unit
		local dist = (target - currentPos).Magnitude
		
		if dist > 1 then
			bodyVelocity.Velocity = dir * math.min(speed, dist * 3)
		else
			-- ПРИЗЕМЛИЛИСЬ
			bodyVelocity.Velocity = Vector3.new(0, 0, 0)
			rootPart.Position = target
			bodyVelocity:Destroy()
			print("Приземлились у " .. targetPlayer.Name)
			script:Destroy()
		end
	end
end)
