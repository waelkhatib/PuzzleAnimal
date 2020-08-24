local libADS = {};
local revmob, chartboost, ads, tapfortap, playhaven, adbuddiz, flurry;
--Functions localizations and random seed set
local dbJsonLib = require "dbJsonLib";
local mRandom = math.random;
local adsShowFunctions, adsApiKeys, adsListenerFunctions, adsInitFunctions, adsRemoveBannerFunctions, activeBanners;
math.randomseed(os.time());

adsApiKeys = {
  --VUNGLE ADS http://www.vungle.com
  --ON ANDROID, VUNGLE ADS REQUIRES THE GOOGLE PLAY SERVICES PLUGIN IF YOUR CORONA VERSION IS 2014.2264 OR GREATER
  --MORE INFO HERE http://docs.coronalabs.com/plugin/vungle/index.html
  --VUNGLE SUPPORTS A FUNCTION CALLBACK THAT NOTIFIES YOU IF THE USER HAS WATCHED THE ENTIRE VIDEO, SO THAT YOU CAN REWARD HIM.
  --THE CALLBACK IS _G.VungleCallbackForCompletedVideo, AND RETURNS TRUE IF THE USER HAS WATCHED IT, FALSE IF NOT.
  --AN EXAMPLE OF THE CALLBACK CAN BE
  --_G.VungleCallbackForCompletedVideo = function(result)
  --   if result then
  --     increaseUserCoins();
  --   end
  --end
  --THE CALLBACK CAN BE PLACED ANYWHERE, ANY FILE.
  ["flurry"] = {
    ["Android"] = {
      appId = "K6YPDRTD4KS6MNXRWCHY"
    },
    ["iPhone"] = {
      appId = "W9Z86FSCFF4RDRB96BD4"
    }
  },
  ["vungle"] = {
    ["Android"] = {
      appId = "Your App ID from Vungle for Android"
    },
    ["iPhone"] = {
      appId = "Your App ID from Vungle for iOS"
    }
  },
  --INNER-ACTIVE ADS http://inner-active.com
  ["inneractive"] = {
    ["Android"] = {
      appId = "Your App ID from Inner-Active for Android"
    },
    ["iPhone"] = {
      appId = "Your App ID from Inner-Active for iOS"
    }
  },
  --INMOBI ADS http://www.inmobi.com  
  ["inmobi"] = {
    ["Android"] = {
      appId = "Your App ID from inMobi for Android"
    },
    ["iPhone"] = {
      appId = "Your App ID from inMobi for iOS"
    }
  },
  --ADBUDDIZ ADS http://www.adbuddiz.com
  ["adbuddiz"] = {
    ["Android"] = {
      publisherKey = "Your publisher key from AdBuddiz for Android"
    },
    ["iPhone"] = {
      publisherKey = "Your publisher key from AdBuddiz for iOS"
    }
  },
  --CHARTBOOST ADS http://www.chartboost.com
  --******VERY IMPORTANT******
  --IF YOU'RE USING A CORONA SDK VERSION EQUAL OR MORE RECENT THAN 2014.2169, YOU WILL NEED TO GET THE CHARTBOOST PLUGIN 
  --http://docs.coronalabs.com/plugin/chartboost/index.html
  --THE ABOVE IS TRUE ONLY FOR IOS. ANDROID WORKS WITHOUT ISSUES OR THE NEED OF THE PLUGIN.
  --
   ["chartboostplugin"] = {  
    ["Android"] = {
      appId = "55463da543150f240a040fb9",
      appSignature = "dfe6db129cf7d578a2b9dd5089e50b771ef088c8",
      appVersion = "1.0"
    },
    ["iPhone"] = {
      appId = "55463da543150f240a040fb8",
      appSignature = "a30857989723d51f52a9500516113f5044d12ffd",
      appVersion = "1.0"
    }
  },
  ["chartboost"] = {  
    ["Android"] = {
      appId = "55463da543150f240a040fb9",
      appSignature = "dfe6db129cf7d578a2b9dd5089e50b771ef088c8",
      appVersion = "1.0"
    },
    ["iPhone"] = {
      appId = "55463da543150f240a040fb8",
      appSignature = "a30857989723d51f52a9500516113f5044d12ffd",
      appVersion = "1.0"
    }
  },
  --REVMOB ADS https://www.revmobmobileadnetwork.com
  ["revmob"] = {
    ["Android"] = {
      appId = "5546436183cb8b5c1149eac5"
    },
    ["iPhone"] = {
      appId = "5546433bd7cc866630a9e192"
    }
  },
  --TAPFORTAP ADS https://tapfortap.com
  ["tapfortap"] = {
    ["Android"] = {
      appId = "80c48eac070218aabaf59edf0d7bb1ef"
    },
    ["iPhone"] = {
      appId = "80c48eac070218aabaf59edf0d7bb1ef"
    }
  },
  --ADMOB ADS https://www.admob.com
  ["admob"] = {
    ["Android"] = {
      pluginVersion = 2, --SPECIFY IF YOU'RE USING VERSION 1 (OLD) OF THE PLUGIN, OR VERSION 2 (NEW). DIFFERENCIES CAN BE FOUND HERE: http://coronalabs.com/blog/2014/07/15/tutorial-implementing-admob-v2/
      bannerId = "ca-app-pub-2924090436780396/1279378669",
      interstitialId = "ca-app-pub-2924090436780396/5709578264"
    },
    ["iPhone"] = {
      pluginVersion = 2, --SPECIFY IF YOU'RE USING VERSION 1 (OLD) OF THE PLUGIN, OR VERSION 2 (NEW). DIFFERENCIES CAN BE FOUND HERE: http://coronalabs.com/blog/2014/07/15/tutorial-implementing-admob-v2/
      bannerId = "ca-app-pub-2924090436780396/8663044664",
      interstitialId = "ca-app-pub-2924090436780396/1139777860"
    }
  },
  --IADS ADS http://advertising.apple.com
  ["iads"] = {
    ["iPhone"] = {
      appId = "Your app id from iads"
    }
  },
  --PLAYHAVEN ADS http://upsight.com
  ["playhaven"] = {
    ["Android"] = {
      appToken = "7b3e6e0eeda74c408a22815820678a70",
      appSecret = "bd66f16b33574748bec467568756a9cc",
      placementId = "puzzleanimals"
    },
    ["iPhone"] = {
      appToken = "f77863423e374d71bd30a2b78da61195",
      appSecret = "753c76b6650d470eba75c5b04a2c801e",
      placementId = "puzzleanimalas"
    }
  }
};

local currentSystem = system.getInfo("platformName");

if currentSystem ~= "WinPhone" then
  if currentSystem ~= "Android" then
    currentSystem = "iPhone";
  end
end

adsListenerFunctions = {
  ["vungle"] = function(event)
    if event.isError then
      if ads.dbJsonLibADS and ads.dbJsonLibADS.vungle then
        local adData, providerData = ads.dbJsonLibADS.vungle.adData, ads.dbJsonLibADS.vungle.providerData;
        adData.fallbackCount = adData.fallbackCount or 0;
        adData.fallbackCount = adData.fallbackCount+1;
        if providerData.providerFallback and adData.fallbackCount <= #adData.providers then
          adsShowFunctions[adData.providers[providerData.providerFallback].providerName][adData.adType](adData.providers[providerData.providerFallback], adData);
        else
          adData.fallbackCount = 0;
        end
      end
    elseif event.type == "adView" then
      if event.isCompletedView then
        if _G.VungleCallbackForCompletedVideo then
          _G.VungleCallbackForCompletedVideo(true);
        end
      else
        if _G.VungleCallbackForCompletedVideo then
          _G.VungleCallbackForCompletedVideo(false);
        end
      end
    end
  end,
  ["inneractive"] = function(event)
    if event.isError then
      if ads.dbJsonLibADS and ads.dbJsonLibADS.inneractive then
        local adData, providerData = ads.dbJsonLibADS.inneractive.adData, ads.dbJsonLibADS.inneractive.providerData;
        adData.fallbackCount = adData.fallbackCount or 0;
        adData.fallbackCount = adData.fallbackCount+1;
        if providerData.providerFallback and adData.fallbackCount <= #adData.providers then
          adsShowFunctions[adData.providers[providerData.providerFallback].providerName][adData.adType](adData.providers[providerData.providerFallback], adData);
        else
          adData.fallbackCount = 0;
        end
      end
    end
  end,
  ["inmobi"] = function(event)
    if event.isError then
      if ads.dbJsonLibADS and ads.dbJsonLibADS.inmobi then
        local adData, providerData = ads.dbJsonLibADS.inmobi.adData, ads.dbJsonLibADS.inmobi.providerData;
        adData.fallbackCount = adData.fallbackCount or 0;
        adData.fallbackCount = adData.fallbackCount+1;
        if providerData.providerFallback and adData.fallbackCount <= #adData.providers then
          adsShowFunctions[adData.providers[providerData.providerFallback].providerName][adData.adType](adData.providers[providerData.providerFallback], adData);
        else
          adData.fallbackCount = 0;
        end
      end
    end
  end,
  ["adbuddiz"] = function(event)
    if event.value == "didFailToShowAd" then
      if adbuddiz.dbJsonLibADS then
        local adData, providerData = adbuddiz.dbJsonLibADS.adData, adbuddiz.dbJsonLibADS.providerData;
        adData.fallbackCount = adData.fallbackCount or 0;
        adData.fallbackCount = adData.fallbackCount+1;
        if providerData.providerFallback and adData.fallbackCount <= #adData.providers then
          adsShowFunctions[adData.providers[providerData.providerFallback].providerName][adData.adType](adData.providers[providerData.providerFallback], adData);
        else
          adData.fallbackCount = 0;
        end
      end
    end
  end,
  ["chartboostplugin"] = function(event)
    if event.type == "interstitial" then
      if event.respone == "failed" then
        if chartboost.dbJsonLibADS then
          local adData, providerData = chartboost.dbJsonLibADS.adData, chartboost.dbJsonLibADS.providerData;
          adData.fallbackCount = adData.fallbackCount or 0;
          adData.fallbackCount = adData.fallbackCount+1;
          if providerData.providerFallback and adData.fallbackCount <= #adData.providers then
            adsShowFunctions[adData.providers[providerData.providerFallback].providerName][adData.adType](adData.providers[providerData.providerFallback], adData);
          else
            adData.fallbackCount = 0;
          end
        end
      end
    end
  end,
  ["chartboost"] = {
    didFailToLoadInterstitial = function(event)
      if chartboost.dbJsonLibADS then
        local adData, providerData = chartboost.dbJsonLibADS.adData, chartboost.dbJsonLibADS.providerData;
        adData.fallbackCount = adData.fallbackCount or 0;
        adData.fallbackCount = adData.fallbackCount+1;
        if providerData.providerFallback and adData.fallbackCount <= #adData.providers then
          adsShowFunctions[adData.providers[providerData.providerFallback].providerName][adData.adType](adData.providers[providerData.providerFallback], adData);
        else
          adData.fallbackCount = 0;
        end
      end
    end
  },
  ["revmob"] = function(event)
    if event.type == "adNotReceived" then
      if revmob.dbJsonLibADS then
        local adData, providerData = revmob.dbJsonLibADS.adData, revmob.dbJsonLibADS.providerData;
        adData.fallbackCount = adData.fallbackCount or 0;
        adData.fallbackCount = adData.fallbackCount+1;
        if providerData.providerFallback and adData.fallbackCount <= #adData.providers then
          adsShowFunctions[adData.providers[providerData.providerFallback].providerName][adData.adType](adData.providers[providerData.providerFallback], adData);
        else
          adData.fallbackCount = 0;
        end
      end
    end
  end,
  ["tapfortap"] = function(event)
    if event.event == "onFailToReceiveAd" then
      if tapfortap.dbJsonLibADS then
        local adData, providerData = tapfortap.dbJsonLibADS.adData, tapfortap.dbJsonLibADS.providerData;
        adData.fallbackCount = adData.fallbackCount or 0;
        adData.fallbackCount = adData.fallbackCount+1;
        if providerData.providerFallback and adData.fallbackCount <= #adData.providers then
          adsShowFunctions[adData.providers[providerData.providerFallback].providerName][adData.adType](adData.providers[providerData.providerFallback], adData);
        else
          adData.fallbackCount = 0;
        end
      end
    end
  end,
  ["admob"] = function(event)
    if event.isError then
      if ads.dbJsonLibADS and ads.dbJsonLibADS.admob then
        local adData, providerData = ads.dbJsonLibADS.admob.adData, ads.dbJsonLibADS.admob.providerData;
        adData.fallbackCount = adData.fallbackCount or 0;
        adData.fallbackCount = adData.fallbackCount+1;
        if providerData.providerFallback and adData.fallbackCount <= #adData.providers then
          adsShowFunctions[adData.providers[providerData.providerFallback].providerName][adData.adType](adData.providers[providerData.providerFallback], adData);
        else
          adData.fallbackCount = 0;
        end
      end
    end
  end,
  ["iads"] = function()
    if event.isError then
      if ads.dbJsonLibADS and ads.dbJsonLibADS.iads then
        local adData, providerData = ads.dbJsonLibADS.iads.adData, ads.dbJsonLibADS.iads.providerData;
        adData.fallbackCount = adData.fallbackCount or 0;
        adData.fallbackCount = adData.fallbackCount+1;
        if providerData.providerFallback and adData.fallbackCount <= #adData.providers then
          adsShowFunctions[adData.providers[providerData.providerFallback].providerName][adData.adType](adData.providers[providerData.providerFallback], adData);
        else
          adData.fallbackCount = 0;
        end
      end
    end
  end,
  ["playhaven"] = function(event)
    if event.status == "didFail" or event.status == "requestFailed" then
      if playhaven.dbJsonLibADS then
        local adData, providerData = playhaven.dbJsonLibADS.adData, playhaven.dbJsonLibADS.providerData;
        adData.fallbackCount = adData.fallbackCount or 0;
        adData.fallbackCount = adData.fallbackCount+1;
        if providerData.providerFallback and adData.fallbackCount <= #adData.providers then
          adsShowFunctions[adData.providers[providerData.providerFallback].providerName][adData.adType](adData.providers[providerData.providerFallback], adData);
        else
          adData.fallbackCount = 0;
        end
      end
    end
  end
};


adsInitFunctions = {
  ["flurry"] = function()
    if ( system.getInfo( "platformName" ) ~= "WinPhone" ) then   
      flurry = require( "analytics" )
      flurry.init( adsApiKeys.flurry[currentSystem].appId )
    end
  end,
  ["vungle"] = function()
    ads = require "ads";
    ads.init("vungle", adsApiKeys.vungle[currentSystem].appId, adsListenerFunctions.vungle);
  end,
  ["inneractive"] = function()
    ads = require "ads";
    ads.init("inneractive", adsApiKeys.inneractive[currentSystem].appId, adsListenerFunctions.inneractive);
  end,
  ["inmobi"] = function()
    ads = require "ads";
    ads.init("inmobi", adsApiKeys.inmobi[currentSystem].appId, adsListenerFunctions.inmobi);
  end,
  ["adbuddiz"] = function()
    adbuddiz = require("plugin.adbuddiz");
    if currentSystem == "Android" then
      adbuddiz.setAndroidPublisherKey(adsApiKeys.adbuddiz[currentSystem].publisherKey);
    else
      adbuddiz.setIOSPublisherKey(adsApiKeys.adbuddiz[currentSystem].publisherKey);
    end
    adbuddiz.cacheAds();
    Runtime:addEventListener("AdBuddizEvent", adsListenerFunctions.adbuddiz);
  end,
  ["chartboostplugin"] = function()
    chartboost = require( "plugin.chartboost" );
    chartboost.init(
    {
      appID = adsApiKeys.chartboostplugin[currentSystem].appId,
      appSignature = adsApiKeys.chartboostplugin[currentSystem].appSignature,  
      listener = adsListenerFunctions.chartboostplugin
    })
    local function systemEvent( event )
      local phase = event.phase;
      if event.type == 'applicationResume' then
        chartboost.startSession( adsApiKeys.chartboostplugin[currentSystem].appId, adsApiKeys.chartboostplugin[currentSystem].appSignature );
      end
      return true
    end
    Runtime:addEventListener('system', systemEvent);
    chartboost.startSession(adsApiKeys.chartboostplugin[currentSystem].appId, adsApiKeys.chartboostplugin[currentSystem].appSignature);
    chartboost.cache("cachedInterstitial");
  end,
  ["chartboost"] = function()
    chartboost = require "lib.chartboost.chartboost";
    chartboost.create{
      appId = adsApiKeys.chartboost[currentSystem].appId,
      appSignature = adsApiKeys.chartboost[currentSystem].appSignature,
      appVersion = adsApiKeys.chartboost[currentSystem].appVersion,
      delegate = adsListenerFunctions.chartboost;
    };
    chartboost.startSession();
    chartboost.cacheInterstitial();
  end,
  ["revmob"] = function()
    revmob = require "lib.revmob.revmob";
    revmob.startSession({["Android"] = adsApiKeys.revmob["Android"].appId, ["iPhone OS"] = adsApiKeys.revmob["iPhone"].appId });
  end,
  ["tapfortap"] = function()
    tapfortap = require "plugin.tapfortap";
    tapfortap.initialize(adsApiKeys.tapfortap[currentSystem].appId);
    tapfortap.setInterstitialListener(adsListenerFunctions.tapfortap);
    tapfortap.setAdViewListener(adsListenerFunctions.tapfortap);
    tapfortap.prepareInterstitial();
  end,
  ["admob"] = function()
    ads = require "ads";
    local adMobAppId = adsApiKeys.admob[currentSystem].bannerId;
    if adMobAppId == "Your app id from admob for a banner ad" then
      adMobAppId = adsApiKeys.admob[currentSystem].interstitialId;
    end
    ads.init("admob", adMobAppId, adsListenerFunctions.admob);
    if ads:getCurrentProvider() ~= "admob" then
      ads:setCurrentProvider("admob");
    end
    if adsApiKeys.admob[currentSystem].interstitialId ~= "Your app id from admob for an interstitial ad" then
      ads.load("interstitial", {appId = adsApiKeys.admob[currentSystem].interstitialId, testMode = false});
    end
  end,
  ["iads"] = function()
    ads = require "ads";
    ads.init("iads", adsApiKeys.iads["iPhone"].appId, adsListenerFunctions.iads);
  end,
  ["playhaven"] = function()
    playhaven = require "plugin.playhaven";
    playhaven.init(adsListenerFunctions.playhaven, {
        token = adsApiKeys.playhaven[currentSystem].appToken,
        secret = adsApiKeys.playhaven[currentSystem].appSecret,
        closeButton = system.pathForFile("lib/playhaven/closeButton.png", system.ResourceDirectory),
        closeButtonTouched = system.pathForFile("lib/playhaven/closeButtonTouched.png", system.ResourceDirectory)
    });
  end
};

adsShowFunctions = {
  ["vungle"] = {
    ["interstitial"] = function(providerData, adData)
      if ads:getCurrentProvider() ~= "vungle" then
        ads:setCurrentProvider("vungle");
      end
      
      if providerData.mustBeCached then
        if not ads.isAdAvailable() then
          adData.fallbackCount = adData.fallbackCount or 0;
          adData.fallbackCount = adData.fallbackCount+1;
          if providerData.providerFallback and adData.fallbackCount <= #adData.providers then
            adsShowFunctions[adData.providers[providerData.providerFallback].providerName]["interstitial"](adData.providers[providerData.providerFallback], adData);
          else
            adData.fallbackCount = 0;
          end
          return;
        end
      end
      ads.dbJsonLibADS = ads.dbJsonLibADS or {};
      ads.dbJsonLibADS.vungle = ads.dbJsonLibADS.vungle or {};
      ads.dbJsonLibADS.vungle.adData = adData;
      ads.dbJsonLibADS.vungle.providerData = providerData;
      
      ads.show("interstitial");
    end
  },
  ["inneractive"] = {
    ["interstitial"] = function(providerData, adData)
      if ads:getCurrentProvider() ~= "inneractive" then
        ads:setCurrentProvider("inneractive");
      end

      ads.dbJsonLibADS = ads.dbJsonLibADS or {};
      ads.dbJsonLibADS.inneractive = ads.dbJsonLibADS.inneractive or {};
      ads.dbJsonLibADS.inneractive.adData = adData;
      ads.dbJsonLibADS.inneractive.providerData = providerData;
      
      ads.show("fullscreen");
    end,
    ["banner"] = function(providerData, adData)
      if ads:getCurrentProvider() ~= "inneractive" then
        ads:setCurrentProvider("inneractive");
      end
      
      ads.dbJsonLibADS = ads.dbJsonLibADS or {};
      ads.dbJsonLibADS.inneractive = ads.dbJsonLibADS.inneractive or {};
      ads.dbJsonLibADS.inneractive.adData = adData;
      ads.dbJsonLibADS.inneractive.providerData = providerData;
      
      local xPos, yPos;
      adData.adPosition = adData.adPosition or "top";
      if adData.adPosition == "top" then
        xPos, yPos = display.screenOriginX, display.screenOriginY;
      elseif adData.adPosition == "bottom" then
        xPos, yPos = display.screenOriginX, 10000;
      end
      
      ads.show("banner", { x= xPos, y= yPos});
      activeBanners = activeBanners or {};
      activeBanners[adData.innerId] = "inneractive";
    end
  },
  ["inmobi"] = {
    ["interstitial"] = function(providerData, adData)
      if ads:getCurrentProvider() ~= "inmobi" then
        ads:setCurrentProvider("inmobi");
      end

      ads.dbJsonLibADS = ads.dbJsonLibADS or {};
      ads.dbJsonLibADS.inmobi = ads.dbJsonLibADS.inmobi or {};
      ads.dbJsonLibADS.inmobi.adData = adData;
      ads.dbJsonLibADS.inmobi.providerData = providerData;
      
      ads.show("interstitial");
    end,
    ["banner"] = function(providerData, adData)
      if ads:getCurrentProvider() ~= "inmobi" then
        ads:setCurrentProvider("inmobi");
      end
      
      ads.dbJsonLibADS = ads.dbJsonLibADS or {};
      ads.dbJsonLibADS.inmobi = ads.dbJsonLibADS.inmobi or {};
      ads.dbJsonLibADS.inmobi.adData = adData;
      ads.dbJsonLibADS.inmobi.providerData = providerData;
      
      local xPos, yPos;
      adData.adPosition = adData.adPosition or "top";
      if adData.adPosition == "top" then
        xPos, yPos = display.screenOriginX, display.screenOriginY;
      elseif adData.adPosition == "bottom" then
        xPos, yPos = display.screenOriginX, 10000;
      end
      
      ads.show("banner320x50", { x= xPos, y= yPos});
      activeBanners = activeBanners or {};
      activeBanners[adData.innerId] = "inmobi";
    end
  },
  ["adbuddiz"] = {
    ["interstitial"] = function(providerData, adData)
      if providerData.mustBeCached then
        if not adbuddiz.isReadyToShowAd() then
          adbuddiz.cacheAds();
          adData.fallbackCount = adData.fallbackCount or 0;
          adData.fallbackCount = adData.fallbackCount+1;
          if providerData.providerFallback and adData.fallbackCount <= #adData.providers then
            adsShowFunctions[adData.providers[providerData.providerFallback].providerName]["interstitial"](adData.providers[providerData.providerFallback], adData);
          else
            adData.fallbackCount = 0;
          end
          return;
        end
      end
      adbuddiz.dbJsonLibADS = adbuddiz.dbJsonLibADS or {};
      adbuddiz.dbJsonLibADS.adData = adData;
      adbuddiz.dbJsonLibADS.providerData = providerData;
      
      adbuddiz.showAd();
    end
  },
  ["chartboostplugin"] = {
    ["interstitial"] = function(providerData, adData)
      if providerData.mustBeCached then
        if not chartboost.hasCachedInterstitial("cachedInterstitial") then
          chartboost.cache("cachedInterstitial");
          adData.fallbackCount = adData.fallbackCount or 0;
          adData.fallbackCount = adData.fallbackCount+1;
          if providerData.providerFallback and adData.fallbackCount <= #adData.providers then
            adsShowFunctions[adData.providers[providerData.providerFallback].providerName]["interstitial"](adData.providers[providerData.providerFallback], adData);
          else
            adData.fallbackCount = 0;
          end
          return;
        else
          chartboost.show( 'interstitial', "cachedInterstitial");
        end
      else
        chartboost.show('interstitial');
      end
      chartboost.dbJsonLibADS = chartboost.dbJsonLibADS or {};
      chartboost.dbJsonLibADS.adData = adData;
      chartboost.dbJsonLibADS.providerData = providerData;
    end
  },
  ["chartboost"] = {
    ["interstitial"] = function(providerData, adData)
      if providerData.mustBeCached then
        if not chartboost.hasCachedInterstitial() then
          chartboost.cacheInterstitial();
          adData.fallbackCount = adData.fallbackCount or 0;
          adData.fallbackCount = adData.fallbackCount+1;
          if providerData.providerFallback and adData.fallbackCount <= #adData.providers then
            adsShowFunctions[adData.providers[providerData.providerFallback].providerName]["interstitial"](adData.providers[providerData.providerFallback], adData);
          else
            adData.fallbackCount = 0;
          end
          return;
        end
      end
      chartboost.dbJsonLibADS = chartboost.dbJsonLibADS or {};
      chartboost.dbJsonLibADS.adData = adData;
      chartboost.dbJsonLibADS.providerData = providerData;
      
      chartboost.showInterstitial();
    end
  },
  ["revmob"] = {
    ["interstitial"] = function(providerData, adData)
      revmob.dbJsonLibADS = revmob.dbJsonLibADS or {};
      revmob.dbJsonLibADS.adData = adData;
      revmob.dbJsonLibADS.providerData = providerData;
      
      revmob.showFullscreen(adsListenerFunctions.revmob);
    end,
    ["banner"] = function(providerData, adData)
      local xPos, yPos;
      adData.adPosition = adData.adPosition or "top";
      if adData.adPosition == "top" then
        xPos, yPos = display.contentCenterX, display.screenOriginY+20;
      elseif adData.adPosition == "bottom" then
        xPos, yPos = display.contentCenterX, display.contentHeight-display.screenOriginY-20;
      end
      
      revmob.dbJsonLibADS = revmob.dbJsonLibADS or {};
      revmob.dbJsonLibADS.adData = adData;
      revmob.dbJsonLibADS.providerData = providerData;
      
      revmob.dbJsonLibADS.currentBanner = revmob.createBanner({x = xPos, y = yPos, width = display.contentWidth-(display.screenOriginX*2), height = 40, listener = adsListenerFunctions.revmob});
      
      activeBanners = activeBanners or {};
      activeBanners[adData.innerId] = "revmob";
    end
  },
  ["tapfortap"] = {
    ["interstitial"] = function(providerData, adData)
      if providerData.mustBeCached then
        if not tapfortap.interstitialIsReady() then
          tapfortap.prepareInterstitial();
          adData.fallbackCount = adData.fallbackCount or 0;
          adData.fallbackCount = adData.fallbackCount+1;
          if providerData.providerFallback and adData.fallbackCount <= #adData.providers then
            adsShowFunctions[adData.providers[providerData.providerFallback].providerName]["interstitial"](adData.providers[providerData.providerFallback], adData);
          else
            adData.fallbackCount = 0;
          end
          return;
        end
      end
      tapfortap.dbJsonLibADS = tapfortap.dbJsonLibADS or {};
      tapfortap.dbJsonLibADS.adData = adData;
      tapfortap.dbJsonLibADS.providerData = providerData;
 
      tapfortap.showInterstitial();
    end,
    ["banner"] = function(providerData, adData)
      local xPos, yPos;
      adData.adPosition = adData.adPosition or "top";
      if adData.adPosition == "top" then
        xPos, yPos = 1, 2;
      elseif adData.adPosition == "bottom" then
        xPos, yPos = 3, 2;
      end   
      tapfortap.dbJsonLibADS = tapfortap.dbJsonLibADS or {};
      tapfortap.dbJsonLibADS.adData = adData;
      tapfortap.dbJsonLibADS.providerData = providerData;
      
      tapfortap.createAdView(xPos, yPos);
      activeBanners = activeBanners or {};
      activeBanners[adData.innerId] = "tapfortap";
    end
  },
  ["admob"] = {
    ["interstitial"] = function(providerData, adData)
      if ads:getCurrentProvider() ~= "admob" then
        ads:setCurrentProvider("admob");
      end
      
      if providerData.mustBeCached then
        if not ads.isLoaded() then
          ads.load("interstitial", {appId = adsApiKeys.admob[currentSystem].interstitialId, testMode = false});
          adData.fallbackCount = adData.fallbackCount or 0;
          adData.fallbackCount = adData.fallbackCount+1;
          if providerData.providerFallback and adData.fallbackCount <= #adData.providers then
            adsShowFunctions[adData.providers[providerData.providerFallback].providerName]["interstitial"](adData.providers[providerData.providerFallback], adData);
          else
            adData.fallbackCount = 0;
          end
          return;
        end
      end
      ads.dbJsonLibADS = ads.dbJsonLibADS or {};
      ads.dbJsonLibADS.admob = ads.dbJsonLibADS.admob or {};
      ads.dbJsonLibADS.admob.adData = adData;
      ads.dbJsonLibADS.admob.providerData = providerData;
      
      ads.show("interstitial", {appId = adsApiKeys.admob[currentSystem].interstitialId});
    end,
    ["banner"] = function(providerData, adData)
      if ads:getCurrentProvider() ~= "admob" then
        ads:setCurrentProvider("admob");
      end
      
      ads.dbJsonLibADS = ads.dbJsonLibADS or {};
      ads.dbJsonLibADS.admob = ads.dbJsonLibADS.admob or {};
      ads.dbJsonLibADS.admob.adData = adData;
      ads.dbJsonLibADS.admob.providerData = providerData;
      
      local xPos, yPos;
      adData.adPosition = adData.adPosition or "top";
      if adData.adPosition == "top" then
        xPos, yPos = display.screenOriginX, display.screenOriginY;
      elseif adData.adPosition == "bottom" then
        xPos, yPos = display.screenOriginX, 10000;
      end
      
      ads.show("banner", { x= xPos, y= yPos, appId = adsApiKeys.admob[currentSystem].bannerId});
      activeBanners = activeBanners or {};
      activeBanners[adData.innerId] = "admob";
    end
  },
  ["iads"] = {
    ["banner"] = function(providerData, adData)
      if ads:getCurrentProvider() ~= "iads" then
        ads:setCurrentProvider("iads");
      end
      
      ads.dbJsonLibADS = ads.dbJsonLibADS or {};
      ads.dbJsonLibADS.iads = ads.dbJsonLibADS.iads or {};
      ads.dbJsonLibADS.iads.adData = adData;
      ads.dbJsonLibADS.iads.providerData = providerData;
      
      local xPos, yPos;
      adData.adPosition = adData.adPosition or "top";
      if adData.adPosition == "top" then
        xPos, yPos = display.screenOriginX, display.screenOriginY;
      elseif adData.adPosition == "bottom" then
        xPos, yPos = display.screenOriginX, 10000;
      end
      
      ads.show("banner", { x= xPos, y= yPos, appId = adsApiKeys.admob[currentSystem].bannerId});
      activeBanners = activeBanners or {};
      activeBanners[adData.innerId] = "iads";
    end
  },
  ["playhaven"] = {
    ["interstitial"] = function(providerData, adData)
      playhaven.dbJsonLibADS = playhaven.dbJsonLibADS or {};
      playhaven.dbJsonLibADS.adData = adData;
      playhaven.dbJsonLibADS.providerData = providerData;
      
      playhaven.contentRequest(adsApiKeys.playhaven[currentSystem].placementId, true);
    end
  }
};

adsRemoveBannerFunctions = {
  ["revmob"] = function()
    if revmob.dbJsonLibADS and revmob.dbJsonLibADS.currentBanner then
      revmob.dbJsonLibADS.currentBanner:release();
      revmob.dbJsonLibADS.currentBanner = nil;
    end
  end,
  ["tapfortap"] = function()
    tapfortap.removeAdView();
  end,
  ["admob"] = function()
    if ads:getCurrentProvider() ~= "admob" then
      ads:setCurrentProvider("admob");
    end
    ads:hide();
  end,
  ["iads"] = function()
    if ads:getCurrentProvider() ~= "iads" then
      ads:setCurrentProvider("iads");
    end
    ads:hide();
  end,
  ["inmobi"] = function()
    if ads:getCurrentProvider() ~= "inmobi" then
      ads:setCurrentProvider("inmobi");
    end
    ads:hide();
  end,
  ["inneractive"] = function()
    if ads:getCurrentProvider() ~= "inneractive" then
      ads:setCurrentProvider("inneractive");
    end
    ads:hide();
  end
};

libADS.init = function(activeAds, adsSettings)
  if ( system.getInfo( "platformName" ) ~= "WinPhone" ) then
    libADS.adsSettings = adsSettings;
    activeAds = activeAds[currentSystem];
--    print( "activeAds  = ".. tostring(activeAds) )
    for i = 1, #activeAds do
      adsInitFunctions[activeAds[i]]();
    end
  end
end

libADS.showLogEvent = function(logE)
  if ( system.getInfo( "platformName" ) ~= "WinPhone" ) then   
    local valueVersion = system.getInfo( "appVersionString" );
    flurry.logEvent("Version apps -> "..valueVersion.." log -> "..logE);
  end;
end

libADS.showAd = function(adId)
  local selectedAd = libADS.adsSettings[currentSystem][adId];
  if not selectedAd then
    return;
  elseif dbJsonLib.getSaveValue("isAdsRemoved") then
      print("isAdsRemoved");
      return;
  end 
  selectedAd.innerId = adId;
  if selectedAd.frequency > 1 then
    selectedAd.currentFrequencyCount = selectedAd.currentFrequencyCount or 0;
    selectedAd.currentFrequencyCount = selectedAd.currentFrequencyCount+1;
    if selectedAd.currentFrequencyCount >= selectedAd.frequency then
      selectedAd.currentFrequencyCount = 0;
    else
      return;
    end
  end
  
  local chosenProvider;
  if selectedAd.mediationType == "order" then
    if selectedAd.keepOrderDuringSession then
      selectedAd.currentOrderCount = dbJsonLib.getSaveValue(adId.."order") or 0;
    end
    selectedAd.currentOrderCount = selectedAd.currentOrderCount or 0;
    selectedAd.currentOrderCount = selectedAd.currentOrderCount+1;
    if selectedAd.currentOrderCount > #selectedAd.providers then
      selectedAd.currentOrderCount = 1;
    end
    if selectedAd.keepOrderDuringSession then
      dbJsonLib.setSaveValue(adId.."order", selectedAd.currentOrderCount, true);
    end
    chosenProvider = selectedAd.providers[selectedAd.currentOrderCount];
  elseif selectedAd.mediationType == "percentage" then
    local chance = mRandom(1, 100);
    local currentWeight = 0;
    for i = 1, #selectedAd.providers do
      currentWeight = currentWeight+selectedAd.providers[i].weight;
      if chance <= currentWeight then
        chosenProvider = selectedAd.providers[i];
        break;
      end
    end
  end

  adsShowFunctions[chosenProvider.providerName][selectedAd.adType](chosenProvider, selectedAd);
end

libADS.removeAd = function(adId)
  if activeBanners and activeBanners[adId] then
    adsRemoveBannerFunctions[activeBanners[adId]]();
  end
end

return libADS;