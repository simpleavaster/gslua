GameSense API for Lua
=====================

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
* [client.RandomInt](#clientrandomint)
* [client.RandomFloat](#clientrandomfloat)

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

client.RandomInt
----------------
**syntax:** *val = RandomInt(min, max)*

Generate a random integer between min and max.

`min` - The lowest possible integer.

`max` - The highest possible integer.

<sup>[Back to TOC](#gamesense-api-for-lua)</sup>

client.RandomFloat
------------------
**syntax:** *val = RandomFloat(min, max)*

Generate a random float between min and max.

`min` - The lowest possible float.

`max` - The highest possible float.

<sup>[Back to TOC](#gamesense-api-for-lua)</sup>
