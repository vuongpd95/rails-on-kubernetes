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

# TODOs
- [ ] Configure yml file for the app while using local app container
- [ ] Configure yml file for the load balancer
- [ ] Configure yml file for Database for the app
- [ ] Configure yml file for Redis cache
- [ ] Configure yml file for the search engine using Elastic Search
- [ ] Configure yml file for logger engine with ELK
- [ ] Configure SSL for the app
