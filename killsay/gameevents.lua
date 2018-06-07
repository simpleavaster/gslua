local console_cmd = client.exec
local is_local_player = client.is_local_player
local get_player_name = client.get_player_name

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
