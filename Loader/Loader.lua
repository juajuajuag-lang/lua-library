local Loader={}

Loader.Name="LibraryLoader"
Loader.Version="1.0.0"

function Loader:Load(URL)
 local Source=game:HttpGet(URL)
 return loadstring(Source)()
end

return Loader
