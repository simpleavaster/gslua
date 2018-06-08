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

local _M = {}

--[[
short   userid          user ID who died
short   attacker        user ID who killed
short   assister        user ID who assisted in the kill
string  weapon          weapon name killer used
string  weapon_itemid   inventory item id of weapon killer used
string  weapon_fauxitemid faux item id of weapon killer used
string  weapon_originalowner_xuid
bool    headshot        signals a headshot
short   dominated       did killer dominate victim with this kill
short   revenge         did killer get revenge on victim with this kill
short   penetrated      number of objects shot penetrated before killing target
]]--
function _M.player_death(e)
	local userid, attacker, assister, headshot = e.userid, e.attacker, e.assister, e.headshot
	if userid == nil or attacker == nil then return end

	local victim_name = get_player_name(userid) or "unknown"
	local attacker_name = get_player_name(attacker) or "unknown"
	local weapon = e.weapon or "unknown"

	if is_local_player(attacker) then
		if e.headshot then
			console_cmd("say Easy one tap ", victim_name, ".")
		else
			console_cmd("say Easy baim ", victim_name, ".")
		end
    elseif is_local_player(assister) then 
        console_cmd("say Easy assist ", victim_name, ".")
    end
end

return _M
