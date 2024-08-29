helm repo add stakater https://stakater.github.io/stakater-charts
helm repo update
helm install stakater/reloader
helm install stakater/reloader --set reloader.watchGlobally=false --namespace ns-windows-management
 --generate-name