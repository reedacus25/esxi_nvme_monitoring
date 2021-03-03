##  Monitor your ESXi NVMe disks

This is a quick and dirty script and template to grab some quick statistics like percentage used and temperature, as well as some warning values, from NVMe disks inside an ESXi host.

These scripts require passwordless SSH access to your ESXi host in question, so make sure your ssh public key is loaded onto your ESXi host.

You also need to make sure you have the zabbix_sender package installed.

The way I architected the template file is PER DISK.
So you need to edit/import the template for each disk you are wanting to monitor.
The script will monitor all of the disks in one go.

In scripts and the templates, there are some variable that need to be set.
In the scripts you need to set:
* zabbixServer - this is the hostname or IP address of your Zabbix server or proxy
* zabbixName - this is the name of the host that the template is applied to in Zabbix
* yourESXiHost - this is your ESXi host to which you are SSHing to
* org - this is part of the zabbix key, I made the zabbix key using my org name to make it unique
 

In the template you need to set:
* device - this is the name of the device as listed by ESXi using `esxcli nvme device list`
* org - same as org above


Once you do a find and replace in the template for each device, and in the scripts, you just need to configure these scripts to run automatically, in crontab for instance.

There are two scripts, because one I only run once a day (slow) to monitor model/serial/firmware changes, while I run the other (fast) every hour to monitor wear/temperature/etc. You can set these intervals to whatever makes sense for you.

Hope this is helpful to someone out there.
