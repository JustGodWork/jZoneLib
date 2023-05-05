--[[
----
----Created Date: 4:11 Friday May 5th 2023
----Author: JustGod
----Made with ❤
----
----File: [imports]
----
----Copyright (c) 2023 JustGodWork, All Rights Reserved.
----This file is part of JustGodWork project.
----Unauthorized using, copying, modifying and/or distributing of this file
----via any medium is strictly prohibited. This code is confidential.
----
--]]

ENV.name = GetCurrentResourceName();
ENV.lib_name = "jZoneLib";

local state = GetResourceState(ENV.lib_name);

if (state == "missing") then
    return error(('\n^1Error: %s is missing^0'):format(ENV.lib_name), 0);
end

if (state ~= "started") then
    return error(('\n^1Error: %s must be started before ^5%s^0'):format(ENV.lib_name, ENV.name), 0);
end

if (not ENV.IS_SERVER) then

    ENV.require('lib/events.lua', ENV.lib_name);
    ENV.require('classes/Radius.lua', ENV.lib_name);
    ENV.require('classes/Zone.lua', ENV.lib_name);

end