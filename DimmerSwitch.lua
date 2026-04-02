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
FaderDebounce = Timer.New()
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