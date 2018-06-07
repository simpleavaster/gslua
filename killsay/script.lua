--[[

CS:GO event callbacks for GameSense

Event descriptors can be found at
  https://wiki.alliedmods.net/Counter-Strike:_Global_Offensive_Events
  https://wiki.alliedmods.net/Generic_Source_Events

Place this file in the same folder as csgo.exe for now. Type
	'script_reload_code nameofthisfile.lua'
in console to load/reload this script.

]]--


local gameevents = require "gameevents" 

local err =
	gs.set_event_callback('player_death', gameevents.player_death)

if err then
	engine.log('set_event_callback failed: ', err)
end
