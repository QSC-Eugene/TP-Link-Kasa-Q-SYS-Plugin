-- layout["code"] = {PrettyName = "Code",Style = "None"}

local x, y = 0, 10

local current_page = props["page_index"].Value
local deviceType = props["Device Type"].Value

if current_page == 3 then --Discover
  layout["Discover"] = {
    Position = {x, y},
    Size = {60, 40},
    Style = "Button",
    Legend = "Discover",
    FontSize = 14
  }
  y = y + 60
  layout["Discovered Devices"] = {
    Position = {x, y},
    Size = {300, 300},
    Style = "Text",
    Legend = "Discovered Devices",
    HTextAlign = "Left",
    VTextAlign = "Top",
    FontSize = 12
  }
elseif current_page == 1 then --Setup
  table.insert(
    graphics,
    {
      Type = "Label",
      Text = "IP Address:",
      Position = {x, y},
      Size = {100, 16},
      HTextAlign = "Right",
      FontSize = 12
    }
  )
  x = x + 100
  layout["IPAddress"] = {
    Position = {x, y},
    Size = {200, 16},
    Style = "Text",
  }
  x = 0
  y = y + 20
  table.insert(
    graphics,
    {
      Type = "Label",
      Text = "Status:",
      Position = {x, y},
      Size = {100, 16},
      HTextAlign = "Right",
      FontSize = 12
    }
  )
  x = x + 100
  layout["Status"] = {
    Position = {x, y},
    Size = {200, 16},
    Style = "Text",
  }
  x = 0
  y = y + 20
  table.insert(
    graphics,
    {
      Type = "Label",
      Text = "Name:",
      Position = {x, y},
      Size = {100, 16},
      HTextAlign = "Right",
      FontSize = 12
    }
  )
  x = x + 100
  layout["Name"] = {
    Position = {x, y},
    Size = {200, 16},
    Style = "Text",
  }
  x = 0
  y = y + 20
  table.insert(
    graphics,
    {
      Type = "Label",
      Text = "Model:",
      Position = {x, y},
      Size = {100, 16},
      HTextAlign = "Right",
      FontSize = 12
    }
  )
  x = x + 100
  layout["Model"] = {
    Position = {x, y},
    Size = {200, 16},
    Style = "Text",
  }
  x = 0
  y = y + 20
  table.insert(
    graphics,
    {
      Type = "Label",
      Text = "MAC Address:",
      Position = {x, y},
      Size = {100, 16},
      HTextAlign = "Right",
      FontSize = 12
    }
  )
  x = x + 100
  layout["MACAddress"] = {
    Position = {x, y},
    Size = {200, 16},
    Style = "Text",
  }
  x = 0
  y = y + 20
  table.insert(
    graphics,
    {
      Type = "Label",
      Text = "Device Firmware:",
      Position = {x, y},
      Size = {100, 16},
      HTextAlign = "Right",
      FontSize = 12
    }
  )
  x = x + 100
  layout["DeviceFirmware"] = {
    Position = {x, y},
    Size = {200, 16},
    Style = "Text",
  }
  x = 0
  y = y + 20
  table.insert(
    graphics,
    {
      Type = "Label",
      Text = "RSSI:",
      Position = {x, y},
      Size = {100, 16},
      HTextAlign = "Right",
      FontSize = 12
    }
  )
  x = x + 100
  layout["Rssi"] = {
    Position = {x, y},
    Size = {200, 16},
    Style = "Text",
  }
elseif current_page == 2 then -- Loads
  if props["Device Type"].Value == "Power Strip" then
    for p = 1, props["Number Of Outputs"].Value do
      x = 0
      table.insert(
        graphics,
        {
          Type = "Label",
          Text = p..":",
          Position = {x, y},
          Size = {24,16},
          FontSize = 12,
          HTextAlign = "Right"
        }
      )
      x = x + 24
      layout["PlugName "..p] = {
        Position = {x, y},
        Size = {50, 16},
        Style = "Text",
      }
      x = x + 50
      layout["Off "..p] = {
        Position = {x, y},
        Size = {36,16},
        Style = "Button",
        ButtonStyle = "Toggle",
        Legend = "Off",
        FontSize = 9
      }
      x = x + 36
      layout["On "..p] = {
        Position = {x, y},
        Size = {36,16},
        Style = "Button",
        ButtonStyle = "Toggle",
        Legend = "On",
        FontSize = 9
      }
      x = x + 36
      layout["Toggle "..p] = {
        Position = {x, y},
        Size = {36,16},
        Style = "Button",
        ButtonStyle = "Toggle",
        Legend = "Toggle",
        FontSize = 9
      }
      if props["Energy Monitoring"].Value then
        x = x + 36
        layout["Voltage "..p] = {
          Position = {x, y},
          Size = {50, 16},
          Style = "Text",
        }
        x = x + 50
        layout["Current "..p] = {
          Position = {x, y},
          Size = {50, 16},
          Style = "Text",
        }
        x = x + 50
        layout["Power "..p] = {
          Position = {x, y},
          Size = {50, 16},
          Style = "Text",
        }
      end
      y = y + 20
    end
  else
    layout["Off"] = {
      Position = {x, y},
      Size = {60, 40},
      Style = "Button",
      ButtonStyle = "Toggle",
      Legend = "Off",
      FontSize = 14
    }
    x = x + 64
    layout["On"] = {
      Position = {x, y},
      Size = {60, 40},
      Style = "Button",
      ButtonStyle = "Toggle",
      Legend = "On",
      FontSize = 14
    }
    x = x + 64
    layout["Toggle"] = {
      Position = {x, y},
      Size = {60, 40},
      Style = "Button",
      ButtonStyle = "Toggle",
      Legend = "Toggle",
      FontSize = 14
    }
    x = 0
    y = y + 64
    if props["Device Type"].Value == "Dimmer" then
      layout["Brightness"] = {
        Position = {x, y},
        Size = {188, 40},
        Style = "Fader",
      }
      y = y + 44
    end
    if props["Energy Monitoring"].Value then
      table.insert(
        graphics,
        {
          Type = "Label",
          Text = "Voltage:",
          Position = {x, y},
          Size = {50, 16},
          HTextAlign = "Right",
          FontSize = 12
        }
      )
      x = x + 50
      layout["Voltage"] = {
        Position = {x, y},
        Size = {50, 16},
        Style = "Text",
      }
      x = 0
      y = y + 20
      table.insert(
        graphics,
        {
          Type = "Label",
          Text = "Current:",
          Position = {x, y},
          Size = {50, 16},
          HTextAlign = "Right",
          FontSize = 12
        }
      )
      x = x + 50
      layout["Current"] = {
        Position = {x, y},
        Size = {50, 16},
        Style = "Text",
      }
      x = 0
      y = y + 20
      table.insert(
        graphics,
        {
          Type = "Label",
          Text = "Power:",
          Position = {x, y},
          Size = {50, 16},
          HTextAlign = "Right",
          FontSize = 12
        }
      )
      x = x + 50
      layout["Power"] = {
        Position = {x, y},
        Size = {50, 16},
        Style = "Text",
      }

    end
  end

  
  

end
