--start of definitions
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

function autobuy(e)
	local userid = e.userid
    if userid == nil then return end
    if not is_local_player(userid) then return end 

    local r_eyegloss, primary = get_cvar("r_eyegloss"), ''
    if r_eyegloss == nil then return end

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
	
    if primary == '' then
        console_log("[autobuy] Invalid r_eyegloss value, possible values are auto scout awp ak negev")
    else
        console_cmd(primary, 'buy deagle; buy taser; buy defuser; buy vesthelm; buy molotov; buy incgrenade; buy hegrenade; buy smokegrenade')
    end
end

local err = gs.set_event_callback('player_spawn', autobuy)
if err then
    console_log('set_event_callback failed: ', err)
end

console_log('[autobuy] How to use')
console_log('[autobuy] Set r_eyegloss to auto or awp or scout or ak or negev')
console_log('[autobuy] Example: r_eyegloss auto')
 
