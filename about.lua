local composer = require( "composer" )
local scene = composer.newScene()
local widget = require("widget")
local dbJsonLib = require "dbJsonLib";
local twitterHelper = require "lib.twHelper";
local facebookHelper = require "lib.fbHelper";


translations = require("translations")


setLanguage()

local centerX = display.contentCenterX;
local centerY = display.contentCenterY;
local particle
local canEmail = native.canShowPopup("mail");
local facebookShare, twitterShare, emailShare;

-- local _W = display.contentWidth / 2
-- local _H = display.contentHeight / 2

-- -----------------------------------------------------------------------------------------------------------------
-- All code outside of the listener functions will only be executed ONCE unless "composer.removeScene()" is called.
-- -----------------------------------------------------------------------------------------------------------------

local shareFunctions = {
  ["facebook"] = facebookHelper.postOnUserWall,
  ["twitter"] = function(message)
    twitterHelper:tweet(message);
  end,
  ["email"] = function(message)
    local options =
    {
       body = message
    }
    native.showPopup("mail", options)
  end
};

if _G.useSocialPlugin then
  if system.getInfo("platformName") ~= "Android" then
    shareFunctions["facebook"] = function(message)
      native.showPopup("social", {
        service = "facebook",
        message = message,
        image = {filename = _G.imageForSocialShare, baseDir = system.ResourceDirectory}
      });
    end
  end
  shareFunctions["twitter"] = function(message)
    native.showPopup("social", {
      service = "twitter",
      message = message,
      image = {filename = _G.imageForSocialShare, baseDir = system.ResourceDirectory}
    });
  end
end

shareMessage = function(shareType, message, replaceData)
  for k, v in pairs(replaceData) do
    local find = "%f[%a]"..k.."%f[%A]";
    message = message:gsub(find, v);
  end
  shareFunctions[shareType](message);
end



-- "scene:create()"
function scene:create( event )
    _G.lastScene = "menu";
    _G.BlastScene = true
    _G.socialShareMessage = translations["SdMensaje"][language];
    local group = self.view

   -- Background image
    local bg = display.newImageRect(group, "resource/IMG/".._G.kBG, _G.totalWidth, _G.totalHeight);
    bg.x, bg.y = centerX, centerY;

    local lbtitle = display.newText(group,translations["About"][language], 0, 0, fontNameGlobal, ((_G.totalHeight/7)))
    lbtitle.x, lbtitle.y = centerX, _G.topSide + 70
    lbtitle:setFillColor( 0,0,0)

    local lbtext = display.newText(group,translations["AboutText"][language], 15, 250, 1000, 700, native.systemFont, 25)
    lbtext.x = centerX
    lbtext.y = centerY + lbtitle.y 
    lbtext:setFillColor( 0,0,0)

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
        composer.gotoScene("menu", "slideDown");
    end

    local emitter
    local mRand = math.random
    particle = timer.performWithDelay( 100, 
      function()
        emitter = dbJsonLib.newEmitter(_G.kParticle, _G.kParticlePNG)
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

    local credictButton = dbJsonLib.newSimpleButton(group, "resource/IMG/".._G.kCredito, 100, 100);
    credictButton.x, credictButton.y = _G.rightSide - 70 , _G.bottomSide - 70
    function credictButton:touchBegan()
        self:setFillColor(.5, .5, .5);
        self.xScale, self.yScale = .9, .9;
    end
    function credictButton:touchEnded()
        audio.play(buttonSFX, {channel = audio.findFreeChannel()});
        self:setFillColor(1, 1, 1);
        self.xScale, self.yScale = 1, 1;
        composer.gotoScene("credito", "slideDown");
--        _G.socialShareMessage = translations["SdMensaje"][language]
--        group:insert(shareLib.init(_G.socialShareMessage, {nil}));
    end

    local fbButton = dbJsonLib.newSimpleButton(group, "resource/IMG/shareIMG/fb.png", 100, 100);
    fbButton.x, fbButton.y = _G.rightSide - 70 , credictButton.y - 110
    function fbButton:touchBegan()
        self:setFillColor(.5, .5, .5);
        self.xScale, self.yScale = .9, .9;
    end
    function fbButton:touchEnded()
        audio.play(buttonSFX, {channel = audio.findFreeChannel()});
        self:setFillColor(1, 1, 1);
        self.xScale, self.yScale = 1, 1;
        shareMessage("facebook", _G.socialShareMessage, {nil});
    end
    
    local twButton = dbJsonLib.newSimpleButton(group, "resource/IMG/shareIMG/tw.png", 100, 100);
    twButton.x, twButton.y = _G.rightSide - 70 , fbButton.y - 110
    function twButton:touchBegan()
        self:setFillColor(.5, .5, .5);
        self.xScale, self.yScale = .9, .9;
    end
    function twButton:touchEnded()
        audio.play(buttonSFX, {channel = audio.findFreeChannel()});
        self:setFillColor(1, 1, 1);
        self.xScale, self.yScale = 1, 1;
        shareMessage("twitter", _G.socialShareMessage, {nil});
    end
    
    local mailButton = dbJsonLib.newSimpleButton(group, "resource/IMG/shareIMG/email.png", 100, 100);
    mailButton.x, mailButton.y = _G.rightSide - 70 , twButton.y - 110
    function mailButton:touchBegan()
        self:setFillColor(.5, .5, .5);
        self.xScale, self.yScale = .9, .9;
    end
    function mailButton:touchEnded()
        audio.play(buttonSFX, {channel = audio.findFreeChannel()});
        self:setFillColor(1, 1, 1);
        self.xScale, self.yScale = 1, 1;
        shareMessage("email", _G.socialShareMessage, {nil});
    end

	if (string.lower(system.getInfo( "platformName")) ==  "winphone" ) then
		fbButton.alpha = 0.0001
		twButton.alpha = 0.0001
		mailButton.alpha = 0.0001
	end

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