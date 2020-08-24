-- settings.lua, Created by hoan
-- http://developer.coronalabs.com/code/settingslua-storing-info

-- Nothing in the file needs to be amended.

module(..., package.seeall)

function settingdata.set(key, value)
    
    _G.__settings[key] = value
    
    settingdata.save()
end

function settingdata.get(key)
    if _G.__settings then
        return _G.__settings[key]
    else
        return nil
    end
end

function settingdata.save()
    local json = require("json")
    local path = system.pathForFile("settings.json", system.DocumentsDirectory)
    local fh = io.open(path, "w")
    
    fh:write(json.encode(_G.__settings))
    io.close(fh)
    fh = nil
end

function settingdata.load()
    local json = require("json")
    local path = system.pathForFile("settings.json", system.DocumentsDirectory)
    local fh, reason = io.open(path, "r")
    
    if fh then
        -- read all contents of file into a string
        local contents = fh:read("*a")
        
        local succ, data = pcall(function()
            return json.decode(contents)
        end)
        
        if succ and data then
            _G.__settings = data
        else
            _G.__settings = {}
        end    
        
        io.close( fh)
        fh = nil
        -- print("Loaded settings")
    else
        -- print("No settings file found. \n Creating settings file")
        
        -- create file because it doesn't exist yet
        _G.__settings = {}
        settingdata.save()
    end
    
end

function doesFileExist( fname, path )

    local results = false

    local filePath = system.pathForFile( fname, path )

    --filePath will be 'nil' if file doesn't exist and the path is 'system.ResourceDirectory'
    if ( filePath ) then
        filePath = io.open( filePath, "r" )
    end

    if ( filePath ) then
        print( "File found: " .. fname )
        --clean up file handles
        filePath:close()
        results = true
    else
        print( "File does not exist: " .. fname )
    end

    return results
end


function settingdata.newEmitter(fileName, textureFileName, baseDir)
    local json = require("json")
    local path = system.pathForFile( fileName, baseDir)
	print("VAlues "..path)
    local fh, reason = io.open(path, "r")
    
    if fh then
        -- read all contents of file into a string
        local contents = fh:read("*a")
        
        local succ, data = pcall(function()
            print("Resultado Files")
            return json.decode(contents)
        end)
        
        if succ and data then
            print("Tiene data Files")
            _G.__settings = data
            data.textureFileName = textureFileName
            for k,v in pairs(data) do      
                data[k] = tonumber(v) or v
                --print(k,emitterParams[k])
            end
            local emitter = display.newEmitter( data )
            return emitter
        else
            print("not data Files")
            _G.__settings = {}
        end    
        print("Close  Files")
        io.close( fh)
        fh = nil
        -- print("Loaded settings")
    else
        print("No settings file found. \n Creating settings file")
        
        -- create file because it doesn't exist yet
        _G.__settings = {}
        settingdata.save()
    end
    -- io.close( fh)
    -- fh = nil
end