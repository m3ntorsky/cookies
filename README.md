
<p align="center">
  <a href="https://github.com/swiftly-solution/swiftly_pluginname">
    <img src="https://cdn.swiftlycs2.net/swiftly-logo.png" alt="SwiftlyLogo" width="80" height="80">
  </a>

  <h3 align="center">[Swiftly] Cookies</h3>

  <p align="center">
    A simple plugin for Swiftly that implements a cookie system. With this tool, developers can easily set, read, and modify cookies assigned to individual players.
    <br/>
  </p>
</p>

<p align="center">
  <img src="https://img.shields.io/github/downloads/swiftly-solution/cookies/total" alt="Downloads"> 
  <img src="https://img.shields.io/github/contributors/swiftly-solution/cookies?color=dark-green" alt="Contributors">
  <img src="https://img.shields.io/github/issues/swiftly-solution/cookies" alt="Issues">
  <img src="https://img.shields.io/github/license/swiftly-solution/cookies" alt="License">
</p>

---

### Installation 👀

1. Download the newest [release](https://github.com/swiftly-solution/cookies/releases).
2. Everything is drag & drop, so I think you can do it!

### Configuring the plugin 🧐

* After installing the plugin, you can change the database connection name and table name from `addons/swiftly/configs/plugins` (optional).

### Cookie Events 🛠️

The following events are available:

| Name                      | Arguments | Description                                            |
|---------------------------|-----------|--------------------------------------------------------|
| OnPlayerCookieLoaded      | playerid  | Triggered when a player's cookies are loaded          |
| OnPlayerCookieUnloaded    | playerid  | Triggered when a player's cookies are unloaded        |

### Cookie Exports 🛠️

The following exports are available:

| Name                | Arguments                             | Description                                           |
|---------------------|---------------------------------------|-------------------------------------------------------|
| RegisterCookie      | cookie_name, default_value            | Register cookie with default value                    |
| GetPlayerCookie     | playerid, cookie_name                 | Retrieves a player cookie by their playerid and cookie name |
| SetPlayerCookie     | playerid, cookie_name, cookie_value   | Sets a player's cookie                               |
| HasPlayerCookie     | playerid, cookie_name                 | Checks if a player has a specific cookie            |


### Example Usage ✍️

The following example code shows how to register a default cookie variable:

```lua
AddEventHandler("OnPlayerCookieLoaded", function (event, playerid)
    if not exports["cookies"]:HasPlayerCookie(playerid, "cookie_name") then
      exports["cookies"]:SetPlayerCookie(playerid, "cookie_name", "default_value")
    end
    return EventResult.Continue
end)
```

or

```lua
AddEventHandler("OnAllPluginsLoaded", function (event, playerid)
    if GetPluginState("cookies") == PluginState_t.Started then
      exports["cookies"]:RegisterCookie("cookie_name","default_value")
    end
    return EventResult.Continue
end)
```

### Creating A Pull Request 😃

1. Fork the Project
2. Create your Feature Branch
3. Commit your Changes
4. Push to the Branch
5. Open a Pull Request

### Have ideas/Found bugs? 💡
Join [Swiftly Discord Server](https://swiftlycs2.net/discord) and send a message in the topic from `📕╎plugins-sharing` of this plugin!

---