GameSense API for Lua
=====================

* [gs.set_event_callback](#gsset_event_callback)
* [gs.create_menu_checkbox](#gscreate_menu_checkbox)
* [gs.set_var](#gsset_var)
* [gs.get_var](#gsget_var)
* [client.log](#clientlog)
* [client.exec](#clientexec)
* [client.cvar_get](#clientcvar_get)
* [client.is_enemy](#clientis_enemy)
* [client.is_local_player](#clientis_local_player)
* [client.get_player_name](#clientget_player_name)
* [client.read_entity_prop](#clientread_entity_prop)
* [client.userid_to_entindex](#clientuserid_to_entindex)
* [client.draw_debug_text](#clientdraw_debug_text)
* [client.draw_hitboxes](#clientdraw_hitboxes)
* [client.random_int](#clientrandom_int)
* [client.random_float](#clientrandom_float)
* [client.draw_text](#clientdraw_text)
* [client.draw_rectangle](#clientdraw_rectangle)
* [client.world_to_screen](#clientworld_to_screen)

gs.set_event_callback
---------------------
**syntax:** *set_event_callback(event_name, callback_function)*

<sup>[Back to TOC](#gamesense-api-for-lua)</sup>

gs.create_menu_checkbox
---------------------
**syntax:** *var = create_menu_checkbox(tab_name, container_name, checkbox_name)*

Returns nil on failure. Tab names must be one of: AA, LEGIT, MISC, PLAYERS, RAGE, SKINS, VIS.

The result of this function is a special type that can be only be used with gs.set_var and gs.get_var. Do not call this from an event callback. See gs.get_var for an example.

<sup>[Back to TOC](#gamesense-api-for-lua)</sup>

gs.set_var
---------------------
**syntax:** *set_var(var, enabled)*

Programmatically check/uncheck a checkbox that you created with gs.create_menu_checkbox

<sup>[Back to TOC](#gamesense-api-for-lua)</sup>

gs.get_var
---------------------
**syntax:** *get_var(var)*

Check whether or not a user-created checkbox is checked.

Example:
```lua

local test_item = gs.create_menu_checkbox("AA", "Other", "Test variable 2")
if not test_item then
    console_log("create_menu_checkbox failed")
end

-- inside an event function
    if gs.get_var(test_item) then
        -- checkbox is checked
        -- implement feature here
    end
```

<sup>[Back to TOC](#gamesense-api-for-lua)</sup>

client.log
----------
**syntax:** *log(str, ...)*

Output text to the console.

`str` - The text you want to output.

`...` - Optional arguments separated by commas.

* **Example:**
    
`client.log("Hello!")`
        
>[gamesense] Hello!

<sup>[Back to TOC](#gamesense-api-for-lua)</sup>

client.exec
-----------
**syntax:** *exec(cmds, ...)*

Execute console command(s).

`cmds` - String of the commands you want to execute, separated by a `;`.

`...` - Optional arguments separated by commas.

* **Example:**

```lua

  client.exec("say Hello!")
```

>avaster: Hello!

<sup>[Back to TOC](#gamesense-api-for-lua)</sup>

client.cvar_get
---------------
**syntax:** *val = cvar_get(convar_name)*

Returns the value of a cvar.

`cvar` - The name of the cvar you want to get the value of.

* **Example:**

```lua

  client.log('My name: ', client.cvar_get('name'))`
```

>[gamesense] My name: avaster

<sup>[Back to TOC](#gamesense-api-for-lua)</sup>


client.is_enemy
---------------
**syntax:** *val = is_enemy(userid)*

Returns true if the specified `userid` is on the enemy team.

`userid` - The `userid` of the player.

<sup>[Back to TOC](#gamesense-api-for-lua)</sup>

client.is_local_player
----------------------
**syntax:** *val = is_local_player(userid)*

Returns true if the specified `userid` is you.

`userid` - The `userid` of the player.

<sup>[Back to TOC](#gamesense-api-for-lua)</sup>

client.get_player_name
----------------------
**syntax:** *name = get_player_name(userid)*

Returns the players name from `userid`, or `nil` if the user does not exist.

`userid` - The `userid` of the player.

<sup>[Back to TOC](#gamesense-api-for-lua)</sup>

client.read_entity_prop
-----------------------
**syntax:** *val = read_entity_prop(entindex, netvar)*

Returns value of the netvar on the entity, or `nil` on failure.

`entindex` - The entity index you want to access.

`netvar` - The name of the property you want to know the value of.

* **Example:**

`client.log('Health: ', read_entity_prop(myentindex, "m_iHealth"))`

>[gamesense] Health: 100 

<sup>[Back to TOC](#gamesense-api-for-lua)</sup>

client.userid_to_entindex
-------------------------
**syntax:** *entindex = userid_to_entindex(userid)*

Returns an `entindex` from a `userid`, or `0` on failure.

`userid` - The `userid` of the player.

<sup>[Back to TOC](#gamesense-api-for-lua)</sup>

client.draw_debug_text
----------------------
**syntax:** *draw_debug_text(x, y, z, line_offset, duration, r, g, b, a, ...)*

Draws text at the specifid world position.

`x`, `y`, `z` - 3D coordinates in world space where the text will be drawn.

`line_offset` - Used for vertical alignment between multiple calls. Use `0` for the first line.

`duration` - Time in seconds that the text will remain visible.

`r`, `g`, `b`, `a` - Color (red, green, blue, alpha). Values should be within the range 1-255.

<sup>[Back to TOC](#gamesense-api-for-lua)</sup>

client.draw_hitboxes
--------------------
**syntax:** *draw_hitboxes(userid, duration, hitbox, r, g, b)*

Draws one or more hitboxes.

`userid` - The `userid` of the player.

`duration` - Time in seconds that the text will remain visible.

`hitbox` - Hitbox index to draw. Use `19` to draw all hitboxes.

`r`, `g`, `b` - Color (red, green, blue). Values should be within the range 1-255.

<sup>[Back to TOC](#gamesense-api-for-lua)</sup>

client.random_int
----------------
**syntax:** *val = random_int(min, max)*

Generate a random integer between min and max.

`min` - The lowest possible integer.

`max` - The highest possible integer.

<sup>[Back to TOC](#gamesense-api-for-lua)</sup>

client.random_float
------------------
**syntax:** *val = random_float(min, max)*

Generate a random float between min and max.

`min` - The lowest possible float.

`max` - The highest possible float.

<sup>[Back to TOC](#gamesense-api-for-lua)</sup>

client.draw_text
------------------
**syntax:** *val = draw_text(paint_context, x, y, r, g, b, a, flags, max_width, text, ...)*

Draw text at the given screen coordinates.

`paint_context` - The context in which the text should be drawn in.

`x`, `y` - Coordinate offset from the top left of the display where the text will be drawn.

`r`, `g`, `b`, `a` - Color (red, green, blue, alpha). Values should be within the range 1-255.

`flags` - Flags which modify the style and origin of the text, or `nil` to draw default.
    
* `+` - Large text, used for the on-screen indicators.
* `-` - Small text, used for Flags.
* `c` - Center text at origin.

`max_width` - *todo*

`text` - The text you want to draw.

<sup>[Back to TOC](#gamesense-api-for-lua)</sup>

client.draw_rectangle
------------------
**syntax:** *val = draw_rectangle(paint_context, x, y, w, h, r, g, b, a)*

Draw a rectangle at the given screen coordinates.

`paint_context` - The context in which the rectangle should be drawn in.

`x`, `y` - Coordinate offset from the top left of the display where the rectangle will be drawn.

`w`, `h` - The width and height of the rectangle.

`r`, `g`, `b`, `a` - Color (red, green, blue, alpha). Values should be within the range 1-255.

<sup>[Back to TOC](#gamesense-api-for-lua)</sup>


client.world_to_screen
------------------
**syntax:** *x, y = world_to_screen(paint_ctx, x, y, z)*

Get the screen coordinates for the world position. Returns nil if the position is behind you (not visible).

*todo*

<sup>[Back to TOC](#gamesense-api-for-lua)</sup>


