local DiscoveredDevices = {}

function RenderDiscoveredDevices()
  Controls["Discovered Devices"].String = ""
  local toPrint = ""
  for _, device in pairs(DiscoveredDevices) do
    toPrint = toPrint..device.alias.."["..device.model.."] - "..device.ip.."\n"
  end
  Controls["Discovered Devices"].String = toPrint
end

DiscoverySocket = UdpSocket.New()
DiscoverySocket.EventHandler = function(socket, packet)  
  data = decode(packet.Data,true)
  if data.system.get_sysinfo.alias then 
    print(decodeToString(packet.Data,true))
    print(data.system.get_sysinfo.alias.."["..data.system.get_sysinfo.model.."] - "..packet.Address)
    local mac = data.system.get_sysinfo.mac and data.system.get_sysinfo.mac or data.system.get_sysinfo.mic_mac -- support light strips
    if DiscoveredDevices[mac] == nil then
      DiscoveredDevices[mac] = {}
    end
    DiscoveredDevices[mac].alias = data.system.get_sysinfo.alias
    DiscoveredDevices[mac].model = data.system.get_sysinfo.model
    DiscoveredDevices[mac].ip = packet.Address
  end 
  RenderDiscoveredDevices()
end 


Controls.Discover.EventHandler = function()
  DiscoverySocket:Open("",9999)
  print("Sending Discovery packet")
  DiscoveredDevices = {}
  RenderDiscoveredDevices()
  if System.IsEmulating then
    DiscoverySocket:Send("255.255.255.255",9999,"\xd0\xf2\x81\xf8\x8b\xff\x9a\xf7\xd5\xef\x94\xb6\xd1\xb4\xc0\x9f\xec\x95\xe6\x8f\xe1\x87\xe8\xca\xf0\x8b\xf6\x8b\xf6")
  else
    for _,interface in pairs(Network.Interfaces()) do 
      DiscoverySocket:Send(interface.BroadcastAddress,9999,"\xd0\xf2\x81\xf8\x8b\xff\x9a\xf7\xd5\xef\x94\xb6\xd1\xb4\xc0\x9f\xec\x95\xe6\x8f\xe1\x87\xe8\xca\xf0\x8b\xf6\x8b\xf6")
    end 
  end
  Timer.CallAfter(function()
    DiscoverySocket:Close()
  end, 5
    )
end 