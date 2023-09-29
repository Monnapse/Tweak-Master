local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
--[[
	Made by Monnapse
--]]

--// Folders
local UI = script:FindFirstChild("UI")
local PropertiesUI = UI:FindFirstChild("Properties")

--// Packages
local Types = require(script.Types)
local Signal = require(script.Signal)

local TM = {}

TM.Version = "0.0.1"

TM.Types = {}
TM.Types.Boolean = {type = "Boolean"}
TM.Types.Number = {type = "Number"}
TM.Types.Vector3 = {type = "Vector3"}

--[[
	Private Functions
--]]
local function GetPropertyUI(Name: string): Frame
	return PropertiesUI:FindFirstChild(Name):Clone()
end
local function GetPropertyValueInstance(Property: Frame, Type: Types.TYPE): Frame
	if Type.type == "Boolean" then
		return Property.Right.CheckBox
	elseif Type.type == "Number" then
		return Property.Right.ValueButton
	else
		print("Error: Could not find the value for", Type.type)
		return
	end
end
local function SetProperty(Activator: Frame, Type: Types.TYPE, Value: boolean | string | Vector3 | Vector2)
	if Type.type == "Boolean" then
		Activator.CheckMark.Visible = Value

		if Value then
			Activator.BackgroundTransparency = 0
			Activator.UIStroke.Transparency = 0
		else
			Activator.BackgroundTransparency = 1
			Activator.UIStroke.Transparency = 0.5
		end
	elseif Type.type == "Number" then
		Activator.Value.Text = Value
	end
end
local function ActivateProperty(Property: Frame, Type: Types.TYPE, ConnectedSignal: Signal.signal)
	local activator = GetPropertyValueInstance(Property, Type)
	
	if Type.type == "Boolean" then
		local Enabled = activator.CheckMark.Visible

		activator.MouseButton1Click:Connect(function()
			Enabled = not Enabled
			SetProperty(activator,Type, Enabled)
			ConnectedSignal:Fire(Enabled)
		end)
	end
end

--[[
	Void
	Returns nothing
--]]
function TM:AddProperty(Name: string, Type: Types.TYPE, StartValue: boolean | string | Vector3 | Vector2): Signal.signal
	local Connection = Signal.new()
	local object: Frame = GetPropertyUI(Type.type)
	object.Parent = self.UI.MainFrame.ScrollingFrame
	object.Left.Name = Name
	
	if StartValue ~= nil then
		SetProperty(GetPropertyValueInstance(object, Type), Type, StartValue)
	end

	ActivateProperty(object, Type, Connection)
	
	table.insert(self.ConnectedProperties, {
		type = Type,
		object = object,
		name = Name,
		signal = Connection,
	})

	self.UI.MainFrame.TopBar.Right.Connections.Text = "Connected to "..#self.ConnectedProperties.." properties"

	return Connection
end

--[[
	Creates a new MASTER UI

	F4 to toggle menu
	F2 to reset position
--]]
function TM.new(): Types.Master
	local self = TM
	
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
	
	return self
end

return TM