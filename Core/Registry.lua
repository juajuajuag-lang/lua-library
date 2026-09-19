local Registry={}
local Modules={}

function Registry:Register(Name,Module)
 Modules[Name]=Module
 return Module
end

function Registry:Get(Name)
 return Modules[Name]
end

function Registry:GetAll()
 return Modules
end

return Registry
