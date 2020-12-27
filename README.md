# Running MiniKube on Development Env

## Install on Debian
```
curl -LO https://storage.googleapis.com/minikube/releases/latest/minikube_latest_arm64.deb
sudo dpkg -i minikube_latest_arm64.deb
```
## Starting MiniKube

If we are running MiniKube using Docker driver, remember to add current user to docker group
```
sudo usermod -aG docker $USER
```
Start MiniKube using
```
minikube start --driver=docker
```
Open MiniKube Dashboard
```
minikube dashboard
```
Enable Ingress
```
minikube addons enable ingress
```
Enable Storage Provisioner
```
minikube addons enable storage-provisioner
kubectl get sc
```
# Build the docker image for app

## Build command
```
// If using MiniKube, before building the app image, run:
// eval $(minikube -p minikube docker-env)
docker build -t vuongpd95/rails-on-kubernetes:0.1 .
```
## Remove built image
```
docker image rm vuongpd95/rails-on-kubernetes:0.1
```
## Run the docker image
```
docker run -it --publish 3000:3000 vuongpd95/rails-on-kubernetes:0.1
```
## Push the image to docker hub
```
// Make sure your image is private
docker image push vuongpd95/rails-on-kubernetes:0.1
```
# Setup the app secrets
A rake task to upload secrets from credentials file to kubernetes is provided in `lib/tasks/k8s`
```
// To update rok-production-credentials k8s secret
rake k8s:upload_secrets
```

# Kubectl commands
## Apply a yaml file
```
kubectl apply -f k8s/app.yml
```
## Delete an applied yaml file
```
// Great for developing but don't do this on production
kubectl delete -f k8s/app.yml
```
## Debugging a pod
```
kubectl get pods -o wide
kubectl exec -it <NAME> -- bash
kubectl describe pods <NAME>
```
# TODOs
- [x] Configure yml file for the app while using local app container
- [x] Configure yml file for the load balancer
- [x] Rake task to handle syncing secrets between k8s & rails
- [ ] Configure yml file for the primary database
- [ ] Configure yml file for Redis cache
- [ ] Configure yml file for session storage using Redis
- [ ] Configure yml file for background job service
- [ ] Configure yml file for the search engine service using Elastic Search
- [ ] Configure yml file for logging service using ELK stack
- [ ] Configure SSL for the app
