local Players = game:GetService("Players")
--[[
	Made by Monnapse
--]]

--// Folders
local UI = script:FindFirstChild("UI")
local PropertiesUI = UI:FindFirstChild("Properties")

--// Packages
local Types = require(script.Types)

local TM = {}

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
local function SetProperty(Property: Frame, Type: Types.TYPE, Value: boolean | string | Vector3 | Vector2)
	local activator = GetPropertyValueInstance(Property, Type)

	if Type.type == "Boolean" then
		activator.CheckMark.Visible = Value

		if Value then
			activator.BackgroundTransparency = 0
			activator.UIStroke.Transparency = 0
		else
			activator.BackgroundTransparency = 1
			activator.UIStroke.Transparency = 0.5
		end
	elseif Type.type == "Number" then
		activator.Value.Text = Value
	end
end

--[[
	Void
	Returns nothing
--]]
function TM:AddProperty(Name: string, Type: Types.TYPE, StartValue: boolean | string | Vector3 | Vector2): nil
	local object: Frame = GetPropertyUI(Type.type)
	object.Parent = self.UI.MainFrame.ScrollingFrame
	object.Left.Name = Name
	
	if StartValue ~= nil then
		SetProperty(object, Type, StartValue)
	end
	
	table.insert(self.ConnectedProperties, {
		type = Type,
		object = object,
		name = Name
	})
end

--[[
	Creates a new MASTER UI
--]]
function TM.new(): Types.Master
	local self = TM
	
	self.UI = UI.TweakMaster:Clone()
	self.ConnectedProperties = {}

	self.UI.Parent = Players.LocalPlayer.PlayerGui

	return self
end

return TM