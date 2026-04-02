CurrentPickerString = Controls.ColorPicker and Controls.ColorPicker.String or ""

function Unsubscribe(compName)
  local comp = Component.New(compName)
  if comp and comp["hsv.hue"] then
    for _, ctrl in pairs(comp) do
      if ctrl.EventHandler then
        ctrl.EventHandler = nil
      end
    end
  end
end

function GetColorPickers()
  local choices = {""}
  for _, comp in pairs(Component.GetComponents()) do
    if comp.Type == "color_picker" then
      table.insert(choices, comp.ID)
    end
  end
  Controls.ColorPicker.Choices = choices
end

function LinkColorPicker()
  Unsubscribe(CurrentPickerString)
  CurrentPickerString = Controls.ColorPicker.String
  local ColorPicker = Component.New(Controls.ColorPicker.String)
  if ColorPicker then
    if ColorPicker["hsv.hue"] then
      ColorPicker["hsv.hue"].EventHandler = function(ctrl)
        if not ColorPickerFB then
          -- print("hue:" .. ctrl.Value)
          Controls.Hue.Value = ctrl.Value
          ColorPickerTick()
        end
      end
    end
    if ColorPicker["hsv.saturation"] then
      ColorPicker["hsv.saturation"].EventHandler = function(ctrl)
        if not ColorPickerFB then
          -- print("saturation:" .. ctrl.Value)
          Controls.Saturation.Value = ctrl.Value
          ColorPickerTick()
        end
      end
    end
    if ColorPicker["hsv.value"] then
      ColorPicker["hsv.value"].EventHandler = function(ctrl)
        if not ColorPickerFB then
          -- print("value:" .. ctrl.Value)
          Controls.Brightness.Value = ctrl.Value
          ColorPickerTick()
        end
      end
    end
    UpdateColorPicker()
  else
    print("Picker does not exist: " .. Controls.ColorPicker.String)
  end
end

function ColorPickerTick()
  SendingCommand = true
  ColorPickerDebounce:Stop()
  ColorPickerDebounce:Start(0.1)
end

function ColorPickerFBTick()
  ColorPickerFB = true
  ColorPickerFBDebounce:Stop()
  ColorPickerFBDebounce:Start(0.2)
end

function UpdateColorPicker()
  local ColorPicker = Component.New(Controls.ColorPicker.String)
  if ColorPicker and ColorPicker["hsv.hue"] then
    if
      ColorPicker["hsv.hue"].Value ~= Controls.Hue.Value or
        ColorPicker["hsv.saturation"].Value ~= Controls.Saturation.Value or
        ColorPicker["hsv.value"].Value ~= Controls.Brightness.Value
     then
      ColorPicker["hsv.hue"].Value = Controls.Hue.Value
      ColorPicker["hsv.saturation"].Value = Controls.Saturation.Value
      ColorPicker["hsv.value"].Value = Controls.Brightness.Value
      ColorPickerFBTick()
    end
  end
end
