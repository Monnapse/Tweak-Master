local ReplicatedStorage = game:GetService("ReplicatedStorage")
local TweakMaster = require(ReplicatedStorage.TweakMaster)

local TM = TweakMaster.new()
local BooleanChanged = TM:AddProperty("Boolean Test", TweakMaster.Types.Boolean, true)
local FloatChanged = TM:AddProperty("Float Test", TweakMaster.Types.Float, 1.5)
local IntegerChanged = TM:AddProperty("Integer Test", TweakMaster.Types.Integer, 0)

BooleanChanged:Connect(function(Value: boolean)
    print(Value)
end)

FloatChanged:Connect(function(Value: number)
    print(Value)
end)