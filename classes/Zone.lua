--[[
----
----Created Date: 11:31 Thursday May 4th 2023
----Author: JustGod
----Made with ❤
----
----File: [Zone]
----
----Copyright (c) 2023 JustGodWork, All Rights Reserved.
----This file is part of JustGodWork project.
----Unauthorized using, copying, modifying and/or distributing of this file
----via any medium is strictly prohibited. This code is confidential.
----
--]]

STORED_ZONES = {};

---@class Zone: BaseObject
---@field public context string
---@field public id string
---@field public position vector3
---@field public size number
---@field public markers Marker[]
---@field public radius Radius[]
---@field public started boolean
---@field public action fun(self: Zone)
---@field public events EventEmitter
---@overload fun(): Zone
Zone = Class.new 'Zone';

---@private
function Zone:Constructor()

    self.context = ENV.name;
    self.id = uuid();

    self.position = vector3(0, 0, 0);
    self.size = 10;
    self.markers = {};
    self.radius = {};
    self.started = false;
    self.action = nil;

    self.events = EventEmitter();

    STORED_ZONES[self.id] = self;
    TriggerEvent(eEvents.Add, self.id, self.position, self.size);

end

---@private
function Zone:Listen()

    if (type(self.action) == "function") then
        self.action(self);
    end

    for i = 1, #self.radius do
        if (self.radius[i]:IsIn()) then

            if (not self.radius[i].entered) then
                self.radius[i].entered = true;
                self.radius[i].events:Trigger('enter', self.radius[i]);
            end

            if (type(self.radius[i].action) == "function") then
                self.radius[i].action(self.radius[i]);
            end

        else
            if (self.radius[i].entered) then

                self.radius[i].entered = false;
                self.radius[i].events:Trigger('leave', self.radius[i]);

            end
        end
    end

end

function Zone:Start()

    if (self.started) then
        return;
    end
    self.started = true;

    self.events:Trigger('enter', self);
    
    CreateThread(function()
        while (self.started) do
            self:Listen();
            Wait(0);
        end
    end);

    return self;

end

function Zone:Stop()
    if (not self.started) then
        return;
    end
    self.started = false;

    for i = 1, #self.radius do
        if (self.radius[i]:IsIn()) then
            self.radius[i].entered = false;
            self.radius[i].events:Trigger('leave', self.radius[i]);
        end
    end

    self.events:Trigger('leave', self);

    return self;

end

---@param action fun(self: Zone)
function Zone:SetAction(action)
    self.action = action;
    return self;
end

---@param enter fun(self: Zone)
function Zone:OnEnter(enter)
    self.events:Register('enter', enter);
    return self;
end

---@param leave fun(self: Zone)
function Zone:OnLeave(leave)
    self.events:Register('leave', leave);
    return self;
end

---@param position vector3
function Zone:SetPosition(position)
    self.position = position;
    for i = 1, #self.radius do
        self.radius[i].position = position;
    end
    TriggerEvent(eEvents.Update, self.id, self.position, self.size);
    return self;
end

---@param size number
function Zone:SetSize(size)
    self.size = size;
    TriggerEvent(eEvents.Update, self.id, self.position, self.size);
    return self;
end

function Zone:AddRadius()
    local id = #self.radius + 1;
    self.radius[id] = Radius(id, self.position);
    return self.radius[id];
end

---@return Marker
function Zone:GetMarker(id)
    return self.markers[id];
end

---@return Marker
function Zone:AddMarker()
    local id = #self.markers + 1;
    self.markers[id] = Marker(id);
    return self.markers[id];
end

---@param marker Marker
function Zone:RemoveMarker(marker)
    if (self.markers[marker.id]) then
        self.markers[marker.id] = nil;
    end
    return self;
end

return Zone;