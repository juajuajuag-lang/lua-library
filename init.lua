local Library={}
local Loader=require("Loader.Loader")

Library.Name="LuaLibrary"
Library.Version="1.0.0"
Library.Loader=Loader

Library.Modules={
 Dashboard="Modules/Dashboard.lua"
}

return Library
