local ReplicatedStorage = game:GetService("ReplicatedStorage")
local TweakMaster = require(ReplicatedStorage.TweakMaster)

local TM = TweakMaster.new()
local BooleanChanged = TM:AddProperty("Test 123", TweakMaster.Types.Boolean, true)
local NumberChanged = TM:AddProperty("Number Test 123", TweakMaster.Types.Number, 0)

BooleanChanged:Connect(function(Value: boolean)
    print(Value)
end)

NumberChanged:Connect(function(Value: boolean)
    print(Value)
end)