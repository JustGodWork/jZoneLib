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
---@param position vector3
---@param size number
function jZoneLib.AddZone(resourceName, zoneId, position, size)

    zones[resourceName] = zones[resourceName] or {};
    zones[resourceName][zoneId] = {

        state = false,
        position = position,
        size = size,

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
---@param position vector3
---@param size number
function jZoneLib.UpdateZone(resourceName, zoneId, position, size)
    if (type(zones[resourceName]) == "table") then
        if (type(zones[resourceName][zoneId]) == "table") then
            zones[resourceName][zoneId].position = position;
            zones[resourceName][zoneId].size = size;
        end
    end
end

---@param resourceName string
function jZoneLib.Purge(resourceName)
    zones[resourceName] = nil;
end

CreateThread(function()
    while true do

        local ped = PlayerPedId();
        local position = GetEntityCoords(ped);

        for resourceName, resourceZones in pairs(zones) do

            if (type(resourceZones) == "table") then

                for zoneId, zone in pairs(resourceZones) do

                    if (type(zone) == "table") then

                        local dist = #(position - zone.position);

                        if (zone.state and dist > zone.size) then
                            TriggerEvent(eEvents.Stop, resourceName, zoneId);
                            zone.state = false;
                        end

                        if (not zone.state and dist <= zone.size) then
                            zone.state = true;
                            TriggerEvent(eEvents.Start, resourceName, zoneId);
                        end

                    end

                end

            end

        end

        Wait(750);
    end
end);