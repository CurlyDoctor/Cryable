local Cryable = {}
Cryable.__index = Cryable

function Cryable.CreateClass()
    local self = setmetatable({}, Cryable)
    self.__index = self

    self.Parameters = {}

    return self
end


function Cryable:_constructor(f: Function)
    -- This function will run any statements before new is specified
    -- There should not be any parameters in the constructor

    assert(type(f()) == "table", "f has to return a table")

    self.constructor = f()


    return self
end

function Cryable:_properties(table)
    assert(type(table) == "table", "#1 parameter has to be a table!")
    --Inits any values that need to be set in before

    for index, value in pairs(table) do
        self[index] = value
    end

    return self
end

function Cryable:_propertyAfter(func)
    self.PropertyAfter = func

    return self
end
function Cryable:_parameters(...)
    assert(type(...) == "string", "arg is not a string")

    self.Parameters = self.Parameters

    local par = {...}
    
    for _, str in ipairs(par) do
        table.insert(self.Parameters, #self.Parameters + 1, str)
    end

    
    

    return self
end

function Cryable:_methods(methods)
    assert(type(methods) == "table", "methods has to be packed in a table")
    assert(methods.new == nil, "a .new method cannot exist exist within methods. Please Remove .new")

    for name, func in pairs(methods) do
        self[name] = func
    end

    print("Methods unlocked!")

    return self
end

function Cryable:dissolveAllParameters()
    for index, value in pairs(self.Parameters) do
        self[index] = value
    end

    return self
end

function Cryable:new(...)
    assert(getmetatable(self) == Cryable, "Cannot run original Cryable using this method. Please remember to call the class with [[:Get.]] Thank you ")

    local newself = setmetatable({}, self)

    local args = {...}

    for index, value in pairs(args) do
        local str = self.Parameters[index]

        self[str] = value
    end

 
    if self.PropertyAfter ~= nil and type(self.PropertyAfter) == "function" then
        self:PropertyAfter()
    end
    return newself
end

function Cryable:_destroy(f: func)
    self.Destroy = f

    return self
end

return Cryable