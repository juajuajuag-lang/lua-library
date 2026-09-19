local Loader={}

Loader.Name="LibraryLoader"
Loader.Version="1.0.0"

function Loader:Register(Name,Module)
 self[Name]=Module
 return Module
end

function Loader:Get(Name)
 return self[Name]
end

return Loader
