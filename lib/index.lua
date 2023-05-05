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

end

---@param resourceName string
---@param zoneId string
function jZoneLib.StartZone(resourceName, zoneId)
    if (type(zones[resourceName]) == "table") then
        if (type(zones[resourceName][zoneId]) == "table") then
            zones[resourceName][zoneId].state = true;
        end
    end
end 

---@param resourceName string
---@param zoneId string
function jZoneLib.StopZone(resourceName, zoneId)

    if (type(zones[resourceName]) == "table") then
        if (type(zones[resourceName][zoneId]) == "table") then
            zones[resourceName][zoneId].state = false;
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
    if (type(zones[resourceName]) == "table") then
        if (type(zones[resourceName][zoneId]) == "table") then
            zones[resourceName][zoneId].position = Vector3(position.x, position.y, position.z);
            zones[resourceName][zoneId].size = size;
            zones[resourceName][zoneId].job = job;
            zones[resourceName][zoneId].job_grade = job_grade;
            zones[resourceName][zoneId].job2 = job2;
            zones[resourceName][zoneId].job2_grade = job2_grade;
        end
    end
end

---@param resourceName string
function jZoneLib.Purge(resourceName)
    zones[resourceName] = nil;
end

---@return boolean
local function IsESXReady()
    return ENV.ESX and type(ESX.PlayerData) == "table";
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

    if (type(player[jobType]) ~= "table") then return false; end
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

            if (type(resourceZones) == "table") then

                for zoneId, zone in pairs(resourceZones) do

                    if (type(zone) == "table") then

                        local dist = zone.position:Distance(position);

                        if (not jZoneLib.ESX) then

                            if (zone.state and dist > zone.size) then
                                TriggerEvent(eEvents.Stop, resourceName, zoneId);
                                zone.state = false;
                            elseif (not zone.state and dist <= zone.size) then
                                zone.state = true;
                                TriggerEvent(eEvents.Start, resourceName, zoneId);
                            end

                        elseif (ESXReady) then

                            local allowed = PlayerAllowed(zone.job, zone.job_grade, zone.job2, zone.job2_grade);

                            if (zone.state and dist > zone.size) then

                                TriggerEvent(eEvents.Stop, resourceName, zoneId);
                                zone.state = false;

                            elseif (not zone.state and dist <= zone.size and allowed) then

                                zone.state = true;
                                TriggerEvent(eEvents.Start, resourceName, zoneId);

                            elseif (zone.state and not allowed) then
                                
                                TriggerEvent(eEvents.Stop, resourceName, zoneId);
                                zone.state = false;

                            end

                        end

                    end

                end

            end

        end

        Wait(750);
    end
end);