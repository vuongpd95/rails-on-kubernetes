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

# Kubectl commands
## Apply a yaml file
```
kubectl apply -f kube/app.yml
```
## Delete an applied yaml file
```
kubectl delete -f kube/app.yml
```

# TODOs
- [ ] Configure yml file for the app while using local app container
- [ ] Configure yml file for the load balancer
- [ ] Configure yml file for Database for the app
- [ ] Configure yml file for Redis cache
- [ ] Configure yml file for the search engine using Elastic Search
- [ ] Configure yml file for logger engine with ELK
- [ ] Configure SSL for the app
