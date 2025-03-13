return function( path )
 local project = path
 local path = PATH .. "/" .. EDIT_PROJECT.name
 local success = lfs.chdir( path )
 local name = tostring(WINDOW.box.text)
 local new_folder_path

 if WINDOW.box.text ~= '' then
   if success then
    lfs.mkdir( name )
    new_folder_path = lfs.currentdir() .. "/" .. name
   end
 end

 require 'global.open-project'( {file = project} )
end