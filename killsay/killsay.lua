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

local tonumber = tonumber
local math_floor = math.floor

local hitgroup_names = { "body", "head", "chest", "stomach", "left arm", "right arm", "left leg", "right leg", "neck", "?", "body" }
local hitbox_names = { "head", "neck", "pelvis", "stomach", "spine3", "spine2", "spine1", "left thigh", "right thigh", "left calf", "right calf", "left foot", "right foot", "left hand", "right hand", "left upperarm", "left forearm", "right upperarm", "right forearm", "all" }
local group_to_hitboxes = { { 0 }, { 4, 5, 6 }, { 2, 3 }, { 15, 16 }, { 17, 18 }, { 7, 9, 11 }, { 8, 10, 12 }, { 1 } }

function killsay(e)
	local userid, attacker, health, armor, weapon, dmg_health, dmg_armor, hitgroup = e.userid, e.attacker, e.health, e.armor, e.weapon, e.dmg_health, e.dmg_armor, e.hitgroup
	if userid == nil or attacker == nil or hitgroup < 1 or hitgroup > 8 then return end
	
	local head, chest, stomach, left_leg, right_leg, neck = 1, 2, 3, 6, 7, 8
	local victim_name = get_player_name(userid) or "unknown"

	if is_local_player(attacker) then 
		if tonumber(health) == 0 then
			local hitbox_hit = ''
			if hitgroup == head then
				hitbox_hit = 'head '
			elseif hitgroup == chest then
				hitbox_hit = 'chest '
			elseif hitgroup == stomach then
				hitbox_hit = 'stomach '
			elseif hitgroup == neck then
				hitbox_hit = 'neck '
			elseif hitgroup == left_leg then
				hitbox_hit = 'toe '
			elseif hitgroup == right_leg then 
				hitbox_hit = 'toe '
			end

			if hitbox_hit ~= '' then 
				console_cmd('say Nice ', hitbox_hit, victim_name)
			end
		end
	end
end

local result = gs.set_event_callback('player_hurt', killsay)
if result then
    console_log('set_event_callback failed: ', result)
end
