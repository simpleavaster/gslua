local console_log = client.log
local console_cmd = client.exec
local is_enemy = client.is_enemy
local is_local_player = client.is_local_player
local get_player_name = client.get_player_name
local read_entity_prop = client.read_entity_prop
local userid_to_entindex = client.userid_to_entindex
local get_cvar = client.get_cvar

local RandomInt = client.random_int
local RandomFloat = client.random_float

local worldtoscreen = client.world_to_screen
local draw_debug_text = client.draw_debug_text
local draw_hitboxes = client.draw_hitboxes
local paint_draw_text = client.draw_text
local paint_draw_rectangle = client.draw_rectangle
local cheat_setvar = gs.set_var
local cheat_getvar = gs.get_var
local cheat_create_menu_checkbox = gs.create_menu_checkbox
local cheat_create_menu_slider = gs.create_menu_slider
local cheat_create_menu_button = gs.create_menu_button

local tonumber = tonumber
local math_floor = math.floor

local hitgroup_names = { "body", "head", "chest", "stomach", "left arm", "right arm", "left leg", "right leg", "neck", "?", "body" }
local hitbox_names = { "head", "neck", "pelvis", "stomach", "spine3", "spine2", "spine1", "left thigh", "right thigh", "left calf", "right calf", "left foot", "right foot", "left hand", "right hand", "left upperarm", "left forearm", "right upperarm", "right forearm", "all" }
local group_to_hitboxes = { { 0 }, { 4, 5, 6 }, { 2, 3 }, { 15, 16 }, { 17, 18 }, { 7, 9, 11 }, { 8, 10, 12 }, { 1 } }

function aim_fire(e)
    local group = hitgroup_names[e.hitgroup + 1] or "?"
    local hitchance = tonumber(string.format("%." .. 2 .. "f", e.hit_chance)) or 0 -- limit the precision of the float to 2 decimal places
	local userid, damage, backtrack, teleported, highpriority = e.userid, e.damage, e.backtrack, e.teleported, e.high_priority

    console_log("[aimbot] hitgroup=", group,
        " damage=", damage,
        " hitchance=", hitchance,
        " backtrack=", backtrack, 's',
        " teleported=", teleported,
        " highpriority=", highpriority)
end

local result = gs.set_event_callback('aim_fire', aim_fire) 

if result then
	engine.log('set_event_callback failed: ', result)
end
