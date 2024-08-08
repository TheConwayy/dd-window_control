local resourceName = GetCurrentResourceName()

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

-- Function to print message to console
local function printMess(message)
  exports.ddUtils:consoleMessage(resourceName, message)
end

-- Function to print error to console
local function printErr(err)
  exports.ddUtils:consoleErr(resourceName, err)
end

--[[
* VARIABLES
--]]

-- Endpoint to get latest version from GitHub
local endpoint = 'https://raw.githubusercontent.com/TheConwayy/fivem-versions/main/dd-window_control.txt'
local releasesPage = 'https://github.com/TheConwayy/dd-window_control/releases'

--[[
* VERSION CHECKING
--]]

-- Check if config is enabled
if Config.CheckForUpdates then

  -- Wait to avoid spam
  Citizen.Wait(1500)

  -- Perform request to get current version
  PerformHttpRequest(endpoint, function (_, text, _)
    -- Nil check
    if (text == nil) then
      printErr('^1There was an error checking for the latest version. If this issue persists, please open a ticket in this Discord: https://discord.gg/3rMN9uZAnf^7')
      return
    end

    -- Get versions
    local latestVersion = trim(text)
    local installedVersion = trim(GetInstalledVersion())

    -- Print versions
    printMess('Installed version: ' .. installedVersion)
    printMess('Latest version: ' .. latestVersion)

    -- Print if update is needed or not
    if latestVersion ~= installedVersion then
      printMess('^1Script is out-of-date! You can get the latest version here: ^7' .. releasesPage)
      printMess('==================================================')
    else
      printMess('Script is up-to-date!')
      printMess('==================================================')
    end
  end)
else
  -- If update checks are disable, encourge to enable them
  printErr('Update checking is disabled! We highly recommend that you enable it to make sure you have the latest features.')
end