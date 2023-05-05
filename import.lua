--[[
----
----Created Date: 11:39 Thursday May 4th 2023
----Author: JustGod
----Made with ❤
----
----File: [import]
----
----Copyright (c) 2023 JustGodWork, All Rights Reserved.
----This file is part of JustGodWork project.
----Unauthorized using, copying, modifying and/or distributing of this file
----via any medium is strictly prohibited. This code is confidential.
----
--]]

ENV = {};

ENV.lib_name = 'jZoneLib';
ENV.name = GetCurrentResourceName();
ENV.IS_SERVER = IsDuplicityVersion();

local _require = require;
local _load = load;
local state = GetResourceState(ENV.lib_name);

if (state == "missing") then
    return error(('\n^1Error: %s is missing^0'):format(ENV.lib_name), 0);
end

if (state ~= "started") then
    return error(('\n^1Error: %s must be started before ^5%s^0'):format(ENV.lib_name, ENV.name), 0);
end

---@param file string
---@param name string
---@return any
local function load(file, name)
    local fn, err = _load(file, ('@@%s/%s'):format(ENV.lib_name, name))

    if (fn == nil or type(err) == "string") then
        return error(('\n^1Error importing module (%s): %s^0'):format(name, err), 3);
    end

    return fn();
end

---@param modname string
---@param type string
---@return any
function require(modname)

    if (type(modname) == "table") then
        for i = 1, #modname do
            require(modname[i]);
        end
        return;
    end

    if (type(modname) ~= "string") then
        return error(('\n^1Error importing module (%s): Invalid type^0'):format(tostring(modname)), 3);
    end

    if (not modname:find(".lua")) then
        return error(('\n^1Error importing module (%s): Invalid format^0'):format(modname), 3);
    end

    local file = LoadResourceFile(ENV.lib_name, string.format('%s', modname));

    if (file == nil) then return (function() end)(); end

    return load(file, modname);

end

require { 

    'system/uuid.lua',
    'system/class.lua' 

};
require {

    'enums/eEvents.lua',
    'enums/eMarkerType.lua'

};

require 'events.lua';

require {
    'classes/EventEmitter.lua',
    'classes/Color.lua',
    'classes/Scale.lua',
    'classes/Marker.lua',
    'classes/Radius.lua',
    'classes/Zone.lua';

};