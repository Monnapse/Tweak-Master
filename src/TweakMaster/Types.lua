local SignalType = require(script.Parent.Signal)

local Types = {}

export type Property = {
    type: TYPE, 
    object: Instance, 
    name: string,
    singal: SignalType.signal,
    value: boolean | string | Vector3 | Vector2
}

export type Master = {
   ConnectedProperties: {number: Property},
   UI: ScreenGui,
   KeyCode: Enum.KeyCode,
   ResetKeyCode: Enum.KeyCode
}

export type TYPE = {
    type: string
}

return Types