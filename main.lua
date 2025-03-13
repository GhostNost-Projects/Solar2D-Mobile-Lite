display.setStatusBar(display.HiddenStatusBar)
display.setStatusBar(display.TranslucentStatusBar)
display.setStatusBar(display.HiddenStatusBar)

originalPackagePath = package.path
originalNewImage = display.newImage
originalNewImageRect = display.newImageRect
originalTimerPerformWithDelay = timer.performWithDelay
originalLoadSound = audio.loadSound
originalLoadStream = audio.loadStream
originalNewImageSheet = graphics.newImageSheet

require 'local.start'()
lfs.mkdir( PATH )
MENU.create()