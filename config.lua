-- DO NOT TOUCH THIS --
Config = {}

-- Debug mode will log EVERYTHING, and may cause lag on bigger servers. Only use this if you need it, or if asked by support --
Config.DebugMode = false

-- Enable chat commands /fl, /fr, /rl, /rr --
Config.ChatCommands = false

-- Whether or not notifications are sent --
Config.Notfications = true

-- The method of notification (if "Notifications" is set to true) --
--[[
  NOTIFICAION METHOD TYPES:
  - 'CHAT' (sends a notification in the chat box (CHATMESSAGE))
  - 'ABOVE_MINIMAP' (sends a notificaation above the mini-map (NOTIFICATION))
  - 'TOP_LEFT' (sends a notification in the top left corener (ALERT))
--]]
Config.NotificationMethod = 'ABOVE_MINIMAP'

-- Whether or not only the driver can control windows --
Config.DriverOnly = true

-- Whether or not to check for version updates (recommended to keep set to 'true') --
Config.CheckForUpdates = true