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

---@class Zone: BaseObject
---@field public context string
---@field public id string
---@field public position Vector3
---@field public size number
---@field public markers Marker[]
---@field public radius Radius[]
---@field public job string
---@field public job_grade number
---@field public job2 string
---@field public job2_grade number
---@field public started boolean
---@field public action fun(self: Zone)
---@field public events EventEmitter
---@overload fun(): Zone
Zone = Class.new 'Zone';

---@private
function Zone:Constructor()

    self.context = ENV.name;
    self.id = uuid();

    self.position = Vector3(0, 0, 0);
    self.size = 10;
    self.markers = {};
    self.radius = {};
    self.job = nil;
    self.job_grade = nil;
    self.job2 = nil;
    self.job2_grade = nil;
    self.started = false;
    self.action = nil;
    self.force_hide = false

    self.events = EventEmitter();

    STORED_ZONES[self.id] = self;
    TriggerEvent(eEvents.ZoneLib.Add, self.id, self.position, self.size, self.job, self.job_grade, self.job2, self.job2_grade, self.force_hide);

end

---@private
function Zone:Listen()

    if (Value.IsValid(self.action, Value.Types.Function)) then
        self.action(self);
    end

    for i = 1, #self.radius do

        if (Value.IsInstanceOf(self.radius[i], 'Radius')) then

            if (self.radius[i]:IsIn()) then

                if (not self.radius[i].entered) then
                    self.radius[i].entered = true;
                    self.radius[i].events:Trigger('enter', self.radius[i]);
                end

                if (Value.IsValid(self.radius[i].action, Value.Types.Function)) then
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

end

---@param key? string
---@param value? any
function Zone:SendUpdate(key, value)
    if (Value.IsString(key)) then
        TriggerEvent(eEvents.ZoneLib.UpdateSingle, self.id, key, value);
    else
        TriggerEvent(eEvents.ZoneLib.Update, self.id, self.position, self.size, self.job, self.job_grade, self.job2, self.job2_grade, self.force_hide);
    end
end

---@param force_hide boolean
function Zone:SetForceHide(force_hide)
    self.force_hide = force_hide;
    self:SendUpdate("force_hide", force_hide);
    return self;
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

---@param position Vector3
function Zone:SetPosition(position)
    self.position = position;
    for i = 1, #self.radius do
        self.radius[i].position = position;
    end
    self:SendUpdate("position", position);
    return self;
end

---@param size number
function Zone:SetSize(size)
    self.size = size;
    self:SendUpdate("size", size);
    return self;
end

---@param job string
---@param grade number
function Zone:SetJob(job, grade)
    self.job = job;
    self.job_grade = grade;
    self:SendUpdate("job", job);
    self:SendUpdate("job_grade", grade);
    return self;
end

---@param job2 string
---@param grade number
function Zone:SetJob2(job2, grade)
    self.job2 = job2;
    self.job2_grade = grade;
    self:SendUpdate("job2", job2);
    self:SendUpdate("job2_grade", grade);
    return self;
end

---@param id number
---@return Radius
function Zone:GetRadius(id)
    return self.radius[id];
end

---@return Radius
function Zone:AddRadius()
    local id = #self.radius + 1;
    self.radius[id] = Radius(id, self.position);
    return self.radius[id];
end

---@param radius Radius
function Zone:RemoveRadius(radius)
    if (self.radius[radius.id]) then
        self.radius[radius.id] = nil;
    end
    return self;
end

---@param id number
---@return Marker
function Zone:GetMarker(id)
    return self.markers[id];
end

---@param marker? Marker | MarkerCircle
---@return Marker
function Zone:AddMarker(marker)
    local id = #self.markers + 1;
    self.markers[id] = Value.IsInstance(marker) and marker or Marker();
    self.markers[id].id = id;
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