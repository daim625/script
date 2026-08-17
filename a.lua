local shal = Vector3.new(215.67343139648438, 404.62530517578125, -106.6278305053711)
local lp = game.Players.LocalPlayer.Character
local food = workspace.Interactions.Food

-- Вариант 1: Плавно (как MoveTo)
--lp:MoveTo(shal)

local function GandTp(obj)
    lp:MoveTo(obj.WorldPivot.Position)
    wait(2)
    local args = {
	workspace:WaitForChild("Interactions"):WaitForChild("Food"):WaitForChild(obj.Name)
    }
    game:GetService("ReplicatedStorage"):WaitForChild("Remotes"):WaitForChild("FoodChunk"):InvokeServer(unpack(args))
    local save = lp.HumanoidRootPart.Position
    lp:MoveTo(shal)
    wait(0.5)
    local args = {
	"Shadow"
    }
    game:GetService("ReplicatedStorage"):WaitForChild("Remotes"):WaitForChild("WardenOffering"):InvokeServer(unpack(args))

end

local function YandTp(obj)
    lp:MoveTo(obj.WorldPivot.Position)
    wait(3)
    local args = {
	workspace:WaitForChild("Interactions"):WaitForChild("Food"):WaitForChild(obj.Name)
    }
    game:GetService("ReplicatedStorage"):WaitForChild("Remotes"):WaitForChild("FoodPickup"):InvokeServer(unpack(args))
    local save = lp.HumanoidRootPart.Position
    wait(1)
    lp:MoveTo(shal)
    wait(1.5)
    local args = {
	"Shadow"
    }
    game:GetService("ReplicatedStorage"):WaitForChild("Remotes"):WaitForChild("WardenOffering"):InvokeServer(unpack(args))


end

--YandTp(workspace.Interactions.Food:GetChildren()[10])
while true do
for _, object in food:GetChildren() do
    --print(object.Name)
    if (object.Name == "Carnivore Carcass" 
    or object.Name == "Herbivore Carcass"
    or object.Name == "Omnivore Carcass"
    or object.Name == "NPC Carcass"
    or object.Name == "Plant Carcass")
    and object:GetAttribute("Held") == nil then
        YandTp(object)

    elseif (object.Name == "Carcass" 
    or object.Name == "Sea Carcass")
    and object:GetAttribute("Held") == nil then

    for i = 1, 5 do
    --GandTp(object)
    end

    end
end

lp:MoveTo(Vector3.new(math.random(-2391, 2544), 300, math.random(-2797, 3000)))
wait(7)
end
