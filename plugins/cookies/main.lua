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

    local createTableQuery = [[
        CREATE TABLE IF NOT EXISTS @tablename (
            steamid VARCHAR(30) PRIMARY KEY,
            value JSON NOT NULL
        )
        CHARACTER SET utf8mb4 
        COLLATE utf8mb4_unicode_ci;
    ]]
    local params = {
        ["tablename"] = config:Fetch("cookies.database.tablename") or "sw_cookies" ,
    }
    db:QueryParams(createTableQuery, params, function(err, result)
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

    local selectRowQuery = "SELECT * FROM @tablename WHERE steamid = @steamid LIMIT 1;"

    local params = {
        ["tablename"] = config:Fetch("cookies.database.tablename") or "sw_cookies",
        ["steamid"] = steamid
    }

    db:QueryParams(selectRowQuery, params, function(err, result)
        if err and #err > 0 then
            return print("{darkred} Error: {darkred}" .. err)
        end

        if #result == 0 then
            Cookies[playerid] = {}
        else
            Cookies[playerid] = json.decode(result[1].value)
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

    local insertRowQuery = "INSERT INTO @tablename (steamid, value) VALUES ('@steamid', '@value') ON DUPLICATE KEY UPDATE value ='@value';"

    local params = {
        ["tablename"] = config:Fetch("cookies.database.tablename") or "sw_cookies",
        ["steamid"] = steamid,
        ["value"] = json.encode(Cookies[playerid])
    }

    db:QueryParams(insertRowQuery, params, function(err, result)
        if err and #err > 0 then
            return print("{darkred} Error: {darkred}" .. err)
        end
    end)

    Cookies[playerid] = nil

    TriggerEvent("OnPlayerCookieUnloaded", playerid)

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
