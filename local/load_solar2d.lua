return {
 data = function() require 'local.start'() end,
 default = function()
  display.setDefault('fillColor', 1)
  display.setDefault("strokeColor", 1)
  display.setDefault("anchorX", 0.5)
  display.setDefault("anchorY", 0.5)
 end,
 set = function()
  display.setStatusBar(display.HiddenStatusBar)
  display.setStatusBar(display.TranslucentStatusBar)
  display.setStatusBar(display.HiddenStatusBar)
  native.setKeyboardFocus(nil)
 end,
 get = function()
  _G.display.getCurrentStage().rotation = 0
  _G.display.getCurrentStage().x = 0
  _G.display.getCurrentStage().y = 0
  _G.display.fps = 60
  if display.getCurrentStage().width ~= 720 or display.getCurrentStage().height ~= 1280 then
   _G.display.getCurrentStage().width = 720 * 7.2
   _G.display.getCurrentStage().height = 1280 * 12.8
  end
  display.getCurrentStage().alpha = 1
  display.getCurrentStage().xScale = 1
  display.getCurrentStage().yScale = 1
  display.getCurrentStage().isHitTestable = true
 end,
 files = function()
  local path, filename
  EDIT_PROJECT = require 'scenes.edit-project.scene'
  
  for key, value in pairs(EDIT_PROJECT.files) do
   filename = value.name
   if filename ~= 'main.lua' and filename:lower():sub(-4) == ".lua" then
    filename = filename:sub(1, -5)
    package.loaded[filename] = nil
   end
  end
 end,
 project = function()
  package.path = originalPackagePath
  PROJECT = require 'scenes.project.scene'

  if PROJECT.timers[1] then
   for i = #PROJECT.timers, 1, -1 do
    timer.cancel(PROJECT.timers[i])
    PROJECT.timers[i] = nil
   end
   PROJECT.timers = {}
  end

  audio.stop()
  
  if originalNewImage then
   display.newImage = originalNewImage
  end
 
  if originalNewImageRect then
   display.newImageRect = originalNewImageRect
  end

  if originalNewImageSheet then
   graphics.newImageSheet = originalNewImageSheet
  end

  if originalLoadSound then
   audio.loadSound = originalLoadSound
  end

  if originalLoadStream then
   audio.loadStream = originalLoadStream
  end

  if originalPrint then
   print = originalPrint
  end
 end }