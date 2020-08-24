local dbJsonLib = require "dbJsonLib";
local libADS = require ("lib.libADS");
translations = require("translations")
local composer = require( "composer" )


-- sets the language based on the users device and saves it as a setting.
-- if settings file aready exists, it just loads the settings. 
 function setLanguage()
    lang = system.getPreference("ui", "language")
    language =    string.lower(string.sub(lang, 1, 2 ))
    if (dbJsonLib.getSaveValue('language')) == nil then
        -- print( language )
        if (translations["test"][language]) == nil then
           language = "en"
           dbJsonLib.setSaveValue('language', language, true)
           -- print ("UI language supported - Saving "..language.." to settings.json")
        else
           dbJsonLib.setSaveValue('language', language, true)
           -- print ("UI language supported - Saving "..language.." to settings.json")
        end
    else
        language = dbJsonLib.getSaveValue('language')
    end
end

dbJsonLib.setSaveValue('language', language, true)

local totalWidth = _G.totalWidth;
local totalHeight = _G.totalHeight;
local leftSide = _G.leftSide;
local rightSide = _G.rightSide;
local topSide = _G.topSide;
local bottomSide = _G.bottomSide;
local centerX = display.contentCenterX;
local centerY = display.contentCenterY;

_G.iOSappIDforRate = "Your iOS app ID";
_G.kAndroidAppPackegeName =  "com.igamesforkids.Puzzle_Animals";
_G.twitterConsumerKey = "rHFT6atLRU2RCxGwZctTzTAKL";
_G.twitterSecretKey = "yHbOVRiKbbffpjaBRQMJFt0jonIok6ER0ZDqhgFfFIGCInLC2X";
_G.facebookAPPID = "629903493813451";

_G.socialShareMessage = translations["SdMensaje"][language];
_G.imageForSocialPluginShare = "resource/IMG/shareIMG/sharegames.png";
_G.useSocialPlugin = true;

_G.activeRemoveAdsButton = true;
_G.iApItems = {
  ["removeAds"] = {"com.igames4kids.removeAds"}, --modify  with your own iAp ID (non-consumable product)
};


--SOUND & effect Games 
-- Note not add ext ".mp3 and .wav" 
_G.kButtonSFX = "clickSFX"
_G.kEffectLoadMatch = "puzzle"
_G.KEffectLoadSpring = "sspring"
_G.kEffectelements = "domino"
_G.kEffectapplause = "applaused"
_G.kMusicLoop =  "musicloop"
--Is not error 
_G.kPopSound = "pop.wav"
-----------------------------
--FONT apps
--
if (string.lower(system.getInfo( "platformName")) ==  "winphone" ) then
    _G.kfontNameGlobal =  "burnstown dam.ttf#burnstown dam" --"burnstown dam"
else 
    _G.kfontNameGlobal = "burnstown dam"
end
--

-- Particle 
--
_G.kParticle = "resource/Effect/emitter29641.rg"
_G.kParticlePNG = "resource/Effect/particle29641.png"
--

--IMAGEN APPS
_G.kPictureFB = "resource/IMG/igames4kids.png"
_G.kDescriptionFB =  "Get the Advanced Games!"
_G.kLinkFB = "https://plus.google.com/u/0/b/117664187519428477378/117664187519428477378/posts"
_G.kNameFB = "iMobiles Solutions"
_G.kCaptionFB = "iMobiles Solutions!"


_G.kBG = "bg.png"
_G.logoScreenSplash = "igames4kids.png"
_G.kTitleGames = "_PuzzleAnimals.png"  --la rayita de comienza es para determinar el tipo de lenguajes que bas a poner ejemplo. "br_PuzzleAnimals.png" brazil
_G.kSoundOff = "soundOff.png"
_G.kSoundOn = "sound.png"
_G.kSetting = "setting.png"
_G.kSettingOff = "settingOff.png"
_G.kRate = "rate.png"
_G.kRateOff = "rateOff.png"
_G.kAbout =  "about.png"
_G.kAboutOff = "aboutOff.png"
_G.kClose =  "close.png"
_G.kCredito = "credito.png"

-- Esta imagen es sprite con imagen 200x200 que estan en la pantalla principal del juego.
_G.kLevelsmain = "levelsmain.png"
_G.kLevelmain = "main.png"

_G.levelsData = {
  [1] = "resource/LVLS/chicken.png",
  [2] = "resource/LVLS/cow.png",
  [3] = "resource/LVLS/dog.png",
  [4] = "resource/LVLS/elephant.png",
  [5] = "resource/LVLS/hen.png",
  [6] = "resource/LVLS/horse.png",
  [7] = "resource/LVLS/ladybug.png",
  [8] = "resource/LVLS/pig.png",
  [9] = "resource/LVLS/seal.png",
  [10] = "resource/LVLS/sheep.png",
  [11] = "resource/LVLS/fox",
  [12] = "resource/LVLS/level1",
  [13] = "resource/LVLS/level1",
  [14] = "resource/LVLS/level1",
  [15] = "resource/LVLS/level1",
  [16] = "resource/LVLS/level1",
  [17] = "resource/LVLS/level1",
  [18] = "resource/LVLS/level1",
  [19] = "resource/LVLS/level1",
  [20] = "resource/LVLS/level1"
  };

-- Credito Scene 
_G.kLbDesing = "Design"
_G.kValDesign = "Retanto Foster"
_G.kLbProgramming = "Programming"
_G.kValProgramming = "Ramon Moscat"
_G.kLbQA = "Quality Assurance"
_G.kValQA = "Edward Garo"
_G.kLbCowBoy = "Cowboy"
_G.kValCowBoy = "Francis Zorrilla"
_G.kOtherValues1 = "www.pixabay.com/es/users/OpenClips-30363 and Nemo-3736"
_G.kOtherValues2 = "www.freesound.org and www.freetranslations.org"
_G.kLogoGames = "resource/IMG/igames4kids.png"
---

_G.menuGame = {
  [1] = "menu",
  [2] = "about",
  [3] = "games",
  [4] = "lenguajes",
  [5] = "wingame",
  [6] = "credito",
  [7] = "setting"
 };

local function systemEvents( event )
   if ( event.type == "applicationSuspend" ) then
   elseif ( event.type == "applicationResume" ) then
   elseif ( event.type == "applicationExit" ) then
   elseif ( event.type == "applicationStart" ) then
    -- native.requestExit();
   end
   return true
end

Runtime:addEventListener( "system", systemEvents )

local function onComplete( event )
    if "clicked" == event.action then
        local i = event.index
        if 1 == i then
          native.requestExit()
        elseif 2 == i then
          print( "Out Games" )
        end
    end
end

local function onKeyEvent( event )

   local phase = event.phase
   local keyName = event.keyName
   print( event.phase, event.keyName )

   if ( "back" == keyName and phase == "up" ) then
      if ( composer.getSceneName( "current" ) == "menu" ) then
          local alert = native.showAlert( translations["Exit"][language] , translations["OutGames"][language] , { translations["OutYes"][language], translations["OutNo"][language] }, onComplete )
        -- native.requestExit()
      else
         if ( composer.isOverlay ) then
            composer.hideOverlay()
         else
            local lastScene = _G.lastScene
            if ( lastScene ) then
               composer.gotoScene( lastScene, { effect="crossFade", time=500 } )
            else
            local alert = native.showAlert( translations["Exit"][language],  translations["OutGames"][language] , { translations["OutYes"][language], translations["OutNo"][language]  }, onComplete )
            end
         end
      end
      return true;
   end
   return false  --SEE NOTE BELOW
end

--add the key callback
Runtime:addEventListener( "key", onKeyEvent )

if ( system.getInfo("platformName") == "Android" ) then
   local androidVersion = string.sub( system.getInfo( "platformVersion" ), 1, 3)
   if( androidVersion and tonumber(androidVersion) >= 4.4 ) then
     native.setProperty( "androidSystemUiVisibility", "immersiveSticky" )
     --native.setProperty( "androidSystemUiVisibility", "lowProfile" )
   elseif( androidVersion ) then
     native.setProperty( "androidSystemUiVisibility", "lowProfile" )
   end
end
  
  local function myUnhandledErrorListener( event )
      local iHandledTheError = true
      if ( system.getInfo( "platformName" ) ~= "WinPhone" ) then 
          if iHandledTheError then
            libADS.showLogEvent("Handling the unhandled error ", event.errorMessage);
              -- print( "Handling the unhandled error", event.errorMessage )
          else
            libADS.showLogEvent("Not handling the unhandled error ", event.errorMessage);
              -- print( "Not handling the unhandled error", event.errorMessage )
          end
      end
      return iHandledTheError
  end
Runtime:addEventListener("unhandledError", myUnhandledErrorListener)

--To add appId network each advertiser must go to libADS.lua file

local adsSettings = {
  ["iPhone"] = {
    ["game_over"] = {
      mediationType = "order", 
      adType = "interstitial",
      frequency = 1,
      keepOrderDuringSession = true,
      providers = {
        [1] = {
          providerName = "admob",
          providerFallback = 2,
          mustBeCached = true,
        },
        [2] = {
          providerName = "chartboost",
          providerFallback = 3,
          mustBeCached = false
        },
        [3] = {
          providerName = "revmob",
          providerFallback = 1,
          mustBeCached = false
        }
      }
    },
    ["mainLaunch"] = {
      mediationType = "order", 
      adType = "interstitial",
      frequency = 1,
      keepOrderDuringSession = true,
      providers = {
         [1] = {
          providerName = "admob",
          providerFallback = 2,
          mustBeCached = true,
        },
        [2] = {
          providerName = "chartboost",
          providerFallback = 3,
          mustBeCached = false
        },
        [3] = {
          providerName = "revmob",
          providerFallback = 1,
          mustBeCached = false
        }
      }
    },
    ["during_game"] = {
      mediationType = "order",
      adType = "banner",
      frequency = 1,
      adPosition = "bottom",
      keepOrderDuringSession = true,
      providers = {
        [1] = {
          providerName = "admob",
          providerFallback = 2
        },
        [2] = {
          providerName = "revmob",
          providerFallback = 1
        }
      }
    }
  },
  ["Android"] = {
    ["game_over"] = {
      mediationType = "order",  --possible values are "order" and "percentage"
      adType = "interstitial", --possible values are "banner" or "interstitial"
      frequency = 1, --frequency defines how frequently the ad should appear. In this case, it'll take 2 main menus loads for the ad to show up every time.
      keepOrderDuringSession = true,
      providers = {
        [1] = {
          providerName = "admob", --possible values are "chartboost", "revmob", "tapfortap", "admob", "iads", "playhaven"
          providerFallback = 2, --this defines the fallback provider. In this case, it falls back to the provider number 2 of this table, "revmob".
          mustBeCached = true  --where supported, if the ad is not preloaded, it will fall back to the set provider until the ad is loaded.
          --weight = 75 --meaning 75%, it's the chance of this provider to be chosen for the ad.
        },
        [2] = {
          providerName = "chartboost",
          providerFallback = 3,
          mustBeCached = false
        },
        [3] = {
          providerName = "revmob",
          providerFallback = 1,
          mustBeCached = false
        }
      }
    },
    ["mainLaunch"] = {
      mediationType = "order", 
      adType = "interstitial",
      frequency = 1,
      keepOrderDuringSession = true,
      providers = {
        [1] = {
          providerName = "admob",
          providerFallback = 2,
          mustBeCached = true,
        },
        [2] = {
          providerName = "chartboost",
          providerFallback = 3,
          mustBeCached = false
        },
        [3] = {
          providerName = "revmob",
          providerFallback = 1,
          mustBeCached = false
        }
      }
    },
    ["during_game"] = {
      mediationType = "order",
      adType = "banner",
      frequency = 1,
      adPosition = "bottom",  --only for "banner" ads, it can be set to either "top" or "bottom"
      keepOrderDuringSession = true, --this makes it so that if the app is closed, the order reached will be kept for next time.
      providers = {
        [1] = {
          providerName = "admob",
          providerFallback = 2
        },
        [2] = {
          providerName = "revmob",
          providerFallback = 1
        }
      }
    }
  }
};

local activeAdsProviders = {
  ["Android"] = {"admob", "chartboost","revmob","flurry"}, -- possible values are "tapfortap", "admob", "playhaven", "revmob", "chartboost", "iads"
  ["iPhone"] = {"admob", "chartboost" ,"revmob","flurry"} --it should include all the ads providers you've put in the adsSettings table
};

libADS.init(activeAdsProviders, adsSettings);


