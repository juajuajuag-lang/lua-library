local Library={}

Library.Name="LuaLibrary"
Library.Version="1.0.0"

Library.Modules={
 Dashboard="Modules/Dashboard.lua",
 Visual="Modules/Visual.lua"
}

function Library:GetModule(Name)
 local Path=self.Modules[Name]
 if not Path then
  return nil
 end

 local BaseURL="https://raw.githubusercontent.com/juajuajuag-lang/lua-library/main/"
 local Source=game:HttpGet(BaseURL..Path)
 return loadstring(Source)()
end

return Library
