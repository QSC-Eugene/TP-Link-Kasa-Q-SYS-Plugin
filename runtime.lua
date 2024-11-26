rapidjson = require("rapidjson")

DeviceType = Properties["Device Type"].Value
isStrip = DeviceType == "Power Strip"
EnergyMonitoring =
  (DeviceType ~= "Dimmer" or DeviceType ~= "Light Strip") and Properties["Energy Monitoring"].Value or false

DebugTx, DebugRx, DebugFunction = false, false, false
DebugPrint = Properties["Debug Print"].Value
if DebugPrint == "Tx/Rx" then
  DebugTx, DebugRx = true, true
elseif DebugPrint == "Tx" then
  DebugTx = true
elseif DebugPrint == "Rx" then
  DebugRx = true
elseif DebugPrint == "Function Calls" then
  DebugFunction = true
elseif DebugPrint == "All" then
  DebugTx, DebugRx, DebugFunction = true, true, true
end

StatusState = {OK = 0, COMPROMISED = 1, FAULT = 2, NOTPRESENT = 3, MISSING = 4, INITIALIZING = 5}

--[[ #include "KasaEncryption.lua" ]]
--[[ #include "Discovery.lua" ]]
Socket = TcpSocket.New()
PollTimer = Timer.New()
FaderDebounce = Timer.New()
PollTime = Properties["Poll Time"].Value
Buffer = ""
LastPacketErr = false
Info = {}
Energy = {}

PollTimer.EventHandler = function()
  DevicePoll()
end
Socket.EventHandler = function(socket, event, err)
  -- print(event)
  if event == TcpSocket.Events.Data then
    -- print("got " .. socket.BufferLength .. " bytes")
    Buffer = Buffer .. socket:Read(socket.BufferLength)
    local jsonData, err = nil, nil
    local success, pcallError =
      pcall(
      function()
        jsonData, err = decode(Buffer)
      end
    )
    if not success then
      print("Error: " .. pcallError)
      print("Buffer Length: " .. #Buffer)
      Buffer = ""
      LastPacketErr = false
    elseif err == nil then
      -- print("JSON OK, " .. #Buffer .. " bytes")
      Buffer = ""
      LastPacketErr = false
      if DebugRx then
        print("RX:\n" .. rapidjson.encode(jsonData))
      end
      if jsonData.system then
        if jsonData.system.get_sysinfo then
          if jsonData.system.get_sysinfo.err_code == 0 then
            Controls["Status"].Value = 0 --ok
            Controls["Status"].String = ""
          end
          parseGetInfo(jsonData.system.get_sysinfo)
        elseif jsonData.system.set_relay_state then
          DevicePoll()
        end
      elseif jsonData["smartlife.iot.dimmer"] then -- Dimmer response
        -- Poll()
      elseif jsonData.emeter then -- Energy info
        if jsonData.emeter.get_realtime and EnergyMonitoring then -- Realtime energy info
          parseEnergyInfo(jsonData.emeter.get_realtime)
        end
      else
        print("Unknown JSON")
        print(rapidjson.encode(jsonData))
      end
    elseif not LastPacketErr then
      LastPacketErr = true
    else
      print("strikeout")
      print(decodeToString(Buffer))
      Buffer = ""
      LastPacketErr = false
    end
  elseif event == TcpSocket.Events.Connected then
    DevicePoll()
    PollTimer:Start(PollTime)
    Buffer = ""
    LastPacketErr = false
  else
    PollTimer:Stop()
    Controls["Status"].Value = 4 --missing
    Controls["Status"].String = event
  end
end

function Send(toSend)
  if Socket.IsConnected then
    if DebugTx then
      print("TX: " .. toSend)
    end
    Socket:Write(encode(toSend))
  else
    print("Socket not connected, cannot send:" .. toSend)
  end
end

Controls["IPAddress"].EventHandler = function(ctrl)
  DeviceDisconnect()
  DeviceConnect()
end

if isStrip then
  for p = 1, Properties["Number Of Outputs"].Value do
    Controls["On"][p].EventHandler = function(ctrl)
      if Info.deviceId ~= nil and Info.children ~= nil and Info.children[p] ~= nil and Info.children[p].id ~= nil then
        local childID = #Info.children[p].id > 2 and Info.children[p].id or Info.deviceId .. Info.children[p].id
        Send('{"context":{"child_ids":["' .. childID .. '"]},"system":{"set_relay_state":{"state":1}}}')
      end
    end
    Controls["Off"][p].EventHandler = function(ctrl)
      if Info.deviceId ~= nil and Info.children ~= nil and Info.children[p] ~= nil and Info.children[p].id ~= nil then
        local childID = #Info.children[p].id > 2 and Info.children[p].id or Info.deviceId .. Info.children[p].id
        Send('{"context":{"child_ids":["' .. childID .. '"]},"system":{"set_relay_state":{"state":0}}}')
      end
    end
    Controls["Toggle"][p].EventHandler = function(ctrl)
      if Info.deviceId ~= nil and Info.children ~= nil and Info.children[p] ~= nil and Info.children[p].id ~= nil then
        local childID = #Info.children[p].id > 2 and Info.children[p].id or Info.deviceId .. Info.children[p].id
        Send(
          '{"context":{"child_ids":["' ..
            childID .. '"]},"system":{"set_relay_state":{"state":' .. (ctrl.Boolean and 1 or 0) .. "}}}"
        )
      end
    end
    Controls["PlugName"][p].EventHandler = function(ctrl)
      if Info.deviceId ~= nil and Info.children ~= nil and Info.children[p] ~= nil and Info.children[p].id ~= nil then
        local childID = #Info.children[p].id > 2 and Info.children[p].id or Info.deviceId .. Info.children[p].id
        Send(
          '{"context":{"child_ids":["' .. childID .. '"]},"system":{"set_dev_alias":{"alias":"' .. ctrl.String .. '"}}}'
        )
      end
    end
  end
else -- single load
  Controls["On"].EventHandler = function(ctrl)
    Send('{ "system":{ "set_relay_state":{ "state":1 } } }')
  end
  Controls["Off"].EventHandler = function(ctrl)
    Send('{ "system":{ "set_relay_state":{ "state":0 } } }')
  end
  Controls["Toggle"].EventHandler = function(ctrl)
    Send('{ "system":{ "set_relay_state":{ "state":' .. (ctrl.Boolean and 1 or 0) .. " } } }")
  end
end
if DeviceType == "Dimmer" then
  Controls["Brightness"].EventHandler = function(ctrl)
    FaderDebounce:Stop()
    FaderDebounce:Start(0.1)
  end
  FaderDebounce.EventHandler = function()
    FaderDebounce:Stop()
    val = math.floor(Controls["Brightness"].Value)
    Send('{ "smartlife.iot.dimmer":{ "set_brightness":{ "brightness":' .. val .. " } } }")
  end
end

Controls["Name"].EventHandler = function(ctrl)
  Send('{ "system":{ "set_dev_alias":{ "alias":"' .. ctrl.String .. '" } } }')
end

function ClearVariables()
  if isStrip then
    for p = 1, Properties["Number Of Outputs"].Value do
      Controls["On"][p].Boolean = false
      Controls["Off"][p].Boolean = false
      Controls["Toggle"][p].Boolean = false
      Controls["PlugName"][p].String = ""
      if EnergyMonitoring then
        Controls["Voltage"][p].String = ""
        Controls["Current"][p].String = ""
        Controls["Power"][p].String = ""
      end
    end
  else
    Controls["On"].Boolean = false
    Controls["Off"].Boolean = false
    Controls["Toggle"].Boolean = false
    if DeviceType == "Dimmer" or DeviceType == "Light Strip" then
      Controls["Brightness"].Value = 0
    end
    if EnergyMonitoring then
      Controls["Voltage"].String = ""
      Controls["Current"].String = ""
      Controls["Power"].String = ""
    end
    if DeviceType == "Light Strip" then
      Controls.Hue.Value = 0
      Controls.Saturation.Value = 0
    end
  end
  Controls["Status"].Value = 3
  Controls["Status"].String = ""
  Controls["Name"].String = ""
  Controls["Model"].String = ""
  Controls["MACAddress"].String = ""
  Controls["DeviceFirmware"].String = ""
  Controls["Rssi"].String = ""
end

function DeviceConnect()
  local ip = Controls["IPAddress"].String
  PollTimer:Stop()
  Buffer = ""
  LastPacketErr = false
  Info = {}
  Energy = {}
  if ip ~= nil and ip ~= "" then
    Socket:Connect(ip, 9999)
  else
    ClearVariables()
    Controls["Status"].Value = 3 --not present
    Controls["Status"].String = "No IP Address"
  end
end
function DeviceDisconnect(index)
  PollTimer:Stop()
  Socket:Disconnect()
end
function DevicePoll()
  Send('{ "system":{ "get_sysinfo":null } }')

  if EnergyMonitoring and Info.feature ~= nil and Info.feature:find("ENE") then
    if isStrip then
      for p = 1, Properties["Number Of Outputs"].Value do
        if Info.children ~= nil and Info.children[p] ~= nil then
          local childID = #Info.children[p].id > 2 and Info.children[p].id or Info.deviceId .. Info.children[p].id
          Timer.CallAfter(
            function()
              Send('{"context":{"child_ids":["' .. childID .. '"]},"emeter":{"get_realtime":{}}}')
            end,
            (.1 * p)
          )
        end
      end
    else
      Timer.CallAfter(
        function()
          Send('{"emeter":{"get_realtime":{}}}')
        end,
        0.1
      )
    end
  end
end

function parseGetInfo(data)
  -- Device Info
  if data.alias then
    Controls["Name"].String = data.alias
    Info.alias = data.alias
  end
  if data.model then
    Controls["Model"].String = data.model
    Info.model = data.model
  end
  if data.mac then
    Controls["MACAddress"].String = data.mac
    Info.mac = data.mac
  elseif data.mic_mac then -- for light strips
    Controls["MACAddress"].String = data.mic_mac
    Info.mac = data.mic_mac
  end
  if data.sw_ver then
    Controls["DeviceFirmware"].String = data.hw_ver
    Info.sw_ver = data.sw_ver
  end
  if data.rssi then
    Controls["Rssi"].String = data.rssi
    Info.rssi = data.rssi
  end
  if data.feature then
    Info.feature = data.feature
  end
  if data.deviceId then
    Info.deviceId = data.deviceId
  end
  if data.children then
    Info.children = data.children
    if not isStrip then
      print("ERROR: Device " .. index .. " has children")
    end
  end
  if isStrip then
    if data.child_num > 0 and data.children then
      for _, child in ipairs(data.children) do
        childID = tonumber(child.id:sub(-2)) + 1
        if child.alias then
          Controls["PlugName"][childID].String = child.alias
        end
        if child.state then
          Controls["On"][childID].Boolean = child.state == 1
          Controls["Off"][childID].Boolean = child.state == 0
          Controls["Toggle"][childID].Boolean = child.state == 1
        end
      end
    end
  elseif DeviceType ~= "Light Strip" then
    if DeviceType == "Dimmer" then
      if data.brightness then
        Controls["Brightness"].Value = data.brightness
      end
    end
    if data.relay_state then
      Controls["On"].Boolean = data.relay_state == 1
      Controls["Off"].Boolean = data.relay_state == 0
      Controls["Toggle"].Boolean = data.relay_state == 1
    end
  else -- Light Strip
    --TODO: parse light strip info
  end
end
function parseEnergyInfo(data)
  if isStrip then
    local p = data.slot_id + 1
    if data.voltage_mv then
      Controls["Voltage"][p].String = data.voltage_mv / 1000 .. " V"
    end
    if data.current_ma then
      Controls["Current"][p].String = data.current_ma / 1000 .. " A"
    end
    if data.power_mw then
      Controls["Power"][p].String = data.power_mw / 1000 .. " W"
    end
  else
    if data.voltage_mv then
      Controls["Voltage"].String = data.voltage_mv / 1000 .. " V"
    end
    if data.current_ma then
      Controls["Current"].String = data.current_ma / 1000 .. " A"
    end
    if data.power_mw then
      Controls["Power"].String = data.power_mw / 1000 .. " W"
    end
  end
end

function Init()
  ClearVariables()
  DeviceConnect()
end

Init()
