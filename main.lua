
display.setStatusBar(display.HiddenStatusBar);

_G.totalWidth = display.contentWidth-(display.screenOriginX*2);
_G.totalHeight = display.contentHeight-(display.screenOriginY*2);
_G.leftSide = display.screenOriginX;
_G.rightSide = display.contentWidth-display.screenOriginX;
_G.topSide = display.screenOriginY;
_G.bottomSide = display.contentHeight-display.screenOriginY;
_G.BlastScene =  false;

local composer = require "composer";
settingdata = require("settingdata")
local dbJsonLib = require "dbJsonLib";


configGames = require "configGames";
local libADS = require ("lib.libADS");


composer.recycleOnSceneChange = true;
composer.gotoScene( "splashscreen" , "crossFade") 

translations = require("translations")

setLanguage()

local typeSound
if ( system.getInfo("platformName") == "WinPhone" ) then
    typeSound = ".wav"
else 
    typeSound = ".mp3"
end

_G.buttonSFX = audio.loadSound("resource/SFX/".._G.kButtonSFX..typeSound)
_G.effectLoadMatch = audio.loadSound( "resource/SFX/".._G.kEffectLoadMatch..typeSound) 
_G.effectLoadSpring = audio.loadSound( "resource/SFX/".._G.KEffectLoadSpring..typeSound) 
_G.effectelements = audio.loadSound( "resource/SFX/".._G.kEffectelements..typeSound)
_G.effectapplause = audio.loadSound( "resource/SFX/".._G.kEffectapplause..typeSound)
_G.popSound = audio.loadSound("resource/SFX/".._G.kPopSound)


if (dbJsonLib.getSaveValue('Sound')) == nil then
    dbJsonLib.setSaveValue('Sound', true, true)
end

if (dbJsonLib.getSaveValue('Diffic')) == nil then
    dbJsonLib.setSaveValue('Deffic', "easy", true)
end

if (dbJsonLib.getSaveValue("Sound")) == true then
    
  if ( system.getInfo("platformName") == "WinPhone" ) then
    gameMusicLoad = audio.loadSound( "resource/SFX/".._G.kMusicLoop..".wav" ) 
  else 
    gameMusicLoad = audio.loadSound( "resource/SFX/".._G.kMusicLoop..".mp3" ) 
  end
    gameMusicChannel = audio.play( gameMusicLoad, { loops = -1 } )
    audio.setVolume( 0.75, { channel=1 } ) 
end


fontNameGlobal = _G.kfontNameGlobal


local screenShotNumber = 1;

function keyIsPressed(event)
  if event.keyName == "a" and event.phase == "down" then
    display.save(composer.stage, "screen"..screenShotNumber..".png", system.DocumentsDirectory, true);
    screenShotNumber = screenShotNumber+1;
  end
end

Runtime:addEventListener("key", keyIsPressed);


