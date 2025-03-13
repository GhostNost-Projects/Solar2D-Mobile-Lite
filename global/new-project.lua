return function()
 local name = tostring(WINDOW.box.text)
 local success = lfs.chdir( PATH )
 local dates = require 'local.files'
 local new_folder_path

 if name ~= '' then
  if success then
   lfs.mkdir( name )
   new_folder_path = lfs.currentdir() .. "/" .. name
  end

  for key, value in pairs(dates) do
   local file = io.open( new_folder_path .. "/" .. key, "w" )
   file:write(value)
   io.close( file )
   file = nil
  end
  
  require 'global.open-project'( {file = tostring(WINDOW.box.text)} )
 else
  native.showAlert("Error #1", "You did not enter a project name!", {"OK"})
  MENU.create()
 end
end