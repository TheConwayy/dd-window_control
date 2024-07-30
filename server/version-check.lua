--[[
* FUNCTIONS
--]]

-- Function to get current version from fxmanifest
local function GetInstalledVersion()
  return GetResourceMetadata(GetCurrentResourceName(), 'version')
end

-- Function trim any whitespace
local function trim(s)
  return (s:gsub("^%s*(.-)%s*$", "%1"))
end

--[[
* VARIABLES
--]]

-- Endpoint to get latest version from GitHub
local endpoint = 'https://raw.githubusercontent.com/TheConwayy/fivem-versions/main/dd-window_control.txt'

-- Name of the resource
local resourceName = GetCurrentResourceName()

--[[
* VERSION CHECKING
--]]

-- Check if config is enabled
if Config.CheckForUpdates then

  -- Wait to avoid spam
  Citizen.Wait(500)

  -- Perform request to get current version
  PerformHttpRequest(endpoint, function (err, text, headers)
    -- Nil check
    if (text == nil) then
      print('^1There was an error check for the latest version. If this issue persists, please open a ticket in this Discord: https://discord.gg/3rMN9uZAnf^7')
      return
    end

    -- Get versions
    local latestVersion = trim(text)
    local installedVersion = trim(GetInstalledVersion())

    -- Print versions
    print('Installed version: ' .. installedVersion)
    print('Latest version: ' .. latestVersion)

    -- Print if update is needed or not
    if latestVersion ~= installedVersion then
      print('^1Your "^7' .. resourceName .. '^1" script is out-of-date! You can get the latest version here:^7 https://github.com/TheConwayy/dd-window_control/releases.')
    else
      print('^2Your "^7' .. resourceName .. '^2" script is up-to-date! Have fun!^7')
    end
  end)
else
  -- If update checks are disable, encourge to enable them
  print('^1Update checking for "^7' .. resourceName .. '^1" is disabled! ^7We highly recommend that you enable it to make sure you have the latest features.^7')
end