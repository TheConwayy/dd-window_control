--[[
* FUNCTIONS
--]]

-- Function for debugging
local function debug(string)
  if Config.DebugMode then
    print(string)
  end
end

-- Function to send a chat message
local function sendChatMessage(string)
  if Config.SendChatMessage then
    TriggerEvent('chat:addMessage', {
    args = { '^4^*Window Control^7: ^r' .. string }
  })
  debug('Window control chat message sent')
  end
end

-- Function to take a window index and return a string
local function windowIndexToString(windowIndex)
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
      debug(isWindowOpen)
      if isWindowOpen then
        RollDownWindow(playerVehicle, windowIndex)
        sendChatMessage('The ' .. windowIndexToString(windowIndex) .. ' window has been rolled ^1down^r')
        debug('(openOrCloseWindow function) window rolled down')
      else
        RollUpWindow(playerVehicle, windowIndex)
        sendChatMessage('The ' .. windowIndexToString(windowIndex) .. ' window has been rolled ^2up^r')
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
        sendChatMessage('The ' .. windowIndexToString(windowIndex) .. ' window has been rolled ^1down^r')
        debug('(openOrCloseWindow function) window rolled down')
      else
        RollUpWindow(playerVehicle, windowIndex)
        sendChatMessage('The ' .. windowIndexToString(windowIndex) .. ' window has been rolled ^2up^r')
        debug('(openOrCloseWindow function) window rolled up')
      end
    end
  end
end

--[[
* MISC. CHECKS
--]]

-- If debug mode is on, then list all configs and their values
if Config.DebugMode then
  for k,v in pairs(Config) do
    print('Config "' .. k .. '" is set to: ' .. tostring(v))
  end
end

-- If chat commands are disabled, remove the suggestions
if not Config.ChatCommands then
  TriggerEvent('chat:removeSuggestion', '/fl')
  TriggerEvent('chat:removeSuggestion', '/fr')
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
end

--[[
* REGISTER KEYBINDINGS
--]]

RegisterKeyMapping('-toggleflwindow', 'Toggle front left window', 'keyboard', 'HOME')
RegisterKeyMapping('-togglefrwindow', 'Toggle front right window', 'keyboard', 'PAGEUP')
RegisterKeyMapping('-togglerlwindow', 'Toggle rear left window', 'keyboard', 'END')
RegisterKeyMapping('-togglerrwindow', 'Toggle rear right window', 'keyboard', 'PAGEDOWN')