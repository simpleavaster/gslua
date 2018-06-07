local console_log = client.log

local hitgroup_names = { "body", "head", "chest", "stomach", "left arm", "right arm", "left leg", "right leg", "neck", "?", "body" }

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

return _M
