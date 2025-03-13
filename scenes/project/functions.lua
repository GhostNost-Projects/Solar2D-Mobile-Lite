local M = {}
local path = require 'local.load_solar2d'



M['del_all'] = function()
 local STAGE_1 = display.getCurrentStage()
 for _=1, STAGE_1.numChildren do
  STAGE_1[1]:removeSelf()
  STAGE_1[1] = nil
  collectgarbage()
 end
end

M['back'] = function( e )
 if e.keyName == "back" then
  if e.phase == "up" then
   M.del_all()
   for key, value in pairs(path) do
    value()
   end
   EDIT_PROJECT = require 'scenes.edit-project.scene'
   require 'global.open-project'( {file = EDIT_PROJECT.name } )
   Runtime:removeEventListener("key", M.back)
   return true
  end
 end
 return false
end

return M