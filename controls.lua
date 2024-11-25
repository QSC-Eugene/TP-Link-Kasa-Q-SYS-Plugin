-- table.insert(ctrls,{Name = "code",ControlType = "Text",PinStyle = "Input",Count = 1})
local outputCount = props["Device Type"].Value == "Power Strip" and props["Number Of Outputs"].Value or 1

table.insert(
  ctrls,
  {
    Name = "Discover",
    ControlType = "Button",
    ButtonType = "Trigger",
    PinStyle = "Input",
    UserPin = true
  }
)

table.insert(
  ctrls,
  {
    Name = "Discovered Devices",
    ControlType = "Indicator",
    IndicatorType = "Text",
    PinStyle = "Output",
    UserPin = true
  }
)

table.insert(
  ctrls,
  {
    Name = "IPAddress",
    ControlType = "Text",
    PinStyle = "Both",
    UserPin = true
  }
)
table.insert(
  ctrls,
  {
    Name = "Status",
    ControlType = "Indicator",
    IndicatorType = Reflect and "StatusGP" or "Status",
    PinStyle = "Output",
    UserPin = true
  }
)

table.insert(
  ctrls,
  {
    Name = "Name",
    ControlType = "Text",
    PinStyle = "Both",
    UserPin = true
  }
)
table.insert(
  ctrls,
  {
    Name = "Model",
    ControlType = "Indicator",
    IndicatorType = "Text",
    PinStyle = "Output",
    UserPin = true
  }
)
table.insert(
  ctrls,
  {
    Name = "MACAddress",
    ControlType = "Indicator",
    IndicatorType = "Text",
    PinStyle = "Output",
    UserPin = true
  }
)
table.insert(
  ctrls,
  {
    Name = "DeviceFirmware",
    ControlType = "Indicator",
    IndicatorType = "Text",
    PinStyle = "Output",
    UserPin = true
  }
)
table.insert(
  ctrls,
  {
    Name = "Rssi",
    ControlType = "Indicator",
    IndicatorType = "Text",
    PinStyle = "Output",
    UserPin = true
  }
)
if props["Energy Monitoring"].Value and props["Device Type"].Value ~= "Light Strip" then
  table.insert(
    ctrls,
    {
      Name = "Voltage",
      ControlType = "Indicator",
      IndicatorType = "Text",
      PinStyle = "Output",
      UserPin = true,
      Count = outputCount
    }
  )
  table.insert(
    ctrls,
    {
      Name = "Current",
      ControlType = "Indicator",
      IndicatorType = "Text",
      PinStyle = "Output",
      UserPin = true,
      Count = outputCount
    }
  )
  table.insert(
    ctrls,
    {
      Name = "Power",
      ControlType = "Indicator",
      IndicatorType = "Text",
      PinStyle = "Output",
      UserPin = true,
      Count = outputCount
    }
  )
end

table.insert(
  ctrls,
  {
    Name = "On",
    ControlType = "Button",
    ButtonType = "Toggle",
    PinStyle = "Both",
    UserPin = true,
    Count = outputCount
  }
)
table.insert(
  ctrls,
  {
    Name = "Off",
    ControlType = "Button",
    ButtonType = "Toggle",
    PinStyle = "Both",
    UserPin = true,
    Count = outputCount
  }
)
table.insert(
  ctrls,
  {
    Name = "Toggle",
    ControlType = "Button",
    ButtonType = "Toggle",
    PinStyle = "Both",
    UserPin = true,
    Count = outputCount
  }
)
if props["Device Type"].Value == "Dimmer" or props["Device Type"].Value == "Light Strip" then
  table.insert(
    ctrls,
    {
      Name = "Brightness",
      ControlType = "Knob",
      ControlUnit = "Percent",
      Min = 1,
      Max = 100,
      PinStyle = "Both",
      UserPin = true
    }
  )
end
if props["Device Type"].Value == "Power Strip" then
  table.insert(
    ctrls,
    {
      Name = "PlugName",
      ControlType = "Text",
      PinStyle = "Both",
      UserPin = true,
      Count = outputCount
    }
  )
end
