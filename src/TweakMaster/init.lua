--[[
	Made by Monnapse

	EXAMPLE

	local ReplicatedStorage = game:GetService("ReplicatedStorage")
	local TweakMaster = require(ReplicatedStorage.TweakMaster)
	
	local TM = TweakMaster.new()
	local BooleanChanged = TM:AddProperty("Test 123", TweakMaster.Types.Boolean, true)
	local NumberChanged = TM:AddProperty("Number Test 123", TweakMaster.Types.Number, 0)
	
	BooleanChanged:Connect(function(Value: boolean)
	    print(Value)
	end)
	
	NumberChanged:Connect(function(Value: number)
	    print(Value)
	end)
--]]

--// Services
local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")

local Mouse = Players.LocalPlayer:GetMouse()

--// Folders
local UI = script:FindFirstChild("UI")
local PropertiesUI = UI:FindFirstChild("Properties")

--// Packages
local Types = require(script.Types)
local Signal = require(script.Signal)

local TM = {}
TM.__index = TM

TM.Version = "0.0.2"

TM.Types = {}
TM.Types.Boolean = {type = "Boolean", uiType = "Boolean"}
TM.Types.Float = {type = "Float", uiType = "Number"}
TM.Types.Integer = {type = "Integer", uiType = "Number"}
TM.Types.Vector3 = {type = "Vector3", uiType = "Vector3"}

--[[
	Private Functions
--]]
local function GetPropertyUI(Name: string): Frame
	return PropertiesUI:FindFirstChild(Name):Clone()
end
local function GetPropertyValueInstance(Property: Frame, Type: Types.TYPE): Frame
	if Type.uiType == "Boolean" then
		return Property.Right.CheckBox
	elseif Type.uiType == "Number" then
		return Property.Right.ValueButton
	else
		print("Error: Could not find the value for", Type.type)
		return
	end
end
local function SetProperty(Activator: Frame, Type: Types.TYPE, Value: boolean | string | Vector3 | Vector2)
	if Type.uiType == "Boolean" then
		Activator.CheckMark.Visible = Value

		if Value then
			Activator.BackgroundTransparency = 0
			Activator.UIStroke.Transparency = 0
		else
			Activator.BackgroundTransparency = 1
			Activator.UIStroke.Transparency = 0.5
		end
	elseif Type.uiType == "Number" then
		Activator.Value.Text = Value
	end
end
local function ActivateProperty(self, Name, Property: Frame, Type: Types.TYPE, ConnectedSignal: Signal.signal, MainFrame: Frame)
	local activator: GuiButton = GetPropertyValueInstance(Property, Type)
	local adder = 0.1
	if Type.type == "Integer" then
		adder = 1
	end
	
	if Type.type == "Boolean" then
		local Enabled = activator.CheckMark.Visible

		activator.MouseButton1Click:Connect(function()
			Enabled = not Enabled
			SetProperty(activator,Type, Enabled)
			self.ConnectedProperties[Name].value = Enabled
			ConnectedSignal:Fire(Enabled)
		end)
	elseif Type.type == "Float" or Type.type == "Integer" then
		local Connected = false

		local textbox: TextBox = activator.Value

		activator.MouseEnter:Connect(function()
			--UserInputService.MouseIconEnabled = false
			--MainFrame.Cursor.Visible = true
		end)
		activator.MouseLeave:Connect(function()
			--if not Connected then
			--	UserInputService.MouseIconEnabled = true
			--	MainFrame.Cursor.Visible = false
			--end
		end)
		activator.MouseButton1Down:Connect(function()
			Connected = true
		end)

		activator.MouseButton1Click:Connect(function()
			textbox:CaptureFocus()
		end)

		if Type.type == "Float" then
			textbox:GetPropertyChangedSignal("Text"):Connect(function()
				textbox.Text = textbox.Text:gsub("[^0-9.-]", "")
				self.ConnectedProperties[Name].value = tonumber(textbox.Text)
				ConnectedSignal:Fire(tonumber(textbox.Text))
			end)
		elseif Type.type == "Integer" then
			textbox:GetPropertyChangedSignal("Text"):Connect(function()
				textbox.Text = textbox.Text:gsub("[^0-9-]", "")
				self.ConnectedProperties[Name].value = tonumber(textbox.Text)
				ConnectedSignal:Fire(tonumber(textbox.Text))
			end)
		end
		

		local previousPosition = Mouse.X

		local Connection = UserInputService.InputChanged:Connect(function(inputObject)
			local MouseDown = UserInputService:IsMouseButtonPressed(Enum.UserInputType.MouseButton1)

			if not MouseDown then
				Connected = false
				--UserInputService.MouseIconEnabled = true
				--MainFrame.Cursor.Visible = false
			end

			if inputObject.UserInputType == Enum.UserInputType.MouseMovement then
				--MainFrame.Cursor.Position = UDim2.new(0,Mouse.X,0,Mouse.Y)

				if MouseDown and not textbox:IsFocused() and Connected then
					--UserInputService.MouseIconEnabled = false
					local normal = 1

					if Mouse.X - previousPosition < 0 then
						normal = -1
					end

					previousPosition = Mouse.X
					local value = tonumber(textbox.Text)+(adder*normal)
					value *= 100
					value = math.floor(value)
					value = value / 100

					textbox.Text = value
				else
					--UserInputService.MouseIconEnabled = true
					--MainFrame.Cursor.Visible = true
				end
			end
		end)
	end
end
local function GetTableSize(table: {})
	local indexes = 0 
	for i,v in pairs(table) do indexes +=1 end 
	return indexes
end

--[[
	Void
	Returns nothing
--]]
function TM:AddProperty(Name: string, Type: Types.TYPE, StartValue: boolean | string | Vector3 | Vector2): Signal.signal
	local Connection = Signal.new()
	local object: Frame = GetPropertyUI(Type.uiType)
	object.Parent = self.UI.MainFrame.ScrollingFrame
	object.Left:FindFirstChild("Name").Text = Name
	
	if StartValue ~= nil then
		SetProperty(GetPropertyValueInstance(object, Type), Type, StartValue)
	end

	ActivateProperty(self, Name, object, Type, Connection, self.UI.MainFrame)
	
	self.ConnectedProperties[Name] = {
		type = Type,
		object = object,
		name = Name,
		signal = Connection,
		value = StartValue
	}
	
	self.UI.MainFrame.TopBar.Right.Connections.Text = "Connected to "..GetTableSize(self.ConnectedProperties).." properties"

	return Connection
end

--[[
	Creates a new MASTER UI

	F4 to toggle menu
	F2 to reset position
--]]
function TM.new(): Types.Master
	local self = setmetatable({},TM)
	
	self.UI = UI.TweakMaster:Clone()
	self.ConnectedProperties = {}
	self.KeyCode = Enum.KeyCode.F4
	self.ResetKeyCode = Enum.KeyCode.F2

	self.UI.Parent = Players.LocalPlayer.PlayerGui
	self.UI.MainFrame.Draggable = true
	self.UI.MainFrame.TopBar.Right.Connections.Text = "Connected to 0 properties"
	self.UI.MainFrame.TopBar.Left.Version.Text = TM.Version
	
	UserInputService.InputBegan:Connect(function(input, gameProcessedEvent)
		if input.KeyCode == self.KeyCode then
			self.UI.Enabled = not self.UI.Enabled
		elseif input.KeyCode == self.ResetKeyCode then
			self.UI.MainFrame.Position = UDim2.new(0.5,0,0.5,0)
		end
	end)
	
	self.UI.MainFrame.TopBar.Right.LogData.MouseButton1Click:Connect(function()
		for i,v in pairs(self.ConnectedProperties) do
			print(i,":", v.value)
		end
	end)

	return self
end

return TM