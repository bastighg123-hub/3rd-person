
local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")

local player = Players.LocalPlayer

local gui = Instance.new("ScreenGui")
gui.Name = "CameraUI"
gui.ResetOnSpawn = false
gui.IgnoreGuiInset = true
gui.Parent = player:WaitForChild("PlayerGui")

local button = Instance.new("TextButton")
button.Name = "CameraButton"
button.Size = UDim2.fromOffset(170, 60)
button.Position = UDim2.new(1, -190, 0.75, 0)

button.BackgroundColor3 = Color3.fromRGB(30, 30, 35)
button.BackgroundTransparency = 0.1
button.Text = "FIRST PERSON"
button.TextColor3 = Color3.fromRGB(255, 255, 255)
button.TextSize = 17
button.Font = Enum.Font.GothamBold
button.AutoButtonColor = true
button.Active = true
button.Parent = gui

local corner = Instance.new("UICorner")
corner.CornerRadius = UDim.new(0, 16)
corner.Parent = button

local stroke = Instance.new("UIStroke")
stroke.Thickness = 2
stroke.Transparency = 0.2
stroke.Parent = button

local firstPerson = true

-- CAMERA

local function updateCamera()
	local character = player.Character
	if not character then return end

	local humanoid = character:FindFirstChildOfClass("Humanoid")
	if not humanoid then return end

	local camera = workspace.CurrentCamera

	camera.CameraType = Enum.CameraType.Custom
	camera.CameraSubject = humanoid

	if firstPerson then
		player.CameraMode = Enum.CameraMode.LockFirstPerson
		button.Text = "FIRST PERSON"
	else
		player.CameraMode = Enum.CameraMode.Classic
		button.Text = "THIRD PERSON"
	end
end

-- TOUCH DRAG

local dragging = false
local dragStart
local startPosition
local dragInput
local moved = false

button.InputBegan:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.Touch
		or input.UserInputType == Enum.UserInputType.MouseButton1 then

		dragging = true
		moved = false
		dragStart = input.Position
		startPosition = button.Position

		if input.UserInputType == Enum.UserInputType.Touch then
			dragInput = input
		end
	end
end)

button.InputChanged:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.Touch
		or input.UserInputType == Enum.UserInputType.MouseMovement then

		dragInput = input
	end
end)

UserInputService.InputChanged:Connect(function(input)
	if not dragging then return end

	if input == dragInput
		or input.UserInputType == Enum.UserInputType.MouseMovement then

		local delta = input.Position - dragStart

		if math.abs(delta.X) > 8 or math.abs(delta.Y) > 8 then
			moved = true
		end

		button.Position = UDim2.new(
			startPosition.X.Scale,
			startPosition.X.Offset + delta.X,
			startPosition.Y.Scale,
			startPosition.Y.Offset + delta.Y
		)
	end
end)

UserInputService.InputEnded:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.Touch
		or input.UserInputType == Enum.UserInputType.MouseButton1 then

		dragging = false
	end
end)

-- BUTTON

button.Activated:Connect(function()
	if moved then return end

	firstPerson = not firstPerson
	updateCamera()
end)

player.CharacterAdded:Connect(function()
	task.wait(0.5)
	updateCamera()
end)

updateCamera()
