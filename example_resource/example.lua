--[[
----
----Created Date: 12:01 Friday May 5th 2023
----Author: JustGod
----Made with ❤
----
----File: [tesl]
----
----Copyright (c) 2023 JustGodWork, All Rights Reserved.
----This file is part of JustGodWork project.
----Unauthorized using, copying, modifying and/or distributing of this file
----via any medium is strictly prohibited. This code is confidential.
----
--]]

local position = vector3(-231.639557, -988.707703, 29.313599);

---@type Zone
local zone = Zone()
    :SetPosition(position)
    :SetSize(10);


local marker1 = zone:AddMarker();
marker1:SetType(eMarkerType.CarSymbol)
    :SetPosition(position)
    :SetDirection(vector3(0.0, 0.0, 0.0))
    :SetScale(Scale(1.0, 1.0, 1.0))
    :SetRotation(vector3(0.0, 0.0, 0.0))
    :SetColor(Color(0, 0, 0, 255))
    :SetRotate(false)
    :SetBobUpAndDown(false)
    :SetFaceCamera(false);

--You can register only one action for a zone
zone:SetAction(function()
    marker1:Draw();
    ESX.Game.Utils.DrawText3D(position, "Come to get an adder", 1.0, 6);
end);

--You can register multiple enter/leave action for a zone
zone:OnEnter(function(self)
    ESX.ShowNotification(("Entering zone %s"):format(self.id));
end);

--You can register multiple enter/leave action for a zone
zone:OnLeave(function(self)
    ESX.ShowNotification(("Exiting zone %s"):format(self.id));
end);

local radius1 = zone:AddRadius()
    :SetSize(2)
    :OnEnter(function(self)
        ESX.ShowNotification(("Entering radius %s"):format(self.id));
    end)
    :OnLeave(function(self)
        ESX.ShowNotification(("Exiting radius %s"):format(self.id));
    end);

--You can register multiple enter/leave action for a zone
radius1:OnEnter(function(self)

    ESX.Game.SpawnVehicle('adder', position, 0.0, function(vehicle)
        TaskWarpPedIntoVehicle(PlayerPedId(), vehicle, -1);
    end);

end);

--You can register multiple enter/leave action for a zone
zone:OnLeave(function(self)

    local vehicle = GetVehiclePedIsIn(PlayerPedId());
    if (vehicle == 0) then
        return;
    end

    ESX.Game.DeleteVehicle(vehicle);

end);
