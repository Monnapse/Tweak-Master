local Types = {}

export type Master = {
   ConnectedProperties: {number: {type: TYPE, object: Instance, name: string}}
}

export type TYPE = {
    type: string
}

return Types