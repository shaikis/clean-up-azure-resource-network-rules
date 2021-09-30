#!/bin/bash

# login your azure account
az login --tenant <tenant id> # this is not required if you build from azure devops pipeline az cli
az account set --subscription <subscription id>  # this is not required if you build from azure devops pipeline az cli

# clean up storage accounts.
while read -r group;
do
 resource_group_name="echo $line |awk '{print $1}'"
 resource_name="echo $group |awk '{print $2}'"
 resource_type="echo $group |awk '{print $3}'"

 if [ "${resource_type}" == "storage"];
 then
    command="az storage account network-rule list --resource-group ${resource_group_name} --account-name ${resource_name} --query ipRules"
 elif [ "${resource_type}" == "vault"]; 
 then
    command="az keyvault network-rule list --name ${resource_name} --resource-group ${resource_group_name}"
 elif [ "${resource_type}" == "SQLserver"]; 
 then
    command = "az sql server firewall-rule list -g ${resource_group} -s ${resource_name}"
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
       command="az storage account network-rule remove --resource-group ${resource_group_name} --account-name ${resource_name} --ip-address ${ip_add}"
      elif [ "${resource_type}" == "vault"]; 
      then
       command="az keyvault network-rule remove --name ${resource_name} --ip-address ${ip_add}/32"
      elif [ "${resource_type}" == "SQLserver"]; 
      then
       command = "az sql server firewall-rule delete"
      elif [ "${resource_type}" == "Synapse"]; 
      then
       command = ""
      else
        command = ""
      fi
    
    # remove the IP's from resource.
     ${command}
    #
     done < storage_ips.txt

done < resource.txt   

