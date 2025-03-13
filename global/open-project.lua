return function( e )
 local name, path
 local list = {}
 if e then name = e.file else name = tostring(WINDOW.box.text) end

 if name ~= '' then
  path = PATH .. "/" .. name

  for file in lfs.dir(path) do
   if file ~= "." and file ~= ".." then
    files_path = PATH .. "/" .. name .. "/" .. file
    table.insert(list, { path = files_path, name = file } )
   end
  end

  file = nil

  EDIT_PROJECT.create( { name = name, params = { unpack(list) } } )
 else
  native.showAlert("Error #1", "You did not enter a project name!", {"OK"})
  MENU.create()
 end
end