--[[
----
----Created Date: 12:01 Friday May 5th 2023
----Author: JustGod
----Made with ❤
----
----File: [example]
----
----Copyright (c) 2023 JustGodWork, All Rights Reserved.
----This file is part of JustGodWork project.
----Unauthorized using, copying, modifying and/or distributing of this file
----via any medium is strictly prohibited. This code is confidential.
----
--]]

local position = Vector3(-231.639557, -988.707703, 29.313599);
local position2 = Vector3(-223.819778, -1002.184631, 29.330444);
local current = position;

local count = 0;

---@type Zone
local zone = Zone()
    :SetPosition(current)
    :SetSize(20);

local marker1 = zone:AddMarker();
    marker1:SetType(eMarkerType.ReplayIcon)
        :SetPosition(current)
        :SetDirection(Direction())
        :SetScale(Scale())
        :SetRotation(Rotation())
        :SetColor(Color(0, 0, 0, 255))
        :SetRotate(true)
        :SetBobUpAndDown(true)
        :SetFaceCamera(false);

zone:SetAction(function() --You can register only one action for a zone
    marker1:SetPosition(current);
    marker1:Draw();
    ESX.Game.Utils.DrawText3D(current, "Come here 😈", 1.0, 6);
end)
    :OnEnter(function(self) --You can register multiple enter/leave action for a zone
        ESX.ShowNotification(("Entering zone ~c~(~b~%s~c~)~s~"):format(self.id));
    end)
    :OnLeave(function(self) --You can register multiple enter/leave action for a zone
        ESX.ShowNotification(("Exiting zone ~c~(~b~%s~c~)~s~"):format(self.id));
    end)
    :OnLeave(function(self) --You can register multiple enter/leave action for a zone

        local vehicle = GetVehiclePedIsIn(PlayerPedId());
        if (vehicle == 0) then
            return;
        end

        ESX.Game.DeleteVehicle(vehicle);

    end);

local radius1 = zone:AddRadius()
    :SetSize(2)
    :OnEnter(function(self)
        ESX.ShowNotification(("Entering radius ~c~(~b~%s~c~)~r~ switching zone position"):format(self.id));
    end)
    :OnLeave(function(self)
        ESX.ShowNotification(("Exiting radius ~c~(~b~%s~c~)~s~ 🤡"):format(self.id));
    end)
    :OnEnter(function(self) --You can register multiple enter/leave action for a zone

        if (count == math.random(8, 12)) then
            ESX.ShowNotification("Enjoying the view? 😈");
            count = 0;
        end

        SetTimeout(500, function()
            current = current == position and position2 or position;
            zone:SetPosition(current);
            count = count + 1;
        end);

    end);