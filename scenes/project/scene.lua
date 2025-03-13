local M = { func, timers = {}, print = {} }
local functions = require 'scenes.project.functions'



M['load'] = function(code)
  local func, err = loadstring(code)
  if not func then
   native.showAlert("Error #2", "error: " .. err, {"OK"})
   return false, err
  end

  local success, result = pcall(func)
  if not success then
   native.showAlert("Error #2", "error: " .. result, {"OK"})
   return false, result
  end
  return true, result
end

M['create'] = function()
 require 'global.screen'.Delete()
 display.setDefault( "background", 0 )

 local customPath = PATH .. "/" .. EDIT_PROJECT.name .. "/?.lua"
 package.path = customPath

 local function getImagePath(filename)
   return PATH .. "/" .. EDIT_PROJECT.name .. "/" .. filename
  end

 local function getSoundPath(filename)
  return PATH .. "/" .. EDIT_PROJECT.name .. "/" .. filename
 end

 function display.newImage(filename, ...)
   return originalNewImage(getImagePath(filename), ...)
 end

 function graphics.newImageSheet(filename, ...)
  return originalNewImageSheet(getImagePath(filename), ...)
 end

 function display.newImageRect(filename, width, height)
   return originalNewImageRect(getImagePath(filename), width, height)
 end

 function timer.performWithDelay(delay, listener, iterations)
  local t = originalTimerPerformWithDelay(delay, listener, iterations)
  table.insert(M.timers, t)
  return t
 end
 
 function audio.loadSound(filename)
  return originalLoadSound(getSoundPath(filename))
 end

 function audio.loadStream(filename)
  return originalLoadStream(getSoundPath(filename))
 end

 function print(text)
  table.insert(M.print, text)
  return originalPrint(text)
 end

 path = PATH .. "/" .. EDIT_PROJECT.name .. "/" .. "config.json"
 local file, errorString = io.open( path, "r" )
 if not file then
  native.showAlert("Error #3", "File error: " .. errorString, {"OK"})
 else
  contents = file:read( "*a" )
  io.close( file )
 end

 local screen = json.decode(contents)
 _G.display.getCurrentStage().width = screen.application.content.width
 _G.display.getCurrentStage().height = screen.application.content.height
 _G.display.fps = screen.application.content.fps

 file, path, contents, screen = nil, nil, nil, nil

 path = PATH .. "/" .. EDIT_PROJECT.name .. "/" .. "main.lua"
 local file, errorString = io.open( path, "r" )
 if not file then
   native.showAlert("Error #3", "File error: " .. errorString, {"OK"})
 else
  contents = file:read( "*a" )
  io.close( file )
  M.load(contents)
 end
 file, path, contents = nil, nil, nil

 lfs = nil
 json = nil
 appVersion = nil
 COLOR = nil
 LINK = nil
 FONT = nil
 PATH = nil
 STR = nil
 FILE_TYPES = nil
 MENU = nil
 PROJECT = nil
 EDIT_PROJECT = nil
 WINDOW = nil
 
 Runtime:addEventListener("key", functions.back)
end

return M