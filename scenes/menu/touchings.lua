local M = {}
local lastSelected = nil
local functions = require 'scenes.menu.functions'



return function( e )
 if e.phase == 'began' then
  display.getCurrentStage():setFocus(e.target)
  e.target.click = true
  if e.target.touch == 'logo' or (e.target.touch == 'select_panel' and e.target ~= lastSelected) then
   e.target.alpha = 0.75
  elseif e.target.touch == 'links' then
   e.target.fill = COLOR.select_panel
   elseif e.target.touch == 'selects' then
    e.target:setStrokeColor( unpack(COLOR.t_panel_on) )
    e.target.line.fill = COLOR.t_panel_on
    e.target.text.fill = COLOR.select_panel
    for i = 1, 3 do
     e.target.circles[i]:setStrokeColor( unpack(COLOR.t_panel_on) )
     e.target.circles[i].fill = COLOR.circles_on[i]
    end
   elseif e.target.touch == 'select_list' then
    e.target.title.fill = COLOR.select_panel
  end
  elseif e.phase == 'moved' and (math.abs(e.x - e.xStart) > 30 or math.abs(e.y - e.yStart) > 30) then
   e.target.click = false
   if e.target.touch == 'logo' or e.target.touch == 'select_panel' then
    e.target.alpha = 1
   elseif e.target.touch == 'links' then
    e.target.fill = COLOR.t_panel_off
   elseif e.target.touch == 'selects' then
    e.target:setStrokeColor( unpack(COLOR.box) )
    e.target.line.fill = COLOR.box
    e.target.text.fill = {1}
    for i = 1, 3 do
     e.target.circles[i]:setStrokeColor( unpack(COLOR.box) )
     e.target.circles[i].fill = COLOR.circles_off[i]
    end
   elseif e.target.touch == 'select_list' then
    e.target.title.fill = COLOR.t_panel_on
   end
  elseif e.phase == 'ended' or e.phase == 'cancelled' then
   display.getCurrentStage():setFocus(nil)
   if e.target.click then
    e.target.click = false
    if e.target.touch == 'logo' then
     e.target.alpha = 1
     system.openURL("https://solar2d.com/")
    elseif e.target.touch == 'links' then
     e.target.fill = COLOR.t_panel_off
     system.openURL(e.target.link)
    elseif e.target.touch == 'selects' then
     e.target:setStrokeColor( unpack(COLOR.box) )
     e.target.line.fill = COLOR.box
     e.target.text.fill = {1}
     for i = 1, 3 do
      e.target.circles[i]:setStrokeColor( unpack(COLOR.box) )
      e.target.circles[i].fill = COLOR.circles_off[i]
     end
     if e.target.id == 'new' then
      WINDOW.new({name = 'NEW_PROJ', group = MENU.scene, title = 'New Project', text_box = 'Application Name', cancel = function() MENU.create() MENU.scene.isVisible = true end, ok = function() require 'global.new-project'() end, close = function() MENU.create() MENU.scene.isVisible = true end})
     elseif e.target.id == 'open' then
      if MENU.RE_PROJECTS[1] then
       WINDOW.new({name = 'OPEN_PROJ', group = MENU.scene, title = 'Open Project', text_box = 'Application Name', cancel = function() MENU.create() MENU.scene.isVisible = true end, ok = function() require 'global.open-project'() end, close = function() MENU.create() MENU.scene.isVisible = true end})
      else
      WINDOW.new({name = 'NEW_PROJ', group = MENU.scene, title = 'New Project', text_box = 'Application Name', cancel = function() MENU.create() MENU.scene.isVisible = true end, ok = function() require 'global.new-project'() end, close = function() MENU.create() MENU.scene.isVisible = true end})
      end
     elseif e.target.id == 'relaunch' then
      if MENU.RE_PROJECTS[1] then
       require 'global.open-project'( {file = MENU.RE_PROJECTS[1].name} )
      else
       WINDOW.new({name = 'NEW_PROJ', group = MENU.scene, title = 'New Project', text_box = 'Application Name', cancel = function() MENU.create() MENU.scene.isVisible = true end, ok = function() require 'global.new-project'() end, close = function() MENU.create() MENU.scene.isVisible = true end})
      end
     end
     functions.delete_scene()
    elseif e.target.touch == 'select_list' then
     e.target.title.fill = COLOR.t_panel_on
     functions.delete_scene()
     require 'global.open-project'( { file = e.target.name } )
    elseif e.target.touch == 'select_panel' then
     e.target.alpha = 1
     functions.F_SELECT_PANEL(e.target)
     lastSelected = e.target
    end
   end
  end
 return true
end