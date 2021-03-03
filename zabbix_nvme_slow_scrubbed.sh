#!/bin/bash

#set zabbix server/proxy info
zabbixServer=yourZabbixServerOrProxyHere
zabbixName=yourMonitoredHostHere

for device in $(ssh root@yourESXiHost esxcli nvme device list | grep nvme | awk '{print $1}') ;
        do
                #get model number
                modelNumber=$(ssh root@yourESXiHost esxcli nvme device get -A=$device | grep "Model Number:" | awk -F ':' '{print $2}' | xargs)
                zabbixKey=$org.esxi.nvme.$device.model
                zabbixValue=$modelNumber
                /usr/bin/zabbix_sender -vv -z "$zabbixServer" -s "$zabbixName" -k "$zabbixKey" -o "$zabbixValue"

                #get serial number
                serialNumber=$(ssh root@yourESXiHost esxcli nvme device get -A=$device | grep "Serial Number:" | awk -F ':' '{print $2}' | xargs)
                zabbixKey=$org.esxi.nvme.$device.serial
                zabbixValue=$serialNumber
                /usr/bin/zabbix_sender -vv -z "$zabbixServer" -s "$zabbixName" -k "$zabbixKey" -o "$zabbixValue"

                firmwareVersion=$(ssh root@yourESXiHost esxcli nvme device get -A=$device | grep "Firmware Revision:" | awk -F ':' '{print $2}' | xargs)
                zabbixKey=$org.esxi.nvme.$device.firmware
                zabbixValue=$firmwareVersion
                /usr/bin/zabbix_sender -vv -z "$zabbixServer" -s "$zabbixName" -k "$zabbixKey" -o "$zabbixValue"
        done