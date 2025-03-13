local M = {}
local functions = require 'global.window.functions'



M['window_move'] = function(e)
 if e.phase == 'began' then
     display.getCurrentStage():setFocus(e.target)
     e.target.isMoving = true
     e.target.touchStartX, e.target.touchStartY = e.x, e.y
     e.target.startX, e.target.startY = WINDOW.window.x, WINDOW.window.y
 elseif e.phase == 'moved' and e.target.isMoving then
     local dx = e.x - e.target.touchStartX
     local dy = e.y - e.target.touchStartY
     WINDOW.window.x = e.target.startX + dx
     WINDOW.window.y = e.target.startY + dy
 elseif e.phase == 'ended' or e.phase == 'cancelled' then
     display.getCurrentStage():setFocus(nil)
     e.target.isMoving = false
 end
 return true
end

M['close'] = function( e )
 if e.phase == 'began' then
  display.getCurrentStage():setFocus(e.target)
  e.target.click = true
  e.target.fill = COLOR.window.close
  e.target.text.fill = {1}
  elseif e.phase == 'moved' and (math.abs(e.x - e.xStart) > 30 or math.abs(e.y - e.yStart) > 30) then
   e.target.click = false
   e.target.fill = {1}
   e.target.text.fill = {0}
  elseif e.phase == 'ended' or e.phase == 'cancelled' then
   display.getCurrentStage():setFocus(nil)
   if e.target.click then
    e.target.click = false
    e.target.fill = {1}
    e.target.text.fill = {0}
    native.setKeyboardFocus(nil)
    e.target.func()
    functions.del({name = e.target.id})
   end
  end
 return true
end

M['select'] = function( e )
 if e.phase == 'began' then
  display.getCurrentStage():setFocus(e.target)
  e.target.click = true
  e.target.fill = COLOR.window.select
  e.target:setStrokeColor( unpack(COLOR.window.but_stroke_select) )
  elseif e.phase == 'moved' and (math.abs(e.x - e.xStart) > 30 or math.abs(e.y - e.yStart) > 30) then
   e.target.click = false
   e.target.fill = COLOR.window.but
   e.target:setStrokeColor( unpack(COLOR.window.but_stroke) )
  elseif e.phase == 'ended' or e.phase == 'cancelled' then
   display.getCurrentStage():setFocus(nil)
   if e.target.click then
    e.target.click = false
    e.target.fill = COLOR.window.but
    e.target:setStrokeColor( unpack(COLOR.window.but_stroke) )
    native.setKeyboardFocus(nil)
    functions.del({name = e.target.id})
    e.target.func()
   end
  end
 return true
end

return M