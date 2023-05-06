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

local lib = "jZoneLib";
STORED_ZONES = {};
local IS_LIB = jZoneLib ~= nil;
local GetInvokingResource = GetInvokingResource;

if (IS_LIB) then

    ---@param zoneId string
    ---@param position Vector3
    ---@param size number
    ---@param job string
    ---@param job_grade number
    ---@param job2 string
    ---@param job2_grade number
    AddEventHandler(eEvents.ZoneLib.Add, function(zoneId, position, size, job, job_grade, job2, job2_grade, force_hide)

        local resource = GetInvokingResource();
        
        if (IS_LIB) then
            jZoneLib.AddZone(resource, zoneId, position, size, job, job_grade, job2, job2_grade, force_hide);
        end

    end);

    AddEventHandler(eEvents.ZoneLib.Purge, function()

        local resource = GetInvokingResource();

        if (IS_LIB) then
            jZoneLib.Purge(resource);
        end

    end);

    AddEventHandler(eEvents.ZoneLib.Update, function(zoneId, position, size, job, job_grade, job2, job2_grade, force_hide)

        local resource = GetInvokingResource();

        if (IS_LIB) then
            jZoneLib.UpdateZone(resource, zoneId, position, size, job, job_grade, job2, job2_grade, force_hide);
        end

    end);

    AddEventHandler(eEvents.ZoneLib.UpdateSingle, function(zoneId, key, value)

        local resource = GetInvokingResource();

        if (IS_LIB) then
            jZoneLib.SetValue(resource, zoneId, key, value);
        end

    end);

end

---@param resourceName string
---@param zoneId string
AddEventHandler(eEvents.ZoneLib.Start, function(resourceName, zoneId)

    local resource = GetInvokingResource();

    if (IS_LIB) then
        jZoneLib.StartZone(resourceName, zoneId);
    else

        if (not ENV or resource ~= lib) then return; end -- PREVENT CHEATER CALLING THIS EVENT
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
AddEventHandler(eEvents.ZoneLib.Stop, function(resourceName, zoneId)

    local resource = GetInvokingResource();

    if (IS_LIB) then
        jZoneLib.StopZone(resourceName, zoneId);
    else
        
        if (not ENV or resource ~= lib) then return; end -- PREVENT CHEATER CALLING THIS EVENT
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

    TriggerEvent(eEvents.ZoneLib.Purge);

end);