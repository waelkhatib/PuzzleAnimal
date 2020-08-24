local _M = {}

local oAuth = require('lib.oauth');

_M.consumer_key = _G.twitterConsumerKey;
_M.consumer_secret = _G.twitterSecretKey;

_M.webURL = 'https://www.google.com/';

_M.twitter_request_token_secret = nil

_M.access_token = nil
_M.access_token_secret = nil
_M.user_id = 0
_M.screen_name = ''

_M.action = ''

_M.postMessage = ''
_M.delegate = ''

local function responseToTable(str, delimeters)
  local obj = {};

  while str:find(delimeters[1]) ~= nil do
    if #delimeters > 1 then
      local key_index = 1;
      local val_index = str:find(delimeters[1]);
      local key = str:sub(key_index, val_index - 1);
    
      str = str:sub((val_index + delimeters[1]:len()));
    
      local end_index;
      local value;
    
      if str:find(delimeters[2]) == nil then
        end_index = str:len();
        value = str;
      else
        end_index = str:find(delimeters[2]);
        value = str:sub(1, (end_index - 1));
        str = str:sub((end_index + delimeters[2]:len()), str:len());
      end
      obj[key] = value;
    else
      local val_index = str:find(delimeters[1]);
      str = str:sub((val_index + delimeters[1]:len()));
    
      local end_index;
      local value;
    
      if str:find(delimeters[1]) == nil then
        end_index = str:len();
        value = str;
      else
        end_index = str:find(delimeters[1]);
        value = str:sub(1, (end_index - 1));
        str = str:sub(end_index, str:len());
      end
            
      obj[#obj + 1] = value;
    end
  end
  return obj;
end

function _M.listener(event)
  local url = event.url;
  local self = _M ;
  if url:find(self.webURL) then
    if url:find('oauth_token') then
      url = url:sub(url:find('?') + 1, url:len());
      local authorize_response = responseToTable(url, {'=', '&'});

      oAuth.getAccessToken(authorize_response.oauth_token, authorize_response.oauth_verifier, self.twitter_request_token_secret, self.consumer_key, self.consumer_secret, 'https://api.twitter.com/oauth/access_token', function (event)
        if not event.isError then
          local access_response = responseToTable(event.response, {'=', '&'});
          self.access_token = access_response.oauth_token;
          self.access_token_secret = access_response.oauth_token_secret;
          self.user_id = access_response.user_id;
          self.screen_name = access_response.screen_name;
          if self.action == 'tweet' then
            self:apiTweet();
          end
          self.action = '';
        else
          print('Twitter getAccessToken Error');
        end
      end)
    else
      if type(self.delegate.twitterCancel) == 'function' then
        self.delegate.twitterCancel();
      end
    end
    timer.performWithDelay(150, function()
      native.cancelWebPopup();
    end, 1);
    return false;
  end
  return true;
end

function _M:apiLogin()
  native.setActivityIndicator(true);
  if not self.consumer_key or not self.consumer_secret then
    native.setActivityIndicator(nil);
    if type(self.delegate.twitterFailed) == 'function' then
      self.delegate.twitterFailed();
    end
    return
  end

  local twitter_request = oAuth.getRequestToken(self.consumer_key, self.webURL, 'https://twitter.com/oauth/request_token', self.consumer_secret, function (event)
    native.setActivityIndicator(nil);
    if not event.isError then
      local twitter_request_token = event.token;
      self.twitter_request_token_secret = event.token_secret;
      if not twitter_request_token then
        if type(self.delegate.twitterFailed) == 'function' then
          self.delegate.twitterFailed();
        end
        return
      end
      -- Full screen WebView
      local _T = display.screenOriginY; -- Top
      local _L = display.screenOriginX; -- Left
      local _R = display.viewableContentWidth - _L; -- Right
      local _B = display.viewableContentHeight - _T;-- Bottom
      native.showWebPopup(_L, _T, _R - _L, _B - _T, 'https://api.twitter.com/oauth/authorize?oauth_token=' .. twitter_request_token, {urlRequest = _M.listener});
    else
      print('Twitter getRequestToken Error')
      if type(self.delegate.twitterFailed) == 'function' then
        self.delegate.twitterFailed();
      end
    end
  end)
end

function _M:apiTweet()
  native.setActivityIndicator(true);
  local params = {{key = 'status', value = self.postMessage}};
    
  oAuth.makeRequest('https://api.twitter.com/1.1/statuses/update.json', params, self.consumer_key, self.access_token, self.consumer_secret, self.access_token_secret, 'POST', function (event)
    native.setActivityIndicator(nil);
    if not event.isError then
      if type(self.delegate.twitterSuccess) == 'function' then
        self.delegate.twitterSuccess();
      end
    else
      print('Twitter Tweet Error')
      if type(self.delegate.twitterFailed) == 'function' then
       self.delegate.twitterFailed();
      end
    end
  end)
end

function _M:tweet(msg, del)
  self.action = 'tweet';
  self.postMessage = msg;
  self.delegate = del or {["twitterSuccess"] = function() native.showAlert("Success", "Your tweet was successfuly sent!", {"OK"}); end,
    ["twitterFailed"] = function() native.showAlert("Error", "Couldn't share your tweet. Please try again later!", {"OK"}); end,
    ["twitterCancel"] = function() print("Cancelled tweet message") end,
  };

  if not self.access_token then
    return self:apiLogin();
  else
    return self:apiTweet();
  end
end

return _M