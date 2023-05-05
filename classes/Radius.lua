--[[
----
----Created Date: 1:39 Friday May 5th 2023
----Author: JustGod
----Made with ❤
----
----File: [Radius]
----
----Copyright (c) 2023 JustGodWork, All Rights Reserved.
----This file is part of JustGodWork project.
----Unauthorized using, copying, modifying and/or distributing of this file
----via any medium is strictly prohibited. This code is confidential.
----
--]]

---@class Radius: BaseObject
---@field public id number
---@field public position Vector3
---@field public size number
---@field private entered boolean
---@field private action fun(self: Radius)
---@field private events EventEmitter
---@overload fun(position: Vector3): Radius
Radius = Class.new 'Radius';

---@private
function Radius:Constructor(id, position)

    self.id = id;
    self.position = position;
    self.size = 10;
    self.entered = false;
    self.action = nil;

    self.events = EventEmitter();

end

---@private
function Radius:IsIn()
    local ped = PlayerPedId();
    local position = GetEntityCoords(ped);
    local distance = self.position:Distance(position);
    return distance <= self.size;
end

---@param size number
function Radius:SetSize(size)
    self.size = size;
    return self;
end

---@param action fun(self: Radius)
function Radius:SetAction(action)
    self.action = action;
    return self;
end

---@param enter fun(self: Radius)
function Radius:OnEnter(enter)
    self.events:Register('enter', enter);
    return self;
end

---@param leave fun(self: Radius)
function Radius:OnLeave(leave)
    self.events:Register('leave', leave);
    return self;
end