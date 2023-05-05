--[[
----
----Created Date: 12:39 Friday May 5th 2023
----Author: JustGod
----Made with ❤
----
----File: [index]
----
----Copyright (c) 2023 JustGodWork, All Rights Reserved.
----This file is part of JustGodWork project.
----Unauthorized using, copying, modifying and/or distributing of this file
----via any medium is strictly prohibited. This code is confidential.
----
--]]

local zones = {};
local DEBUG = GetConvar('jClassLib_DEBUG', 'false') == 'true';

jZoneLib = {};

---@param resourceName string
---@param zoneId string
---@param position Vector3
---@param size number
---@param job string
---@param job_grade number
---@param job2 string
---@param job2_grade number
function jZoneLib.AddZone(resourceName, zoneId, position, size, job, job_grade, job2, job2_grade)

    zones[resourceName] = zones[resourceName] or {};
    zones[resourceName][zoneId] = {

        state = false,
        position = Vector3(position.x, position.y, position.z),
        size = size,
        job = job,
        job_grade = job_grade,
        job2 = job2,
        job2_grade = job2_grade

    };

    if (DEBUG) then
        console.debug("^7(^3jZoneLib^7) ^0=> Added zone: ^1" .. zoneId .. "^0 from resource: ^1" .. resourceName .. "^0");
    end

end

---@param resourceName string
---@param zoneId string
function jZoneLib.StartZone(resourceName, zoneId)
    if (Value.IsValid(zones[resourceName], Value.Types.Table)) then
        if (Value.IsValid(zones[resourceName][zoneId], Value.Types.Table)) then

            zones[resourceName][zoneId].state = true;

            if (DEBUG) then
                console.debug("^7(^3jZoneLib^7) ^0=> Started zone: ^1" .. zoneId .. "^0 from resource: ^1" .. resourceName .. "^0");
            end

        end
    end
end 

---@param resourceName string
---@param zoneId string
function jZoneLib.StopZone(resourceName, zoneId)

    if (Value.IsValid(zones[resourceName], Value.Types.Table)) then
        if (Value.IsValid(zones[resourceName][zoneId], Value.Types.Table)) then
            zones[resourceName][zoneId].state = false;

            if (DEBUG) then
                console.debug("^7(^3jZoneLib^7) ^0=> Stopped zone: ^1" .. zoneId .. "^0 from resource: ^1" .. resourceName .. "^0");
            end

        end
    end

end

---@param resourceName string
---@param zoneId string
---@param position Vector3
---@param size number
---@param job string
---@param job_grade number
---@param job2 string
---@param job2_grade number
function jZoneLib.UpdateZone(resourceName, zoneId, position, size, job, job_grade, job2, job2_grade)
    if (Value.IsValid(zones[resourceName], Value.Types.Table)) then
        if (Value.IsValid(zones[resourceName][zoneId], Value.Types.Table)) then

            zones[resourceName][zoneId].position = Vector3(position.x, position.y, position.z);
            zones[resourceName][zoneId].size = size;
            zones[resourceName][zoneId].job = job;
            zones[resourceName][zoneId].job_grade = job_grade;
            zones[resourceName][zoneId].job2 = job2;
            zones[resourceName][zoneId].job2_grade = job2_grade;

            if (DEBUG) then
                console.debug("^7(^3jZoneLib^7) ^0=> Updated zone: ^1" .. zoneId .. "^0 from resource: ^1" .. resourceName .. "^0");
            end

        end
    end
end

---@param resourceName string
function jZoneLib.Purge(resourceName)
    zones[resourceName] = nil;

    if (DEBUG) then
        console.debug("^7(^3jZoneLib^7) ^0=> Purged zones from resource: ^1" .. resourceName .. "^0");
    end

end

---@return boolean
local function IsESXReady()
    return ENV.ESX and Value.IsValid(ESX.PlayerData, Value.Types.Table);
end

---@param job string
---@param grade number
local function IsJobValid(job, grade)
    return (type(job) == "string" and type(grade) == "number");
end

---@param jobType string
---@param job string
---@param grade number
---@return boolean
local function HasJob(jobType, job, grade)

    local player = ESX.PlayerData;

    if (not Value.IsValid(player[jobType], Value.Types.Table)) then return false; end
    if (grade == nil) then return player[jobType].name == job; end
    return (player[jobType].name == job) and (player[jobType].grade >= grade);

end

---@param job string
---@param jobGrade number
---@param job2 string
---@param job2Grade number
---@return boolean
local function PlayerAllowed(job, jobGrade, job2, job2Grade)
    if (not IsJobValid(job, jobGrade) and not IsJobValid(job2, job2Grade)) then return true; end
    return (HasJob("job", job, jobGrade) or HasJob("job2", job2, job2Grade));
end

CreateThread(function()
    while true do

        local ped = PlayerPedId();
        local position = GetEntityCoords(ped);
        local ESXReady = IsESXReady();

        for resourceName, resourceZones in pairs(zones) do

            if (Value.IsValid(resourceZones, Value.Types.Table)) then

                for zoneId, zone in pairs(resourceZones) do

                    if (Value.IsValid(zone, Value.Types.Table)) then

                        local dist = zone.position:Distance(position);

                        if (not ENV.ESX) then

                            if (zone.state and dist > zone.size) then

                                TriggerEvent(eEvents.ZoneLib.Stop, resourceName, zoneId);
                                zone.state = false;

                            elseif (not zone.state and dist <= zone.size) then

                                zone.state = true;
                                TriggerEvent(eEvents.ZoneLib.Start, resourceName, zoneId);

                            end

                        elseif (ESXReady) then

                            local allowed = PlayerAllowed(zone.job, zone.job_grade, zone.job2, zone.job2_grade);

                            if (zone.state and (dist > zone.size or not allowed)) then

                                TriggerEvent(eEvents.ZoneLib.Stop, resourceName, zoneId);
                                zone.state = false;

                            elseif (not zone.state and dist <= zone.size and allowed) then

                                zone.state = true;
                                TriggerEvent(eEvents.ZoneLib.Start, resourceName, zoneId);

                            end

                        end

                    end

                end

            end

        end

        Wait(750);
    end
end);