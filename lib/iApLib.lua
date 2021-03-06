local store;

local iApLib = {};
local resultFun;

local function iApListener(event)
  local transaction = event.transaction;
  if ( transaction.state == "purchased" ) then
    native.setActivityIndicator(false);
    if type(resultFun) == "table" then
      if resultFun[transaction.productIdentifier] then
        resultFun[transaction.productIdentifier]();
      end
    else
      if resultFun then
        resultFun(true);
      end
    end
  elseif (transaction.state == "restored") then
    if resultFun[transaction.productIdentifier] then
      resultFun[transaction.productIdentifier]();
    end
  elseif ( transaction.state == "cancelled" ) then
    native.setActivityIndicator(false);
    native.showAlert("Error", "The purchase was cancelled", {"Ok"});
  elseif ( transaction.state == "failed" ) then
    native.setActivityIndicator(false);
    native.showAlert("Error", "The purchase has failed", {"Ok"});
  end
  store.finishTransaction( event.transaction )
end

iApLib.restoreItems = function(items)
  if store.canMakePurchases then
    resultFun = {};
    for i = 1, #items do
      resultFun[items[i].id] = items[i].callback;
    end
    store.restore();
  else
    native.showAlert("Error", "Purchases are not supported on this device.", {"Ok"});
  end
end

iApLib.purchaseItem = function(item, callback)
  resultFun = callback;
  if store.canMakePurchases then
    native.setActivityIndicator(true);
    if system.getInfo("platformName") == "Android" then
      store.purchase(item[1]);
    elseif (system.getInfo("targetAppStore") == "amazon") then
      store.purchase(item[1]);
    else 
      store.purchase(item);
    end
  else
    native.showAlert("Error", "Purchases are not supported on this device.", {"Ok"});
  end
end

if system.getInfo("platformName") == "Android" then
  store = require( "plugin.google.iap.v3" );
  store.init("google", iApListener);
elseif (system.getInfo("targetAppStore") == "amazon" ) then
  store = require( "plugin.amazon.iap" );
  store.init("amazon", iApListener ); 
else 
  store = require "store";
  store.init("apple", iApListener);
end

return iApLib;

