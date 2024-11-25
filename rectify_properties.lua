if props.plugin_show_debug.Value == false then 
  props["Debug Print"].IsHidden = true 
end
props["Energy Monitoring"].IsHidden = props["Device Type"].Value == "Dimmer" 
props["Number Of Outputs"].IsHidden = props["Device Type"].Value ~= "Power Strip"