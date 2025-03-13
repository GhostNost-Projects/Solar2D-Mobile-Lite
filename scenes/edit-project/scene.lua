local M = { files = {}, name = nil, file = { oldName = nil } }
local functions = require 'scenes.edit-project.functions'
local touch = require 'scenes.edit-project.touchings'



M['create'] = function( e )
 M.scene = display.newGroup()

 M.files = e.params
 M.name = e.name

 local bg = display.newRect(SCREEN.CENTER_X, SCREEN.CENTER_Y, SCREEN.SCREEN_WIDTH, SCREEN.SCREEN_HEIGHT)
 bg.fill = COLOR.edit_project.bg
 M.scene:insert(bg)

 local l_panel = display.newRect(SCREEN.ZERO_X + 250 / 2, bg.y, 250, bg.height)
 l_panel.fill = COLOR.edit_project.panel
 l_panel.strokeWidth = 5
 l_panel:setStrokeColor( unpack(COLOR.edit_project.panel_stroke) )
 M.scene:insert(l_panel)

 local l_t_panel = display.newRect(l_panel.x, SCREEN.ZERO_Y + 5 + 50 / 2 + 2.5, l_panel.width - 2.5 - 5, 50)
 l_t_panel.fill = COLOR.edit_project.bg
 l_t_panel.strokeWidth = 2.5
 l_t_panel:setStrokeColor(unpack(COLOR.select_panel))
 M.scene:insert(l_t_panel)

 local options = {
  text = e.name,     
  x = l_t_panel.x,
  y = l_t_panel.y - 23 / 10,
  width = l_t_panel.width / 1.1,
  height = 23,
  font = FONT,   
  fontSize = 23,
  align = "left"
 }

 local title_app = display.newText(options)
 title_app.fill = COLOR.t_panel_on
 M.scene:insert(title_app)

 local backBg = display.newRoundedRect(l_t_panel.x - l_t_panel.width / 2 + 30 / 1.5, l_t_panel.y + l_t_panel.height / 2 + 30 / 1.3, 30, 30, 10)
 backBg.fill = {0.1}
 M.scene:insert(backBg)

 local back = display.newImageRect("sprites/edit/back.png", -backBg.width, backBg.height)
 back.x = backBg.x
 back.y = backBg.y
 back.id = "back"
 back.touch = 'but_edit'
 back:addEventListener("touch", touch)
 M.scene:insert(back)

 local addFile = display.newImageRect("sprites/edit/addFile.png", 30, 30)
 addFile.x = back.x + addFile.width / 2 + addFile.width
 addFile.y = back.y
 addFile.id = "new_file"
 addFile.touch = 'but_edit'
 addFile:addEventListener("touch", touch)
 M.scene:insert(addFile)

 local addFolder = display.newImageRect("sprites/edit/addFolder.png", 30, 30)
 addFolder.x = addFile.x + addFile.width / 2 + addFolder.width
 addFolder.y = back.y
 addFolder.id = "new_folder"
 addFolder.touch = 'but_edit'
 addFolder:addEventListener("touch", touch)
 M.scene:insert(addFolder)

 local importFile = display.newImageRect("sprites/edit/importFile.png", 30, 30)
 importFile.x = addFolder.x + addFolder.width / 2 + importFile.width
 importFile.y = back.y
 importFile.id = "imp_file"
 importFile.touch = 'but_edit'
 importFile:addEventListener("touch", touch)
 M.scene:insert(importFile)

 local Y = addFile.y + addFile.height / 2 + addFile.height

 local path = PATH .. "/" .. EDIT_PROJECT.name
 local list = {}
 
 for i in lfs.dir(path) do
   if i ~= "." and i ~= ".." then
     local fullPath = path .. "/" .. i
     local attr = lfs.attributes(fullPath, "mode")
     if attr == "directory" then
      table.insert(list, {type = 'folder', name = i})
     else
      table.insert(list, {type = 'file', name = i})
     end
   end
 end

 local name, name_title, name_img

 if list[1] then
  for k in pairs(list) do
    name = "l_list_" .. tostring(k)
    name_title = "l_list_title_" .. tostring(k)
    name_img = "l_list_img_" .. tostring(k)

    local name = display.newRect(l_t_panel.x, Y, l_t_panel.width - 2.5 - 2.5, l_t_panel.height - 2.5 - 2.5 / 1.2)
    name.fill = COLOR.edit_project.l_panel_select
    name.strokeWidth = 2.5
    name.id = k
    name.type = list[k].type
    name.name = list[k].name
    name.touch = 'select'
    name:setStrokeColor(unpack(COLOR.t_panel_off))
    name:addEventListener("touch", touch)
    M.scene:insert(name)

    local image, sizeX, sizeY
    if name.type == "file" then
      image = "sprites/files/default.png"
      sizeX, sizeY = (name.height / 1.2) / 1.7, (name.height / 1.2) / 1.7
      local ext = list[k].name:match("%.([^%.]+)$")
      if ext then
        ext = ext:lower()
        if FILE_TYPES[ext] then
          image = FILE_TYPES[ext]
        end
      end
    elseif name.type == "folder" then
      image = "sprites/folder.png"
      sizeX = 25
      sizeY = (name.height / 1.2) / 2
    end

    local name_img = display.newImageRect(image, sizeX, sizeY)
    name_img.x = name.x - name.width / 2 + sizeX / 1.1
    name_img.y = name.y
    M.scene:insert(name_img)
    
    local width = name.width / 1.2 - sizeX
    options = {
     text = list[k].name,     
     x = name_img.x + sizeX / 2 + width / 1.8,
     y = name.y,
     width = width,
     height = 20,
     font = FONT,   
     fontSize = 20,
     align = "left"
    }
  
    name_title = display.newText(options)
    name_title.fill = COLOR.t_panel_off
    M.scene:insert(name_title)
  
    name.title = name_title
    name.img = name_img
  
    Y = Y + name.height - 2.5
  end
 end

 local width, height = SCREEN.SCREEN_WIDTH - l_panel.width, SCREEN.SCREEN_HEIGHT / 1.8

 local panel_file = display.newRoundedRect(l_panel.x + l_panel.width / 2 + (width / 1.5) / 1.9 + 1, l_t_panel.y + 10, width / 1.5, 45, 15)
 panel_file.fill = COLOR.edit_project.panel
 M.scene:insert(panel_file)

 options = {
  text = '',     
  x = panel_file.x,
  y = panel_file.y,
  width = panel_file.width / 1.1,
  height = panel_file.height / 1.05,
  font = FONT,   
  fontSize = 35,
  align = "left"
 }

 M.title_file = display.newText(options)
 M.title_file.fill = COLOR.t_panel_on
 M.scene:insert(M.title_file)

 local renameBg = display.newRoundedRect(panel_file.x - panel_file.width / 2 + 45 / 1.5, panel_file.y + panel_file.height / 2 + 30, 45, 45, 10)
 renameBg.fill = {0.1}
 M.scene:insert(renameBg)

 M.rename = display.newImageRect("sprites/edit/rename.png", 30, 30)
 M.rename.x = renameBg.x
 M.rename.y = renameBg.y
 M.rename.id = 'ren'
 M.rename.data = {type = 'file', id = 'main.lua'}
 M.rename.touch = 'edit'
 M.rename:addEventListener("touch", touch)
 M.scene:insert(M.rename)

 local deleteBg = display.newRoundedRect(renameBg.x + renameBg.width / 2 + 45, renameBg.y, 45, 45, 10)
 deleteBg.fill = {0.1}
 M.scene:insert(deleteBg)

 M.delete = display.newImageRect("sprites/edit/delete.png", 30, 30)
 M.delete.x = deleteBg.x
 M.delete.y = deleteBg.y
 M.delete.id = 'del'
 M.delete.data = {type = 'file', id = 'main.lua'}
 M.delete.touch = 'edit'
 M.delete:addEventListener("touch", touch)
 M.scene:insert(M.delete)

 local exportBg = display.newRoundedRect(deleteBg.x + deleteBg.width / 2 + 45, deleteBg.y, 45, 45, 10)
 exportBg.fill = {0.1}
 M.scene:insert(exportBg)

 M.export = display.newImageRect("sprites/edit/importFile.png", -30, 30)
 M.export.x = exportBg.x
 M.export.y = exportBg.y
 M.export.id = 'exp'
 M.export.data = {type = 'file', id = 'main.lua'}
 M.export.touch = 'edit'
 M.export:addEventListener("touch", touch)
 M.scene:insert(M.export)

 local runBg = display.newRoundedRect(panel_file.x + panel_file.width / 2 + 30, panel_file.y, panel_file.height, panel_file.height, 10)
 runBg.fill = {0.1}
 M.scene:insert(runBg)

 local run = display.newImageRect("sprites/edit/run.png", runBg.width, runBg.height)
 run.x = runBg.x
 run.y = runBg.y
 run.id = "run"
 run.touch = 'but_edit'
 run:addEventListener("touch", touch)
 M.scene:insert(run)

 M.CODE = display.newGroup()
 M.CODE.isVisible = true

 local panel = display.newRect(l_panel.x + l_panel.width / 2 + width / 2 + 1, renameBg.y + renameBg.height / 2 + height / 1.9, width / 1.05, height)
 panel.fill = COLOR.edit_project.panel
 M.CODE:insert(panel)

 M.edit = native.newTextBox( panel.x, panel.y, panel.width, panel.height )
 M.edit.isFontSizeScaled = true
 M.edit.font = native.newFont( FONT, 20 )
 M.edit.hasBackground = false
 M.edit:setTextColor( unpack(COLOR.t_panel_on) )
 M.edit.isEditable = true
 M.edit:addEventListener("userInput", functions.edit_code)
 M.CODE:insert(M.edit)

 M.scene:insert(M.CODE)

 M.IMAGE = display.newGroup()
 M.IMAGE.isVisible = false

 M.panel_img = display.newRect(panel.x, panel.y, panel.width, panel.height)
 M.panel_img.fill = COLOR.edit_project.panel
 M.IMAGE:insert(M.panel_img)

 M.img = display.newImageRect("sprites/logo.png", M.panel_img.width / 1.05, M.panel_img.height / 1.05)
 M.img.x = M.panel_img.x
 M.img.y = M.panel_img.y
 M.IMAGE:insert(M.img)

 M.scene:insert(M.IMAGE)

 if M.files[1] then
  local data = false
  for k, _ in pairs(M.files) do
   local name = {id = k, name = _.name}
   if name.name:lower() == "main.lua" then
    M.title_file.text = e.params[name.id].name
    functions.read_file({name = e.params[name.id].path})
    M.edit.text = functions.data
    M.edit.id = name.id
    data = true
   end
  end
  if data == false then
   native.showAlert("Warning", 'The project will not work without the "main.lua" file!', {"OK"})
   M.title_file.text = "File not found!"
   M.edit.text = 'Create a "main.lua" file!'
  end
 else
  M.title_file.text = "File not found!"
  M.edit.text = "Create a new file for the project!"
 end

 i = 1
 while true do
  local name, value = debug.getlocal(1, i)
  if not name then break end

  if name ~= "M" then
    debug.setlocal(1, i, nil)
  end
  i = i + 1
 end
end

return M