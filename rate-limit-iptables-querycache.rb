#Path to iptables
iptables = 'sudo /sbin/iptables'
#Servers we want to enter in to the firewall
servers = [
          {:ip => '80.84.250.224',
          :ports => [ 27015, 27020, 27025, 27030, 27045, 27050, 27100, 27101, 27102, 27103, 27104, 27105, 27105, 27106, 27107, 27108, 27109, 27110 ]},
          {:ip => '83.96.144.5',
          :ports => [ 27035, 27040 ]}
          ]
#clear old stuff
`killall querycache`
`#{iptables} -t nat -F`
`#{iptables} -F`

### default rule for established connections
`#{iptables} -A OUTPUT -m state --state established,related -j ACCEPT`
`#{iptables} -A INPUT -m state --state established,related -j ACCEPT`
##
### put ips you want to allow bypassing all these rules here
`#{iptables} -A INPUT -s ariekanarie.nl       -j ACCEPT`
`#{iptables} -A INPUT -s vdsl.ariekanarie.nl  -j ACCEPT`
##
### local connections
`#{iptables} -A INPUT -s 127.0.0.1 -j ACCEPT`
#
#
servers.each do |server|
  ip = server[:ip]
  server[:ports].each do |port|
    querycache_port = port + 1000
    `#{iptables} -t nat -A PREROUTING -p udp -d #{ip} --dport #{port} -m string --algo bm --hex-string '|ffffffff54|' -j REDIRECT --to-port #{querycache_port}`
    `#{iptables} -A INPUT -p udp -m udp --dport #{port} -m string --algo bm --hex-string '|ffffffff|' -m limit --limit 50/s --limit-burst 50 -j ACCEPT`
    `#{iptables} -A INPUT -p udp -m udp --dport #{port} -m string --algo bm --hex-string '|ffffffff|' -m limit --limit 1/s  --limit-burst 1 -j ULOG --ulog-nlgroup 1 --ulog-prefix \"SOURCE UDP FLOOD #{port}\"`
    `#{iptables} -A INPUT -p udp -m udp --dport #{port} -m string --algo bm --hex-string '|ffffffff|' -j DROP`
    `screen -AmdS q-#{port} querycache #{querycache_port} #{ip} #{port}`
  end
end
