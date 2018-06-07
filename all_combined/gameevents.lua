local console_log = client.log
local console_cmd = client.exec

local is_enemy = client.is_enemy
local is_local_player = client.is_local_player

local get_player_name = client.get_player_name

local read_entity_prop = client.read_entity_prop

local userid_to_entindex = client.userid_to_entindex

local cvar_get = client.cvar_get

local draw_debug_text = client.draw_debug_text
local draw_hitboxes = client.draw_hitboxes

local RandomInt = client.RandomInt
local RandomFloat = client.RandomFloat

local tonumber = tonumber

local hitgroup_names = { "body", "head", "chest", "stomach", "left arm", "right arm", "left leg", "right leg", "neck", "?", "body" }
local hitbox_names = { "head", "neck", "pelvis", "stomach", "spine3", "spine2", "spine1", "left thigh", "right thigh", "left calf", "right calf", "left foot", "right foot", "left hand", "right hand", "left upperarm", "left forearm", "right upperarm", "right forearm", "all" }
local group_to_hitboxes = { { 0 }, { 4, 5, 6 }, { 2, 3 }, { 15, 16 }, { 17, 18 }, { 7, 9, 11 }, { 8, 10, 12 }, { 1 } }

local _M = {}

--[[
aim_fire is a custom event that is called whenever the rage aimbot shoots

int     hitgroup       targeted hitbox group
int     damage         estimated shot damage
float   hit_chance     hit chance percentage
float   backtrack      time in seconds that the player was backtracked
bool    teleported     true if player is breaking lag compensation
bool    high_priority  true if player is not using fake angles or is otherwise easier to hit
]]--
function _M.aim_fire(e)
    local group = hitgroup_names[e.hitgroup + 1] or "?"
    local hitchance = tonumber(string.format("%." .. 2 .. "f", e.hit_chance)) or 0 -- limit the precision of the float to 2 decimal places
	local damage, backtrack, teleported, highpriority = e.damage, e.backtrack, e.teleported, e.high_priority

    console_log("[aimbot] hitgroup=", group,
        " damage=", damage,
        " hitchance=", hitchance,
        " backtrack=", backtrack, 's',
        " teleported=", teleported,
        " highpriority=", highpriority)
end

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

--[[ 
    short   userid          user ID on server 
]]
function _M.player_spawn(e)
	local userid = e.userid
    if userid == nil then return end
    if not is_local_player(userid) then return end 

    local r_eyegloss, primary = cvar_get("r_eyegloss"), ''
    if r_eyegloss == nil then return end

    if r_eyegloss == "auto" then
        primary = 'buy scar20; buy g3sg1; '
    elseif r_eyegloss == "scout" then
        primary = 'buy scout; '
    elseif r_eyegloss == "awp" then
        primary = 'buy awp; '
    elseif r_eyegloss == "ak" then
        primary = 'buy ak47; '
    end

    console_cmd('clear; ', primary, 'buy deagle; buy taser; buy defuser; buy vesthelm; buy molotov; buy incgrenade; buy hegrenade; buy smokegrenade')	
    if primary == '' then
        console_log("[autobuy] Invalid r_eyegloss value, possible values are auto scout awp ak")
    end
end

return _M
