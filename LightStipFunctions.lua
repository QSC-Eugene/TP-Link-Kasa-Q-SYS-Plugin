function ParseLightState(data)
  -- print(rapidjson.encode(data))
  if data.transition then
    Controls.TransitionTime.Value = data.transition
  end
  if data.on_off then
    Controls.On.Boolean = data.on_off == 1
    Controls.Off.Boolean = data.on_off == 0
    Controls.Toggle.Boolean = data.on_off == 1
  end
  if data.dft_on_state then
    local state = data.dft_on_state
    if state.hue then
      Controls.Hue.Value = state.hue
    end
    if state.saturation then
      Controls.Saturation.Value = state.saturation
    end
    if state.brightness then
      Controls.Brightness.Value = state.brightness
    end
  else
    if data.hue then
      Controls.Hue.Value = data.hue
    end
    if data.saturation then
      Controls.Saturation.Value = data.saturation
    end
    if data.brightness then
      Controls.Brightness.Value = data.brightness
    end
  end

  UpdateColorPicker()
end

function SetLightState()
  local toSend = {}
  toSend["smartlife.iot.lightStrip"] = {}
  toSend["smartlife.iot.lightStrip"].set_light_state = {}
  toSend["smartlife.iot.lightStrip"].set_light_state.brightness = math.floor(Controls.Brightness.Value)
  toSend["smartlife.iot.lightStrip"].set_light_state.on_off = math.floor(Controls.Toggle.Value)
  toSend["smartlife.iot.lightStrip"].set_light_state.transition = math.floor(Controls.TransitionTime.Value)
  toSend["smartlife.iot.lightStrip"].set_light_state.hue = math.floor(Controls.Hue.Value)
  toSend["smartlife.iot.lightStrip"].set_light_state.saturation = math.floor(Controls.Saturation.Value)
  Send(rapidjson.encode(toSend))
  SendingCommand = false
end

function SetLightStateOnOff()
local toSend = {}
toSend["smartlife.iot.lightStrip"] = {}
toSend["smartlife.iot.lightStrip"].set_light_state = {}
-- toSend["smartlife.iot.lightStrip"].set_light_state.brightness = math.floor(Controls.Brightness.Value)
toSend["smartlife.iot.lightStrip"].set_light_state.on_off = math.floor(Controls.Toggle.Value)
-- toSend["smartlife.iot.lightStrip"].set_light_state.transition = math.floor(Controls.TransitionTime.Value)
-- toSend["smartlife.iot.lightStrip"].set_light_state.hue = math.floor(Controls.Hue.Value)
-- toSend["smartlife.iot.lightStrip"].set_light_state.saturation = math.floor(Controls.Saturation.Value)
Send(rapidjson.encode(toSend))
SendingCommand = false
end
function SetLightBrightness()
local toSend = {}
toSend["smartlife.iot.lightStrip"] = {}
toSend["smartlife.iot.lightStrip"].set_light_state = {}
toSend["smartlife.iot.lightStrip"].set_light_state.brightness = math.floor(Controls.Brightness.Value)
-- toSend["smartlife.iot.lightStrip"].set_light_state.on_off = math.floor(Controls.Toggle.Value)
-- toSend["smartlife.iot.lightStrip"].set_light_state.transition = math.floor(Controls.TransitionTime.Value)
-- toSend["smartlife.iot.lightStrip"].set_light_state.hue = math.floor(Controls.Hue.Value)
-- toSend["smartlife.iot.lightStrip"].set_light_state.saturation = math.floor(Controls.Saturation.Value)
Send(rapidjson.encode(toSend))
SendingCommand = false
end
function SetLightEffect(effectIndex)
  if effectIndex and Effects[effectIndex] then
    Send('{"smartlife.iot.lighting_effect":{"set_lighting_effect":'..Effects[effectIndex]..'}}')
  end
end

function ParseLightEffect(data)
  -- print(rapidjson.encode(data))
  --TODO
end
