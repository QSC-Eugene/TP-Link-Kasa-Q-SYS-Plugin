-- On/Off --

Controls.On.EventHandler = function(ctrl)
  Controls.Toggle.Boolean = true
  SetLightState()
end
Controls.Off.EventHandler = function(ctrl)
  Controls.Toggle.Boolean = false
  SetLightState()
end
Controls.Toggle.EventHandler = function(ctrl)
  SetLightState()
end

-- Debounce --

debouncedControls = {
  -- Controls.TransitionTime,
  Controls.Brightness,
  Controls.Hue,
  Controls.Saturation
}
debounceTimers = {}

for i, ctrl in ipairs(debouncedControls) do
  debounceTimers[i] = Timer.New()
  debounceTimers[i].EventHandler = function()
    debounceTimers[i]:Stop()
    SetLightState()
  end
  ctrl.EventHandler = function()
    SendingCommand = true
    debounceTimers[i]:Stop()
    debounceTimers[i]:Start(0.1)
    UpdateColorPicker()
  end
end

-- Color Picker --

ColorPickerDebounce = Timer.New()
ColorPickerDebounce.EventHandler = function()
  ColorPickerDebounce:Stop()
  SetLightState()
end

ColorPickerFB = false

ColorPickerFBDebounce = Timer.New()
ColorPickerFBDebounce.EventHandler = function()
  ColorPickerFBDebounce:Stop()
  ColorPickerFB = false
end

-- Effects --

--[[ #include "LightEffects.lua" ]]
local EffectChoices = {""}
for k, v in pairs(Effects) do
  table.insert(EffectChoices, k)
end
table.sort(EffectChoices)
Controls.Effect.Choices = EffectChoices

Controls.Effect.EventHandler = function(ctrl)
  SetLightEffect(ctrl.String)
end