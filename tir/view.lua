local util = require 'tir.util'
local os = os;
local assert = assert;
local string = string;
local table = table;
local loadstring = loadstring;
local setmetatable = setmetatable;
local setfenv = setfenv;
local global = _G;

local M = {}
setfenv(1, M)

TEMPLATES = "views/"

-- Used in template parsing to figure out what each {} does.
local VIEW_ACTIONS = {
    ['{%'] = function(code)
        return code
    end,

    ['{{'] = function(code)
        return ('_result[#_result+1] = %s'):format(code)
    end,

    ['{('] = function(code)
        return ([[ 
            if not _children[%s] then
                _children[%s] = M.view(%s)
            end

            _result[#_result+1] = _children[%s](getfenv())
        ]]):format(code, code, code, code)
    end,

    ['{<'] = function(code)
        return ('_result[#_result+1] =  util.escape(%s)'):format(code)
    end,
}



-- Takes a view template and optional name (usually a file) and 
-- returns a function you can call with a table to render the view.
function compile_view(tmpl, name)
    local tmpl = tmpl .. '{}'
    local code = {'local _result, _children = {}, {}\n'}

    for text, block in string.gmatch(tmpl, "([^{]-)(%b{})") do
        local act = VIEW_ACTIONS[block:sub(1,2)]
        local output = text

        if act then
            code[#code+1] =  '_result[#_result+1] = [[' .. text .. ']]'
            code[#code+1] = act(block:sub(3,-3))
        elseif #block > 2 then
            code[#code+1] = '_result[#_result+1] = [[' .. text .. block .. ']]'
        else
            code[#code+1] =  '_result[#_result+1] = [[' .. text .. ']]'
        end
    end

    code[#code+1] = 'return table.concat(_result)'

    code = table.concat(code, '\n')
    local func, err = loadstring(code, name)

    if err then
        assert(func, err)
    end

    return function(context)
        assert(context, "You must always pass in a table for context.")
        local helpers = {
          util=util
        }
        setmetatable(helpers, {__index=global})

        setmetatable(context, {__index=helpers})
        setfenv(func, context)
        return func()
    end
end


-- Crafts a new view from the given file in the TEMPLATES directory.
-- If the ENV[PROD] is set to something then it will do this once.
-- Otherwise it returns a function that reloads the template since you're
-- in developer mode.
function view(name)
    if os.getenv('PROD') then
        local tempf = util.load_file(TEMPLATES, name)
        return compile_view(tempf, name)
    else
        return function (params)
            local tempf = util.load_file(TEMPLATES, name)
            assert(tempf, "Template " .. TEMPLATES .. name .. " does not exist.")

            return compile_view(tempf, name)(params)
        end
    end
end

return M
