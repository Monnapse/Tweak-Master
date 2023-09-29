local ReplicatedStorage = game:GetService("ReplicatedStorage")
local TweakMaster = require(ReplicatedStorage.TweakMaster)

local TM = TweakMaster.new()
TM:AddProperty("Test 123", TweakMaster.Types.Boolean, true)