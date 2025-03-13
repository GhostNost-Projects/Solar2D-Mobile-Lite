return function()
 display.setDefault("magTextureFilter", "nearest")
 lfs = require( "lfs" )
 json = require( "dkjson" )
 appVersion = system.getInfo("appVersionString")
 require 'global.screen'.Installing_the_screen()
 SCREEN = require 'global.screen'.VARS
 COLOR = require 'local.colors'
 LINK = require 'local.links'
 FONT = "ubuntu.ttf"
 PATH = system.pathForFile("Apps", system.DocumentsDirectory)
 STR = require 'local.strings'
 FILE_TYPES = require 'local.file_types'
 MENU = require 'scenes.menu.scene'
 PROJECT = require 'scenes.project.scene'
 EDIT_PROJECT = require 'scenes.edit-project.scene'
 WINDOW = require 'global.window.display'
end