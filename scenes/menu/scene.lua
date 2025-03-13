local M = {}
local touch = require 'scenes.menu.touchings'



M['create'] = function()
 M.scene = display.newGroup()

 local bg = display.newRect(SCREEN.CENTER_X, SCREEN.CENTER_Y, SCREEN.SCREEN_WIDTH, SCREEN.SCREEN_HEIGHT)
 bg.fill = COLOR.bg
 M.scene:insert(bg)

 local panel = display.newRect(bg.x, SCREEN.ZERO_Y + 130 / 2, bg.width, 130)
 panel.fill = COLOR.panel
 M.scene:insert(panel)

 local PROJECTS = display.newGroup()
 PROJECTS.isVisible = false
 M.scene:insert(PROJECTS)

 local line = display.newRect(bg.x + bg.width / 2 - 200, (panel.y + panel.height / 2) + (bg.height - panel.height) / 2, 5, bg.height - panel.height)
 line.fill = COLOR.lines
 PROJECTS:insert(line)

 local sel_width, sel_height = (bg.width - (bg.width - line.x)) / 3, 150

 local folder_img = display.newImageRect("sprites/folder.png", 97 / 3, 80 / 3)
 folder_img.x = line.x + line.width + folder_img.width / 1.5
 folder_img.y = panel.y + panel.height / 2 + folder_img.height
 PROJECTS:insert(folder_img)

 local options = {
  text = STR.menu.other[1],     
  x = folder_img.x + folder_img.width / 1.3 + 150 / 2,
  y = folder_img.y,
  width = 150,
  font = FONT,   
  fontSize = 20,
  align = "left"
 }

 local recent_projects = display.newText(options)
 recent_projects.fill = COLOR.t_panel_on
 PROJECTS:insert(recent_projects)
 
 local projects = system.pathForFile("projects.json", system.DocumentsDirectory)
 local file = io.open( projects, "w" )
 local list = {}

 for data in lfs.dir(PATH) do
  if data ~= "." and data ~= ".." then
    local dataPath = PATH .. "/" .. data
    local attr = lfs.attributes(dataPath)
    table.insert(list, {name = data, id = attr.modification})
  end
  data = nil
 end

 table.sort(list, function(a, b) return a.id > b.id end)
 file:write(tostring(json.encode(list)))
 io.close( file )

 file = nil

 local name_list, name_list_title
 local Y = folder_img.y + folder_img.height / 2 + 30 + 30 / 2
 
 for i = 1, #list do
  name_list = "list_project_" .. tostring(i)
  name_list_title = "list_project_title" .. tostring(i)
  local pathIcon = list[i].name .. "/" .. "Icon.png"
  local project_icon = "sprites/icon_list.png"
  local id = system.ResourceDirectory

  local file = pathIcon and io.open(pathIcon, "r")
  if file then
    file:close()
    project_icon = list[i].name .. "/Icon.png"
    id = system.DocumentsDirectory
  end

  local name_list = display.newImageRect(project_icon, id, 30, 30)
  name_list.x = folder_img.x
  name_list.y = Y
  name_list.name = list[i].name
  name_list.touch = 'select_list'
  name_list:addEventListener("touch", touch)
  PROJECTS:insert(name_list)

  local options = {
    text = list[i].name,     
    x = name_list.x + name_list.width / 2 + recent_projects.width / 1.8,
    y = name_list.y,
    width = recent_projects.width,
    height = 20,
    font = FONT,   
    fontSize = 20,
    align = "left"
   }

  local name_list_title = display.newText( options )
  name_list_title.fill = COLOR.t_panel_on
  name_list_title.name = list[i].name
  name_list_title.touch = 'select_list'
  name_list_title:addEventListener("touch", touch)
  PROJECTS:insert(name_list_title)

  name_list.title = name_list_title
  name_list_title.title = name_list_title

  Y = Y + name_list.height + name_list.height / 2
 end

 M['RE_PROJECTS'] = list

 local info_app = display.newText(STR.menu.other[3], bg.x - bg.width / 2 + 115, bg.y + bg.height / 2 - 20, FONT, 20)
 info_app.fill = COLOR.dark_t
 PROJECTS:insert(info_app)

 options = {
  text = "Build: " .. appVersion,     
  x = line.x - line.width / 2 - 200 / 2 - 200 / 10,
  y = info_app.y,
  width = 200,
  height = 20,
  font = FONT,   
  fontSize = 20,
  align = "right"
 }

 local info_ver = display.newText(options)
 info_ver.fill = COLOR.dark_t
 PROJECTS:insert(info_ver)

 local bg_l = bg.width - sel_width

 local line2 = display.newRect(line.x - line.width / 2 - bg_l / 2, info_app.y - info_app.height / 1.3, bg_l, 5)
 line2.fill = COLOR.lines
 PROJECTS:insert(line2)

 local link_img = display.newImageRect("sprites/link.png", 131 / 3, 125 / 3)
 link_img.x = SCREEN.ZERO_X + link_img.width / 1.1
 link_img.y = line2.y - 230
 PROJECTS:insert(link_img)

 local options = {
  text = "Quick Links",     
  x = link_img.x + link_img.width / 1.3 + 200 / 2,
  y = link_img.y,
  width = 200,
  font = FONT,   
  fontSize = 35,
  align = "left"
 }

 local info = display.newText(options)
 info.fill = COLOR.t_panel_on
 PROJECTS:insert(info)

 local list = STR.menu.links
 local links = LINK.quick
 local X, Y = link_img.x + link_img.width / 2 + info.width / 2 - 35, info.y + 70

 for i = 1, #list do
  local options = {
    text = list[i],     
    x = X,
    y = Y,
    width = 210,
    font = FONT,   
    fontSize = 23,
    align = "left"
  }
  name = "LINK " .. tostring(i)

  local name = display.newText(options)
  name.fill = COLOR.t_panel_off
  name.link = links[i]
  name.touch = 'links'
  name:addEventListener("touch", touch)
  PROJECTS:insert(name)

  Y = Y + 70 / 1.3
  if i % 3 == 0 then
   X = X + 210 * 1.1
   Y = info.y + 70
  end
 end

 local new_project = display.newRoundedRect(SCREEN.ZERO_X + sel_width / 3 + sel_width / 2 - sel_width / 10, (panel.y + panel.height / 2) + 150, sel_width, sel_height, 7.5)
 new_project.fill = COLOR.bg
 new_project.strokeWidth = 6
 new_project:setStrokeColor(unpack(COLOR.box))
 new_project.id = 'new'
 new_project.touch = 'selects'
 new_project:addEventListener("touch", touch)
 PROJECTS:insert(new_project)

 local line_new_project = display.newRect(new_project.x, new_project.y - new_project.height / 5, new_project.width, 6)
 line_new_project.fill = COLOR.box
 PROJECTS:insert(line_new_project)

 local title_new_project = display.newText(STR.menu.windows[1], new_project.x, new_project.y + new_project.height / 7, FONT, 23)
 PROJECTS:insert(title_new_project)

 X, Y = new_project.x - sel_width / 3, line_new_project.y - line_new_project.height - 15
 new_project.circles = {}

 for i = 1, 3 do
  name = "CIRCLE_" .. tostring(i)

  local name = display.newCircle(X, Y, 10)
  name.fill = COLOR.circles_off[i]
  name.strokeWidth = 6
  name:setStrokeColor(unpack(COLOR.box))
  PROJECTS:insert(name)

  table.insert(new_project.circles, name)

  X = X + 33
 end

 new_project.line = line_new_project
 new_project.text = title_new_project

 local open_project = display.newRoundedRect(new_project.x + sel_width + sel_width / 3 + sel_width / 10, new_project.y, sel_width, sel_height, 7.5)
 open_project.fill = COLOR.bg
 open_project.strokeWidth = 6
 open_project:setStrokeColor(unpack(COLOR.box))
 open_project.id = 'open'
 open_project.touch = 'selects'
 open_project:addEventListener("touch", touch)
 PROJECTS:insert(open_project)

 local line_open_project = display.newRect(open_project.x, open_project.y - open_project.height / 5, open_project.width, 6)
 line_open_project.fill = COLOR.box
 PROJECTS:insert(line_open_project)

 local title_open_project = display.newText(STR.menu.windows[2], open_project.x, open_project.y + open_project.height / 7, FONT, 23)
 PROJECTS:insert(title_open_project)

 X, Y = open_project.x - sel_width / 3, line_open_project.y - line_open_project.height - 15
 open_project.circles = {}

 for i = 1, 3 do
  name = "CIRCLE_" .. tostring(i)

  local name = display.newCircle(X, Y, 10)
  name.fill = COLOR.circles_off[i]
  name.strokeWidth = 6
  name:setStrokeColor(unpack(COLOR.box))
  PROJECTS:insert(name)

  table.insert(open_project.circles, name)

  X = X + 33
 end

 open_project.line = line_open_project
 open_project.text = title_open_project

 local relaunch_project = display.newRoundedRect(new_project.x, new_project.y + sel_height / 2 + sel_height - sel_height / 10, sel_width, sel_height, 7.5)
 relaunch_project.fill = COLOR.bg
 relaunch_project.strokeWidth = 6
 relaunch_project:setStrokeColor(unpack(COLOR.box))
 relaunch_project.id = 'relaunch'
 relaunch_project.touch = 'selects'
 relaunch_project:addEventListener("touch", touch)
 PROJECTS:insert(relaunch_project)

 local line_relaunch_project = display.newRect(relaunch_project.x, relaunch_project.y - relaunch_project.height / 5, relaunch_project.width, 6)
 line_relaunch_project.fill = COLOR.box
 PROJECTS:insert(line_relaunch_project)

 local title_relaunch_project = display.newText(STR.menu.windows[3], relaunch_project.x, relaunch_project.y + relaunch_project.height / 7, FONT, 23)
 PROJECTS:insert(title_relaunch_project)

 X, Y = relaunch_project.x - sel_width / 3, line_relaunch_project.y - line_relaunch_project.height - 15
 relaunch_project.circles = {}

 for i = 1, 3 do
  name = "CIRCLE_" .. tostring(i)

  local name = display.newCircle(X, Y, 10)
  name.fill = COLOR.circles_off[i]
  name.strokeWidth = 6
  name:setStrokeColor(unpack(COLOR.box))
  PROJECTS:insert(name)

  table.insert(relaunch_project.circles, name)

  X = X + 33
 end

 relaunch_project.line = line_relaunch_project
 relaunch_project.text = title_relaunch_project

 local DOCUMENTATION = native.newWebView( SCREEN.CENTER_X, (panel.y + panel.height / 2) + (SCREEN.SCREEN_HEIGHT - panel.height) / 2, SCREEN.SCREEN_WIDTH, SCREEN.SCREEN_HEIGHT - panel.height )
 DOCUMENTATION:request( LINK.select_panel[1] )
 DOCUMENTATION.isVisible = false
 M.scene:insert(DOCUMENTATION)

 local FORUMS = native.newWebView( DOCUMENTATION.x, DOCUMENTATION.y, DOCUMENTATION.width, DOCUMENTATION.height )
 FORUMS:request( LINK.select_panel[2] )
 FORUMS.isVisible = false
 M.scene:insert(FORUMS)

 local projects = display.newText(STR.menu.top_panel_list[1], 0, panel.y + 10, FONT, 25)
 projects.x = bg.x - bg.width / 2 + projects.width / 1.3
 projects.fill = COLOR.t_panel_off
 projects.id = PROJECTS
 projects.touch = 'select_panel'
 projects:addEventListener("touch", touch)
 M.scene:insert(projects)

 local documentation = display.newText(STR.menu.top_panel_list[2], 0, projects.y, FONT, 25)
 documentation.x = projects.x + projects.width / 2 + documentation.width / 1.5
 documentation.fill = COLOR.t_panel_off
 documentation.id = DOCUMENTATION
 documentation.touch = 'select_panel'
 documentation:addEventListener("touch", touch)
 M.scene:insert(documentation)

 local forums = display.newText(STR.menu.top_panel_list[3], documentation.x + 175, projects.y, FONT, 26)
 forums.x = documentation.x + documentation.width / 2 + forums.width / 1.1
 forums.fill = COLOR.t_panel_off
 forums.id = FORUMS
 forums.touch = 'select_panel'
 forums:addEventListener("touch", touch)
 M.scene:insert(forums)

 M.select_panel = display.newRect(0, panel.y + panel.height / 2 - 13 / 2, 0, 10)
 M.select_panel.fill = COLOR.select_panel
 M.scene:insert(M.select_panel)

 local logo = display.newImageRect("sprites/logo.png", 175.5, 66.3)
 logo.x = bg.x + bg.width / 2 - logo.width / 1.6
 logo.y = panel.y
 logo.touch = 'logo'
 logo:addEventListener("touch", touch)
 M.scene:insert(logo)

 require 'scenes.menu.functions'.F_SELECT_PANEL(projects)

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