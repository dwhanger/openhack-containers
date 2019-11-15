kubectl create -f https://raw.githubusercontent.com/Azure/kubernetes-keyvault-flexvol/master/deployment/kv-flexvol-installer.yaml

az vmss identity show -g MC_teamResources_myakscluster-6_westus2  -n aks-nodepool1-33767691-vmss -o yaml

az vmss identity assign -g MC_teamResources_myakscluster-6_westus2 -n aks-nodepool1-33767691-vmss
{
  "systemAssignedIdentity": "e77140a5-cf6d-4eb4-8273-18ab13d5cc23",
  "userAssignedIdentities": {}
}

# Create Key Vault
az keyvault create --name "team6-Vault" --resource-group "teamResources" --location westus2

# Add secrets to Key Vault
az keyvault secret set --vault-name "team6-Vault" --name "SQL-USER" --value "sqladminaUx6520"
az keyvault secret set --vault-name "team6-Vault" --name "SQL-PASSWORD" --value "lL1151Bm1"
az keyvault secret set --vault-name "team6-Vault" --name "SQL-SERVER" --value "sqlserveraux6520.database.windows.net"
az keyvault secret set --vault-name "team6-Vault" --name "SQL-DBNAME" --value "mydrivingDB"


# set policy to access keys in your Key Vault
az keyvault set-policy -n team6-Vault --key-permissions get --object-id e77140a5-cf6d-4eb4-8273-18ab13d5cc23

# set policy to access secrets in your Key Vault
az keyvault set-policy -n team6-Vault --secret-permissions get --object-id e77140a5-cf6d-4eb4-8273-18ab13d5cc23

# set policy to access certs in your Key Vault
az keyvault set-policy -n team6-Vault --certificate-permissions get --object-id e77140a5-cf6d-4eb4-8273-18ab13d5cc23