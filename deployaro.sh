#/bin/bash

# ARO cluster variables
domain="arocluster"
vnetName="aroVnet"
vnetAdress=10.0.0.0/22
masterSubnet="aroMasterSubnet"
masterAdress=10.0.0.0/23
workerSubnet="aroWorkerSubnet"
workerAdress=10.0.2.0/23
aroResourceGroup="aro-rg"
location="westeurope"

# Subscription id, subscription name, and tenant id of the current subscription

subscriptionId=$(az account show --query id --output tsv)
subscriptionName=$(az account show --query name --output tsv)
tenantId=$(az account show --query tenantId --output tsv)

az account set --subscription $subscriptionId

while getopts "s:pux:d" arg; do
  case $arg in
    u)
      # Registering the necessary resource providers and features

      echo "Registering the necessary resource providers and features"

      az provider register --namespace 'Microsoft.RedHatOpenShift' --wait
      az provider register --namespace 'Microsoft.Compute' --wait
      az provider register --namespace 'Microsoft.Storage' --wait
      az provider register --namespace 'Microsoft.Authorization' --wait

      az feature register --namespace Microsoft.RedHatOpenShift --name preview

      #Creating resource group for the cluster
      echo ""
      echo "Creating the Resource Group"
      echo ""

      az group create --name $aroResourceGroup --location $location
      
      # creating the vnet, master subnet and worker subnet

      echo ""
      echo "Creating Networking"
      echo ""

      az network vnet create \
         --resource-group $aroResourceGroup \
         --name $vnetName \
         --address-prefixes $vnetAdress

      az network vnet subnet create \
         --resource-group $aroResourceGroup \
         --vnet-name $vnetName \
         --name $masterSubnet \
         --address-prefixes $masterAdress

      az network vnet subnet create \
         --resource-group $aroResourceGroup \
         --vnet-name $vnetName \
         --name $workerSubnet \
         --address-prefixes $workerAdress

      #creating the one and only Openshift Cluster

      echo ""
      echo "Creating the one and only Openshift Cluster"
      echo ""
      echo ""
      echo "Now this may take a while (up to 35min)"
      echo ""
      echo "Go and walk a bit, rest while you can fellow engineer!"
      echo ""

      az aro create \
         --resource-group $aroResourceGroup \
         --name $domain \
         --vnet $vnetName \
         --master-subnet $masterSubnet \
         --worker-subnet $workerSubnet \
      
      if [$? -ne 0];
      then
        echo ""
        echo "Something went wrong"
        echo ""
        echo "Deleting Resource Group and Exiting the script"
        az group delete -y -n $aroResourceGroup
        exit
      fi
	 
      echo ""
      echo "There you go"
      echo "================================================"
      echo "Here are the credentials"
      echo ""

      az aro list-credentials \
         --name $domain \
         --resource-group $aroResourceGroup
	 
      if [$? -ne 0];
      then
        echo ""
        echo "Something went wrong"
        echo ""
        echo "Check the status of your cluster"
	echo ""
        az aro list
	echo ""
	echo "If needed run ./deployaro.sh -d to restart again"
        exit
      fi
      
      echo ""
      echo "Login here in the console"
      echo ""

      az aro show \
         --name $domain \
         --resource-group $aroResourceGroup \
         --query "consoleProfile.url" -o tsv

      apiServer=$(az aro show -g $aroResourceGroup -n $domain --query apiserverProfile.url -o tsv)

      echo ""
      echo "Or be a geek and use the cli"
      echo "For the cli (oc) make sure you have it installed and then run the following command"
      echo ""
      echo "oc login $apiServer -u kubeadmin -p <kubeadmin password>"
      echo "have fun"
	 ;;
    p)
      # Registering the necessary resource providers and features

      echo "Registering the necessary resource providers and features"

      az provider register --namespace 'Microsoft.RedHatOpenShift' --wait
      az provider register --namespace 'Microsoft.Compute' --wait
      az provider register --namespace 'Microsoft.Storage' --wait
      az provider register --namespace 'Microsoft.Authorization' --wait

      az feature register --namespace Microsoft.RedHatOpenShift --name preview

      #Creating resource group for the cluster
      echo ""
      echo "Creating the Resource Group"
      echo ""

      az group create --name $aroResourceGroup --location $location

      # creating the vnet, master subnet and worker subnet

      echo ""
      echo "Creating Networking"
      echo ""

      az network vnet create \
         --resource-group $aroResourceGroup \
         --name $vnetName \
         --address-prefixes $vnetAdress

      az network vnet subnet create \
         --resource-group $aroResourceGroup \
         --vnet-name $vnetName \
         --name $masterSubnet \
         --address-prefixes $masterAdress

      az network vnet subnet create \
         --resource-group $aroResourceGroup \
         --vnet-name $vnetName \
         --name $workerSubnet \
         --address-prefixes $workerAdress

      #creating the one and only Openshift Cluster

      echo ""
      echo "Creating the one and only Openshift Cluster"
      echo ""
      echo ""
      echo "Now this may take a while (up to 35min)"
      echo ""
      echo "Go and walk a bit, rest while you can fellow engineer!"
      echo ""

      az aro create \
         --resource-group $aroResourceGroup \
         --name $domain \
         --vnet $vnetName \
         --master-subnet $masterSubnet \
         --worker-subnet $workerSubnet \
         --apiserver-visibility Private \
         --ingress-visibility Private

      if [$? -ne 0];
      then
        echo ""
        echo "Something went wrong"
        echo ""
        echo "Deleting Resource Group and Exiting the script"
        az group delete -y -n $aroResourceGroup
        exit
      fi

      echo ""
      echo "There you go"
      echo "================================================"
      echo "Here are the credentials"
      echo ""

      az aro list-credentials \
         --name $domain \
         --resource-group $aroResourceGroup
	 
      if [$? -ne 0];
      then
        echo ""
        echo "Something went wrong"
        echo ""
        echo "Check the status of your cluster"
	echo ""
        az aro list
	echo ""
	echo "If needed run ./deployaro.sh -d to restart again"
        exit
      fi
      echo ""
      echo "Login here in the console"
      echo ""

      az aro show \
         --name $domain \
         --resource-group $aroResourceGroup \
         --query "consoleProfile.url" -o tsv

      apiServer=$(az aro show -g $aroResourceGroup -n $domain --query apiserverProfile.url -o tsv)

      echo ""
      echo "Or be a geek and use the cli"
      echo "For the cli (oc) make sure you have it installed and then run the following command"
      echo ""
      echo "oc login $apiServer -u kubeadmin -p <kubeadmin password>"
      echo "have fun"
      ;;
    s) # Specify strength, either 45 or 90.
      secretPath=${OPTARG}
      # Registering the necessary resource providers and features

      echo "Registering the necessary resource providers and features"

      az provider register --namespace 'Microsoft.RedHatOpenShift' --wait
      az provider register --namespace 'Microsoft.Compute' --wait
      az provider register --namespace 'Microsoft.Storage' --wait
      az provider register --namespace 'Microsoft.Authorization' --wait

      az feature register --namespace Microsoft.RedHatOpenShift --name preview

      #Creating resource group for the cluster
      echo ""
      echo "Creating the Resource Group"
      echo ""

      az group create --name $aroResourceGroup --location $location

      # creating the vnet, master subnet and worker subnet

      echo ""
      echo "Creating Networking"
      echo ""

      az network vnet create \
         --resource-group $aroResourceGroup \
         --name $vnetName \
         --address-prefixes $vnetAdress

      az network vnet subnet create \
         --resource-group $aroResourceGroup \
         --vnet-name $vnetName \
         --name $masterSubnet \
         --address-prefixes $masterAdress

      az network vnet subnet create \
         --resource-group $aroResourceGroup \
         --vnet-name $vnetName \
         --name $workerSubnet \
         --address-prefixes $workerAdress

      #creating the one and only Openshift Cluster


      echo ""
      echo "Creating the one and only Openshift Cluster"
      echo ""
      echo ""
      echo "Now this may take a while (up to 35min)"
      echo ""
      echo "Go and walk a bit, rest while you can fellow engineer!"
      echo ""

      az aro create \
         --resource-group $aroResourceGroup \
         --name $domain \
	 --vnet $vnetName \
         --master-subnet $masterSubnet \
         --worker-subnet $workerSubnet \
         --pull-secret @$secretPath \
     
      if [$? -ne 0];
      then
        echo ""
	echo "Something went wrong"
	echo ""
	echo "Deleting Resource Group and Exiting the script"
	az group delete -y -n $aroResourceGroup
	exit
      fi

      echo ""
      echo "There you go"
      echo "================================================"
      echo "Here are the credentials"
      echo ""

      az aro list-credentials \
         --name $domain \
         --resource-group $aroResourceGroup
	 
      if [$? -ne 0];
      then
        echo ""
        echo "Something went wrong"
        echo ""
        echo "Check the status of your cluster"
	echo ""
        az aro list
	echo ""
	echo "If needed run ./deployaro.sh -d to restart again"
        exit
      fi

      echo ""
      echo "Login here in the console"
      echo ""

      az aro show \
         --name $domain \
         --resource-group $aroResourceGroup \
         --query "consoleProfile.url" -o tsv

      apiServer=$(az aro show -g $aroResourceGroup -n $domain --query apiserverProfile.url -o tsv)

      echo ""
      echo "Or be a geek and use the cli"
      echo "For the cli (oc) make sure you have it installed and then run the following command"
      echo ""
      echo "oc login $apiServer -u kubeadmin -p <kubeadmin password>"
      echo "have fun"
      ;;
    x)
      secretPath=${OPTARG}
     
      # Registering the necessary resource providers and features

      echo "Registering the necessary resource providers and features"

      az provider register --namespace 'Microsoft.RedHatOpenShift' --wait
      az provider register --namespace 'Microsoft.Compute' --wait
      az provider register --namespace 'Microsoft.Storage' --wait
      az provider register --namespace 'Microsoft.Authorization' --wait

      az feature register --namespace Microsoft.RedHatOpenShift --name preview

            #Creating resource group for the cluster
      echo ""
      echo "Creating the Resource Group"
      echo ""

      az group create --name $aroResourceGroup --location $location

      # creating the vnet, master subnet and worker subnet

      echo ""
      echo "Creating Networking"
      echo ""

      az network vnet create \
         --resource-group $aroResourceGroup \
         --name $vnetName \
         --address-prefixes $vnetAdress

      az network vnet subnet create \
         --resource-group $aroResourceGroup \
         --vnet-name $vnetName \
         --name $masterSubnet \
         --address-prefixes $masterAdress

      az network vnet subnet create \
         --resource-group $aroResourceGroup \
         --vnet-name $vnetName \
         --name $workerSubnet \
         --address-prefixes $workerAdress

      #creating the one and only Openshift Cluster


      echo ""
      echo "Creating the one and only Openshift Cluster"
      echo ""
      echo ""
      echo "Now this may take a while (up to 35min)"
      echo ""
      echo "Go and walk a bit, rest while you can fellow engineer!"
      echo ""

      az aro create \
         --resource-group $aroResourceGroup \
         --name $domain \
         --vnet $vnetName \
         --master-subnet $masterSubnet \
         --worker-subnet $workerSubnet \
         --pull-secret @$secretPath \
         --apiserver-visibility Private \
         --ingress-visibility Private
      
      if [$? -ne 0];
      then
        echo ""
        echo "Something went wrong"
        echo ""
        echo "Deleting Resource Group and Exiting the script"
        az group delete -y -n $aroResourceGroup
        exit
      fi

      echo ""
      echo "There you go"
      echo "================================================"
      echo "Here are the credentials"
      echo ""

      az aro list-credentials \
         --name $domain \
         --resource-group $aroResourceGroup
	 
      if [$? -ne 0];
      then
        echo ""
        echo "Something went wrong"
        echo ""
        echo "Check the status of your cluster"
	echo ""
        az aro list
	echo ""
	echo "If needed run ./deployaro.sh -d to restart again"
        exit
      fi
      
      echo ""
      echo "Login here in the console"
      echo ""

      az aro show \
         --name $domain \
         --resource-group $aroResourceGroup \
         --query "consoleProfile.url" -o tsv

      apiServer=$(az aro show -g $aroResourceGroup -n $domain --query apiserverProfile.url -o tsv)

      echo ""
      echo "Or be a geek and use the cli"
      echo "For the cli (oc) make sure you have it installed and then run the following command"
      echo ""
      echo "oc login $apiServer -u kubeadmin -p <kubeadmin password>"
      echo "have fun"
       ;;
    d)
      echo "You are about to delete the cluster and its resource group"
      az aro delete --name $domain --resource-group $aroResourceGroup

      az group delete -y -n $aroResourceGroup
       ;;
  esac
done

if [ $OPTIND -eq 1 ]
then	
	echo "Make sure you have already used az login, then you can run the script like this:"
	echo "- Create cluster => ./deployaro.sh -u (uncomplicated)"
	echo "- Delete cluster (cleanup) => ./deployaro.sh -d"
        echo "- Create cluster with pull secret => ./deployaro.sh -s pathToSecret"
        echo "- Create private cluster => ./deployaro.sh -p"
	echo "- Create private cluster with pull secret => ./deployaro.sh -x pathToSecret" 
fi
