--[[
----
----Created Date: 10:45 Thursday May 4th 2023
----Author: JustGod
----Made with ❤
----
----File: [fxmanifest]
----
----Copyright (c) 2023 JustGodWork, All Rights Reserved.
----This file is part of JustGodWork project.
----Unauthorized using, copying, modifying and/or distributing of this file
----via any medium is strictly prohibited. This code is confidential.
----
--]]

fx_version 'cerulean';
game 'gta5';

author 'JustGod';
description 'jZoneLib - A simple library for FiveM to create zones';
version '1.0.0';

shared_script '@jClassLib/imports.lua';
client_script 'lib/index.lua';
client_script 'lib/events.lua';

files {

    'classes/*.lua',
    'lib/*.lua',
    'imports.lua'
    
};

dependency 'jClassLib';