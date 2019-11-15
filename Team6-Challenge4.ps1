
$myResourceGroup = "teamResources"
$myAKSCluster = "myakscluster-6"

$AKS_ID=$(az aks show `
    --resource-group ${myResourceGroup} `
    --name ${myAKSCluster} `
    --query id -o tsv)


$APPDEV_ID=$(az ad group create --display-name webdev --mail-nickname webdev --query objectId -o tsv)


az role assignment create `
  --assignee ${APPDEV_ID} `
  --role "Azure Kubernetes Service Cluster User Role" `
  --scope ${AKS_ID}


$APIDEV_ID=$(az ad group create --display-name apidev --mail-nickname apidev --query objectId -o tsv)


az role assignment create `
  --assignee $APIDEV_ID `
  --role "Azure Kubernetes Service Cluster User Role" `
  --scope ${AKS_ID}

