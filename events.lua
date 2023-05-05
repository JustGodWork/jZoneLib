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

local IS_LIB = jZoneLib ~= nil;
local GetInvokingResource = GetInvokingResource;
local GetResourceState = GetResourceState;
local esx_name = "es_extended";

if (IS_LIB) then

    if (jZoneLib.ESX) then

        ESX = exports[esx_name]:getSharedObject();

        AddEventHandler("onResourceStart", function(resourceName) -- HOT RELOAD SUPPORT

            if (resourceName == GetCurrentResourceName()) then

                if (type(ESX.GetPlayerData()) == "table") then
                    ESX.PlayerData = ESX.GetPlayerData();
                end

            end

        end);

        RegisterNetEvent("esx:playerLoaded", function(xPlayer)

            local resource = GetInvokingResource();
            if (resource ~= nil) then return; end; -- PREVENT CHEATER CALLING THIS EVENT

            ESX.PlayerData = xPlayer;

        end);
        
        RegisterNetEvent("esx:setJob", function(job)

            local resource = GetInvokingResource();
            if (resource ~= nil) then return; end; -- PREVENT CHEATER CALLING THIS EVENT

            ESX.PlayerData.job = job;

        end);
    
        RegisterNetEvent("esx:setJob2", function(job2)

            local resource = GetInvokingResource();
            if (resource ~= nil) then return; end; -- PREVENT CHEATER CALLING THIS EVENT

            ESX.PlayerData.job2 = job2;

        end);

    end

    ---@param zoneId string
    ---@param position vector3
    ---@param size number
    ---@param job string
    ---@param job_grade number
    ---@param job2 string
    ---@param job2_grade number
    AddEventHandler(eEvents.Add, function(zoneId, position, size, job, job_grade, job2, job2_grade)

        local resource = GetInvokingResource();
        if (IS_LIB) then
            jZoneLib.AddZone(resource, zoneId, position, size, job, job_grade, job2, job2_grade);
        end

    end);

    AddEventHandler(eEvents.Purge, function()

        local resource = GetInvokingResource();

        if (IS_LIB) then
            jZoneLib.Purge(resource);
        end

    end);

    AddEventHandler(eEvents.Update, function(zoneId, position, size, job, job_grade, job2, job2_grade)

        local resource = GetInvokingResource();

        if (IS_LIB) then
            jZoneLib.UpdateZone(resource, zoneId, position, size, job, job_grade, job2, job2_grade);
        end

    end);

end


---@param resourceName string
---@param zoneId string
AddEventHandler(eEvents.Start, function(resourceName, zoneId)

    local resource = GetInvokingResource();

    if (IS_LIB) then
        jZoneLib.StartZone(resourceName, zoneId);
    else

        if (not ENV or resource ~= ENV.lib_name) then return; end -- PREVENT CHEATER CALLING THIS EVENT

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

    local resource = GetInvokingResource();

    if (IS_LIB) then
        jZoneLib.StopZone(resource, zoneId);
    else
        
        if (not ENV or resource ~= ENV.lib_name) then return; end -- PREVENT CHEATER CALLING THIS EVENT

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