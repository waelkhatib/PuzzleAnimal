local composer = require( "composer" )
local scene = composer.newScene()
local widget = require("widget")
local dbJsonLib = require "dbJsonLib";
local sheetInfo   = require( "data" )
local MultiTouch = require("dmc_multitouch")
local libADS = require "lib.libADS";


local centerX = display.contentCenterX;
local centerY = display.contentCenterY;


-- "scene:create()"
function scene:create( event )
    _G.lastScene = "menu";
    if ( system.getInfo( "platformName" ) ~= "WinPhone" ) then 
        libADS.removeAd("during_game");
        libADS.showAd("during_game");
        libADS.showLogEvent("Games scene");
    end
    local group = self.view
    local params =  event.params
    local imageHidded = {}
    local imagePuzzle = {}
    local xDisplays={}
    local yDisplays={}

    if (params ~= nil) then
                  objName = params.objName
          indexObjAnimals = params.indexObjAnimals
    end


    local circleDone = false
    setLanguage()
    local diffic = dbJsonLib.getSaveValue("Deffic")

    local function winner (event)
      local options = {
         params = {
            objNameWin = objName,
       indexObjAnimals = indexObjAnimals
         }
      }
      if (circleDone == true ) then
        composer.gotoScene( "wingame", options)
      end
    end

    -- Background image
    local bg = display.newImageRect(group, "resource/IMG/bg.png", _G.totalWidth, _G.totalHeight);
    bg.x, bg.y = centerX, centerY;
    diffic = dbJsonLib.getSaveValue('Deffic')


    local lLVSImage = require("resource.LVLS."..objName )
    
    local myImageSheet = graphics.newImageSheet("resource/LVLS/"..objName..".png", lLVSImage:getSheet() )
    
    data = sheetInfo:getPuzzle(objName)
    
    if (diffic == "easy") then
        imageshadowEasy = display.newImage(group,myImageSheet, lLVSImage:getFrameIndex(objName.."_1"))
        imageshadowEasy.x = centerX;
        imageshadowEasy.y = centerY;
    else
        imageshadowHard = display.newImage(group,myImageSheet, lLVSImage:getFrameIndex(objName.."_2"))
        imageshadowHard.x = centerX;
        imageshadowHard.y = centerY;
    end
print("display.contentCenterX="..display.contentCenterX)
print("display.contentCentery="..display.contentCenterY)
    for i=1,data.pCount do
        local x = data["puzzle"]["a"..tostring(i)].x
        local y = data["puzzle"]["a"..tostring(i)].y
        imageHidded[i] = display.newImage(group,myImageSheet, lLVSImage:getFrameIndex("a_"..tostring(i)));
        imageHidded[i].name = "a_"..tostring(i) 
        imageHidded[i].x = display.contentCenterX + x --data[1]["puzzle"..tostring(i)].x
        imageHidded[i].y = display.contentCenterY + y --data[1]["puzzle"..tostring(i)].x
        imageHidded[i]:setFillColor( 0, 0, 0 )
        imageHidded[i].alpha = 0.001
        MultiTouch.activate(imageHidded[i], "move", "single");
        if (diffic ~= "easy") then
			print("not easy")
            imagePuzzle[i] = display.newImage(myImageSheet, lLVSImage:getFrameIndex("w_"..tostring(i)));
            imagePuzzle[i].name = "a_"..tostring(i) 
            imagePuzzle[i].x = display.contentCenterX + x --dataObject["puzzle"]["a"..tostring(i)].x 
            imagePuzzle[i].y = display.contentCenterY + y --dataObject["puzzle"]["a"..tostring(i)].y 
            -- imagePuzzle[i].alpha = 0.8
        else 
		    print("easy")	
            imagePuzzle[i] = display.newImage(myImageSheet, lLVSImage:getFrameIndex("a_"..tostring(i)));
            imagePuzzle[i].name = "a_"..tostring(i) 
            imagePuzzle[i].x = display.contentCenterX + x --dataObject["puzzle"]["a"..tostring(i)].x 
            imagePuzzle[i].y = display.contentCenterY + y --dataObject["puzzle"]["a"..tostring(i)].y 
			 print( "imagePuzzle[i].x ="..imagePuzzle[i].x.." imagePuzzle[i].y ="..imagePuzzle[i].y )
					print( "imageHidded[i].x ="..imageHidded[i].x.." imageHidded[i].y ="..imageHidded[i].y )
        end
        group:insert( imagePuzzle[i])
    end
	
    local emitter
    local j =math.random(5)    
	print("j="..j)
    local countCompleted = 0
    function puzzletimer()
         
        audio.play(effectelements, {channel = audio.findFreeChannel()});

         for i=1,data.pCount do
            local x = data["puzzle"]["a"..tostring(i)].x
            local y = data["puzzle"]["a"..tostring(i)].y
            
            xDisplays[i] = display.contentCenterX + data["posPuzzle"..tostring(j)]["a"..tostring(i)].x
            yDisplays[i] = display.contentCenterY + data["posPuzzle"..tostring(j)]["a"..tostring(i)].y

            transition.to( imagePuzzle[i], { x=xDisplays[i], y=yDisplays[i] , time=500})
			
            MultiTouch.activate(imagePuzzle[i], "move", "single");
			
            -- Set initial variables to 0
            local pPosX = 0;
            local pPosY = 0;
            -- User drag interaction on Puzzle
            local function pointDrag (event)
                local t = event.target
        --      imagePuzzle[1].x=imagePuzzle[2].x
	--imagePuzzle[1].y=imagePuzzle[2].y
                if event.phase == "began" then
                    local parent = t.parent
                    parent:insert( t )
                    display.getCurrentStage():setFocus( t )
                    t.isFocus = true

                elseif t.isFocus == true then
                       if event.phase == "ended" or event.phase == "cancelled" then
                            display.getCurrentStage():setFocus( nil )
                            t.isFocus = false
                        end
                end

                --If user touches & drags circle, follow the user's touch
                if event.phase == "moved" then
                    isTouchEnabled = true
                    print( "imagePuzzle[i].x ="..imagePuzzle[i].x.." imagePuzzle[i].y ="..imagePuzzle[i].y )
					print( "imageHidded[i].x ="..imageHidded[i].x.." imageHidded[i].y ="..imageHidded[i].y )
                    pPosX = imagePuzzle[i].x - imageHidded[i].x; 
                    pPosY = imagePuzzle[i].y - imageHidded[i].y;
                    
                    if (pPosX < 0) then
                        pPosX = pPosX * -1;
                    end

                    if (pPosY < 0) then
                        pPosY = pPosY * -1;
                    end

                    -- -- If user drags circle within 50 pixels of center of outline, snap into middle
                    if (pPosX <= 50) and (pPosY <= 50) then
                        imagePuzzle[i].x = imageHidded[i].x;
                        imagePuzzle[i].y = imageHidded[i].y;
						print( "win:imagePuzzle[i].x ="..imagePuzzle[i].x.." imagePuzzle[i].y ="..imagePuzzle[i].y )
                        if t.isFocus then
                            -- PUSIMOS ESTO AQUI Y FUNCIONA, CHEQUEALO BIEN
                            audio.play(effectLoadMatch, {channel = audio.findFreeChannel()});
                            isTouchEnabled = false
                            MultiTouch.deactivate(imagePuzzle[i]);
                            MultiTouch.activate(imagePuzzle[i], "move", "single");
                            emitter = dbJsonLib.newEmitter( _G.kParticle, _G.kParticlePNG )
                            emitter.x = event.target.x
                            emitter.y = event.target.y
                            -- emitter = particleDesigner.newEmitter( "heat.json" )
                            -- emitter.x = event.target.x
                            -- emitter.y = event.target.y
                            -- print("force ending fase 2")
                            display.getCurrentStage():setFocus( nil )
                            t.isFocus = false

                            countCompleted = countCompleted + 1    
                            if (data.pCount == countCompleted) then
                                circleDone = true;  
                                winner()
	--							timer.performWithDelay(5000,winner)
                            end
                        end
                    end
                    -- When the stops dragging circle within 50 pixels of center of outline, snap into middle, and...
                elseif event.phase == "ended" then
                    -- print("ending")
                    if isTouchEnabled then
                        isTouchEnabled = false
                        if (pPosX <= 50) and (pPosY <= 50) then
                           --
                        else 
                            audio.play(effectLoadSpring, {channel = audio.findFreeChannel()});
                            transition.to( imagePuzzle[i], { x=xDisplays[i], y=yDisplays[i] , time=100})                               
                        end
                    else
                        audio.play(effectLoadSpring, {channel = audio.findFreeChannel()});
                        transition.to( imagePuzzle[i], { x=xDisplays[i], y=yDisplays[i] , time=100})
                    end
                end
                return true;
            end 
            -- User drag interaction on END
            imagePuzzle[i]:addEventListener(MultiTouch.MULTITOUCH_EVENT, pointDrag);
        end
    end

    puzzletimerCompleted = timer.performWithDelay( 200,  function()
          puzzletimer()
            timer.cancel(puzzletimerCompleted)
    end, 1 )


    local closeButton = dbJsonLib.newSimpleButton(group, "resource/IMG/back.png", 100, 100);
    closeButton.x, closeButton.y = _G.rightSide - 70 , _G.topSide + 70;
    function closeButton:touchBegan()
        self:setFillColor(.5, .5, .5);
        self.xScale, self.yScale = .9, .9;
    end
    function closeButton:touchEnded()
        audio.play(buttonSFX, {channel = audio.findFreeChannel()});
        self:setFillColor(1, 1, 1);
        self.xScale, self.yScale = 1, 1;
        libADS.removeAd("during_game");
        _G.BlastScene = false;
        composer.gotoScene("menu", "slideDown");
    end

end


-- "scene:show()"
function scene:show( event )

    local sceneGroup = self.view
    local phase = event.phase

    if ( phase == "will") then
        if ( system.getInfo("platformName") == "Android" ) then
           local androidVersion = string.sub( system.getInfo( "platformVersion" ), 1, 3)
           if( androidVersion and tonumber(androidVersion) >= 4.4 ) then
             native.setProperty( "androidSystemUiVisibility", "immersiveSticky" )
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
        libADS.showLogEvent("End Games scene");
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