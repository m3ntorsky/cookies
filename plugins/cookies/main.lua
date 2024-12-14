AddEventHandler("OnPluginStart", function(event)
    config:Create("cookies",{
        database = {
            connection = "default_connection",
            tablename = "sw_cookies"
        }
    })
    config:Reload("cookies")

    db = Database(tostring(config:Fetch("cookies.database.connection")) or "default_connection")
    if not db:IsConnected() then return EventResult.Continue end

    db:QueryBuilder():Table(tostring(config:Fetch("cookies.database.tablename") or "sw_cookies")):Create({
        steamid = "VARCHAR(30) PRIMARY KEY",
        value = "JSON NOT NULL"
    }):Execute(function (err, result)
        if #err > 0 then
            return print("{darkred} Error: {darkred}" .. err)
        end        
    end)

    return EventResult.Continue
end)


AddEventHandler("OnClientConnect", function(event, playerid)
    if not db:IsConnected() then return EventResult.Continue end

    local player = GetPlayer(playerid)
    if not player or player:IsFakeClient() then return EventResult.Continue end

    local steamid = player:GetSteamID()
    if not steamid then return EventResult.Continue end

    db:QueryBuilder():Table(tostring(config:Fetch("cookies.database.tablename") or "sw_cookies")):Select({'value'}):Where('steamid','=',steamid):Limit(1):Execute(function (err, result)
        if err and #err > 0 then
            return print("{darkred} Error: {darkred}" .. err)
        end

        if #result == 0 then
            Cookies[playerid] = {}
        else
            Cookies[playerid] = json.decode(result[#result].value)
        end

        for _, cookie in ipairs(RegisteredCookies) do
            if Cookies[playerid][cookie.name] == nil then
                Cookies[playerid][cookie.name] = cookie.value
            end
        end
        TriggerEvent("OnPlayerCookieLoaded", playerid)        
    end)

    return EventResult.Continue
end)


AddEventHandler("OnClientDisconnect", function(event, playerid)
    if not db:IsConnected() then return EventResult.Continue end
    if not Cookies[playerid] then return end

    local player = GetPlayer(playerid)
    if not player or player:IsFakeClient() then return EventResult.Continue end

    local steamid = player:GetSteamID()
    if not steamid then return EventResult.Continue end

    local value = Cookies[playerid]

    db:QueryBuilder():Table(tostring(config:Fetch("cookies.database.tablename") or "sw_cookies")):Insert({
        steamid = steamid,
        value = json.encode(value)
    }):OnDuplicate({value = json.encode(value)}):Execute(function (err, result)
        if err and #err > 0 then
            return print("{darkred} Error: {darkred}" .. err)
        end
        Cookies[playerid] = nil
        TriggerEvent("OnPlayerCookieUnloaded", playerid)
    end)
    return EventResult.Continue
end)


function GetDefaultCookieValue(cookie_name)
    for _, cookie in ipairs(RegisteredCookies) do
        if cookie.name == cookie_name then
            return cookie.value
        end
    end
    return nil
end
