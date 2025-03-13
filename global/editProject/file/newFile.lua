return function( path )
 local project = path
 local name, path

 if WINDOW.box.text ~= '' then
  name = tostring( WINDOW.box.text )
  path = PATH .. "/" .. project .. "/" .. name

  local file, errorString = io.open( path, "w" )

  if not file then
   print( "File error: " .. errorString )
  else
   file:write('')
   io.close( file )
  end

  file, name, path = nil, nil, nil
 end

 require 'global.open-project'( {file = project} )
end