# clean-up-azure-resource-network-rules
In Azure cloud people are whitelising their IP's for each resource , during workFromHome , every day they are adding new IP to the resource network rules.
Here is the plan to remove the IP's every day. 

1) Take the resource details. 
2) get the IP's added
3) remove each IP address from the resoruce network rules
4) add approved IP's like app server IP, Vpn IP.e.tc
