$myResourceGroup = "teamResources"
$aksname="myakscluster-6"
$subnetId="/subscriptions/3a859018-0a49-43f0-91f1-d33864d28a24/resourceGroups/teamResources/providers/Microsoft.Network/virtualNetworks/vnet/subnets/akscluster"



# Create the Azure AD application
$serverApplicationId=$(az ad app create `
    --display-name "${aksname}Server" `
    --identifier-uris "https://${aksname}Server" `
    --query appId -o tsv)

# Update the application group memebership claims
az ad app update --id $serverApplicationId --set groupMembershipClaims=All

# Create a service principal for the Azure AD application
az ad sp create --id $serverApplicationId

# Get the service principal secret
$serverApplicationSecret=$(az ad sp credential reset `
    --name $serverApplicationId `
    --credential-description "AKSPassword" `
    --query password -o tsv)

#Lunch Break
az ad app permission add `
    --id $serverApplicationId `
    --api 00000003-0000-0000-c000-000000000000 `
    --api-permissions e1fe6dd8-ba31-4d61-89e7-88639da4683d=Scope 06da0dbc-49e2-44d2-8312-53f166ab848a=Scope 7ab1d382-f21e-4acd-a863-ba3e13f7da61=Role
	

az ad app permission grant --id $serverApplicationId --api 00000003-0000-0000-c000-000000000000
az ad app permission admin-consent --id  $serverApplicationId

$clientApplicationId=$(az ad app create `
    --display-name "${aksname}Client" `
    --native-app `
    --reply-urls "https://${aksname}Client" `
    --query appId -o tsv)
	
az ad sp create --id $clientApplicationId
	
$oAuthPermissionId=$(az ad app show --id $serverApplicationId --query "oauth2Permissions[0].id" -o tsv)

az ad app permission add --id $clientApplicationId --api $serverApplicationId --api-permissions $oAuthPermissionId=Scope
az ad app permission grant --id $clientApplicationId --api $serverApplicationId


$tenantId=$(az account show --query tenantId -o tsv)
	
az ad signed-in-user show --query userPrincipalName -o tsv

az network vnet subnet list `
    --resource-group $myResourceGroup `
    --vnet-name vnet `
    --query "[0].id" --output tsv

#Create Service Principal for AKS w/ Network Perms
az ad sp create-for-rbac -n "AKS-ServicePrincipal" --role "Network Contributor" `
    --scopes /subscriptions/3a859018-0a49-43f0-91f1-d33864d28a24/resourceGroups/teamResources/providers/Microsoft.Network/virtualNetworks/vnet

#Get appId and clientSecret from above
Creating a role assignment under the scope of "/subscriptions/3a859018-0a49-43f0-91f1-d33864d28a24/resourceGroups/teamResources/providers/Microsoft.Network/virtualNetworks/vnet"
{
  "appId": "8c61572e-22f1-4eb4-8060-aa79d5086159",
  "displayName": "AKS-ServicePrincipal",
  "name": "http://AKS-ServicePrincipal",
  "password": "06383513-0dc2-4bba-95ac-5e059c6eaef3",
  "tenant": "2a6a5f9f-9417-4343-9763-423413558884"
}
     
#az aks get versions. Add 1.15.5

az aks create `
    --resource-group $myResourceGroup `
    --name $aksname `
    --network-plugin azure `
    --vnet-subnet-id $subnetId `
    --docker-bridge-address 172.17.0.1/16 `
    --dns-service-ip 10.2.4.10 `
    --service-cidr 10.2.4.0/24 `
    --generate-ssh-keys `
	--node-count 3 `
    --aad-server-app-id $serverApplicationId `
    --aad-server-app-secret $serverApplicationSecret `
    --aad-client-app-id $clientApplicationId `
    --aad-tenant-id $tenantId `
	--attach-acr registryaUx6520 `
	--kubernetes-version 1.15.5 `
	--service-principal 8c61572e-22f1-4eb4-8060-aa79d5086159 `
    --client-secret 06383513-0dc2-4bba-95ac-5e059c6eaef3

	
	
az aks get-credentials --resource-group $myResourceGroup --name $aksname --admin





#Adding RBAC Access to AKS
# Get the resource ID of your AKS cluster
AKS_CLUSTER=$(az aks show --resource-group myResourceGroup --name myAKSCluster --query id -o tsv)

# Get the account credentials for the logged in user
ACCOUNT_UPN=$(az account show --query user.name -o tsv)
ACCOUNT_ID=$(az ad user show --upn-or-object-id $ACCOUNT_UPN --query objectId -o tsv)

# Assign the 'Cluster Admin' role to the user
az role assignment create `
    --assignee $ACCOUNT_ID `
    --scope $AKS_CLUSTER `
    --role "Azure Kubernetes Service Cluster Admin Role"
	
	

	
	