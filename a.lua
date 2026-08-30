-- ============================================
-- НАСТРОЙКИ (меняй здесь)
-- ============================================
local targetPlayerName = "Dima_nark"  -- Укажи имя целевого игрока
local flySpeed = 300                   -- Скорость полёта (чем больше, тем быстрее)
local riseHeight = 100                -- Высота подъёма перед полётом
local stopDistance = 5                -- Расстояние остановки над игроком
-- ============================================

local player = game.Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()
local humanoid = character:WaitForChild("Humanoid")
local rootPart = character:WaitForChild("HumanoidRootPart")

-- Отключаем гравитацию и стандартное управление
humanoid.PlatformStand = true

-- Создаём BodyVelocity
local bodyVelocity = Instance.new("BodyVelocity")
bodyVelocity.MaxForce = Vector3.new(4000, 4000, 4000)
bodyVelocity.P = 1000
bodyVelocity.Parent = rootPart

-- Функция для получения позиции целевого игрока
local function getTargetPosition()
	local target = game.Players:FindFirstChild(targetPlayerName)
	if target and target.Character then
		local targetRoot = target.Character:FindFirstChild("HumanoidRootPart")
		if targetRoot then
			return targetRoot.Position
		end
	end
	return nil
end

-- Фаза 1: Подъём вверх
local startPos = rootPart.Position
local targetPos = startPos + Vector3.new(0, riseHeight, 0)

print("🚀 Поднимаемся на высоту...")
while (rootPart.Position - targetPos).Magnitude > 2 do
	local direction = (targetPos - rootPart.Position).Unit
	bodyVelocity.Velocity = direction * flySpeed * 1.5
	task.wait()
end

-- Фаза 2: Полёт к игроку
print("✈️ Летим к игроку " .. targetPlayerName .. "...")
while true do
	local targetPosNow = getTargetPosition()
	if not targetPosNow then
		print("⚠️ Игрок не найден или его персонаж отсутствует!")
		task.wait(0.5)
		continue
	end
	
	-- Летим над игроком (смещение по Y)
	local flyTarget = targetPosNow + Vector3.new(0, stopDistance, 0)
	local distance = (rootPart.Position - flyTarget).Magnitude
	
	if distance < 3 then
		-- Достигли цели
		break
	end
	
	local direction = (flyTarget - rootPart.Position).Unit
	bodyVelocity.Velocity = direction * flySpeed
	
	task.wait()
end

-- Фаза 3: Опускание на высоту игрока
print("🪂 Опускаемся на высоту игрока...")
while true do
	local targetPosNow = getTargetPosition()
	if not targetPosNow then
		print("⚠️ Игрок пропал!")
		task.wait(0.5)
		continue
	end
	
	local distance = (rootPart.Position - targetPosNow).Magnitude
	
	if distance < 2 then
		break
	end
	
	local direction = (targetPosNow - rootPart.Position).Unit
	local speed = flySpeed * 0.5  -- Медленнее опускаемся
	bodyVelocity.Velocity = direction * speed
	
	task.wait()
end

-- Финиш: останавливаемся и включаем гравитацию
bodyVelocity.Velocity = Vector3.new(0, 0, 0)
humanoid.PlatformStand = false
bodyVelocity:Destroy()

print("✅ Приземлились на игрока " .. targetPlayerName .. "!")
