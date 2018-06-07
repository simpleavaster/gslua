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

client.log
----------
**syntax:** *log(str, ...)*

Output text to the console.

`str` - The text you want to output.

`...` - Optional arguments separated by commas.

* **Example:**
    
`client.log("Hello!")`
        
>[gamesense] Hello!

[Back to TOC](#gamesense-api-for-lua)

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

[Back to TOC](#gamesense-api-for-lua)

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

[Back to TOC](#gamesense-api-for-lua)


client.is_enemy
---------------
**syntax:** *val = is_enemy(userid)*

Returns true if the specified `userid` is on the enemy team.

`userid` - The `userid` of the player.

[Back to TOC](#gamesense-api-for-lua)

client.is_local_player
---------------
**syntax:** *val = is_local_player(userid)*

Returns true if the specified `userid` is you.

`userid` - The `userid` of the player.

[Back to TOC](#gamesense-api-for-lua)

client.get_player_name
---------------
**syntax:** *name = get_player_name(userid)*

Returns the players name from `userid`, or nil if the user does not exist.

`userid` - The `userid` of the player.

[Back to TOC](#gamesense-api-for-lua)

client.read_entity_prop
---------------
**syntax:** *val = read_entity_prop(entindex, netvar)*

Returns value of the netvar on the entity

`entindex` - The entity index you want to access.

`netvar` - The name of the property you want to know the value of.

* **Example:**

`client.log('Health: ', read_entity_prop(myentindex, "m_iHealth"))`

>[gamesense] Health: 100 

[Back to TOC](#gamesense-api-for-lua)

client.userid_to_entindex
---------------
**syntax:** *entindex = userid_to_entindex(userid)*

Returns an `entindex` from a `userid`.

`userid` - The `userid` of the player.

[Back to TOC](#gamesense-api-for-lua)
