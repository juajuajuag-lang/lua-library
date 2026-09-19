local Library={}
local Registry=require("Core.Registry")
local Dashboard=require("Modules.Dashboard")

Library.Name="LuaLibrary"
Library.Version="1.0.0"

Library.Registry=Registry
Library.Dashboard=Registry:Register("Dashboard",Dashboard)

return Library
