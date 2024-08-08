local resourceName = GetCurrentResourceName()

--[[
* FUNCTIONS
--]]

-- Function for debugging
local function debug(message)
  exports.ddUtils:debug(Config, resourceName, message)
end

-- Function to check notification method
local function checkNotificationMethod(method)
  local methods = { 'CHAT', 'ABOVE_MINIMAP', 'TOP_LEFT' }
  debug('(checkNotificationMethod function) method gathered: "' .. method .. '"')
  return exports.ddUtils:stringInTable(methods, method)
end

-- Function to get correct colors
local function color(colorWanted)
  local format = 0
  if Config.NotificationMethod ~= 'CHAT' then
    format = 1
  else
    format = 0
  end
  debug('(color function) format set to: ' .. tostring(format))
  return exports.ddUtils:color(format, colorWanted)
end

-- Function to send notification according to the config
local function notify(message)
  if Config.Notfications then
    local method = Config.NotificationMethod
    debug('(notify function) method gathered: "' .. method .. '"')
    if not checkNotificationMethod(method) then
      exports.ddUtils:consoleErr(resourceName, 'You must provide a valid "NotificationMethod" in the config.lua')
      return
    end
    message = message .. color('white')
    debug('(notify function) formatted message: "' .. message .. '"')
    if method == 'CHAT' then
      exports.ddUtils:sendChatMessage('Window Control', message)
    elseif method == 'ABOVE_MINIMAP' then
      exports.ddUtils:showNotification(message, false)
    elseif 'TOP_LEFT' then
      exports.ddUtils:showAlert(message, 0, false, -1)
    end
  end
end

-- Function to take a window index and return a string
local function windowIndexToString(windowIndex)
  debug ('(windowIndexToString function) window index gathered: ' .. tostring(windowIndex))
  if windowIndex == 0 then
    return 'front left'
  elseif windowIndex == 1 then
    return 'front right'
  elseif windowIndex == 2 then
    return 'rear left'
  elseif windowIndex == 3 then
    return 'rear right'
  end
end

function openOrCloseWindow(playerPed, windowIndex)
  debug('(openOrCloseWindow function) Player ped provided: ' .. playerPed)
  debug('(openOrCloseWindow function) Window index provided: ' .. windowIndex)
  local playerVehicle = GetVehiclePedIsIn(playerPed, false)
  if Config.DriverOnly then
    debug('(openOrCloseWindow function) detected driver only config')
    if playerVehicle > 0 and GetPedInVehicleSeat(playerVehicle, -1) == playerPed then
      debug('(openOrCloseWindow function) playerVehicle exists and player executing command is in driver seat')
      local isWindowOpen = IsVehicleWindowIntact(playerVehicle, windowIndex)
      debug('(openOrCloseWindow function) Is window open: ' .. tostring(isWindowOpen))
      if isWindowOpen then
        RollDownWindow(playerVehicle, windowIndex)
        notify('The ' .. windowIndexToString(windowIndex) .. ' window has been rolled ' .. color('red') .. 'down')
        debug('(openOrCloseWindow function) window rolled down')
      else
        RollUpWindow(playerVehicle, windowIndex)
        notify('The ' .. windowIndexToString(windowIndex) .. ' window has been rolled ' .. color('green') .. 'up')
        debug('(openOrCloseWindow function) window rolled up')
      end
    end
  else
    debug('(openOrCloseWindow function) did not detect driver only config')
    if playerVehicle > 0 then
      debug('(openOrCloseWindow function) playerVehicle exists and player executing command is in driver seat')
      local isWindowOpen = IsVehicleWindowIntact(playerVehicle, windowIndex)
      debug(isWindowOpen)
      if isWindowOpen then
        RollDownWindow(playerVehicle, windowIndex)
        notify('The ' .. windowIndexToString(windowIndex) .. ' window has been rolled ' .. color('red') .. 'down')
        debug('(openOrCloseWindow function) window rolled down')
      else
        RollUpWindow(playerVehicle, windowIndex)
        notify('The ' .. windowIndexToString(windowIndex) .. ' window has been rolled ' .. color('green') .. 'up')
        debug('(openOrCloseWindow function) window rolled up')
      end
    end
  end
end

--[[
* MISC. CHECKS
--]]

-- Check config
exports.ddUtils:checkConfig(Config)

-- If chat commands are disabled, remove the suggestions
if not Config.ChatCommands then
  TriggerEvent('chat:removeSuggestion', '/fl')
  TriggerEvent('chat:removeSuggestion', '/fr')
  TriggerEvent('chat:removeSuggestion', '/rl')
  TriggerEvent('chat:removeSuggestion', '/rr')
  debug('Chat suggestions have been removed, if not already')
end

--[[
* REGISTER COMMANDS
--]]

-- Keybind registry
RegisterCommand('-toggleflwindow', function ()
  local playerPed = PlayerPedId()
  openOrCloseWindow(playerPed, 0)
  debug('Command "-toggleflwindow" has been executed')
end)
RegisterCommand('-togglefrwindow', function ()
  local playerPed = PlayerPedId()
  openOrCloseWindow(playerPed, 1)
  debug('Command "-togglefrwindow" has been executed')
end)
RegisterCommand('-togglerlwindow', function ()
  local playerPed = PlayerPedId()
  openOrCloseWindow(playerPed, 2)
  debug('Command "-togglerlwindow" has been executed')
end)
RegisterCommand('-togglerrwindow', function ()
  local playerPed = PlayerPedId()
  openOrCloseWindow(playerPed, 3)
  debug('Command "-togglerrwindow" has been executed')
end)

-- If enabled, chat command registry
if Config.ChatCommands then
  RegisterCommand('fl', function ()
    local playerPed = PlayerPedId()
    openOrCloseWindow(playerPed, 0)
    debug('Command "/fl" has been executed')
  end)
  RegisterCommand('fr', function ()
    local playerPed = PlayerPedId()
    openOrCloseWindow(playerPed, 1)
    debug('Command "/fr" has been executed')
  end)
  RegisterCommand('rl', function ()
    local playerPed = PlayerPedId()
    openOrCloseWindow(playerPed, 2)
    debug('Command "/rl" has been executed')
  end)
  RegisterCommand('rr', function ()
    local playerPed = PlayerPedId()
    openOrCloseWindow(playerPed, 3)
    debug('Command "/rr" has been executed')
  end)
  TriggerEvent('chat:addSuggestions', {
    {
      name = '/fl',
      help = 'Toggle your front left window'
    },
    {
      name = '/fr',
      help = 'Toggle your front right window'
    },
    {
      name = '/rl',
      help = 'Toggle your rear left window'
    },
    {
      name = '/rr',
      help = 'Toggle your rear right window'
    },
  })
  debug('Chat suggestions have been added, if not already')
end

--[[
* REGISTER KEYBINDINGS
--]]

RegisterKeyMapping('-toggleflwindow', 'Toggle front left window', 'keyboard', 'HOME')
RegisterKeyMapping('-togglefrwindow', 'Toggle front right window', 'keyboard', 'PAGEUP')
RegisterKeyMapping('-togglerlwindow', 'Toggle rear left window', 'keyboard', 'END')
RegisterKeyMapping('-togglerrwindow', 'Toggle rear right window', 'keyboard', 'PAGEDOWN')