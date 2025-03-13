local M = {}
local touch = require 'global.window.touchings'



M['new'] = function( e )
 M[e.name] = display.newGroup()

 e.group.xScale, e.group.yScale = 0.5, 0.5
 display.save(e.group, { filename="screenshot.png", baseDir=system.TemporaryDirectory })

 local screenshot = display.newImageRect("screenshot.png", system.TemporaryDirectory, SCREEN.SCREEN_WIDTH, SCREEN.SCREEN_HEIGHT)
 screenshot.x, screenshot.y = SCREEN.CENTER_X, SCREEN.CENTER_Y
 M[e.name]:insert(screenshot)

 display.remove(e.group)
 e.group = nil

 local dark = display.newRect(screenshot.x, screenshot.y, screenshot.width, screenshot.height)
 dark.fill = {0}
 dark.alpha = 0.5
 M[e.name]:insert(dark)

 M['window'] = display.newGroup()
 M[e.name]:insert(M.window)

 local panel = display.newRect(SCREEN.CENTER_X, SCREEN.CENTER_Y, SCREEN.SCREEN_WIDTH / 1.15, 200)
 panel.fill = COLOR.window.bg
 M.window:insert(panel)

 local top_panel = display.newRect(panel.x, panel.y - panel.height / 2, panel.width, 50)
 top_panel:addEventListener("touch", touch.window_move)
 M.window:insert(top_panel)

 local options = {
  text = tostring(e.title),     
  x = 0,
  y = top_panel.y,
  font = FONT,   
  fontSize = 23,
  align = "left"
 }

 local title_text = display.newText(options)
 title_text.x = panel.x - panel.width / 2 + title_text.width / 2 + 15
 title_text.fill = {0}
 M.window:insert(title_text)

 local close = display.newRect(panel.x + panel.width / 2 - 50 / 2, top_panel.y, 50, 50)
 close.id = e.name
 close.func = e.close
 close:addEventListener("touch", touch.close)
 M.window:insert(close)

 local title_close = display.newText("×", close.x, close.y, FONT, 35)
 title_close.fill = {0}
 close.text = title_close
 M.window:insert(title_close)

 local cancel = display.newRect(panel.x + panel.width / 2 - 125 / 1.5, panel.y + panel.height / 2 - 40 / 1.1, 125, 40)
 cancel.fill = COLOR.window.but
 cancel.strokeWidth = 3.5
 cancel:setStrokeColor( unpack(COLOR.window.but_stroke) )
 cancel.id = e.name
 cancel.but = 'cancel'
 cancel.func = e.cancel
 cancel:addEventListener("touch", touch.select)
 M.window:insert(cancel)

 local title_cancel = display.newText("Cancel", cancel.x, cancel.y, FONT, 20)
 title_cancel.fill = {0}
 M.window:insert(title_cancel)

 local ok = display.newRect(cancel.x - cancel.width - cancel.width / 10, cancel.y, cancel.width - 3.5, cancel.height - 3.5)
 ok.fill = COLOR.window.but
 ok.strokeWidth = 3.5
 ok:setStrokeColor( unpack(COLOR.window.but_stroke) )
 ok.id = e.name
 ok.but = 'OK'
 ok.func = e.ok
 ok:addEventListener("touch", touch.select)
 M.window:insert(ok)

 local title_ok = display.newText("OK", ok.x, ok.y, FONT, 20)
 title_ok.fill = {0}
 M.window:insert(title_ok)

 local options = {
  text = tostring(e.text_box .. " :"),
  x = 0,
  y = top_panel.y + top_panel.height + top_panel.height / 2,
  font = FONT,   
  fontSize = 23,
  align = "left"
 }

 local title_box = display.newText(options)
 title_box.x = panel.x - panel.width / 2 + title_box.width / 2 + title_box.width / 10
 title_box.fill = {0}
 M.window:insert(title_box)

 M['box'] = native.newTextField( title_box.x + title_box.width / 2 + 300 / 2 + 10, title_box.y, 300, 50 )
 M.box.size = title_box.height / 1.3
 M.box:resizeHeightToFitFont()
 M.window:insert(M.box)

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