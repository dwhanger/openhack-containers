# Create a namespace for your ingress resources
kubectl create namespace ingress-basic


helm repo add stable https://kubernetes-charts.storage.googleapis.com
helm repo update

# Use Helm to deploy an NGINX ingress controller
helm install  team6-nginx stable/nginx-ingress \
    --namespace ingress-basic \
    --set controller.replicaCount=2 \
    --set controller.nodeSelector."beta\.kubernetes\.io/os"=linux \
    --set defaultBackend.nodeSelector."beta\.kubernetes\.io/os"=linux


kubectl apply -f yaml/tripinsights-ingress-web-dev.yaml
kubectl apply -f yaml/tripinsights-ingress-api-dev.yaml