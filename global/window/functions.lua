local M = {}

M['del'] = function( e )
 if WINDOW[e.name] then
  display.remove(WINDOW[e.name])
  WINDOW[e.name] = nil
 end
 return true
end

return M