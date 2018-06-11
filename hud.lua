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

local function draw_container(ctx, x, y, w, h)
    local c = {10, 60, 40, 40, 40, 60, 20}
    for i = 0,6,1 do
        client_draw_rectangle(ctx, x+i, y+i, w-(i*2), h-(i*2), c[i+1], c[i+1], c[i+1], 255)
    end
end

---- CONFIG CONFIG CONFIG ----
local only_show_money_in_buyzone = false
---- CONFIG CONFIG CONFIG ----

local function on_paint_hud(ctx)
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

    if armor > 1 and armor <= 100 then
        has_kevlar = true
    else
        has_kevlar = false
    end

    ----bottom left hp armor
    draw_container(ctx, -10, scrsize_y-45, 300, 55)

    if health >= 0 and health <= 100 then
        client_draw_text(ctx, 25, scrsize_y-20, 255, 255, 255, 255, "c+", 0, "HP")
        client_draw_text(ctx, 45, scrsize_y-33, 231, 76, 60, 255, "+", 0, health)
    end

    if armor >= 100 then
        client_draw_text(ctx, 180, scrsize_y-20, 255, 255, 255, 255, "c+", 0, "ARMOR")
        client_draw_text(ctx, 230, scrsize_y-33, 52, 152, 219, 255, "+", 0, armor)
    elseif armor >= 10 and armor < 100 then 
        client_draw_text(ctx, 195, scrsize_y-20, 255, 255, 255, 255, "c+", 0, "ARMOR")
        client_draw_text(ctx, 245, scrsize_y-33, 52, 152, 219, 255, "+", 0, armor)
    elseif armor < 10 then
        client_draw_text(ctx, 210, scrsize_y-20, 255, 255, 255, 255, "c+", 0, "ARMOR")
        client_draw_text(ctx, 260, scrsize_y-33, 52, 152, 219, 255, "+", 0, armor)
    end
    ----

    ----flags
    if teamnum == teamnum_ct then 
        draw_container(ctx, 300, scrsize_y-45, 88, 55)

        if has_helmet == 1 then 
            client_draw_text(ctx, 315, scrsize_y-33, 46, 204, 113, 255, "+", 0, "H")
        elseif has_helmet == 0 then
            client_draw_text(ctx, 315, scrsize_y-33, 231, 76, 60, 255, "+", 0, "H")
        end    

        if has_kevlar == true then 
            client_draw_text(ctx, 335, scrsize_y-33, 46, 204, 113, 255, "+", 0, "K")
        elseif has_kevlar == false then
            client_draw_text(ctx, 335, scrsize_y-33, 231, 76, 60, 255, "+", 0, "K")
        end 

        if has_defuser == 1 then 
            client_draw_text(ctx, 355, scrsize_y-33, 46, 204, 113, 255, "+", 0, "D")
        elseif has_defuser == 0 then
            client_draw_text(ctx, 355, scrsize_y-33, 231, 76, 60, 255, "+", 0, "D")
        end 
    elseif teamnum == teamnum_t then
        draw_container(ctx, 300, scrsize_y-45, 101, 55)

        if has_helmet == 1 then 
            client_draw_text(ctx, 315, scrsize_y-33, 46, 204, 113, 255, "+", 0, "H")
        elseif has_helmet == 0 then
            client_draw_text(ctx, 315, scrsize_y-33, 231, 76, 60, 255, "+", 0, "H")
        end    

        if has_kevlar == true then 
            client_draw_text(ctx, 335, scrsize_y-33, 46, 204, 113, 255, "+", 0, "K")
        elseif has_kevlar == false then
            client_draw_text(ctx, 335, scrsize_y-33, 231, 76, 60, 255, "+", 0, "K")
        end 

        if c4_holder == local_player then 
            client_draw_text(ctx, 355, scrsize_y-33, 46, 204, 113, 255, "+", 0, "C4")
        else
            client_draw_text(ctx, 355, scrsize_y-33, 231, 76, 60, 255, "+", 0, "C4")
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

end

client_set_event_callback("paint", on_paint_hud)