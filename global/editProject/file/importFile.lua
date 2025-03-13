return function( path )
    local function copyFileToDocuments(sourcePath, destFilename)
        local destPath = system.pathForFile(EDIT_PROJECT.name .. "/" .. destFilename, system.DocumentsDirectory)
        local file, errorMsg = io.open(sourcePath, "rb")
        local data = file:read("*a")
        file:close()
    
        local destFile, errorMsg2 = io.open(destPath, "wb")
        destFile:write(data)
        destFile:close()
        return true
    end
    
    local function onFileSelected(event)
        if event.action == "selected" then
            local sourcePath = event.url
            local destFilename = event.filename
            local success = copyFileToDocuments(sourcePath, destFilename)
        end
    end
    native.showPopup("openFile", { listener = onFileSelected })
end