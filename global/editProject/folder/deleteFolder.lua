return function( name )
 local path = PATH .. "/" .. EDIT_PROJECT.name .. "/" .. name

 for file in lfs.dir(path) do
  if file ~= "." and file ~= ".." then
   local filePath = path .. "/" .. file
   local attr = lfs.attributes(filePath)
   if attr.mode == "directory" then
    lfs.rmdir(filePath)
   else
    os.remove(filePath)
   end
  end
 end

 lfs.rmdir(path)

 require 'global.open-project'( {file = EDIT_PROJECT.name} )
end