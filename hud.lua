local globals_realtime = globals.realtime
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

local client_screensize = client.screen_size

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
local string_format = string.format
local string_replace = string.gsub

----vector stuff
local pi = 3.14159265358979323846
local deg2rad = pi / 180.0
local rad2deg = 180.0 / pi
local cos, sin, atan, sqrt, min, max = math.cos, math.sin, math.atan, math.sqrt, math.min, math.max

local function rotate_point(point_to_rot_x, point_to_rot_y, center_point_x, center_point_y, angle)
    angle = angle * (deg2rad)
    local cos_theta = cos(angle)
    local sin_theta = sin(angle)
    local x = cos_theta * (point_to_rot_x - center_point_x) - sin_theta * (point_to_rot_y - center_point_y)
    local y = sin_theta * (point_to_rot_x - center_point_x) + cos_theta * (point_to_rot_y - center_point_y)
    x = x + center_point_x
    y = y + center_point_y
    return x, y
end

local function get_length(x, y)
    return sqrt(x^2 + y^2)
end

local function normalize(x, y)
    local length = get_length(x, y)
    norm_x = x / length
    norm_y = y / length
    return norm_x, norm_y
end
----

local function draw_container(ctx, x, y, w, h)
    local c = {10, 60, 40, 40, 40, 60, 20}
    for i = 0,6,1 do
        client_draw_rectangle(ctx, x+i, y+i, w-(i*2), h-(i*2), c[i+1], c[i+1], c[i+1], 255)
    end
end

local function draw_radar(ctx)
    local center_x, center_y = 400, 100
    local local_player = entity_get_local_player()
    local lp_x, lp_y, lp_z = entity_get_prop(local_player, "m_vecOrigin")
    local lp_viewang_y = entity_get_prop(local_player, "m_angEyeAngles[1]")
    local size = 150
    draw_container(ctx, center_x-(size/2), center_y-(size/2), size, size)

    client_draw_rectangle(ctx, center_x-2, center_y-2, 4, 4, 255, 255, 255, 255)

    local players = entity_get_players()
    for i=1, #players do
        local player = players[i]
        local p_x, p_y, p_z = entity_get_prop(player, "m_vecOrigin")
        p_x = lp_x - p_x
        p_y = lp_y - p_y

        local distance = min(get_length(p_x, p_y) * (0.02 * 1.5), 300)
        local np_x, np_y = normalize(p_x, p_y)
        np_x, np_y = np_x * distance, np_y * distance

        np_x, np_y = np_x + center_x, np_y + center_y

        local rnp_x, rnp_y = rotate_point(np_x, np_y, center_x, center_y, lp_viewang_y-90)

        client_draw_rectangle(ctx, rnp_x-3, rnp_y-3, 6, 6, 255, 0, 0, 255)
    end
end

local function sanitize_string(string)
    return string:gsub("%W", "")
end

---- CONFIG CONFIG CONFIG ----
local only_show_money_in_buyzone = false
---- CONFIG CONFIG CONFIG ----

local kills = {}
local function on_player_death(e)
    local victim, attacker, assister, weapon, headshot, dominated, revenge, penetrated = e.userid, e.attacker, e.assister, e.weapon, e.headshot, e.dominated, e.revenge, e.penetrated

    if #kills >= 8 then
        table_remove(kills, 1)
    end

    local killfeed = ''

    local attacker_name = entity_get_player_name(client_userid_to_entindex(attacker))
    attacker_name = sanitize_string(attacker_name)
    local victim_name = entity_get_player_name(client_userid_to_entindex(victim))
    victim_name = sanitize_string(victim_name)

    if headshot then
        killfeed = attacker_name .. " headshot " .. victim_name .. " with a " .. weapon
    else
        killfeed = attacker_name .. " killed " .. victim_name .. " with a " .. weapon
    end

    table_insert(kills, killfeed)
end

local function on_round_start(e)
    kills = {}
end

local function drawhud(ctx)
    local scrsize_x, scrsize_y = client_screensize()
    local scrcenter_x, scrcenter_y = scrsize_x - (scrsize_x / 2), scrsize_y - (scrsize_y / 2)
    local local_player = entity_get_local_player() -- we use this multiple times, best to store it once instead of calling it multiple times

    local health, armor, teamnum = entity_get_prop(local_player, "m_iHealth"), entity_get_prop(local_player, "m_ArmorValue"), entity_get_prop(local_player, "m_iTeamNum")
    local teamnum_t, teamnum_ct = 2, 3
    local has_helmet, has_defuser, has_kevlar = entity_get_prop(local_player, "m_bHasHelmet"), entity_get_prop(local_player, "m_bHasDefuser"), nil
    local in_buyzone, money = entity_get_prop(local_player, "m_bInBuyZone"), entity_get_prop(local_player, "m_iAccount")
    local playerresource = entity_get_all("CCSPlayerResource")[1]
    local c4_holder = entity_get_prop(playerresource, "m_iPlayerC4")
    local gameinfo = entity.get_all("CCSGameRulesProxy")

    draw_radar(ctx)

    if armor > 1 and armor <= 100 then
        has_kevlar = true
    else
        has_kevlar = false
    end

    ----hp armor
    local width = 80
    draw_container(ctx, scrcenter_x-(width/2), scrsize_y-70, width, 80)

    if health >= 0 and health <= 100 then
        client_draw_text(ctx, scrcenter_x, scrsize_y-17, 231, 76, 60, 255, "c+", 0, health)
    end

    if armor >= 0 and armor <= 100 then
        client_draw_text(ctx, scrcenter_x, scrsize_y-43, 52, 152, 219, 255, "c+", 0, armor)
    end
    ----
    ----armor flags
    draw_container(ctx, scrcenter_x-200, scrsize_y-45, 68, 55)

    if has_helmet == 1 then 
        client_draw_text(ctx, scrcenter_x-185, scrsize_y-33, 46, 204, 113, 255, "+", 0, "H")
    elseif has_helmet == 0 then
        client_draw_text(ctx, scrcenter_x-185, scrsize_y-33, 231, 76, 60, 255, "+", 0, "H")
    end    

    if has_kevlar == true then 
        client_draw_text(ctx, scrcenter_x-165, scrsize_y-33, 46, 204, 113, 255, "+", 0, "K")
    elseif has_kevlar == false then
        client_draw_text(ctx, scrcenter_x-165, scrsize_y-33, 231, 76, 60, 255, "+", 0, "K")
    end 
    ----

    ----defuser/c4 flags
    draw_container(ctx, scrcenter_x-120, scrsize_y-45, 68, 55)

    if teamnum == teamnum_ct then
        if has_defuser == 1 then 
            client_draw_text(ctx, scrcenter_x-94, scrsize_y-33, 46, 204, 113, 255, "+", 0, "D")
        elseif has_defuser == 0 then
            client_draw_text(ctx, scrcenter_x-94, scrsize_y-33, 231, 76, 60, 255, "+", 0, "D")
        end 
    elseif teamnum == teamnum_t then
        if c4_holder == local_player then 
            client_draw_text(ctx, scrcenter_x-102, scrsize_y-33, 46, 204, 113, 255, "+", 0, "C4")
        else
            client_draw_text(ctx, scrcenter_x-102, scrsize_y-33, 231, 76, 60, 255, "+", 0, "C4")
        end
    end
    ----

    ----money
    if only_show_money_in_buyzone == true then
        if in_buyzone == 1 then
            if money >= 10000 then
                draw_container(ctx, -10, scrcenter_y-300, 133, 55)
                client_draw_text(ctx, 10, scrcenter_y-286, 46, 204, 113, 255, "+", 0, "$", money)
            elseif money >= 1000 and money < 10000 then
                draw_container(ctx, -10, scrcenter_y-300, 120, 55)
                client_draw_text(ctx, 10, scrcenter_y-286, 46, 204, 113, 255, "+", 0, "$", money)
            elseif money >= 100 and money < 1000 then
                draw_container(ctx, -10, scrcenter_y-300, 107, 55)
                client_draw_text(ctx, 10, scrcenter_y-286, 46, 204, 113, 255, "+", 0, "$", money)
            else
                draw_container(ctx, -10, scrcenter_y-300, 107, 55)
                client_draw_text(ctx, 10, scrcenter_y-286, 46, 204, 113, 255, "+", 0, "$", money)
            end
        end
    elseif only_show_money_in_buyzone == false then
        if money >= 10000 then
            draw_container(ctx, -10, scrcenter_y-300, 133, 55)
            client_draw_text(ctx, 10, scrcenter_y-286, 46, 204, 113, 255, "+", 0, "$", money)
        elseif money >= 1000 and money < 10000 then
            draw_container(ctx, -10, scrcenter_y-300, 120, 55)
            client_draw_text(ctx, 10, scrcenter_y-286, 46, 204, 113, 255, "+", 0, "$", money)
        elseif money >= 100 and money < 1000 then
            draw_container(ctx, -10, scrcenter_y-300, 107, 55)
            client_draw_text(ctx, 10, scrcenter_y-286, 46, 204, 113, 255, "+", 0, "$", money)
        else
            draw_container(ctx, -10, scrcenter_y-300, 107, 55)
            client_draw_text(ctx, 10, scrcenter_y-286, 46, 204, 113, 255, "+", 0, "$", money)
        end
    end
    ----

    ----killfeed
    draw_container(ctx, scrsize_x-290, -10, 300, 185)

    for i=1, #kills do
        client_draw_text(ctx, scrsize_x-145, 19*i, 255, 255, 255, 255, "c", 0, kills[i])
    end
    ----
end

local origins = {}
local function on_paint_hud(ctx)
    drawhud(ctx)
end

client_set_event_callback("paint", on_paint_hud)
client_set_event_callback("player_death", on_player_death)
client_set_event_callback("round_start", on_round_start)