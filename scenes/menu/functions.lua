local M = {}
local lastSelected, lastSelectedGroup = nil, nil



M['F_SELECT_PANEL'] = function( e )
 transition.to( MENU.select_panel, { time=100, x=e.x, width=e.width } )

 if lastSelected and lastSelected ~= e
 then lastSelected.fill = COLOR.t_panel_off end
 lastSelected = e
 e.fill = COLOR.t_panel_on
 
 if lastSelectedGroup and lastSelectedGroup ~= e.id
 then lastSelectedGroup.isVisible = false end
 lastSelectedGroup = e.id
 e.id.isVisible = true
end

M['delete_scene'] = function()
 display.remove(MENU.scene)
 MENU.scene = nil
end

return M