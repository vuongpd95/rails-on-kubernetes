# Step by steps to run it yourself
1. [Install minikube](#running-minikube-on-development-env). And start it using:
```
minikube start --driver=docker
minikube dashboard
```
2. Build the docker container for the application. This is on local only, don't need to push to Docker Hub. The first command must be run for every new terminal that you open else the docker container built by the second command won't be seen by minikube
```
eval $(minikube -p minikube docker-env)
docker build -t vuongpd95/rails-on-kubernetes:0.1 .
```
3. Setup the application production secrets. We will use production env on minikube since we are building configurations for a production ready application
```
EDITOR=vi bundle exec rails credentials:edit -e production
```
The secret file should have this format
```yml
secret_key_base: "Use `rake secret` to get one"
rok_db:
  user: "rok_db_user"
  password: "your chosen password"
```
4. Upload the secrets to minikube
```
RAILS_ENV=production rake k8s:upload_secrets
```
5. Apply yml files to create services
```
kubectl apply -f k8s/load_balancer.yml
kubectl apply -f k8s/db_sc.yml
kubectl apply -f k8s/db_pv.yml
kubectl apply -f k8s/db_pvc.yml
kubectl apply -f k8s/db_service.yml
kubectl apply -f k8s/app.yml
```
6. Go to minikube dashboard, find the Load Balancer IP in the ingress section & access the application from your browser. You can check out the routes:
```
/
/secrets
/posts
```

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
Operate on minikube node
```
minikube ssh
// E.g. Remove persistence storage in host path
sudo su
rm -rf /mnt/data/*
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
// Create your own production credentials
// Use RAILS_ENV=production for your minikube cluster
RAILS_ENV=production rake k8s:upload_secrets
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
## Delete a pod
```
kubectl delete pod <NAME>
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
- [x] Configure yml file for the primary database
- [ ] Configure yml file for Redis cache
- [ ] Configure yml file for session storage using Redis
- [ ] Configure yml file for background job service
- [ ] Configure yml file for the search engine service using Elastic Search
- [ ] Configure yml file for logging service using ELK stack
- [ ] Configure SSL for the app
- [ ] Configure yml file for images service
- [ ] Handle compling & using assets for the application
- [ ] Add StimulusJS to the app (A good way to organize JS codes, make it independent from CSS classes & ID). For application with simple business logic, we don't need big libraries or frameworks (VueJS, ReactJS, etc.)
- [ ] Build a small UI component lib using TailwindCSS & view_component gem. By encapsulating TailwindCSS classes into component, we reduce CSS size & in turn, able to embed them directly as internal CSS which leads to improved perceived site performance. Plus, eliminating Turbolinks weakness of slow landing page

# What can be improved?
- [ ] Use namespace to manage resources (Don't know how to do this yet)
- [ ] Find a good way to organizing & using labels in Kubernetes
- [ ] Using StatefulSet to setup Posgresql DB is better than using Headless service?

# Visit later
- https://stacksoft.io/blog/postgres-statefulset/
