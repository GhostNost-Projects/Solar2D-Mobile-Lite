local M = {}
local functions = require 'scenes.edit-project.functions'
local editPath = 'global.editProject.'
local edits = {
  newFile = require (editPath .. 'file.newFile'), newFolder = require (editPath .. 'folder.newFolder'),
  deleteFile = require (editPath .. 'file.deleteFile'), deleteFolder = require (editPath .. 'folder.deleteFolder'),
  importFile = require (editPath .. 'file.importFile'), rename = require (editPath .. 'rename')
}



return function( e )
 if e.phase == 'began' then
  display.getCurrentStage():setFocus(e.target)
  e.target.click = true
  if e.target.touch == 'select' then
   e.target:setStrokeColor( unpack(COLOR.t_panel_on) )
   e.target.title.fill = COLOR.select_panel
   e.target:toFront()
   e.target.title:toFront()
   e.target.img:toFront()
  elseif e.target.touch == 'but_edit' or e.target.touch == 'edit' then
   e.target.strokeWidth = 2
  end
  elseif e.phase == 'moved' and (math.abs(e.x - e.xStart) > 10 or math.abs(e.y - e.yStart) > 10) then
   e.target.click = false
   if e.target.touch == 'select' then
    e.target:setStrokeColor( unpack(COLOR.t_panel_off) )
    e.target.title.fill = COLOR.t_panel_off
   elseif e.target.touch == 'but_edit' or e.target.touch == 'edit' then
    e.target.strokeWidth = 0
   end
  elseif e.phase == 'ended' or e.phase == 'cancelled' then
   display.getCurrentStage():setFocus(nil)
   native.setKeyboardFocus(nil)
   if e.target.click then
    e.target.click = false
    if e.target.touch == 'select' then
     e.target:setStrokeColor( unpack(COLOR.t_panel_off) )
     e.target.title.fill = COLOR.t_panel_off
     local name = EDIT_PROJECT.files[e.target.id].name
     local path = EDIT_PROJECT.files[e.target.id].path
     local width, height
     EDIT_PROJECT.title_file.text = name
     EDIT_PROJECT.rename.data = {type = e.target.type, id = name}
     EDIT_PROJECT.delete.data = {type = e.target.type, id = name}
     EDIT_PROJECT.export.data = {type = e.target.type, id = name}
     audio.stop()
     if e.target.type == 'file' then
      if name:lower():sub(-4) == ".lua" or name:lower():sub(-4) == ".txt" or name:lower():sub(-5) == ".json" then
       EDIT_PROJECT.IMAGE.isVisible = false
       functions.read_file({name = path})
       EDIT_PROJECT.edit.text = functions.data
       EDIT_PROJECT.edit.id = e.target.id
       EDIT_PROJECT.CODE.isVisible = true
       EDIT_PROJECT.edit.isVisible = true
      elseif name:lower():sub(-4) == ".mp3" then
        EDIT_PROJECT.CODE.isVisible = false
        EDIT_PROJECT.edit.isVisible = false
        EDIT_PROJECT.IMAGE.isVisible = false
        audio.stop()
        local optionts = {
          loops = -1 }
        local sound = audio.loadSound("Apps/" .. EDIT_PROJECT.name .. "/" .. name, system.DocumentsDirectory)
        audio.play(sound, optionts)
      elseif name:lower():sub(-4) == ".png" or ".jpg" then
       EDIT_PROJECT.CODE.isVisible = false
       EDIT_PROJECT.edit.isVisible = false
       local newImage = display.newImage("Apps/" .. EDIT_PROJECT.name .. "/" .. name, system.DocumentsDirectory)
       if newImage.width >= EDIT_PROJECT.panel_img.width / 1.05 then
        EDIT_PROJECT.img.width = EDIT_PROJECT.panel_img.width / 1.05
       else
        EDIT_PROJECT.img.width = newImage.width
       end
       if newImage.height >= EDIT_PROJECT.panel_img.height / 1.05 then
        EDIT_PROJECT.img.height = EDIT_PROJECT.panel_img.height / 1.05
       else
        EDIT_PROJECT.img.height = newImage.height
       end
       newImage:removeSelf()
       newImage = nil
       EDIT_PROJECT.img.fill = { type="image", filename="Apps/" .. EDIT_PROJECT.name .. "/" .. name, baseDir=system.DocumentsDirectory }
       EDIT_PROJECT.IMAGE.isVisible = true
      end
     elseif e.target.type == 'folder' then
      EDIT_PROJECT.CODE.isVisible = false
      EDIT_PROJECT.edit.isVisible = false
      EDIT_PROJECT.IMAGE.isVisible = false
     end
    elseif e.target.touch == 'but_edit' then
      e.target.strokeWidth = 0
      audio.stop()
      if e.target.id == 'new_file' then
        WINDOW.new({name = 'NEW_FILE', group = EDIT_PROJECT.scene, title = 'Create a new file', text_box = 'File Name', cancel = function() EDIT_PROJECT.create( { params = EDIT_PROJECT.files, name = EDIT_PROJECT.name } ) end, ok = function() edits.newFile( EDIT_PROJECT.name ) end, close = function() EDIT_PROJECT.create( { params = EDIT_PROJECT.files, name = EDIT_PROJECT.name } ) end})
        display.remove(EDIT_PROJECT.scene)
        EDIT_PROJECT.scene = nil
    elseif e.target.id == 'new_folder' then
      WINDOW.new({name = 'NEW_FOLDER', group = EDIT_PROJECT.scene, title = 'Create a new folder', text_box = 'Folder Name', cancel = function() EDIT_PROJECT.create( { params = EDIT_PROJECT.files, name = EDIT_PROJECT.name } ) end, ok = function() edits.newFolder( EDIT_PROJECT.name ) end, close = function() EDIT_PROJECT.create( { params = EDIT_PROJECT.files, name = EDIT_PROJECT.name } ) end})
      display.remove(EDIT_PROJECT.scene)
      EDIT_PROJECT.scene = nil
    elseif e.target.id == 'imp_file' then
      native.showAlert("Warning!", "File import is under development!", {"OK"})
      WINDOW.new({name = 'IMP_FILE', group = EDIT_PROJECT.scene, title = 'Import file from device', text_box = 'File Name', cancel = function() EDIT_PROJECT.create( { params = EDIT_PROJECT.files, name = EDIT_PROJECT.name } ) end, ok = function() edits.importFile( EDIT_PROJECT.name ) end, close = function() EDIT_PROJECT.create( { params = EDIT_PROJECT.files, name = EDIT_PROJECT.name } ) end})
      display.remove(EDIT_PROJECT.scene)
      EDIT_PROJECT.scene = nil
    elseif e.target.id == 'back' then
      display.remove(EDIT_PROJECT.scene)
      EDIT_PROJECT.scene = nil
      MENU.create()
    elseif e.target.id == 'run' then
      display.remove(EDIT_PROJECT.scene)
      EDIT_PROJECT.scene = nil
      PROJECT.create()
    end
    elseif e.target.touch == 'edit' then
      e.target.strokeWidth = 0
      audio.stop()
      if e.target.data.type == 'file' then
        if e.target.id == 'del' then
          display.remove(EDIT_PROJECT.scene)
          EDIT_PROJECT.scene = nil
          edits.deleteFile(e.target.data.id)
        elseif e.target.id == 'ren' then
          WINDOW.new({name = 'REN_FILE', group = EDIT_PROJECT.scene, title = 'Renaming a file', text_box = 'new file name', cancel = function() EDIT_PROJECT.create( { params = EDIT_PROJECT.files, name = EDIT_PROJECT.name } ) end, ok = function() edits.rename(e.target.data.id) end, close = function() EDIT_PROJECT.create( { params = EDIT_PROJECT.files, name = EDIT_PROJECT.name } ) end})
        elseif e.target.id == 'exp' then
          local options = {
            subject = "File from Solar2D Mobile",
            body = e.target.data.id,
            attachment = { { baseDir = system.DocumentsDirectory, filename = PATH .. "/" .. EDIT_PROJECT.name .. "/" .. e.target.data.id, type = "text/plain" } } }
            native.showPopup("mail", options)
        end
      elseif e.target.data.type == 'folder' then
        if e.target.id == 'del' then
          display.remove(EDIT_PROJECT.scene)
          EDIT_PROJECT.scene = nil
          edits.deleteFolder(e.target.data.id)
        elseif e.target.id == 'ren' then
          WINDOW.new({name = 'REN_FILE', group = EDIT_PROJECT.scene, title = 'Renaming a folder', text_box = 'new folder name', cancel = function() EDIT_PROJECT.create( { params = EDIT_PROJECT.files, name = EDIT_PROJECT.name } ) end, ok = function() edits.rename(e.target.data.id) end, close = function() EDIT_PROJECT.create( { params = EDIT_PROJECT.files, name = EDIT_PROJECT.name } ) end})
        end
      end
    end
   end
  end
 return true
end