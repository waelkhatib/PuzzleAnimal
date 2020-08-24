local composer = require( "composer" )
local scene = composer.newScene()
local widget = require("widget")
local dbJsonLib = require "dbJsonLib";

local centerX = display.contentCenterX;
local centerY = display.contentCenterY;

local iconEasy, iconHard , iconEasyOff, iconHardOff, diffic

-- "scene:create()"
function scene:create( event )
    _G.lastScene = "menu";
    local group = self.view

    local tf2, lbHard, lbEasy,
    dogHardshadow, dogHardPuzzle, lbHardHelp,
    dogEasyshadow, dogEasyPuzzle, lbEasyHelp

         -- Background image
    local bg = display.newImageRect(group, "resource/IMG/".._G.kBG, _G.totalWidth, _G.totalHeight);
    bg.x, bg.y = centerX, centerY;
    diffic = dbJsonLib.getSaveValue('Deffic')
    
    local function hardToggle(event)
    if (event.phase=="ended")  then
        dbJsonLib.setSaveValue("Deffic","hard", true)
        iconEasy.isVisible = false
        iconHard.isVisible = true
        iconHardOff.isVisible = false
        audio.play(buttonSFX, {channel = audio.findFreeChannel()});
        composer.gotoScene( "menu", { effect = "slideDown", time = 800 } )
    end
    return true -- indicates touch event was handled
    end

    local function easyToggle(event)
        if (event.phase=="ended")  then
            dbJsonLib.setSaveValue("Deffic","easy", true)
            iconEasy.isVisible = true
            iconHard.isVisible = false
            iconHardOff.isVisible = true
            audio.play(buttonSFX, {channel = audio.findFreeChannel()});
            composer.gotoScene( "menu", { effect = "slideDown", time = 800 } )
        end
        return true -- indicates touch event was handled
    end

    local closeButton = dbJsonLib.newSimpleButton(group, "resource/IMG/".._G.kClose, 100, 100);
    closeButton.x, closeButton.y = _G.rightSide - 70 , _G.topSide + 70;
    function closeButton:touchBegan()
        self:setFillColor(.5, .5, .5);
        self.xScale, self.yScale = .9, .9;
    end
    function closeButton:touchEnded()
        audio.play(buttonSFX, {channel = audio.findFreeChannel()});
        self:setFillColor(1, 1, 1);
        self.xScale, self.yScale = 1, 1;
        _G.BlastScene = false;
        composer.gotoScene("menu", "slideDown");
    end

    separador = display.newImageRect(group, "resource/IMG/separador.png", 20, 700 )
    separador.y = centerY
    separador.x = centerX
    

    iconEasyOff = display.newImageRect( group,"resource/IMG/okOff.png", 75, 75 )
    iconEasyOff.y = centerY/2 - 100
    iconEasyOff.x = centerX/2 - 30
    iconEasyOff:addEventListener("touch", easyToggle)
    

    iconEasy = display.newImageRect(group, "resource/IMG/ok.png", 75, 75 )
    iconEasy.y = centerY/2 - 100
    iconEasy.x = centerX/2 - 30
    iconEasy:addEventListener("touch", easyToggle)
    

    lbEasy = display.newText(group,translations["EASY"][language], 0, 0, fontNameGlobal, 50)
    lbEasy.x, lbEasy.y = iconEasy.x + lbEasy.width + lbEasy.height - 35, iconEasy.y 
    lbEasy:setFillColor ( 0,0,0 )
    lbEasy:addEventListener("touch", easyToggle)
    

    iconHardOff = display.newImageRect(group,"resource/IMG/okOff.png", 75, 75 )
    iconHardOff.y = centerY/2 - 100
    iconHardOff.x = centerX +  iconHardOff.width
    iconHardOff:addEventListener("touch", hardToggle)
    

    iconHard = display.newImageRect(group, "resource/IMG/ok.png", 75, 75 )
    iconHard.y = centerY/2 - 100
    iconHard.x = centerX +  iconHard.width
    iconHard:addEventListener("touch", hardToggle)
    

    lbHard = display.newText(group,translations["HARD"][language], 0, 0, fontNameGlobal, 50)
    lbHard.x, lbHard.y = iconHard.x + lbHard.width + lbHard.height, iconHard.y
    lbHard:setFillColor ( 0,0,0 )
    lbHard:addEventListener("touch", hardToggle)
    
    
    dogHardshadow = display.newImageRect(group,"resource/IMG/dogshadowhard.png", 400, 400 )
    dogHardshadow.y = centerY
    dogHardshadow.x =  lbHard.x + 50
    dogHardshadow:addEventListener("touch", hardToggle)
    
    
    dogHardPuzzle = display.newImageRect(group, "resource/IMG/doghard.png", 320/2, 398/2)
    dogHardPuzzle.y = centerY/2 +  dogHardshadow.y
    dogHardPuzzle.x = _G.rightSide - dogHardPuzzle.width/2 - 10
    dogHardPuzzle:addEventListener("touch", hardToggle)
    
    
    lbHardHelp = display.newText(group,translations["info2"][language] , 15, 250, 300, 400,  native.systemFont, 30 )
    lbHardHelp.y = _G.bottomSide + dogHardPuzzle.width/2  -  95
    lbHardHelp.x = separador.x + lbHardHelp.width - 20
    lbHardHelp:setFillColor ( 0,0,0 )
    lbHardHelp:addEventListener("touch", hardToggle)
    
    
    dogEasyshadow = display.newImageRect(group, "resource/IMG/dogshadoweasy.png", 400, 400 )
    dogEasyshadow.y = centerY
    dogEasyshadow.x =  _G.leftSide + dogEasyshadow.width/2 + 30
    dogEasyshadow:addEventListener("touch", easyToggle)
    
    
    dogEasyPuzzle = display.newImageRect(group, "resource/IMG/dogeasy.png", 320/2, 398/2)
    dogEasyPuzzle.y = centerY/2 + dogEasyshadow.y
    dogEasyPuzzle.x = lbEasy.x + 20--centerX - separador.width
    dogEasyPuzzle:addEventListener("touch", easyToggle)
    
    lbEasyHelp = display.newText(group,translations["info1"][language] , 15, 250, 300, 400,  native.systemFont, 30 )
    lbEasyHelp.y = dogEasyPuzzle.y +  lbEasyHelp.height/2 + 10
    lbEasyHelp.x = _G.leftSide + lbEasyHelp.width - 50
    lbEasyHelp:setFillColor ( 0,0,0 )
    lbEasyHelp:addEventListener("touch", easyToggle)
    
  
end


-- "scene:show()"
function scene:show( event )

    local sceneGroup = self.view
    local phase = event.phase

    setLanguage()
    
    if ( phase == "will") then
        diffic = dbJsonLib.getSaveValue('Deffic')
        
        if (diffic == "easy") then
            iconEasy.isVisible = true
            iconHard.isVisible = false
            iconHardOff.isVisible = true
        else 
            iconEasy.isVisible = false
            iconHard.isVisible = true
            iconHardOff.isVisible = false
        end
    if ( system.getInfo("platformName") == "Android" ) then
       local androidVersion = string.sub( system.getInfo( "platformVersion" ), 1, 3)
       if( androidVersion and tonumber(androidVersion) >= 4.4 ) then
         native.setProperty( "androidSystemUiVisibility", "immersiveSticky" )
         --native.setProperty( "androidSystemUiVisibility", "lowProfile" )
       elseif( androidVersion ) then
         native.setProperty( "androidSystemUiVisibility", "lowProfile" )
       end
    end

    elseif ( phase == "did" ) then    
        --        
    end
end

-- "scene:destroy()"
function scene:destroy( event )

    local sceneGroup = self.view
    -- composer.removeScene( "setting", true )
    -- Called prior to the removal of scene's view ("sceneGroup").
    -- Insert code here to clean up the scene.
    -- Example: remove display objects, save state, etc.
end


-- "scene:hide()"
function scene:hide( event )
    local sceneGroup = self.view

    local phase = event.phase

    if ( phase == "will" ) then
      local removeAll;
    
      removeAll = function(group)
        if group.enterFrame then
          Runtime:removeEventListener("enterFrame", group);
        end
        if group.touch then
          group:removeEventListener("touch", group);
          Runtime:removeEventListener("touch", group);
        end     
        for i = group.numChildren, 1, -1 do
          if group[i].numChildren then
            removeAll(group[i]);
          else
            if group[i].enterFrame then
              Runtime:removeEventListener("enterFrame", group[i]);
            end
            if group[i].touch then
              group[i]:removeEventListener("touch", group[i]);
              Runtime:removeEventListener("touch", group[i]);
            end
          end
        end
      end

      removeAll(self.view);
        -- Called when the scene is on screen (but is about to go off screen).
        -- Insert code here to "pause" the scene.
        -- Example: stop timers, stop animation, stop audio, etc.
    elseif ( phase == "did" ) then
        -- Called immediately after scene goes off screen.
    end
end

-- -------------------------------------------------------------------------------

-- Listener setup
scene:addEventListener( "create", scene )
scene:addEventListener( "show", scene )
scene:addEventListener( "destroy", scene )
scene:addEventListener( "hide", scene )

-- -------------------------------------------------------------------------------

return scene