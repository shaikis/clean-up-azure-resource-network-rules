#!/bin/bash

# login your azure account
az login --tenant 

# clean up storage accounts.
while read -r group;
do
 resource_group_name="echo $line |awk ${print1}"
 storage_account_name="echo $group |awk ${print2}"
 resource_type="echo $group |awk ${print3}"

 if [ "${resource_type}" == "storage"];then
    command="az storage account network-rule"
 elif [ "${resource_type}" == "vault"]; then
    command="az keyvault network-rule"
 elif [ "${resource_type}" == "SQLserver"]; then
    command = ""
 elif [ "${resource_type}" == "Synapse"]; then
    command = ""
 else
    command = ""
 
 ${comamnd} list --resource-group ${resource_group_name} --account-name ${storage_account_name} >> ${resource_type}_ips.txt

     while read -r ip;
     do
     ip_add="echo $ip |awk ${print1}"
     ${command} remove --resource-group ${resource_group_name} --account-name $storage_account_name --ip-address ${ip_add} >> ${resource_type}_log.txt
     done << storage_ips.txt

done << resource.txt   

