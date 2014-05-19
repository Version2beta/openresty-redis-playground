-- Note: In order to run tests using Busted under openresty,
-- be sure that `lua_code_cache off;` is in the nginx config.

local busted = require 'busted'
local options = {
  path = './',
  lang = 'en',
  pattern = busted.defaultpattern,
  defer_print = true,
  sound = false,
  cwd = './',
  success_messages = busted.success_messages or nil,
  failure_messages = busted.failure_messages or nil,
  filelist = nil,
  root_file = "spec",
  excluded_tags = {},
  tags = {},
}

local html = function()
  options.output = 'spec/html_output.lua'
  local status_string, failures = busted(options)
  if failures then
    ngx.status = 412
  end
  return status_string
end

local console = function()
  options.output = 'utf_terminal'
  local status_string, failures = busted(options)
  if failures then
    ngx.status = 412
  end
  return status_string
end

return {
  html = html,
  console = console
}
