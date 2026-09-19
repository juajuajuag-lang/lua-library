local Library={}

Library.Name="LuaLibrary"
Library.Version="1.0.0"

Library.Modules={
 Dashboard="Modules/Dashboard.lua"
}

function Library:GetModule(Name)
 return self.Modules[Name]
end

return Library
