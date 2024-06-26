--[[ #include "info.lua" ]]
local Colors = {
  White = {255, 255, 255},
  Black = {0, 0, 0},
  Red = {255, 0, 0},
  Green = {0, 255, 0},
  Blue = {0, 0, 255},
  Gray = {136, 136, 136},
  LightGray = {51, 51, 51},
  KasaBlue = {74, 203, 214},
  PluginColor = {74, 203, 214}
}

local MaxDevices = 24

-- Define the color of the plugin object in the design
function GetColor(props)
  return Colors.PluginColor
end

-- The name that will initially display when dragged into a design
function GetPrettyName(props)
  return PluginInfo.Name .. "\r" .. PluginInfo.BuildVersion
  -- return "Vaddio" .. props["Model"].Value .. " " .. PluginInfo.Version
end

-- Optional function used if plugin has multiple pages
PageNames = {"Central Control", "Discovery"} --List the pages within the plugin
function PopulatePageNames(props)
  for x = 1, props["Number Of Single Endpoints"].Value do
    table.insert(PageNames, "Device " .. x)
  end
  for x = 1, props["Number Of Multi Endpoints"].Value do
    table.insert(PageNames, "Strip " .. x)
  end
end

function GetPages(props)
  local pages = {}
  --[[ #include "pages.lua" ]]
  return pages
end

-- Define User configurable Properties of the plugin
function GetProperties()
  local props = {}
  --[[ #include "properties.lua" ]]
  return props
end

-- Optional function to define pins on the plugin that are not connected to a Control
function GetPins(props)
  local pins = {}
  --[[ #include "pins.lua" ]]
  return pins
end

-- Optional function to update available properties when properties are altered by the user
function RectifyProperties(props)
  --[[ #include "rectify_properties.lua" ]]
  return props
end

-- Optional function to define components used within the plugin
function GetComponents(props)
  local components = {}
  --[[ #include "components.lua" ]]
  return components
end

-- Optional function to define wiring of components used within the plugin
function GetWiring(props)
  local wiring = {}
  --[[ #include "wiring.lua" ]]
  return wiring
end

-- Defines the Controls used within the plugin
function GetControls(props)
  local ctrls = {}
  --[[ #include "controls.lua" ]]
  return ctrls
end

--Layout of controls and graphics for the plugin UI to display
function GetControlLayout(props)
  local layout = {}
  local graphics = {}
  --[[ #include "layout.lua" ]]
  return layout, graphics
end

--Start event based logic
if Controls then
--[[ #include "runtime.lua" ]]
end
