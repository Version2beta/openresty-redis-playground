local json = json or require 'cjson'

local redis = redis or require "resty.redis"

local redisconnect = function()
  local red = redis:new()
  red:set_timeout(1000) -- 1 sec
  local ok, err = red:connect("127.0.0.1", 6379)
  if not ok then
    ngx.log(ngx.CRIT, "failed to connect to redis database: ", err)
  end
  local times, err = red:get_reused_times()
  if not times then
    ngx.log(ngx.ERR, "redis connection pool failed: " .. err)
  else
    ngx.log(ngx.INFO, "reused redis connection " .. times .. " times")
  end
  return red
end

local redisdisconnect = function(red)
  local ok, err = red:set_keepalive(10000, 100)
  if not ok then
    ngx.log(ngx.ERR, "failed to set redis keepalive: ", err)
  end
end

local set = function(key, value)
  red = redisconnect()
  local result, err = red:set(key, value)
  redisdisconnect(red)
  if not result then
    ngx.status = 504
    ngx.log(ngx.ERR, "could not set " .. key .. " to redis: " .. err)
    return
  end
  return result
end

local get = function(key)
  red = redisconnect()
  local result, err = red:get(key)
  redisdisconnect(red)
  if not result then
    ngx.status = 504
    ngx.log(ngx.ERR, "could not get " .. key .. " from redis: " .. err)
    return
  end
  return result
end

return {
  _DESCRIPTION = "Just playing so far",
  _VERSION = "-0.0.1",
  _URL = "http://peer60.com",
  _AUTHOR = "Rob Martin / @version2beta / on behalf of Peer60 Inc.",
  _LICENSE = "Proprietary",
  health = "OK",
  get = get,
  set = set
}
