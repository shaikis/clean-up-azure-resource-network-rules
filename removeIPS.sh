#!/bin/bash

# login your azure account
az login --tenant 

# clean up storage accounts.
while read -r group;
do
 resource_group_name="echo $line |awk '{print $1}'"
 storage_account_name="echo $group |awk '{print $2}'"
 resource_type="echo $group |awk '{print $3}'"

 if [ "${resource_type}" == "storage"];
 then
    command="az storage account network-rule list --resource-group ${resource_group_name} --account-name ${storage_account_name} --query ipRules"
 elif [ "${resource_type}" == "vault"]; 
 then
    command="az keyvault network-rule"
 elif [ "${resource_type}" == "SQLserver"]; 
 then
    command = ""
 elif [ "${resource_type}" == "Synapse"]; 
 then
    command = ""
 else
    command = ""
 fi
 
 # get IP's from resource network rules.
 ${comamnd} |grep "ipAddressOrRange" > ${resource_type}_ips.txt

     while read -r ip;
     do
     ip_add="echo $ip |awk '{print $1}' "
      if [ "${resource_type}" == "storage"];
      then
       command="az storage account network-rule list --resource-group ${resource_group_name} --account-name ${storage_account_name} --query ipRules"
      elif [ "${resource_type}" == "vault"]; 
      then
       command="az keyvault network-rule"
      elif [ "${resource_type}" == "SQLserver"]; 
      then
       command = ""
      elif [ "${resource_type}" == "Synapse"]; 
      then
       command = ""
      else
        command = ""
      fi
    
    # remove the IP's from resource.
     ${command} remove --resource-group ${resource_group_name} --account-name $storage_account_name --ip-address ${ip_add}
     done < storage_ips.txt

done < resource.txt   

