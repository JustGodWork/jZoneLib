--[[
----
----Created Date: 12:55 Friday May 5th 2023
----Author: JustGod
----Made with ❤
----
----File: [events]
----
----Copyright (c) 2023 JustGodWork, All Rights Reserved.
----This file is part of JustGodWork project.
----Unauthorized using, copying, modifying and/or distributing of this file
----via any medium is strictly prohibited. This code is confidential.
----
--]]

-- todo : Add Position change event

local IS_LIB = jZoneLib ~= nil;
local GetInvokingResource = GetInvokingResource;

if (IS_LIB) then

    ---@param zoneId string
    ---@param position vector3
    ---@param size number
    AddEventHandler(eEvents.Add, function(zoneId, position, size)

        local resource = GetInvokingResource();
        if (IS_LIB) then
            jZoneLib.AddZone(resource, zoneId, position, size);
        end

    end);

    ---@param resourceName string
    AddEventHandler(eEvents.Purge, function(resourceName)

        local resource = GetInvokingResource();

        if (IS_LIB) then
            jZoneLib.Purge(resource);
        end

    end);

    AddEventHandler(eEvents.Update, function(zoneId, position, size)

        local resource = GetInvokingResource();
        if (IS_LIB) then
            jZoneLib.UpdateZone(resource, zoneId, position, size);
        end

    end);

end


---@param resourceName string
---@param zoneId string
AddEventHandler(eEvents.Start, function(resourceName, zoneId)

    --- todo : Add check if resource triggering is lib or not
    local resource = GetInvokingResource();

    if (IS_LIB) then
        jZoneLib.StartZone(resourceName, zoneId);
    else

        if (resourceName ~= ENV.name) then return; end

        ---@type Zone
        local zone = STORED_ZONES[zoneId];

        if (zone) then

            if (not zone.started) then
                zone:Start();
            end

        end
        
    end

end);

---@param resourceName string
---@param zoneId string
AddEventHandler(eEvents.Stop, function(resourceName, zoneId)

    --- todo : Add check if resource triggering is lib or not
    local resource = GetInvokingResource();

    if (IS_LIB) then
        jZoneLib.StopZone(resource, zoneId);
    else
        
        if (resourceName ~= ENV.name) then return; end

        ---@type Zone
        local zone = STORED_ZONES[zoneId];

        if (zone) then

            if (zone.started) then
                zone:Stop();
            end

        end

    end

end);

AddEventHandler("onResourceStop", function(resourceName)
    
    if (IS_LIB) then return; end
    if (resourceName ~= ENV.name) then return; end

    TriggerEvent(eEvents.Purge);

end);