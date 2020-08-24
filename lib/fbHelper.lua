local facebook = require "facebook";
local json = require "json";
local facebookHelper = {};
local appID = _G.facebookAPPID;

facebookHelper.postOnUserWall = function(message)
  local listener;
  listener = function(event)
	  if ( "session" == event.type ) then
		  if ( "login" == event.phase ) then
        local postMsg = {
          ["app_id"] = appID,
          picture = _G.kPictureFB,
          description = _G.kDescriptionFB,
          link = _G.kLinkFB,
          name = _G.kNameFB,
          caption = _G.kCaptionFB
        };
        facebook.showDialog("feed", postMsg);
		  end
	  elseif ("request" == event.type) then	
			local respTab = json.decode(event.response);
   		if respTab then
         native.showAlert("Success", "Message successfuly posted!", {"OK"});
			end
		end
	end
  facebook.login(appID, listener);
end

return facebookHelper;