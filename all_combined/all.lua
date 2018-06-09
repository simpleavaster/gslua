local globals_curtime = globals.realtime
local globals_curtime = globals.curtime
local globals_maxplayers = globals.maxplayers
local globals_tickcount = globals.tickcount
local globals_tickinterval = globals.tickinterval
local globals_mapname = globals.mapname

local client_set_event_callback = client.set_event_callback
local client_console_log = client.log
local client_console_cmd = client.exec
local client_userid_to_entindex = client.userid_to_entindex
local client_get_cvar = client.get_cvar
local client_draw_debug_text = client.draw_debug_text
local client_draw_hitboxes = client.draw_hitboxes
local client_random_int = client.random_int
local client_random_float = client.random_float
local client_draw_text = client.draw_text
local client_draw_rectangle = client.draw_rectangle
local client_draw_line = client.draw_line
local client_world_to_screen = client.world_to_screen
local client_is_local_player = client.is_local_player

local ui_new_checkbox = ui.new_checkbox
local ui_new_slider = ui.new_slider
local ui_new_button = ui.new_button
local ui_set = ui.set
local ui_get = ui.get

local entity_get_local_player = entity.get_local_player
local entity_get_all = entity.get_all
local entity_get_players = entity.get_players
local entity_get_classname = entity.get_classname
local entity_set_prop = entity.set_prop
local entity_get_prop = entity.get_prop
local entity_is_enemy = entity.is_enemy
local entity_get_player_name = entity.get_player_name

local to_number = tonumber
local math_floor = math.floor
local table_insert = table.insert
local table_remove = table.remove

local hitgroup_names = { "body", "head", "chest", "stomach", "left arm", "right arm", "left leg", "right leg", "neck", "?", "body" }
local hitbox_names = { "head", "neck", "pelvis", "stomach", "spine3", "spine2", "spine1", "left thigh", "right thigh", "left calf", "right calf", "left foot", "right foot", "left hand", "right hand", "left upperarm", "left forearm", "right upperarm", "right forearm", "all" }
local group_to_hitboxes = { { 0 }, { 4, 5, 6 }, { 2, 3 }, { 15, 16 }, { 17, 18 }, { 7, 9, 11 }, { 8, 10, 12 }, { 1 } }

local function is_local_player(entindex)
    return entindex == entity_get_local_player()
end

local function is_local_player_userid(userid)
    return is_local_player(client_userid_to_entindex(userid))
end

local aimbot_logging_checkbox = ui_new_checkbox("MISC", "Miscellaneous", "Aimbot logging")
if not aimbot_logging_checkbox then client_console_log("Failed to create checkbox") end

local killsay_checkbox = ui_new_checkbox("MISC", "Miscellaneous", "Killsay")
if not killsay_checkbox then client_console_log("Failed to create checkbox") end

local autobuy_checkbox = ui_new_checkbox("MISC", "Miscellaneous", "Autobuy")
if not autobuy_checkbox then client_console_log("Failed to create checkbox") end

function aimbot(e)
    local group = hitgroup_names[e.hitgroup + 1] or "?"
    local hitchance = to_number(string.format("%." .. 2 .. "f", e.hit_chance)) or 0 -- limit the precision of the float to 2 decimal places
	local target, damage, backtrack, teleported, highpriority = e.target, e.damage, e.backtrack, e.teleported, e.high_priority
	local enabled = ui_get(aimbot_logging_checkbox)

	local target_name = entity_get_player_name(target) or "unknown"
	
	if enabled then 
		client_console_log("[aimbot] target=", target_name,
			" hitgroup=", group,
			" damage=", damage,
			" hitchance=", hitchance,
			" backtrack=", backtrack, 's',
			" teleported=", teleported,
			" highpriority=", highpriority)
	end
end

function killsay(e)
	local userid, attacker, health, armor, weapon, dmg_health, dmg_armor, hitgroup = e.userid, e.attacker, e.health, e.armor, e.weapon, e.dmg_health, e.dmg_armor, e.hitgroup
	if userid == nil or attacker == nil or hitgroup < 1 or hitgroup > 8 then return end

	local head, chest, stomach, left_leg, right_leg, neck = 1, 2, 3, 6, 7, 8
	local victim_name = entity_get_player_name(client_userid_to_entindex(userid)) or "unknown"
	local enabled = ui_get(killsay_checkbox)
	
	if enabled then
		if is_local_player_userid(attacker) then 
			if to_number(health) == 0 then
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
					client_console_cmd('say Nice ', hitbox_hit, victim_name)
				end
			end
		end
	end
end

function autobuy(e)
	local enabled, userid = ui_get(autobuy_checkbox), e.userid
	if userid == nil then return end
	local local_player = entity_get_local_player()
	if not is_local_player_userid(userid) then return end

	local r_eyegloss, primary = client_get_cvar("r_eyegloss"), ''
	if r_eyegloss == nil then return end
	
	if enabled then
		if r_eyegloss == "auto" then
			primary = 'buy scar20; buy g3sg1; '
		elseif r_eyegloss == "scout" then
			primary = 'buy scout; '
		elseif r_eyegloss == "awp" then
			primary = 'buy awp; '
		elseif r_eyegloss == "ak" then
			primary = 'buy ak47; '
		elseif r_eyegloss == "negev" then
			primary = 'buy negev; '
		end

		client_console_cmd(primary, 'buy deagle; buy taser; buy defuser; buy vesthelm; buy molotov; buy incgrenade; buy hegrenade; buy smokegrenade')
		if primary == '' then
			client_console_log("[autobuy] Invalid r_eyegloss value, possible values are auto scout awp ak negev")
		end
	end
end

local result =
	client_set_event_callback('aim_fire', aimbot) or
	client_set_event_callback('player_hurt', killsay) or
	client_set_event_callback('player_spawn', autobuy) 

if result then
	engine.log('set_event_callback failed: ', result)
end
