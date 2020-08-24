local composer = require( "composer" )
local scene = composer.newScene()
local widget = require("widget")
local dbJsonLib = require "dbJsonLib";
local physics = require("physics")
local sheetInfo   = require( "data" )
local sheetInfoAnimals   = require( "resource.IMG.levelsmain" )
local libADS = require "lib.libADS"


setLanguage()

local centerX = display.contentCenterX;
local centerY = display.contentCenterY;

physics.start()
physics.setGravity(0,36.8)

local typeSound
if ( system.getInfo("platformName") == "WinPhone" ) then
    typeSound = ".wav"
else 
    typeSound = ".mp3"
end


-- local _W = display.contentWidth / 2
-- local _H = display.contentHeight / 2

-- -----------------------------------------------------------------------------------------------------------------
-- All code outside of the listener functions will only be executed ONCE unless "composer.removeScene()" is called.
-- -----------------------------------------------------------------------------------------------------------------

-- "scene:create()"
function scene:create( event )
  _G.lastScene = "menu";
  -- if ( system.getInfo( "platformName" ) ~= "WinPhone" ) then 
  --   -- local rInt = math.random(1,10)    
  --   -- if rInt == 5 then
  libADS.showLogEvent("Show Intertitial Wind Games Application");
  libADS.showAd("game_over");
  local group = self.view
  local allBalloons = {}
  local objectName  = sheetInfoAnimals:getFrameName()

  local params = event.params
  nameLevel = params.objNameWin
  indexObjAnimals  = params.indexObjAnimals

    
     print( nameLevel.." indexObjAnimals "..indexObjAnimals)

   	-- Background image
   local bg = display.newImageRect(group, "resource/IMG/bg.png", _G.totalWidth, _G.totalHeight);
   bg.x, bg.y = centerX, centerY;


    local lLVSImage = require("resource.LVLS."..nameLevel )

    -- print( nameLevel.." indexObjAnimals "..indexObjAnimals)
    -- Initialize the scene here.
    -- Example: add display objects to "sceneGroup", add touch listeners, etc.
      local effectSpeech 
	  local effectsound = audio.loadSound( "resource/SFX/animals/"..nameLevel..typeSound )
        if (dbJsonLib.getSaveValue('language')) == "en" then
            effectSpeech = audio.loadSound( "resource/SFX/Speech/English/"..nameLevel..typeSound )
        elseif (dbJsonLib.getSaveValue('language')) == "fr" then 
              effectSpeech = audio.loadSound( "resource/SFX/Speech/French/"..nameLevel..typeSound )
        elseif (dbJsonLib.getSaveValue('language')) == "de" then 
              effectSpeech = audio.loadSound( "resource/SFX/Speech/German/"..nameLevel..typeSound )
        elseif (dbJsonLib.getSaveValue('language')) == "es" then 
              effectSpeech = audio.loadSound( "resource/SFX/Speech/Spanish/"..nameLevel..typeSound )
        elseif (dbJsonLib.getSaveValue('language')) == "it" then 
              effectSpeech = audio.loadSound( "resource/SFX/Speech/Italian/"..nameLevel..typeSound )
        elseif (dbJsonLib.getSaveValue('language')) == "br" then 
              effectSpeech = audio.loadSound( "resource/SFX/Speech/Portuguese/"..nameLevel..typeSound )
        end
      
    

    -- local effectsound = audio.loadSound( "resource/SFX/animals/"..nameLevel..typeSound )
    local myImageSheet = graphics.newImageSheet( "resource/LVLS/"..nameLevel..".png", lLVSImage:getSheet(nameLevel) )
    local data = sheetInfo:getPuzzle(nameLevel)
    
    local onSpeech = false
    local function onSpeechFinished( event )
      -- print( "Narration Finished on channel", event.channel )
      if ( event.completed ) then
          onSpeech = false
      end
    end

    local function onSoundSpeech( event )
      if onSpeech  == false then
        onSpeech = true
        audio.play(effectSpeech, {channel = audio.findFreeChannel(), onComplete=onSpeechFinished });
      end
      return true
    end
print(nameLevel)
    local lbtitle = display.newText(group,translations[nameLevel][language], 0, 0, fontNameGlobal, 100)
    lbtitle.x, lbtitle.y = centerX, _G.topSide + 100
    lbtitle:setFillColor( 0, 0, 0)
    lbtitle.alpha = 0
    lbtitle:addEventListener("tap", onSoundSpeech)

     local iconBack = dbJsonLib.newSimpleButton(group, "resource/IMG/back.png", 100, 100);
    iconBack.y = display.contentCenterY
    iconBack.x = iconBack.width
    function iconBack:touchBegan()
        self:setFillColor(.5, .5, .5);
        self.xScale, self.yScale = .9, .9;
    end
    function iconBack:touchEnded()
        audio.play(_G.buttonSFX, {channel = audio.findFreeChannel()});
        self:setFillColor(1, 1, 1);
        self.xScale, self.yScale = 1, 1;
        _G.BlastScene = false
        composer.gotoScene("menu", "slideDown");
    end


    local imageshadowEasy = display.newImage(group,myImageSheet, lLVSImage:getFrameIndex(nameLevel.."_0"))
        imageshadowEasy.x = centerX+7	;
         imageshadowEasy.y = centerY;
        -- sceneGroup:insert(imageshadowEasy)

    local iconReset = dbJsonLib.newSimpleButton(group, "resource/IMG/reset.png", 100, 100);
    iconReset.y = 15+ (_G.topSide + iconReset.height /2) 
    iconReset.x = - 15+ (_G.totalWidth - iconReset.width /2) 
    function iconReset:touchBegan()
        self:setFillColor(.5, .5, .5);
        self.xScale, self.yScale = .9, .9;
    end
    function iconReset:touchEnded()
        audio.play(_G.buttonSFX, {channel = audio.findFreeChannel()});
        self:setFillColor(1, 1, 1);
        self.xScale, self.yScale = 1, 1;
        -- print( "nameLevel ="..nameLevel )
        local options = {
               params = {
                      objName = nameLevel,
              indexObjAnimals = indexObjAnimals
                   }
                }
          _G.BlastScene = false;
   	      composer.gotoScene( "games", options )
    end
    
    local iconNext = dbJsonLib.newSimpleButton(group, "resource/IMG/next.png", 100, 100);
  	iconNext.y =  display.contentCenterY --iconNext.y  + 15+ (topScrn + iconNext.height /2) 
    iconNext.x =  - 15+ (_G.totalWidth - iconNext.width /2) 
    function iconNext:touchBegan()
        self:setFillColor(.5, .5, .5);
        self.xScale, self.yScale = .9, .9;
    end
    function iconNext:touchEnded()
        audio.play(_G.buttonSFX, {channel = audio.findFreeChannel()});
        self:setFillColor(1, 1, 1);
        self.xScale, self.yScale = 1, 1;
         -- print( "nameLevel ="..nameLevel.." indexObjAnimals "..indexObjAnimals )
                indexObjAnimals = indexObjAnimals + 1
          -- print( "indexObjAnimals nameLevel ="..nameLevel.." indexObjAnimals "..indexObjAnimals )
                local nameObject = objectName.name[indexObjAnimals]
                if (indexObjAnimals <= #objectName.name) then                    
                     local options = {
                       params = {
                          objName = nameObject,
                  indexObjAnimals = indexObjAnimals
                       }
                    }
                    composer.gotoScene( "games", options )
                else 
                local nameObject = objectName.name[1]                    
                local options = {
                       params = {
                          objName = nameObject,
                  indexObjAnimals = 1
                       }
                    }
                    composer.gotoScene( "games", options )
                end
              _G.BlastScene =  false;
    end


    local function onTouch( self, event )
	    allBalloons[self] = nil
	    audio.play(_G.popSound, {channel = audio.findFreeChannel()});
	    display.remove(self)
    return true
    end

  
    iconBack.alpha = 0
    iconReset.alpha = 0
    iconNext.alpha = 0

    local function createBalloon( )
        local imgNum = math.random( 1, 5 )  
        local tmp = display.newImageRect( "resource/IMG/balloon" .. imgNum .. ".png", 295/1.5, 482/1.5 ) 
        tmp.y = -50
        tmp.x = math.random( tmp.width, _G.totalWidth - (482/2))
        tmp.touch = onTouch
        tmp:addEventListener( "touch" )
        physics.addBody( tmp, { radius = tmp.contentWidth} )
        tmp.angularVelocity = math.random( -180, 180 )
        tmp.linearDamping = 5
        group:insert( tmp )
        timer.performWithDelay( 5000,
            function()
                allBalloons[tmp] = nil
                display.remove( tmp )
                iconBack.alpha = 1
                iconReset.alpha = 1
                iconNext.alpha = 1
            end )

    end

    local onSound = false
    local function onFinished( event )
      -- print( "Narration Finished on channel", event.channel )
      if ( event.completed ) then
          onSound = false
          -- print( "Narration completed playback naturally" )
      else
          onSound = false
          -- print( "Narration was stopped before completion" )
      end
    end

    local function onTouchComplet( event )
		print("wasw")
      if onSound == false then
        onSound = true
        audio.play(effectsound, {channel = audio.findFreeChannel(), onComplete=onFinished });  
      end
	    return true
	  end
          
    local effecAplause = audio.loadStream( "resource/SFX/".._G.kEffectapplause..typeSound ) 
    local aplauseChannel = audio.play( effecAplause )
    timeBallonForEver = timer.performWithDelay( 100, createBalloon, -1)
    timeBallonCompleted =timer.performWithDelay( 2000,
    function()
            if(timeBallonForEver)then 
                timer.cancel(timeBallonForEver)
                lbtitle.alpha  =  1
            end                               
        end )
    audio.play(effectSpeech, {channel = audio.findFreeChannel()});
    imageshadowEasy:addEventListener( "tap", onTouchComplet)

end


-- "scene:show()"
function scene:show( event )

    local sceneGroup = self.view
    local phase = event.phase
    
    if ( phase == "will" ) then
        --
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