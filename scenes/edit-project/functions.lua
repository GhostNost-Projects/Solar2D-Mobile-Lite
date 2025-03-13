local M = { data = nil }

M['read_file'] = function( e )
 local file, errorString = io.open( e.name, "r" )

 if not file then
  print( "1: " .. errorString )
  return nil
 else
  M.data = file:read( "*a" )
  io.close( file )
 end
 file = nil
end

M['edit_code'] = function( e )
 if e.phase == "editing" then
  local file, errorString
  if e.target.id then
   local path = EDIT_PROJECT.files[e.target.id].path
   file, errorString = io.open( path, "w" )
   if not file then
    print( "File error: " .. errorString )
    return nil
   else
    file:write( e.text )
    io.close( file )
   end
   M.read_file({name = path})
   file = nil
  end
 end
end

return M