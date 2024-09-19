-- Get a player's cookie by their playerid and cookie name
export("GetPlayerCookie", function(playerid, cookie_name)
    if not Cookies[playerid] then return nil end
    return Cookies[playerid][cookie_name]
end)

-- Set a player's cookie
export("SetPlayerCookie", function(playerid, cookie_name, cookie_value)
    if not Cookies[playerid] then
        Cookies[playerid] = {}
    end
    Cookies[playerid][cookie_name] = cookie_value
    return true
end)

-- Check if a player has a specific cookie
export("HasPlayerCookie", function(playerid, cookie_name)
    if not Cookies[playerid] then return false end
    return Cookies[playerid][cookie_name] ~= nil
end)
