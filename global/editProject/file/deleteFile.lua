return function( name )
 path = PATH .. "/" .. EDIT_PROJECT.name .. "/" .. name
 os.remove( path )
 path = nil
 require 'global.open-project'( {file = EDIT_PROJECT.name} )
end