local console_log = client.log
local console_cmd = client.exec
local cvar_get = client.cvar_get

local is_local_player = client.is_local_player

local _M = {}

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
