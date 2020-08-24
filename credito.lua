local composer = require( "composer" )
local scene = composer.newScene()
local widget = require("widget")
local dbJsonLib = require "dbJsonLib";


setLanguage()

local centerX = display.contentCenterX;
local centerY = display.contentCenterY;
local particle
-- local _W = display.contentWidth / 2
-- local _H = display.contentHeight / 2

-- -----------------------------------------------------------------------------------------------------------------
-- All code outside of the listener functions will only be executed ONCE unless "composer.removeScene()" is called.
-- -----------------------------------------------------------------------------------------------------------------

-- "scene:create()"
function scene:create( event )
  _G.lastScene = "about";
  _G.BlastScene = true
	local group = self.view

print( composer.getSceneName( "current" ) )
print( composer.getSceneName( "previous" ) )
print( composer.getSceneName( "overlay" ) )
-- Background image
    local bg = display.newImageRect(group, "resource/IMG/".._G.kBG, _G.totalWidth, _G.totalHeight);
      bg.x, bg.y = centerX, centerY;

    local lbtitle = display.newText(group,translations["Credito"][language], 0, 0, fontNameGlobal, ((_G.totalHeight/7)))
    lbtitle.x, lbtitle.y = centerX, _G.topSide + 70
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
        if(particle)then 
              timer.cancel(particle)
              emitter = nil
        end     
        _G.BlastScene = false;
        composer.gotoScene("about", "slideUp");
    end
   
    local emitter
    local mRand = math.random
    particle = timer.performWithDelay( 100, 
      function()
        emitter = dbJsonLib.newEmitter( _G.kParticle, _G.kParticlePNG)
        emitter.x = mRand( 50, _G.totalWidth)
        emitter.y = mRand( 50, _G.totalHeight)
    end, -1 )

    timer.performWithDelay( 5000,
        function()
            if(particle)then 
                timer.cancel(particle)
                emitter = nil
            end                               
    end)

    local lbDesign = display.newText(group, _G.kLbDesing, 0, 0, fontNameGlobal, ((_G.totalHeight/14)))
    lbDesign.x, lbDesign.y = centerX, lbtitle.y + 110
    lbDesign:setFillColor( 0,0,0)

    local textDesign = display.newText(group, _G.kValDesign , 0, 0, native.systemFont, ((_G.totalHeight/30)))
    textDesign.x, textDesign.y = centerX, lbDesign.y + 50

    local lbprogramming = display.newText(group, _G.kLbProgramming , 0, 0, fontNameGlobal, ((_G.totalHeight/14)))
    lbprogramming.x, lbprogramming.y = centerX, textDesign.y + 50
    lbprogramming:setFillColor( 0,0,0)

    local textProgramming = display.newText(group, _G.kValProgramming, 0, 0, native.systemFont, ((_G.totalHeight/30)))
    textProgramming.x, textProgramming.y = centerX, lbprogramming.y + 50

    local lbQA = display.newText(group, _G.kLbQA , 0, 0, fontNameGlobal, ((_G.totalHeight/14)))
    lbQA.x, lbQA.y = centerX, textProgramming.y + 50
    lbQA:setFillColor( 0,0,0)

    local textQA = display.newText(group, _G.kValQA , 0, 0, native.systemFont, ((_G.totalHeight/30)))
    textQA.x, textQA.y = centerX, lbQA.y + 50

   local lbCow = display.newText(group, _G.kLbCowBoy , 0, 0, fontNameGlobal, ((_G.totalHeight/14)))
    lbCow.x, lbCow.y = centerX, textQA.y + 50
    lbCow:setFillColor( 0,0,0)

   local textCow = display.newText(group, _G.kValCowBoy, 0, 0, native.systemFont, ((_G.totalHeight/30)))
    textCow.x, textCow.y = centerX, lbCow.y + 50

    local textOther = display.newText(group, _G.kOtherValues1, 0, 0, native.systemFont, ((_G.totalHeight/30)))
    textOther.x, textOther.y = centerX, textCow.y + 60

    local textOther1 = display.newText(group, _G.kOtherValues2 , 0, 0, native.systemFont, ((_G.totalHeight/30)))
    textOther1.x, textOther1.y = centerX, textOther.y + 40

    local title = display.newImageRect(group,_G.kLogoGames , 500, 78)
    title.x , title.y = centerX, _G.bottomSide - 80
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
      _G.BlastScene = false
    
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