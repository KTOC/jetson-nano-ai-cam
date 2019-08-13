#/bin/bash 


today=`date +%Y-%m-%d.%H.%M.%S`

clear
/home/samson/skip_sudo.sh


##create mobile connections
#https://docs.ubuntu.com/core/en/stacks/network/network-manager/docs/configure-cellular-connections

sudo modem-manager.mmcli -L

sudo modem-manager.mmcli -m 0

sudo nmcli c delete mobile_network

sudo nmcli c add type gsm ifname ttyUSB1 con-name mobile_network apn internet

sudo nmcli r wwan on

sudo nmcli c modify mobile_network connection.autoconnect yes



##Create WiFi Hotspot connection
#https://gist.github.com/narate/d3f001c97e1c981a59f94cd76f041140

sudo nmcli c delete jetson_hotspot

#nmcli con add type wifi ifname wlan0 con-name jetson_hotspot autoconnect yes ssid jetson

sudo nmcli dev wifi hotspot ifname wlan0  con-name jetson_hotspot ssid jetson password "car1hkcar1hk"

sudo nmcli con modify jetson_hotspot 802-11-wireless.mode ap 802-11-wireless.band bg ipv4.method shared

#nmcli con modify jetson_hotspot wifi-sec.key-mgmt wpa-psk
#nmcli con modify jetson_hotspot wifi-sec.psk "car1hkcar1hk"
sudo nmcli con modify jetson_hotspot wifi.channel 11
sudo nmcli con modify jetson_hotspot ipv4.address 192.168.2.1/24
sudo nmcli con up jetson_hotspot
sudo nmcli c modify jetson_hotspot connection.autoconnect yes

systemctl NetworkManager restart

nmcli dev wifi list

#If after reboot nmcli con up Hotspot doesn't work
#Use this command instead to start Hotspot
#UUID=$(grep uuid /etc/NetworkManager/system-connections/Hotspot | cut -d= -f2)
#nmcli con up uuid $UUID