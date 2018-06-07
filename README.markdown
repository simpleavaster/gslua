GameSense API for Lua
=====================

* [client.log](#clientlog)
* [client.exec](#clientexec)
* [client.cvar_get](#clientcvar_get)

client.log
----------
**syntax:** *val = log(str, ...)

Output text to the console.

`str` - The text you want to output.

`...` - Optional arguments separated by commas.

* **Example:**
    
`client.log("Hello!")`
        
>[gamesense] Hello!

[Back to TOC](#gamesense-api-for-lua)

client.exec
-----------
**syntax:** exec(cmds, ...)

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
**syntax:** cvar_get(convar_name)

Returns the value of a cvar.

`cvar` - The name of the cvar you want to get the value of.

* **Example:**

```lua

  client.log('My name: ', client.cvar_get('name'))`
```

>[gamesense] My name: avaster

[Back to TOC](#gamesense-api-for-lua)

### Other

1. **`is_enemy(userid)`**

Returns true if the specified `userid` is on the enemy team.

`userid` - The `userid` of the player.

[Back to TOC](#gamesense-api-for-lua)

2. **`is_local_player(userid)`**

Returns true if the specified `userid` is you.

`userid` - The `userid` of the player.

[Back to TOC](#gamesense-api-for-lua)

3. **`get_player_name(userid)`**

Returns the players name from `userid`, or nil if the user does not exist.

`userid` - The `userid` of the player.

[Back to TOC](#gamesense-api-for-lua)

4. **`read_entity_prop(entindex, netvar)`**

Returns value of the netvar on the entity

`entindex` - The entity index you want to access.

`netvar` - The name of the property you want to know the value of.

* **Example:**

`client.log('Health: ', read_entity_prop(myentindex, "m_iHealth"))`

>[gamesense] Health: 100 

[Back to TOC](#gamesense-api-for-lua)

5. **`userid_to_entindex(userid)`**

Returns an `entindex` from a `userid`.

`userid` - The `userid` of the player.

[Back to TOC](#gamesense-api-for-lua)
