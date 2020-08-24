local composer = require( "composer" )
local scene = composer.newScene()
local dbJsonLib = require "dbJsonLib";

setLanguage()

local centerX = display.contentCenterX;
local centerY = display.contentCenterY;
-- local _W = display.contentWidth / 2
-- local _H = display.contentHeight / 2

-- -----------------------------------------------------------------------------------------------------------------
-- All code outside of the listener functions will only be executed ONCE unless "composer.removeScene()" is called.
-- -----------------------------------------------------------------------------------------------------------------

-- "scene:create()"
function scene:create( event )
    _G.lastScene = "menu";
    local group = self.view

    local flag1, flag2, flag3, flag4, flag5, flag6, lbtitle, lbtitle1

    -- Background image
    local bg = display.newImageRect(group, "resource/IMG/".._G.kBG, _G.totalWidth, _G.totalHeight);
      bg.x, bg.y = centerX, centerY;

    lbtitle = display.newText(group,translations["lengTitle"][language], 0, 0, fontNameGlobal, ((_G.totalHeight/7)))
    lbtitle.x, lbtitle.y = centerX, _G.topSide + 100
    lbtitle:setFillColor( 0,0,0)
    
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
        composer.gotoScene("menu", "slideDown");
    end

    local function touchHandler ( event )
        if "ended" == event.phase then

            if event.target.name == "flag1" then
                language = "en"
                dbJsonLib.setSaveValue('language', language, true)
            elseif event.target.name == "flag2" then
                language = "br"
                dbJsonLib.setSaveValue('language', language, true)
            elseif event.target.name == "flag3" then
                language = "de"
                dbJsonLib.setSaveValue('language', language, true)
            elseif event.target.name == "flag4" then
                language = "es"
                dbJsonLib.setSaveValue('language', language, true)
            elseif event.target.name == "flag5" then
                language = "it"
                dbJsonLib.setSaveValue('language', language, true)
            elseif event.target.name == "flag6" then
                language = "fr"
                dbJsonLib.setSaveValue('language', language, true)
            end
            audio.play(buttonSFX, {channel = audio.findFreeChannel()});
            composer.gotoScene( "menu", { effect = "slideDown"} )
        end
    end

    -- loads the country flags with event listeners
    flag1 = display.newImageRect(group,"resource/IMG/usa.png", 124, 124) 
    flag1.x = centerX - 300;
    flag1.y = centerY - 50;
    flag1.name = "flag1"
    flag1:addEventListener( "touch",touchHandler );

    flagText1 = display.newText(group, "English",0,0,fontNameGlobal, 60)
    flagText1.x = flag1.x
    flagText1.y =  flag1.y + 80
    flagText1:setFillColor( 0,0,0)

    flag2 = display.newImageRect(group,"resource/IMG/brasil.png", 124, 124) 
    flag2.x = centerX;
    flag2.y = centerY - 50;
    flag2.name = "flag2"
    flag2:addEventListener( "touch",touchHandler );

    flagText2 = display.newText(group, "Português",0,0,fontNameGlobal, 60)
    flagText2.x = flag2.x
    flagText2.y =  flag2.y + 80
    flagText2:setFillColor( 0,0,0)

    flag3 = display.newImageRect(group,"resource/IMG/germany.png", 124, 124) 
    flag3.x = centerX + 300;
    flag3.y = centerY - 50;
    flag3.name = "flag3"
    flag3:addEventListener( "touch",touchHandler );

    flagText3 = display.newText(group, "Deutsch",0,0,fontNameGlobal, 60)
    flagText3.x = flag3.x
    flagText3.y =  flag3.y + 80
    flagText3:setFillColor( 0,0,0)


    flag4 = display.newImageRect(group,"resource/IMG/spain.png", 124, 124) 
    flag4.x = centerX - 300;
    flag4.y = centerY + 120;
    flag4.name = "flag4"
    flag4:addEventListener( "touch",touchHandler );

    flagText4 = display.newText(group, "Español",0,0,fontNameGlobal, 60)
    flagText4.x = flag4.x
    flagText4.y =  flag4.y + 80
    flagText4:setFillColor( 0,0,0)


    flag5 = display.newImageRect(group,"resource/IMG/italy.png", 124, 124) 
    flag5.x = centerX;
    flag5.y = centerY + 120;
    flag5.name = "flag5"
    flag5:addEventListener( "touch",touchHandler );

    flagText5 = display.newText(group, "Italia",0,0,fontNameGlobal, 60)
    flagText5.x = flag5.x
    flagText5.y =  flag5.y + 80
    flagText5:setFillColor( 0,0,0)


    flag6 = display.newImageRect(group,"resource/IMG/france.png", 124, 124) 
    flag6.x = flag5.x + 300;
    flag6.y = centerY + 120;
    flag6.name = "flag6"
    flag6:addEventListener( "touch",touchHandler );

    flagText6 = display.newText(group, "Français",0,0,fontNameGlobal, 60)
    flagText6.x = flag6.x
    flagText6.y =  flag6.y + 80
    flagText6:setFillColor( 0,0,0)

end


-- "scene:show()"
function scene:show( event )

    local sceneGroup = self.view
    local phase = event.phase
    
    if ( phase == "will" ) then
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
    -- composer.removeScene( "lenguajes", true )
    -- Called prior to the removal of scene's view ("sceneGroup").
    -- Insert code here to clean up the scene.
    -- Example: remove display objects, save state, etc.
end


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