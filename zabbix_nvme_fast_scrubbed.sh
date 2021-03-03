#!/bin/bash

#set zabbix server/proxy info
zabbixServer=yourZabbixServerOrProxyHere
zabbixName=yourMonitoredHostHere

for device in $(ssh root@yourESXiHost esxcli nvme device list | grep nvme | awk '{print $1}') ;
        do
                #get percentage used
                percentageUsed=$(ssh root@yourESXiHost esxcli nvme device log smart get -A=$device | grep "Percentage Used:" | awk -F ':' '{print $2}' | awk '{print $1}' | xargs)
                zabbixKey=$org.esxi.nvme.$device.percent_used
                zabbixValue=$percentageUsed
                /usr/bin/zabbix_sender -vv -z "$zabbixServer" -s "$zabbixName" -k "$zabbixKey" -o "$zabbixValue"

                #get composite temperature
                compositeTemperatureK=$(ssh root@yourESXiHost esxcli nvme device log smart get -A=$device | grep ":" | awk -F 'Composite Temperature:' '{print $2}' | awk '{print $1}' | xargs)
                zabbixKey=$org.esxi.nvme.$device.temp_composite
                #esxi presentes compositbe temperatre in Kelvin, rather than C, so I conver to C first)
                compositeTemperatureC=$(echo $compositeTemperatureK-273.15|bc)
                zabbixValue=$compositeTemperatureC
                /usr/bin/zabbix_sender -vv -z "$zabbixServer" -s "$zabbixName" -k "$zabbixKey" -o "$zabbixValue"

                #get temperature warning
                temperatureWarning=$(ssh root@yourESXiHost esxcli nvme device log smart get -A=$device | grep "Temperature Warning:" | awk -F ':' '{print $2}' | xargs)
                zabbixKey=$org.esxi.nvme.$device.temp_warn
                zabbixValue=$temperatureWarning
                /usr/bin/zabbix_sender -vv -z "$zabbixServer" -s "$zabbixName" -k "$zabbixKey" -o "$zabbixValue"

                #get reliabilitiy warning
                reliabilityWarning=$(ssh root@yourESXiHost esxcli nvme device log smart get -A=$device | grep "NVM Subsystem Reliability Degradation:" | awk -F ':' '{print $2}' | xargs)
                zabbixKey=$org.esxi.nvme.$device.reliability_warn
                zabbixValue=$reliabilityWarning
                /usr/bin/zabbix_sender -vv -z "$zabbixServer" -s "$zabbixName" -k "$zabbixKey" -o "$zabbixValue"

                #get read only warning
                readOnly=$(ssh root@yourESXiHost esxcli nvme device log smart get -A=$device | grep "Read Only Mode:" | awk -F ':' '{print $2}' | xargs)
                zabbixKey=$org.esxi.nvme.$device.ro_warn
                zabbixValue=$readOnly
                /usr/bin/zabbix_sender -vv -z "$zabbixServer" -s "$zabbixName" -k "$zabbixKey" -o "$zabbixValue"

                #get volatile memory warning
                volMem=$(ssh root@yourESXiHost esxcli nvme device log smart get -A=$device | grep "Volatile Memory Backup Device Failure:" | awk -F ':' '{print $2}' | xargs)
                zabbixKey=$org.esxi.nvme.$device.vol_mem_warn
                zabbixValue=$volMem
                /usr/bin/zabbix_sender -vv -z "$zabbixServer" -s "$zabbixName" -k "$zabbixKey" -o "$zabbixValue"

                #get media errors
                mediaErrors=$(ssh root@yourESXiHost esxcli nvme device log smart get -A=$device | grep "Media Errors:" | awk -F ':' '{print $2}' | xargs)
                zabbixKey=$org.esxi.nvme.$device.media_errors
                zabbixValue=$mediaErrors
                /usr/bin/zabbix_sender -vv -z "$zabbixServer" -s "$zabbixName" -k "$zabbixKey" -o "$zabbixValue"
        done