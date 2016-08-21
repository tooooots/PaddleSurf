#PaddleSurf

###Description:

Sample setup of a Ruby app with Sinatra/Thin connecting to a Redis backend using Docker and Kubernetes on GCE.
Loadbalancing is done with k8s Service, discovery with kube-dns.

###Usage

#####Docker Images

- install [Docker](https://docs.docker.com/engine/installation/linux/)
- build the Docker images using the command in the comment of each [Dockerfile](docker)

#####Google Cloud infra

- Go to Google Cloud website and create a new project

- retag our Docker images to publish them to the Google Cloud registry
```bash
$ sudo docker tag app eu.gcr.io/paddlesurf-XXXX/app:v1
$ sudo docker tag redis eu.gcr.io/paddlesurf-XXXX/redis:v1
```

- install [Google Cloud SDK](https://dl.google.com/dl/cloudsdk/channels/rapid/downloads/google-cloud-sdk-122.0.0-linux-x86_64.tar.gz) and kubectl
```bash
$ ./google-cloud-sdk/install.sh
$ gcloud init
$ gcloud components install kubectl
```

- We can then create our container infrastructure using the SDK:
It will create a kubernetes cluster (Debian hosts, Google images)
```bash
$ gcloud container clusters create paddlesurf
$ gcloud container clusters get-credentials paddlesurf \
  --zone europe-west1-d --project <projectid>
```

After creating the cluster, you should get the output of: `gcloud container clusters list`

>#####Terraform variant :
This is more complex and only useful if we need to manage more services than just the container cluster...
- install [terraform](https://www.terraform.io/intro/getting-started/install.html)
- create infra using terraform:
- export your Google Cloud credentials (json file):
`$ export GOOGLE_CREDENTIALS=<string>`
- modify your project name in `terraform/paddlesurf_k8_gce.tf`
- launch terraform:
`$ terraform plan`
`$ terraform apply`
- get the endpoint url:
`$ terraform show`
We can now test the URL with `curl -kv https://1.2.3.4`


#####Push docker images
```bash
$ gcloud docker push eu.gcr.io/paddlesurf-XXXX/app:v1
$ gcloud docker push eu.gcr.io/paddlesurf-XXXX/redis:v1
```

#####Create the kubernetes services:
we have one yaml config for each service (k/v store database and app).
Each yaml contain a Service definition, either:
- internal port-based: Services map a port on each cluster node to ports on one or more pods.
-  loadbalancer: Clients connect to the external IP address, which forwards to app pod.
```bash
$ kubectl create -f k8s/redis.yaml
$ kubectl create -f k8s/app.yaml
$ kubectl get services
NAME         CLUSTER-IP    EXTERNAL-IP   PORT(S)    AGE
app          10.3.255.86   1.2.3.4       4567/TCP   1m
kubernetes   10.3.240.1    <none>        443/TCP    6h
redis        10.3.242.37   <nodes>       6379/TCP   1m
$ kubectl get pods
$ kubectl get deployments
$ kubectl get ep app
NAME      ENDPOINTS                     AGE
app       10.0.0.4:4567,10.0.1.6:4567   1m
```
You can use `kubectl logs <pod>` to see the output or `kubectl describe pods`
Or connect to your kubernetes cluster webUI directly:
```bash
$ gcloud container clusters get-credentials paddlesurf \
  --zone europe-west1-d --project paddlesurf-XXXX
$ kubectl proxy
$ open http://localhost:8001/ui
```
The application connects to redis using *redis* host populated with the *REDIS_HOST* env variable, using kube-dns.

###Access our application

- Get the external IP address and port of our loadbalanced application:
```bash$ kubectl get services app
NAME         CLUSTER-IP    EXTERNAL-IP   PORT(S)    AGE
app          10.3.255.86   1.2.3.4       4567/TCP   1m
```
and connect using `curl http://1.2.3.4:4567`.

