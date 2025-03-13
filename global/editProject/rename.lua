return function( e )
 local oldName = PATH .. "/" .. EDIT_PROJECT.name .. "/" .. e
 local newName = PATH .. "/" .. EDIT_PROJECT.name .. "/" .. tostring(WINDOW.box.text)
 os.rename(oldName, newName)

 require 'global.open-project'( {file = EDIT_PROJECT.name} )
end