local dbJsonLib = {};

dbJsonLib.getSaveValue = function(key)
  if not dbJsonLib.saveTable then
    local path = system.pathForFile("savedData.json", system.DocumentsDirectory);
    local fh = io.open(path, "r");
    if fh then
      local json = require "json";
      dbJsonLib.saveTable = json.decode(fh:read("*a"));
      io.close(fh);
    end
  end
  dbJsonLib.saveTable = dbJsonLib.saveTable or {};
  return dbJsonLib.saveTable[key];
end

dbJsonLib.setSaveValue = function(key, value, operateSave)
  if not dbJsonLib.saveTable then
    local path = system.pathForFile("savedData.json", system.DocumentsDirectory);
    local fh = io.open(path, "r");
    if fh then
      local json = require "json";
      dbJsonLib.saveTable = json.decode(fh:read("*a"));
      io.close(fh);
    end
  end
  dbJsonLib.saveTable = dbJsonLib.saveTable or {};
  dbJsonLib.saveTable[key] = value;
  if operateSave then
    local path = system.pathForFile("savedData.json", system.DocumentsDirectory);
    local fh = io.open(path, "w+");
    local json = require "json";
    fh:write(json.encode(dbJsonLib.saveTable));
    io.close(fh);
  end
  return dbJsonLib.saveTable[key];
end

dbJsonLib.newComplexButton = function(group, img1, width1, height1, img2, width2, height2, offsetX, offsetY)
  local button = display.newGroup();
  group:insert(button);
  local button1 = display.newImageRect(button, img1, width1, height1);
  local button2 = display.newImageRect(button, img2, width2, height2);
  button2.x, button2.y = offsetX or 0, offsetY or 0;
  button2.isVisible = false;
  function button:touch(event)
    if event.phase == "began" then
      audio.play(_G.buttonSFX, {channel = audio.findFreeChannel()});
      display.getCurrentStage():setFocus(self);
      self.isFocus = true;
      if self.touchBegan then
        self:touchBegan();
      end
      return true;
    elseif event.phase == "moved" and self.isFocus then
      local bounds = self.contentBounds;
      if event.x > bounds.xMax or event.x < bounds.xMin or event.y > bounds.yMax or event.y < bounds.yMin then
        self.isFocus = false;
        display.getCurrentStage():setFocus(nil);
        if self.touchEnded then
          self:touchEnded();
        end
      end
      return true;
    elseif event.phase == "ended" and self.isFocus then
      self.isFocus = false;
      display.getCurrentStage():setFocus(nil);
      if self.touchEnded then
        self:touchEnded();
      end
      return true;
    end
  end
  button:addEventListener("touch", button);
  
  return button;
end
dbJsonLib.newSimpleButton = function(group, img, width, height)
  local button = display.newImageRect(group or display.getCurrentStage(), img, width, height);
  function button:touch(event)
    if event.phase == "began" then
      display.getCurrentStage():setFocus(self);
      self.isFocus = true;
      if self.touchBegan then
        self:touchBegan();
      end
      return true;
    elseif event.phase == "moved" and self.isFocus then
      local bounds = self.contentBounds;
      if event.x > bounds.xMax or event.x < bounds.xMin or event.y > bounds.yMax or event.y < bounds.yMin then
        self.isFocus = false;
        display.getCurrentStage():setFocus(nil);
        if self.touchEnded then
          self:touchEnded();
        end
      end
      return true;
    elseif event.phase == "ended" and self.isFocus then
      self.isFocus = false;
      display.getCurrentStage():setFocus(nil);
      if self.touchEnded then
        self:touchEnded();
      end
      return true;
    end
  end
  button:addEventListener("touch", button);
  
  return button;
end

dbJsonLib.convertRGB = function(r, g, b)
   return {r/255, g/255, b/255};
end

function dbJsonLib.save()
    local json = require("json")
    local path = system.pathForFile("settings.json", system.DocumentsDirectory)
    local fh = io.open(path, "w")
    fh:write(json.encode(_G.__settings))
    io.close(fh)
    fh = nil
end

function dbJsonLib.newEmitter(fileName, textureFileName, baseDir)
    local json = require("json")
    local path = system.pathForFile( fileName, baseDir)
    local fh, reason = io.open(path, "r")
    
    if fh then
        -- read all contents of file into a string
        local contents = fh:read("*a")
        local succ, data = pcall(function()
            return json.decode(contents)
        end)
        
        if succ and data then
            _G.__settings = data
            data.textureFileName = textureFileName
            for k,v in pairs(data) do      
                data[k] = tonumber(v) or v
                --print(k,emitterParams[k])
            end
            local emitter = display.newEmitter( data )
            return emitter
        else
            _G.__settings = {}
        end    
        io.close( fh)
        fh = nil
    else
        -- create file because it doesn't exist yet
        _G.__settings = {}
        settingdata.save()
    end
    -- io.close( fh)
    -- fh = nil
end

return dbJsonLib;
