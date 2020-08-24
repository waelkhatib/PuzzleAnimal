    ----------------------------------------------------------------------------------
local composer = require( "composer" )
local widget = require("widget")
local scene = composer.newScene()
local libADS = require "lib.libADS"
local dbJsonLib = require "dbJsonLib";


if _G.activeRemoveAdsButton then
  iApLib = require "lib.iApLib";
end

local sheetInfo   = require( "resource.IMG.levelsmain" )
local myImageSheet = graphics.newImageSheet( "resource/IMG/".._G.kLevelsmain, sheetInfo:getSheet() )
setLanguage()

-- local objecTables = sheetInfo:getSheet()
local objectName  = sheetInfo:getFrameName()
local buttonGroup = display.newGroup()
local gamesPage = 0
local maxPages = #objectName.name
local movingScreen = false
local nameAnimals
local indexObjAnimals

-- -----------------------------------------------------------------------------------------------------------------
-- All code outside of the listener functions will only be executed ONCE unless "composer.removeScene()" is called.
-- -----------------------------------------------------------------------------------------------------------------

-- local forward references should go here

--let's localize these values for faster reading
local totalWidth = _G.totalWidth;
local totalHeight = _G.totalHeight;
local leftSide = _G.leftSide;
local rightSide = _G.rightSide;
local topSide = _G.topSide;
local bottomSide = _G.bottomSide;
local centerX = display.contentCenterX;
local centerY = display.contentCenterY;

local buttonSFX = _G.buttonSFX;
-- -------------------------------------------------------------------------------

local boxesWidth, boxesHeight, boxesNumColumns, boxesNumRows = 200, 200, 5, 2;
local boxesDistanceX, boxesDistanceY = 240, 220;
-- -------------------------------------------------------------------------------
local pagesList;
local unlockedLevelsAll =  20

createPages = function(parent)
  local group = display.newGroup();
  parent:insert(group);
  
  local unlockedLevels = (unlockedLevelsAll or 0)+1;
  if _G.unlockAllLevels then
    unlockedLevels = #_G.levelsData;
  end

  local xPos, yPos = 0, 0;
  local currPage = display.newGroup();
  group:insert(currPage);
  pagesList[1] = currPage;
  currPage.num = #pagesList;
  for i = 1, #_G.levelsData do
    local box = display.newImageRect(currPage, "resource/IMG/box.png", boxesWidth, boxesHeight);
    box.x, box.y = xPos*boxesDistanceX, yPos*boxesDistanceY;
    if i <= unlockedLevelsAll then
    	if i>10 then
	    	myImageSheet = graphics.newImageSheet( "resource/IMG/".._G.kLevelmain, sheetInfo:getSheet() )
	    end
      nameAnimals = objectName.name[i]
      indexObjAnimals = i
      local levelNum = display.newImage(currPage,myImageSheet, sheetInfo:getFrameIndex(nameAnimals));
      levelNum.x = box.x
      levelNum.y = box.y
      levelNum.destination  = nameAnimals
      levelNum.indexObjAnimals = indexObjAnimals
      -- local levelNum = display.newText(currPage, , box.x, box.y, native.systemFont, 40);
      -- levelNum:setFillColor(levelNumberColor[1], levelNumberColor[2], levelNumberColor[3]);
      function box:touch(event)
        if event.phase == "began" then
          display.getCurrentStage():setFocus(self);
          self.isFocus = true;
          self:setFillColor(.7, .7, .7);
        elseif event.phase == "moved" and self.isFocus then
          local dist = math.abs(event.x-event.xStart);
          if dist > 15 then
            display.getCurrentStage():setFocus(nil);
            self.isFocus = nil;
            self:setFillColor(1, 1, 1);
            event.phase = "began";
            self.parent:touch(event)
          end
        elseif event.phase == "ended" and self.isFocus then
          audio.play(buttonSFX, {channel = audio.findFreeChannel()});
          display.getCurrentStage():setFocus(nil);
          self.isFocus = nil;
          self:setFillColor(1, 1, 1);
          _G.levelNum = i;
          _G.currLevel = _G.levelsData[i];
          print( _G.levelNum.."  ".._G.currLevel )
        local options = {
               params = {
                   effect = "crossFade",
                     time = 800,
                  objName = objectName.name[i],
          indexObjAnimals = levelNum.indexObjAnimals
               }
            }
            composer.gotoScene( "games" , options ) 

        end
        return true;
      end
      box:addEventListener("touch", box);
    else
      local lock = display.newImageRect(currPage, "resource/IMG/coming.png", 150, 150);
      lock.x, lock.y = box.x, box.y;
    end
    xPos = xPos+1;
    if xPos >= boxesNumColumns then
      xPos = 0;
      yPos = yPos+1;
      if yPos >= boxesNumRows  then
        yPos = 0;
        currPage = display.newGroup();
        group:insert(currPage);
		--if  i~=20 then
        pagesList[#pagesList+1] = currPage;
        currPage.num = #pagesList;
		--end
      end
    end
  end
  
  local indicatorGroup = display.newGroup();
  parent:insert(indicatorGroup);
  if #_G.levelsData%10==0 then
	  table.remove(pagesList,#pagesList)
  end
  for i = 1, #pagesList do
    local dot = dbJsonLib.newComplexButton(indicatorGroup, "resource/IMG/greydot.png", 20, 20, "resource/IMG/whitedot.png", 20, 20, 0, 0);
    dot.x = i*20;
    if i == 1 then
      dot[1].isVisible = false;
      dot[2].isVisible = true;
    end
    local pageGroup = pagesList[i];
    pageGroup.anchorChildren = true;
    pageGroup.x, pageGroup.y = centerX+(totalWidth*(i-1))+50, centerY-boxesDistanceY*(boxesNumRows*.5)+pageGroup.contentHeight*.5;
    function pageGroup:touch(event)
	  print("xsaw")
      if event.phase == "began" then
        display.getCurrentStage():setFocus(self);
        self.xStart = event.x-self.x;
        self.isFocus = true;
      elseif event.phase == "moved" and self.isFocus then
        self.x = event.x-self.xStart;
        if self.x > centerX+80 then
          local nextPage = pagesList[self.num-1];
          if nextPage then
            display.getCurrentStage():setFocus(nil);
            self.isFocus = nil;
            if self.transTo then
              transition.cancel(self.transTo);
            end
            audio.play(buttonSFX, {channel = audio.findFreeChannel()});
            self.transTo = transition.to(self, {time = 200, x = centerX+totalWidth});
            if nextPage.transTo then
              transition.cancel(nextPage.transTo);
            end
            nextPage.x = centerX-totalWidth;
            nextPage.transTo = transition.to(nextPage, {time = 200, x = centerX});
            indicatorGroup[self.num][1].isVisible = true;
            indicatorGroup[self.num][2].isVisible = false;
            indicatorGroup[nextPage.num][1].isVisible = false;
            indicatorGroup[nextPage.num][2].isVisible = true;
          end
        elseif self.x < centerX-80 then
          local nextPage = pagesList[self.num+1];
          if nextPage then
            display.getCurrentStage():setFocus(nil);
            self.isFocus = nil;
            if self.transTo then
              transition.cancel(self.transTo);
            end
            audio.play(buttonSFX, {channel = audio.findFreeChannel()});
            self.transTo = transition.to(self, {time = 200, x = centerX-totalWidth});
            if nextPage.transTo then
              transition.cancel(nextPage.transTo);
            end
            nextPage.x = centerX+totalWidth;
            nextPage.transTo = transition.to(nextPage, {time = 200, x = centerX});
            indicatorGroup[self.num][1].isVisible = true;
            indicatorGroup[self.num][2].isVisible = false;
            indicatorGroup[nextPage.num][1].isVisible = false;
            indicatorGroup[nextPage.num][2].isVisible = true;
          end
        end
      elseif event.phase == "ended" and self.isFocus then
        display.getCurrentStage():setFocus(nil);
        self.isFocus = nil;
        if self.transTo then
          transition.cancel(self.transTo);
        end
        self.transTo = transition.to(self, {time = 200, x = centerX});
      end
    end
    pageGroup:addEventListener("touch", pageGroup);
  end
  
  indicatorGroup.anchorChildren = true;
  indicatorGroup.x, indicatorGroup.y = centerX, bottomSide-150-indicatorGroup.contentHeight*.5;
end

----------------------------------------------------------------------------------
-- "scene:create()"
function scene:create( event )
  pagesList = {};
  if ( system.getInfo( "platformName" ) ~= "WinPhone" ) then 
--    local rInt = math.random(1,10)    
    -- print("MenuMAin Verificando Random = "..rInt.." and  mainRunIntertitial = ".._G.mainRunIntertitial);
--    libADS.showLogEvent("MenuMAin Verificando Random = "..rInt.." and  mainRunIntertitial = "..tostring(_G.mainRunIntertitial));
--    if ((rInt == _G.mainRunIntertitial) or _G.mainRunIntertitial == 12 ) then
--      dbJsonLib.setSaveValue('mainRunIntertitial', 1, true);
      libADS.showLogEvent("Showing Intertitial Menu Application");
      libADS.showAd("game_over");
      
--    end
  end
  
  local group = self.view;
  local iconSoundOff
  local iconSoundOn

  local bg = display.newImageRect(group, "resource/IMG/".._G.kBG, totalWidth, totalHeight);
  bg.x, bg.y = centerX, centerY;
  group:insert( buttonGroup )

  local lbTitleGame1 = display.newImageRect(group,"resource/IMG/"..dbJsonLib.getSaveValue('language').._G.kTitleGames, 1000,200);
  lbTitleGame1.x = centerX
  lbTitleGame1.y = (topSide+ lbTitleGame1.height/2)  + 20

  local function soundToggle(event)
    setLanguage()
    local soundON = dbJsonLib.getSaveValue('Sound')
    audio.play(buttonSFX, {channel = audio.findFreeChannel()});
    if soundON then
        if (gameMusicChannel ~= nil) then
            audio.stop( gameMusicChannel )
        end
        soundON =  false
        iconSoundOn.isVisible = false
        iconSoundOff.isVisible = true
    else
          if ( system.getInfo("platformName") == "Android" ) then
            gameMusicLoad = audio.loadStream( "resource/SFX/".._G.kMusicLoop..".wav" ) 
          else 
            gameMusicLoad = audio.loadStream( "resource/SFX/".._G.kMusicLoop..".mp3" ) 
          end
            gameMusicChannel = audio.play( gameMusicLoad, { loops = -1 } )
            audio.setVolume( 0.75, { channel=1 } ) 
        soundON = true
        iconSoundOn.isVisible = true
        iconSoundOff.isVisible = false
    end
    dbJsonLib.setSaveValue('Sound', soundON, true)
    return true
  end

      local function touchHandler ( event )
            if "ended" == event.phase then
                audio.play(buttonSFX, {channel = audio.findFreeChannel()});
                if ( event.target.destination ~= nil) then
                    if (event.target.destination == "lenguajes") then
                        composer.gotoScene( "lenguajes" , { effect = "slideUp", time = 500 } ) 
                    elseif (event.target.destination == "about") then
                        composer.gotoScene( "about" , { effect = "fade", time = 500 } ) 
                    elseif (event.target.destination == "rate") then
                       local options =
                        {
                           iOSAppId = _G.iOSappIDforRate, --your ios app id
                           androidAppPackageName = _G.kAndroidAppPackegeName, 
                           supportedAndroidStores = {"google", "samsung", "amazon", "nook"}, --the store you support on android
                        }
                        native.showPopup("appStore", options);
                    else 
                      composer.gotoScene( event.target.destination , { effect = "slideUp", time = 500 } ) 
                    end
                end
            end
        end

  iconSoundOff = widget.newButton
    {width = 100,
    height = 100,
    defaultFile = "resource/IMG/".._G.kSoundOff,
    overFile = "resource/IMG/".._G.kSoundOff
    }
    iconSoundOff.y = bottomSide - 0.6 * iconSoundOff.height
    iconSoundOff.x = leftSide + 60
    iconSoundOff:addEventListener("tap", soundToggle)
    group:insert( iconSoundOff )
    
  iconSoundOn = widget.newButton
    {
    width = 100,
    height = 100,
    defaultFile = "resource/IMG/".._G.kSoundOn,
    overFile = "resource/IMG/".._G.kSoundOn
    }
    iconSoundOn.y = bottomSide - 0.6 * iconSoundOn.height
    iconSoundOn.x = leftSide + 60
    iconSoundOn:addEventListener("tap", soundToggle)
    group:insert( iconSoundOn)

    soundON = dbJsonLib.getSaveValue('Sound')
    if soundON then
        iconSoundOn.isVisible = true
        iconSoundOff.isVisible = false
    else
        iconSoundOn.isVisible = false
        iconSoundOff.isVisible = true
    end

  local settingButton = widget.newButton
  {
    width = 100,
    height = 100,
    defaultFile = "resource/IMG/".._G.kSetting,
    overFile = "resource/IMG/".._G.kSettingOff
  }
  settingButton.x, settingButton.y = leftSide + 165 , bottomSide - 0.6 * 100;
  settingButton.destination = "setting"
  group:insert( settingButton )
  settingButton:addEventListener ( "touch", touchHandler )
  
  local lengValues 
  if (dbJsonLib.getSaveValue('language')) == "en" then
        lengValues = "usa.png"
  elseif (dbJsonLib.getSaveValue('language')) == "fr" then 
        lengValues = "france.png"
  elseif (dbJsonLib.getSaveValue('language')) == "de" then 
        lengValues = "germany.png"
  elseif (dbJsonLib.getSaveValue('language')) == "es" then 
        lengValues = "spain.png"
  elseif (dbJsonLib.getSaveValue('language')) == "it" then 
        lengValues = "italy.png"
  elseif (dbJsonLib.getSaveValue('language')) == "br" then 
        lengValues = "brasil.png"
  end

  local lengButton = widget.newButton
  {
    width = 100,
    height = 100,
    defaultFile = "resource/IMG/"..tostring(lengValues),
    overFile = "resource/IMG/"..tostring(lengValues)
  }
  lengButton.x, lengButton.y = settingButton.x + 105 , bottomSide - 0.6 * 100;
  lengButton.destination = "lenguajes"
  group:insert( lengButton )
  lengButton:addEventListener ( "touch", touchHandler )

  local rateButton = widget.newButton
  {
    width = 100,
    height = 100,
    defaultFile = "resource/IMG/".._G.kRate,
    overFile = "resource/IMG/".._G.kRateOff
  }
  rateButton.x, rateButton.y = _G.rightSide - 60 , bottomSide - 0.6 * 100;
  rateButton.destination = "rate"
  group:insert( rateButton )
  if ( system.getInfo( "platformName" ) == "WinPhone" ) then 
    rateButton.alpha = 0.0001
    rateButton.x, rateButton.y = _G.rightSide - 165 , bottomSide - 0.6 * 100;
  end
  rateButton:addEventListener ( "touch", touchHandler )

  local aboutButton = widget.newButton
  {
    width = 100,
    height = 100,
    defaultFile = "resource/IMG/".._G.kAbout,
    overFile = "resource/IMG/".._G.kAboutOff
  }
  if ( system.getInfo( "platformName" ) == "WinPhone" ) then 
  aboutButton.x, aboutButton.y = _G.rightSide - 65 , bottomSide - 0.6 * 100;
  else 
  aboutButton.x, aboutButton.y = rateButton.x - 105 , bottomSide - 0.6 * 100;
  end
  aboutButton.destination = "about"
  group:insert( aboutButton )
  aboutButton:addEventListener ( "touch", touchHandler )

if ( system.getInfo( "platformName" ) ~= "WinPhone" ) then 
  if _G.activeRemoveAdsButton and not dbJsonLib.getSaveValue("removeAds") then
    local removeAdsButton = dbJsonLib.newSimpleButton(group, "resource/IMG/noads.png", 100, 100);
    removeAdsButton.x, removeAdsButton.y = leftSide + 60 , topSide + 170
    function removeAdsButton:touchBegan()
      self:setFillColor(.5, .5, .5);
      self.xScale, self.yScale = .9, .9;
    end
    function removeAdsButton:touchEnded()
      audio.play(buttonSFX, {channel = audio.findFreeChannel()});
      self:setFillColor(1, 1, 1);
      self.xScale, self.yScale = 1, 1;
      iApLib.purchaseItem(_G.iApItems["removeAds"], function(result)
      if result then
        dbJsonLib.setSaveValue("isAdsRemoved", "true", true);
      end
    end);
    end
    local restoreAdsButton = dbJsonLib.newSimpleButton(group, "resource/IMG/iap.png", 100, 100);
    restoreAdsButton.x, restoreAdsButton.y = leftSide + 60 , topSide+ 60
    function restoreAdsButton:touchBegan()
      self:setFillColor(.5, .5, .5);
      self.xScale, self.yScale = .9, .9;
    end
    function restoreAdsButton:touchEnded()
      audio.play(buttonSFX, {channel = audio.findFreeChannel()});
      self:setFillColor(1, 1, 1);
      self.xScale, self.yScale = 1, 1;
      iApLib.restoreItems({{id = _G.iApItems["removeAds"][1], callback = function()
        dbJsonLib.setSaveValue("isAdsRemoved", "true", true);
        native.showAlert("Success", "Previous Purchase found! Ads Removed.", {"Ok"});
      end}});
    end
  end
end

  createPages(group)
end


-- "scene:show()"
function scene:show( event )

    local sceneGroup = self.view
    local phase = event.phase

    if ( phase == "will" ) then
      libADS.removeAd("during_game");
      
      if ( system.getInfo("platformName") == "Android" ) then
         local androidVersion = string.sub( system.getInfo( "platformVersion" ), 1, 3)
         if( androidVersion and tonumber(androidVersion) >= 4.4 ) then
           native.setProperty( "androidSystemUiVisibility", "immersiveSticky" )
         elseif( androidVersion ) then
           native.setProperty( "androidSystemUiVisibility", "lowProfile" )
         end
      end
        -- Called when the scene is still off screen (but is about to come on screen).
    elseif ( phase == "did" ) then
        -- Called when the scene is now on screen.
        -- Insert code here to make the scene come alive.
        -- Example: start timers, begin animation, play audio, etc.
    end
end


-- "scene:hide()"
function scene:hide( event )

    local sceneGroup = self.view
    local phase = event.phase
    if ( phase == "will" ) then

     for i = 1, #pagesList do
        pagesList[i] = nil;
      end
      
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


-- "scene:destroy()"
function scene:destroy( event )

    local sceneGroup = self.view
    -- Called prior to the removal of scene's view ("sceneGroup").
    -- Insert code here to clean up the scene.
    -- Example: remove display objects, save state, etc.
end


-- -------------------------------------------------------------------------------

-- Listener setup
scene:addEventListener( "create", scene )
scene:addEventListener( "show", scene )
scene:addEventListener( "hide", scene )
scene:addEventListener( "destroy", scene )

-- -------------------------------------------------------------------------------

return scene