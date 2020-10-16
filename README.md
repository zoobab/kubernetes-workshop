[![noswpatv3](http://zoobab.wdfiles.com/local--files/start/noupcv3.jpg)](https://ffii.org/donate-now-to-save-europe-from-software-patents-says-ffii/)
# Kubernetes workshop

Examples for the Kubernetes workshop originally located at:

http://www.zoobab.com/kubernetes-workshop

This workshop was given multiple times at:

* Meetup Docker Belgium in Brussels: https://www.meetup.com/Docker-Belgium/events/240356311/
* Meetup Docker Belgium in Ghent: https://www.meetup.com/Docker-Belgium/events/240475061/
* SHA2017 in Zeewolde (2 days): https://wiki.sha2017.org/w/Session:KubernetesDockerClusterWorkshop
* Software Freedom Day at HSBXL in Brussels: https://hsbxl.be/Software_Freedom_Day_2017
* Video log of the Ghent event by Thijs Feryn: https://www.youtube.com/watch?v=y4tbQCFj7Ps
* Some tech companies

# Support

If you are looking for Kubernetes consulting or training services, you can contact me at zoobab AT gmail.com.

# K8S architecture

Explain here the typical K8S architecture.

![k8s arch](http://blog.arungupta.me/wp-content/uploads/2015/01/kubernetes-key-concepts.png)

Machines:
* Etcd (not shown in the diagram)
* Master
* Minion

Concepts:
* namespaces
* pod
* kubeket
* kubeproxy
* pausecontainer
* secrets

# Install kubeadm-dind-cluster AND/OR minikube

## Install kubeadm-dind (linux)

We gonna use [https://github.com/Mirantis/kubeadm-dind-cluster kubeadm-dind-cluster], which is simulating a Kubernetes cluster with 3 containers:

```
$ docker ps
CONTAINER ID        IMAGE                                COMMAND                  CREATED             STATUS              PORTS                    NAMES
0b983b9f3334        mirantis/kubeadm-dind-cluster:v1.6   "/sbin/dind_init syst"   2 hours ago         Up 2 hours          0.0.0.0:8080->8080/tcp   kube-master
0c41b88d6cc2        mirantis/kubeadm-dind-cluster:v1.6   "/sbin/dind_init syst"   2 hours ago         Up 2 hours          8080/tcp                 kube-node-2
68b0efe4b8ff        mirantis/kubeadm-dind-cluster:v1.6   "/sbin/dind_init syst"   2 hours ago         Up 2 hours          8080/tcp                 kube-node-1
```

Before launching the script, make sure the docker daemon is running. It is gonna download 1.3GB, and occupy some 4GB of data on your disk, so you should better do it before the workshop. In short, it means:

```
$ wget https://cdn.rawgit.com/Mirantis/kubeadm-dind-cluster/master/fixed/dind-cluster-v1.6.sh
$ chmod +x dind-cluster-v1.6.sh
$ ./dind-cluster-v1.6.sh up
```

Output:

```
$ ./dind-cluster-v1.6.sh up
 WARNING: Usage of loopback devices is strongly discouraged for production use. Use `--storage-opt dm.thinpooldev` to specify a custom block storage device.
WARNING: No swap limit support
 WARNING: Usage of loopback devices is strongly discouraged for production use. Use `--storage-opt dm.thinpooldev` to specify a custom block storage device.
WARNING: No swap limit support
* Making sure DIND image is up to date
v1.6: Pulling from mirantis/kubeadm-dind-cluster
Digest: sha256:451c82dfa9be159ee005d8ebdd938d75e1ac69f8c6c608a9bc28cf8321583c09
Status: Image is up to date for mirantis/kubeadm-dind-cluster:v1.6
* Removing container: 3ca0cac0e6fa
3ca0cac0e6fa
* Removing container: 499a5cfc9456
499a5cfc9456
* Removing container: d90fdb224c94
d90fdb224c94
* Restoring master container
* Restoring master container
* Restoring node container: 1
* Restoring node container: 2
* Starting DIND container: kube-master
* Starting DIND container: kube-node-2
* Starting DIND container: kube-node-1
Warning: Stopping docker.service, but it can still be activated by:
  docker.socket
* Node container restored: 2
* Node container restored: 1
* Master container restored
* Setting cluster config
Cluster "dind" set.
Context "dind" set.
Switched to context "dind".
* Waiting for kube-proxy and the nodes
...................[done]
* Bringing up kube-dns and kubernetes-dashboard
deployment "kube-dns" scaled
deployment "kubernetes-dashboard" scaled
......[done]
NAME          STATUS    AGE       VERSION
kube-master   Ready     2h        v1.6.2
kube-node-1   Ready     2h        v1.6.2
kube-node-2   Ready     2h        v1.6.2
* Access dashboard at: http://localhost:8080/ui
```

Visit the webinterface to test that it is running fine.

## Install minikube (linux,osx,windows)

Minikube runs a k8s cluster in a virtualbox machine (you need virtualbox installed on your system). Minikube has the advantage to run on Linux/OSX/Windows, but is built with one machine (all in one), and it is not appropriate to test the resilience of your application if one node is down. We will mention when examples cannot be run in Minikube.

Refer to https://github.com/kubernetes/minikube to install it (minikube and kubectl commands).

Under OSX:

```
(0a) get Homebrew
(0b) get VirtualBox (an old 4.x VirtualBox still works!)
(1) brew install kubectl
(2) brew cask install minikube
(3) minikube start (this can take a lot of time!)
(4) kubectl run hello-minikube --image=gcr.io/google_containers/echoserver:1.4 --port=8080
(5) kubectl expose deployment hello-minikube --type=NodePort
(6) kubectl get pod (till it shows "Running" somewhere in the output :))
(7) curl $(minikube service hello-minikube --url)
(8) minikube dashboard (to see the Kubernetes dashboard in your default browser)
(9) minikube stop
```

Under Linux:

```
zoobab@sabayon /home/zoobab []$ minikube start
Starting local Kubernetes v1.6.4 cluster...
Starting VM...
Moving files into cluster...
Setting up certs...
Starting cluster components...
Connecting to cluster...
Setting up kubeconfig...
Kubectl is now configured to use the cluster.
zoobab@sabayon /home/zoobab []$ minikube dashboard
Opening kubernetes dashboard in default browser... (http://192.168.99.100:30000/#!/workload?namespace=default)
```

You need to install kubectl as well.

# Visit the web interface

For kubeadm-dind-cluster, visit http://localhost:8080/ui .
For minikube, visit "$ minikube dashboard" which gonna open a web browser at http://192.168.99.100:30000.

Quickly explain what each item means.

Show the multiple nodes difference between kubeadm and minikube.

# Basic commands

Kubectl command is available inside the kube-master container (dind):

```
$ docker exec -it kube-master kubectl
```

Or on your host for minikube.

The kubectl command is present in the kube-master container, so to have it available you can add this line to your .bashrc with your favourite text editor:

```
alias kubectl="docker exec -it kube-master kubectl $@"
```

Relaunch bash, and test that the kubectl command is availble:

```
$ kubectl version
Client Version: version.Info{Major:"1", Minor:"6", GitVersion:"v1.6.2", GitCommit:"477efc3cbe6a7effca06bd1452fa356e2201e1ee", GitTreeState:"clean", BuildDate:"2017-04-19T20:22:08Z", GoVersion:"go1.7.5", Compiler:"gc", Platform:"linux/amd64"}
Server Version: version.Info{Major:"1", Minor:"6", GitVersion:"v1.6.2", GitCommit:"477efc3cbe6a7effca06bd1452fa356e2201e1ee", GitTreeState:"clean", BuildDate:"2017-04-19T20:22:08Z", GoVersion:"go1.7.5", Compiler:"gc", Platform:"linux/amd64"}
```

Info about your cluster:
```
$ kubectl cluster-info
Kubernetes master is running at http://localhost:8080
KubeDNS is running at http://localhost:8080/api/v1/proxy/namespaces/kube-system/services/kube-dns
To further debug and diagnose cluster problems, use 'kubectl cluster-info dump'.
```

List nodes:
```
$ kubectl get nodes
NAME          STATUS    AGE       VERSION
kube-master   Ready     1d        v1.6.2
kube-node-1   Ready     1d        v1.6.2
kube-node-2   Ready     1d        v1.6.2
```

List pods:
```
$ kubectl get pods --all-namespaces             # List all pods in all namespaces
$ kubectl get pods -o wide                      # List all pods in the namespace, with more details
```

Logging:
```
$ kubectl logs my-pod
$ kubectl logs -f my-pod #tail -f equivalent
```

Watch the pods:

```
$ watch kubectl get pods
```

Or watch the events:

```
$ kubectl get pods -w
NAME                       READY     STATUS             RESTARTS   AGE
country-2934771334-0ptlh   0/1       ImagePullBackOff   0          21m
country2-2907442922-1qd7b   0/1       ImagePullBackOff   0         19m
country-2934771334-0ptlh   0/1       ErrImagePull   0         21m
country-2934771334-0ptlh   0/1       ImagePullBackOff   0         21m
country2-2907442922-1qd7b   0/1       ErrImagePull   0         21m
country2-2907442922-1qd7b   0/1       ImagePullBackOff   0         22m
```

Some more interesting commands on the cheatsheet: https://kubernetes.io/docs/user-guide/kubectl-cheatsheet/

# When your cluster is started

When your cluster is started, you should not see any pod running:

```
$ kubectl get pods -o wide
No resources found.
```

But if you check all namespaces, you will see that there are some pods already running for the system (in the "kube-system" namespace):

Under minikube:
```
$ kubectl get pods -o wide --all-namespaces
NAMESPACE     NAME                          READY     STATUS    RESTARTS   AGE       IP               NODE
kube-system   kube-addon-manager-minikube   1/1       Running   2          14m       192.168.99.100   minikube
kube-system   kube-dns-196007617-39gxn      3/3       Running   3          13m       172.17.0.3       minikube
kube-system   kubernetes-dashboard-gvjnl    1/1       Running   1          13m       172.17.0.2       minikube
```

Under kubeadm-dind:
```
$ kubectl get pods -o wide --all-namespaces
NAMESPACE     NAME                                    READY     STATUS    RESTARTS   AGE       IP           NODE
kube-system   etcd-kube-master                        1/1       Running   7          2d        10.192.0.2   kube-master
kube-system   kube-apiserver-kube-master              1/1       Running   7          2d        10.192.0.2   kube-master
kube-system   kube-controller-manager-kube-master     1/1       Running   7          28m       10.192.0.2   kube-master
kube-system   kube-dns-3946503078-p096l               3/3       Running   0          29m       10.192.3.1   kube-node-2
kube-system   kube-proxy-99f8r                        1/1       Running   0          30m       10.192.0.4   kube-node-2
kube-system   kube-proxy-k4vv5                        1/1       Running   0          30m       10.192.0.2   kube-master
kube-system   kube-proxy-v0fmq                        1/1       Running   0          30m       10.192.0.3   kube-node-1
kube-system   kube-scheduler-kube-master              1/1       Running   7          2d        10.192.0.2   kube-master
kube-system   kubernetes-dashboard-2396447444-08xg3   1/1       Running   0          29m       10.192.2.1   kube-node-1
```

# Run nginx via the webinterface

* Note that we use a smaller image "nginx:alpine" instead of the image "nginx"
* Go to "Workloads -> Deployment -> Create -> Deploy a Containerized App -> Appname: "nginxalpine" -> Container image: "nginx:alpine" -> Number of pods: 1 -> Service: none -> Deploy"
* You should have a pod running in the name like "nginxalpine-786442954-w20fj" -> Click on it -> Get its IP address (Node: IP: 10.192.3.3) and its node (Node: kube-node-2)
* Point your browser to 10.192.3.3, you should see the nginx frontpage. You should also visit the "View logs" and check that you see some traffic.
* In the case you do not reach the nginx frontpage, login on the kube-master, and then run "curl http://10.192.3.3"

# Run nginx via kubectl

Run an nginx named "my-nginx" using the Docker Hub image "nginx:alpine":
```
$ kubectl run my-nginx --image=nginx:alpine
deployment "my-nginx" created
```

Get the pods list, you should see 1 pod with "my-nginx":
```
$ kubectl get pods --output=wide
NAME                        READY     STATUS    RESTARTS   AGE       IP           NODE
my-nginx-3905153451-4bg00   1/1       Running   0          6m        10.192.3.2   kube-node-2
```

Go to http://10.192.3.2 with curl launched from the cluster, you should get the nginx welcome page:

```
$ kubectl run -i -t --rm cli --image=tutum/curl --restart=Never
$ curl http://10.192.3.2
<!DOCTYPE html>
<html>
<head>
<title>Welcome to nginx!</title>
<style>
...
```

Check also the logs of the container:
```
$ kubectl logs -f my-nginx-3905153451-4bg00
172.17.0.10 - - [20/Jun/2017:20:07:58 +0000] "GET / HTTP/1.1" 200 612 "-" "curl/7.35.0" "-"
172.17.0.10 - - [20/Jun/2017:20:09:17 +0000] "GET / HTTP/1.1" 200 612 "-" "curl/7.35.0" "-"
172.17.0.10 - - [20/Jun/2017:20:09:20 +0000] "GET / HTTP/1.1" 200 612 "-" "curl/7.35.0" "-"
```

You can also get an interactive shell on the running pod via:

```
$ kubectl exec -ti my-nginx-3905153451-4bg00 -c my-nginx -- /bin/bash
```

You can also run a command (no interactive way):

```
$ kubectl exec my-nginx-3905153451-4bg00 -- /bin/ls -l
total 48
lrwxrwxrwx   1 root root    7 May  8 22:01 bin -> usr/bin
drwxr-xr-x   2 root root 4096 Apr  4 16:00 boot
drwxr-xr-x   5 root root  380 Jun 20 20:05 dev
drwxr-xr-x   1 root root 4096 Jun 20 20:05 etc
drwxr-xr-x   2 root root 4096 Apr  4 16:00 home
lrwxrwxrwx   1 root root    7 May  8 22:01 lib -> usr/lib
lrwxrwxrwx   1 root root    9 May  8 22:01 lib32 -> usr/lib32
lrwxrwxrwx   1 root root    9 May  8 22:01 lib64 -> usr/lib64
lrwxrwxrwx   1 root root   10 May  8 22:01 libx32 -> usr/libx32
drwxr-xr-x   2 root root 4096 May  8 22:01 media
drwxr-xr-x   2 root root 4096 May  8 22:01 mnt
drwxr-xr-x   2 root root 4096 May  8 22:01 opt
dr-xr-xr-x 205 root root    0 Jun 20 20:05 proc
drwx------   2 root root 4096 Jun 19 21:49 root
drwxr-xr-x   1 root root 4096 Jun 20 20:05 run
lrwxrwxrwx   1 root root    8 May  8 22:01 sbin -> usr/sbin
drwxr-xr-x   2 root root 4096 May  8 22:01 srv
dr-xr-xr-x  12 root root    0 Jun 20 20:21 sys
drwxrwxrwt   2 root root 4096 May 30 17:08 tmp
drwxr-xr-x  13 root root 4096 Jun 19 21:49 usr
drwxr-xr-x   1 root root 4096 May 30 17:09 var
```

# Load balancing built-in

Kubernetes uses a TCP/UDP load balancer (kube-proxy) to dispatch the traffic between "replicated" pods. We can launch 2 replicates on nginx:

```
$ kubectl run my-nginx --image=nginx:alpine --replicas=2 --port=80 --record
$ kubectl expose deployment my-nginx --type=LoadBalancer --port=80
```

This will launch 2 pods, but also create what is called a "Service", which is a virtual IP address of the load balancer:

```
$ kubectl get pods -o wide
NAME                       READY     STATUS    RESTARTS   AGE       IP           NODE
my-nginx-858393261-21dsv   1/1       Running   0          8m        10.192.2.2   kube-node-1
my-nginx-858393261-h3xw9   1/1       Running   0          8m        10.192.3.2   kube-node-2
$ kubectl get services
NAME         CLUSTER-IP      EXTERNAL-IP   PORT(S)        AGE
kubernetes   10.96.0.1       <none>        443/TCP        20m
my-nginx     10.107.76.231   <pending>     80:32675/TCP   8m
```

If you do a curl to this IP 10.107.76.231 in a loop, you should see in the logs of each pod that some requests arrive on one pod, and some on another (open 2 terminals):

```
$ kubectl logs -f my-nginx-858393261-21dsv
10.192.0.2 - - [20/Jun/2017:21:17:04 +0000] "GET / HTTP/1.1" 200 612 "-" "curl/7.47.0" "-"
10.192.0.2 - - [20/Jun/2017:21:17:05 +0000] "GET / HTTP/1.1" 200 612 "-" "curl/7.47.0" "-"
10.192.0.2 - - [20/Jun/2017:21:17:06 +0000] "GET / HTTP/1.1" 200 612 "-" "curl/7.47.0" "-"
10.192.0.2 - - [20/Jun/2017:21:17:10 +0000] "GET / HTTP/1.1" 200 612 "-" "curl/7.47.0" "-"
10.192.0.2 - - [20/Jun/2017:21:17:12 +0000] "GET / HTTP/1.1" 200 612 "-" "curl/7.47.0" "-"
10.192.0.2 - - [20/Jun/2017:21:17:15 +0000] "GET / HTTP/1.1" 200 612 "-" "curl/7.47.0" "-"
10.192.0.2 - - [20/Jun/2017:21:17:17 +0000] "GET / HTTP/1.1" 200 612 "-" "curl/7.47.0" "-"
10.192.0.2 - - [20/Jun/2017:21:17:18 +0000] "GET / HTTP/1.1" 200 612 "-" "curl/7.47.0" "-"
$ kubectl logs -f my-nginx-858393261-h3xw9
10.192.0.2 - - [20/Jun/2017:21:17:23 +0000] "GET / HTTP/1.1" 200 612 "-" "curl/7.47.0" "-"
10.192.0.2 - - [20/Jun/2017:21:17:24 +0000] "GET / HTTP/1.1" 200 612 "-" "curl/7.47.0" "-"
10.192.0.2 - - [20/Jun/2017:21:17:25 +0000] "GET / HTTP/1.1" 200 612 "-" "curl/7.47.0" "-"
10.192.0.2 - - [20/Jun/2017:21:17:28 +0000] "GET / HTTP/1.1" 200 612 "-" "curl/7.47.0" "-"
10.192.0.2 - - [20/Jun/2017:21:17:33 +0000] "GET / HTTP/1.1" 200 612 "-" "curl/7.47.0" "-"
10.192.0.2 - - [20/Jun/2017:21:17:34 +0000] "GET / HTTP/1.1" 200 612 "-" "curl/7.47.0" "-"
10.192.0.2 - - [20/Jun/2017:21:17:37 +0000] "GET / HTTP/1.1" 200 612 "-" "curl/7.47.0" "-"
10.192.0.2 - - [20/Jun/2017:21:17:38 +0000] "GET / HTTP/1.1" 200 612 "-" "curl/7.47.0" "-"
```

# A simple Nodejs application

Now that we know how to deploy a pre-built app, let’s create our own and deploy it.

```
$ mkdir hello-nodejs && cd hello-nodejs && touch Dockerfile server.js
```

Create a basic http server using nodeJS that always returns HTTP 200 and “Hello World!” response

```
$ vim server.js
var http = require('http');
var handleRequest = function(request, response){
    console.log("rx request for url:" + request.url);
    response.writeHead(200)
    response.end('Hello World!')
};

var www = http.createServer(handleRequest);
www.listen(8080);
```

Now modify the Dockerfile to define what version of node you need and how to start the server:

```
FROM node:6.9.2
EXPOSE 8080
COPY server.js .
CMD node server.js
```

Docker environment variables must be set for minikube:

```
$ eval $(minikube docker-env)
```

Simple enough?  Ok, let’s build the container!

```
$ docker build -t hello-node:v1 .
Sending build context to Docker daemon 3.072 kB
Step 1 : FROM node:6.9.2
---> faaadb4aaf9b
Step 2 : EXPOSE 8080
---> Using cache
---> e78d6f95b487
Step 3 : COPY server.js .
---> Using cache
---> 30a49bb02305
Step 4 : CMD node server.js
---> Using cache
---> eb22cf1abcf6
Successfully built eb22cf1abcf6
Deploy the App
```

Now you can ship it:

```
$ kubectl run hello-node --image=hello-node:v1 --port=8080
deployment "hello-node" created
```

Let’s confirm by checking the deployment and pods

```
$ kubectl get deployments
NAME           DESIRED   CURRENT   UP-TO-DATE   AVAILABLE   AGE
hello-node   1         1         1            1           1m
$ kubectl get pods
NAME                          READY     STATUS    RESTARTS   AGE
hello-node-2686040790-0t8q4   1/1       Running   0          1m
```

Now, let’s expose the new app:

```
$ kubectl expose deployment hello-node --type=NodePort
service "hello-node" exposed
```

And confirm services…

```
$ kubectl get services
NAME         CLUSTER-IP  EXTERNAL-IP  PORT(S)         AGE
hello-node 10.0.0.13   <nodes>      8080:32272/TCP  2m
kubernetes   10.0.0.1    <none>       443/TCP         1d
```

And finally let’s confirm our nodejs service is functioning…

```
$ curl $(minikube service hello-node --url)
Hello World!
```

OK, we wrote our own simple web service, containerized it and deployed it to a Kubernetes cluster!

# Upscale and Downscale

You can manually upscale or downscale the number of nginx instances you want on your cluster.

Check that your previous deployment is still present:

```
$ kubectl run my-nginx --image=nginx:alpine
deployment "my-nginx" created

$ kubectl get deployment
NAME       DESIRED   CURRENT   UP-TO-DATE   AVAILABLE   AGE
my-nginx   1         1         1            1           7s

$ kubectl scale --replicas=2 deployment/my-nginx
deployment "my-nginx" scaled
```

Now watch the number of pods with watch (preferrably in another terminal):

```
$ watch kubectl get pods

$ kubectl get pods
NAME                        READY     STATUS    RESTARTS   AGE
my-nginx-1570827950-f19fx   1/1       Running   0          1m
my-nginx-1570827950-sjhtq   1/1       Running   0          3m
```

Increase it to 10 replicas:

```
$ kubectl scale --replicas=10 deployment/my-nginx
$ kubectl get pods
NAME                        READY     STATUS              RESTARTS   AGE
my-nginx-1570827950-58wsq   1/1       Running             0          6s
my-nginx-1570827950-9fbx9   0/1       ContainerCreating   0          6s
my-nginx-1570827950-f19fx   1/1       Running             0          2m
my-nginx-1570827950-ql7wv   0/1       ContainerCreating   0          6s
my-nginx-1570827950-qz9f3   1/1       Running             0          6s
my-nginx-1570827950-r21tg   1/1       Running             0          6s
my-nginx-1570827950-sjhtq   1/1       Running             0          4m
my-nginx-1570827950-v8hnf   1/1       Running             0          6s
my-nginx-1570827950-vxxz1   0/1       ContainerCreating   0          6s
my-nginx-1570827950-wz79h   0/1       ContainerCreating   0          6s
```

# Replace the running image

You can replace the running image used in your deployment by another one:

```
$ kubectl set image deployment/my-nginx my-nginx=zoobab/envvars
```

Watch the kubectl get pods as before, and check the logs of the pods to see that it does not run nginx anymore, but something else (see below for the envvars example).

```
$ watch kubectl get pods
```

```
$ kubectl logs -f my-nginx-1570827950-wz79h
FOO is empty
FOO is empty
FOO is empty
[...]
```

# Pod scheduling

You should stop one container and see it coming back

* Run one nginx on your cluster
* Identify on which node it runs
* Go on the shell (for kubeadm: $ docker exec -it kube-node-1 bash) (for minikube: $ minikube ssh) and get the ouput of "docker ps"
* Search for nginx
* Stop the container (for ex: $ docker stop 6598a01726a8)
* Watch the output of "docker ps" or "watch docker ps" and see it coming back after some seconds, being rescheduled by the master

# Pod re-scheduling

(example only valid for kubeadm, which has 2 minions nodes)

If one node is down (ex hardware failure), observe that the master reschedules the pod to the other node

* Launch one nginx pod like before
* Node down on which of the node it runs
* Stop one of the nodes (fox ex: $ docker stop kube-node-1)
* Watch the pod being rescheduled to the other node (in this ex kube-node-2) and note down the time it takes.

# Rollout and Rollback

The power of Deployments comes from their ability to do smart upgrades and rollbacks when something goes wrong.

Let’s update our Deployment of nginx to the newer version. Here is a deployment called "my-nginx-new.yaml":

```
$ cat <<EOF > my-nginx-new.yaml
apiVersion: extensions/v1beta1
kind: Deployment
metadata:
  labels:
    run: my-nginx
  name: my-nginx
  namespace: default
spec:
  replicas: 2
  selector:
    matchLabels:
      run: my-nginx
  template:
    metadata:
      labels:
        run: my-nginx
    spec:
      containers:
      - image: nginx:1.13.1-alpine
        name: my-nginx
        ports:
        - containerPort: 80
          protocol: TCP
EOF
```

Let's deploy it (apply here because we are updating a deployment that already existed):

```
$ kubectl apply -f my-nginx-new.yaml
deployment "my-nginx" configured
```

We can see that a new Replica Set (rs) has been created:

```
$ kubectl get rs
NAME                  DESIRED   CURRENT   AGE
my-nginx-1413250935   2         2         50s
my-nginx-3800858182   0         0         2h
```

If we look at the events section of the Deployment we will see how it performed a rolling update, scaling up the new Replica Set and scaling down the old Replica Set:

```
$ kubectl describe deployments/my-nginx
Name:			my-nginx
Namespace:		default
CreationTimestamp:	Sun, 15 May 2016 19:37:01 +0000
Labels:			run=my-nginx
Selector:		run=my-nginx
Replicas:		2 updated | 2 total | 2 available | 0 unavailable
StrategyType:		RollingUpdate
MinReadySeconds:	0
RollingUpdateStrategy:	1 max unavailable, 1 max surge
OldReplicaSets:		<none>
NewReplicaSet:		my-nginx-1413250935 (2/2 replicas created)
Events:
  FirstSeen	LastSeen	Count	From				SubobjectPath	Type		Reason			Message
  ---------	--------	-----	----				-------------	--------	------			-------
  2h		2h		1	{deployment-controller }			Normal		ScalingReplicaSet	Scaled up replica set my-nginx-3800858182 to 2
  1m		1m		1	{deployment-controller }			Normal		ScalingReplicaSet	Scaled up replica set my-nginx-1413250935 to 1
  1m		1m		1	{deployment-controller }			Normal		ScalingReplicaSet	Scaled down replica set my-nginx-3800858182 to 1
  1m		1m		1	{deployment-controller }			Normal		ScalingReplicaSet	Scaled up replica set my-nginx-1413250935 to 2
  1m		1m		1	{deployment-controller }			Normal		ScalingReplicaSet	Scaled down replica set my-nginx-3800858182 to 0
```

We can modify the deployment to use image "nginx:1.12.0-alpine", re-apply it, and check with curl -v that the new version of nginx got deployed:


```
$ cat <<EOF > my-nginx-new.yaml
apiVersion: extensions/v1beta1
kind: Deployment
metadata:
  labels:
    run: my-nginx
  name: my-nginx
  namespace: default
spec:
  replicas: 2
  selector:
    matchLabels:
      run: my-nginx
  template:
    metadata:
      labels:
        run: my-nginx
    spec:
      containers:
      - image: nginx:1.12.0-alpine
        name: my-nginx
        ports:
        - containerPort: 80
          protocol: TCP
EOF
```

Let's deploy it (apply here because we are updating a deployment that already existed):

```
$ kubectl apply -f my-nginx-new.yaml
deployment "my-nginx" configured
```

```
$ curl -v 10.192.2.8 2>&1 | grep "Server"
< Server: nginx/1.12.0
```

Let’s simulate a situation when a Deployment fails and we need to rollback. Here is a deployment with an error called "my-nginx-typo.yaml":

```
$ cat <<EOF > my-nginx-typo.yaml
apiVersion: extensions/v1beta1
kind: Deployment
metadata:
  labels:
    run: my-nginx
  name: my-nginx
  namespace: default
spec:
  replicas: 2
  selector:
    matchLabels:
      run: my-nginx
  template:
    metadata:
      labels:
        run: my-nginx
    spec:
      containers:
      - image: nginx:1.12.30-alpine
        name: my-nginx
        ports:
        - containerPort: 80
          protocol: TCP
EOF
```

Let's apply it:

```
$ kubectl apply -f ./my-nginx-typo.yaml
```

Some pods are failing:

```
$ kubectl get pods -o wide
NAME                        READY     STATUS         RESTARTS   AGE       IP            NODE
my-nginx-31133408-2ck20     0/1       ErrImagePull   0          14s       10.192.2.10   kube-node-1
my-nginx-31133408-fbwv7     0/1       ErrImagePull   0          14s       10.192.2.11   kube-node-1
my-nginx-3998420655-c6s59   1/1       Running        0          11m       10.192.2.8    kube-node-1
my-nginx-858393261-h3xw9    1/1       Unknown        0          51m       10.192.3.2    kube-node-2
```

And the Deployment shows 2 unavailable Replicas:

```
$ kubectl describe deployments/my-nginx
Name:			my-nginx
Namespace:		default
CreationTimestamp:	Sun, 15 May 2016 19:37:01 +0000
Labels:			run=my-nginx
Selector:		run=my-nginx
Replicas:		2 updated | 2 total | 1 available | 2 unavailable
StrategyType:		RollingUpdate
MinReadySeconds:	0
RollingUpdateStrategy:	1 max unavailable, 1 max surge
OldReplicaSets:		my-nginx-1413250935 (1/1 replicas created)
NewReplicaSet:		my-nginx-2896527177 (2/2 replicas created)
Events:
  FirstSeen	LastSeen	Count	From				SubobjectPath	Type		Reason			Message
  ---------	--------	-----	----				-------------	--------	------			-------
  2h		2h		1	{deployment-controller }			Normal		ScalingReplicaSet	Scaled up replica set my-nginx-3800858182 to 2
  11m		11m		1	{deployment-controller }			Normal		ScalingReplicaSet	Scaled up replica set my-nginx-1413250935 to 1
  11m		11m		1	{deployment-controller }			Normal		ScalingReplicaSet	Scaled down replica set my-nginx-3800858182 to 1
  11m		11m		1	{deployment-controller }			Normal		ScalingReplicaSet	Scaled up replica set my-nginx-1413250935 to 2
  10m		10m		1	{deployment-controller }			Normal		ScalingReplicaSet	Scaled down replica set my-nginx-3800858182 to 0
  1m		1m		1	{deployment-controller }			Normal		ScalingReplicaSet	Scaled up replica set my-nginx-2896527177 to 1
  1m		1m		1	{deployment-controller }			Normal		ScalingReplicaSet	Scaled down replica set my-nginx-1413250935 to 1
  1m		1m		1	{deployment-controller }			Normal		ScalingReplicaSet	Scaled up replica set my-nginx-2896527177 to 2
```

The rollout has stopped. Let’s view the history:

```
$ kubectl rollout history deployments/my-nginx
deployments "my-nginx":
REVISION	CHANGE-CAUSE
1		kubectl run my-nginx --image=nginx --replicas=2 --port=80 --expose --record
2		kubectl apply -f my-nginx-new.yaml
3		kubectl apply -f my-nginx-typo.yaml
```

NOTE: We used --record flag and now all commands are recorded!

Let’s roll back the last Deployment:

```
$ kubectl rollout undo deployment/my-nginx
deployment "my-nginx" rolled back
```

We’ve created a new revision by doing undo:

```
$ kubectl rollout history deployment/my-nginx
deployments "my-nginx":
REVISION	CHANGE-CAUSE
1		kubectl run my-nginx --image=nginx --replicas=2 --port=80 --expose --record
3		kubectl apply -f my-nginx-typo.yaml
4		kubectl apply -f my-nginx-new.yaml
```

The pods are also back and running with the previous working version (check that with curl).

# 1 pod with 1 container

We gonna deploy a container which is doing a simple "busybox ping localhost" command. This "cat" shell command will write a file named "busybox-ping-localhost.yaml".

```
$ cat <<EOF > busybox-ping-localhost.yaml
apiVersion: v1
kind: Pod
metadata:
  name: busybox-ping-localhost
spec:
  containers:
  - name: busybox
    image: busybox
    args:
    - ping
    - localhost
EOF
```

Then load it:

```
$ kubectl create -f ./busybox-ping-localhost.yaml
```

Watch the pods being created:

```
$ watch kubectl get pods
```

Or without watch, it will tail the events as they come:

```
$ kubectl get pods -w
```

Get the logs via:

```
$ kubectl logs -f busybox-ping-localhost
PING localhost (127.0.0.1): 56 data bytes
64 bytes from 127.0.0.1: seq=0 ttl=64 time=0.050 ms
64 bytes from 127.0.0.1: seq=1 ttl=64 time=0.068 ms
64 bytes from 127.0.0.1: seq=2 ttl=64 time=0.094 ms
64 bytes from 127.0.0.1: seq=3 ttl=64 time=0.075 ms
64 bytes from 127.0.0.1: seq=4 ttl=64 time=0.103 ms
64 bytes from 127.0.0.1: seq=5 ttl=64 time=0.100 ms
64 bytes from 127.0.0.1: seq=6 ttl=64 time=0.095 ms
64 bytes from 127.0.0.1: seq=7 ttl=64 time=0.079 ms
```

Stop it via:

```
$ kubectl delete pod busybox-ping-localhost
pod "busybox-ping-localhost" deleted
```

# 2 pods with 1 container each

A little reminder on how busybox works:

```
$ busybox ping yahoo.com
PING yahoo.com (98.138.253.109) 56(84) bytes of data.
64 bytes from ir1.fp.vip.ne1.yahoo.com (98.138.253.109): icmp_seq=1 ttl=52 time=129 ms
^C
--- yahoo.com ping statistics ---
1 packets transmitted, 1 received, 0% packet loss, time 0ms
rtt min/avg/max/mdev = 129.565/129.565/129.565/0.000 ms
```

Note that "yahoo.com" is the first argument.

You can also run it in docker:

```
$ docker run busybox ping -c1 yahoo.com
PING yahoo.com (98.139.180.149): 56 data bytes
64 bytes from 98.139.180.149: seq=0 ttl=50 time=107.452 ms

--- yahoo.com ping statistics ---
1 packets transmitted, 1 packets received, 0% packet loss
round-trip min/avg/max = 107.452/107.452/107.452 ms
```

Now do a "2 pods with 1 container each" yaml file:

```
$ cat <<EOF > busybox-ping-googleyahoo.yaml
apiVersion: v1
kind: Pod
metadata:
  name: busybox-ping-google
spec:
  containers:
  - name: busybox
    image: busybox
    args:
    - ping
    - google.com
---
apiVersion: v1
kind: Pod
metadata:
  name: busybox-ping-yahoo
spec:
  containers:
  - name: busybox
    image: busybox
    args:
    - ping
    - yahoo.com
EOF
```

Now load it:

```
$ kubectl create -f ./busybox-ping-googleyahoo.yaml
```

And watch the pods:

```
$ watch kubectl get pods
NAME                        READY     STATUS        RESTARTS   AGE
busybox-ping-google         1/1       Running   0          29s
busybox-ping-yahoo          1/1       Running   0          1m
my-nginx-3905153451-r5486   1/1       Running       0          17m
nginx-786442954-t58w2       1/1       Running       2          25m
```

If you delete one pod, the other one will still run:

```
$ kubectl delete pod busybox-ping-google
```

# 1 pod with 2 containers

Now do a "1 pod with 2 containers" yaml file:

```
$ cat <<EOF > busybox-ping-googleyahoo-onepod.yaml
apiVersion: v1
kind: Pod
metadata:
  name: busybox-ping-googleyahoo-onepod
spec:
  containers:
  - name: busybox-ping-google
    image: busybox
    args:
    - ping
    - google.com
  - name: busybox-ping-yahoo
    image: busybox
    args:
    - ping
    - yahoo.com
EOF
```

And load it like before.

Check the logs and explain the difference with the case of "2 pods with 1 container each":

```
$ kubectl logs -f busybox-ping-googleyahoo-onepod -c busybox-ping-yahoo
64 bytes from 216.58.209.238: seq=267 ttl=61 time=33.530 ms
64 bytes from 98.139.180.149: seq=265 ttl=61 time=142.088 ms
64 bytes from 216.58.209.238: seq=268 ttl=61 time=17.779 ms
64 bytes from 98.139.180.149: seq=266 ttl=61 time=107.141 ms
64 bytes from 216.58.209.238: seq=269 ttl=61 time=22.258 ms
```

# Mount an empty volume

First of all, you can mount an empty directory using "emptydir", which is not gonna be persistent.

```
apiVersion: v1
kind: Pod
metadata:
  name: redis
spec:
  containers:
  - name: redis
    image: redis
    volumeMounts:
    - name: redis-notpersistent-storage
      mountPath: /data/redis
  volumes:
  - name: redis-notpersistent-storage
    emptyDir: {}
```

Go on the shell of the node, find the docker container running it, and then go inside via "docker exec -it $CTID bash", and go to "cd /data/redis", it should be empty.

# Mount a volume from the host

An example how to mount a volume from the host with redis:

```
apiVersion: v1
kind: Pod
metadata:
  name: redis-volume-slashbin
spec:
  containers:
  - name: redis
    image: redis
    volumeMounts:
    - name: slashbin
      mountPath: /tmp/bin
  volumes:
  - name: slashbin
    hostPath:
      # directory location on host
      path: /bin
```

Go on the shell of the node, find the docker container running it, and then go inside via "docker exec -it $CTID bash", and do an "ls /tmp/bin", it should contain some binaries.

Now go back to the node, and create a file in /bin:

```
$ docker exec -it kube-node-2 bash
root@kube-node-2:/# cd /bin/
root@kube-node-2:/bin# touch file
root@kube-node-2:/bin#
```

You should be able to see that file in the running container in /tmp/bin/file.

# Use an environment variable

(Inspired from http://serverascode.com/2014/05/29/environment-variables-with-docker.html)

For example, run a busybox script which outputs the FOO env variable with docker:

```
$ cat Dockerfile
FROM busybox
ADD run.sh run.sh
RUN chmod +x run.sh
CMD ./run.sh
```

where the run.sh is:

```
$ cat run.sh
#!/bin/sh
while true; do
  sleep 1
  if [ -z "$FOO" ]; then
	echo "FOO is empty"
  else
	echo "FOO is $FOO"
  fi
done
```

Build it and push it to the docker hub:

```
$ docker build -t zoobab/envvars:latest .
Sending build context to Docker daemon 3.072 kB
Step 1 : FROM busybox
 ---> c30178c5239f
Step 2 : ADD run.sh run.sh
 ---> Using cache
 ---> cc7d76754b88
Step 3 : RUN chmod +x run.sh
 ---> Using cache
 ---> 63de1810106e
Step 4 : CMD ./run.sh
 ---> Using cache
 ---> 43c5336bedd5
Successfully built 43c5336bedd5
```

And then push it (if you build it inside minikube (minikube ssh), you won't need to push it to a registry):

```
$ docker push zoobab/envvars:latest
The push refers to a repository [docker.io/zoobab/envvars]
7cfba17afe7f: Layer already exists
3a1dff9afffd: Layer already exists
latest: digest: sha256:1866e3131d611f8bd7ef5dd5c252ac773f594c40e06158d457ab48cc1b1f76d7 size: 734
```

You can quickly test it locally without passing any env var:

```
$ docker run zoobab/envvars
FOO is empty
FOO is empty
FOO is empty
[...]
```

And passing a env var for FOO:

```
$ docker run -e FOO=BAR zoobab/envvars
FOO is BAR
FOO is BAR
[...]
```

Now we can deploy a pod with this container by passing the env variable:

```
$ cat <<EOF > busybox-envvars.yaml
apiVersion: v1
kind: Pod
metadata:
  name: busybox-envvars
spec:
  containers:
  - name: busybox-envvars
    image: zoobab/envvars
    env:
     - name: FOO
       value: hellofromk8s
EOF
```

Check the logs of the pod:

```
$ kubectl logs -f busybox-envvars
FOO is hellofromk8s
FOO is hellofromk8s
FOO is hellofromk8s
FOO is hellofromk8s
FOO is hellofromk8s
FOO is hellofromk8s
```

# Mount a volume from the host bis

Let's create a directory called "www" with an index.html in there containing 'Hello from Brussels!':

```
$ mkdir www
$ cd www
$ echo "<h1>Hello from Brussels!</h1>" > index.html
```

Now let's expose that on http://localhost:4000 via the busybox http server

```
$ docker run -p4000:80 -v $PWD/www:/www  busybox httpd -f -h /www -v
```

Visit the url http://localhost:4000 to check that it works fine.

Now login to the nodes (kube-node-2 and kube-node-1) and create this /www directory with the index.html inside, which should contain the name of the node "Hello from kube-node-1".

Now deploy this container in the cluster:

```
$ cat <<EOF > busybox-httpd-volume-hostpath.yaml
---
apiVersion: v1
kind: Pod
metadata:
  name: busybox-httpd-volume-hostpath
spec:
  containers:
    - name: busybox-httpd-volume-hostpath
      image: busybox
      args:
        - httpd
        - -f
        - -h
        - /www
        - -v
      volumeMounts:
        - name: www
          mountPath: /www
  volumes:
    - name: www
      hostPath:
        path: /www
EOF
```

Deploy it, and then get the IP address via:

```
$ kubectl get pods -o wide | grep "httpd"
busybox-httpd-volume-hostpath   1/1       Running            0          2m        10.192.3.11   kube-node-2
```

Note down the IP address $IPADDR and the $NODE on which it runs.

Visit the http://$IPADDR and check on which node you arrive ("Hello from kube-node-1") for example:

```
$ curl 10.192.3.11
hello from node2
```

Now shutdown the kube-node-2 via:

```
$ docker stop kube-node-2
```

Wait 30 secs and notice that the "busybox-httpd-volume-hostpath" has been rescheduled to the kube-node-1.

```
$ watch kubectl get pods -o wide

```

# Custom nginx.conf via ConfigMap

Explain how to run nginx with a custom nginx.conf config file that lists the root filesystem of the container.

First create a working directory named "conf.d" with a file named "default.conf":

```
$ mkdir conf.d
$ cd conf.d
$ cat <<EOF > default.conf
server {
    listen       80;
    server_name  localhost;

    location / {
        return 200 'Kubernetes is hot, time for a beer!\n';
    }
}
EOF
```

You can first try what it gives by simply running it on your laptop with docker:

```
$ docker run -p9000:80 -d -v $PWD/conf.d:/etc/nginx/conf.d nginx:alpine
21a1f091e24e2824dc5180e143e91a20443ab988e74a654cfbd3d092e06c4446
```

Check that it runs by pointing your browser to http://localhost:9000. You should obtain a page like this one:

```
$ curl http://localhost:9000
Kubernetes is hot, time for a beer!
```

Now we have to create a configmap file to load the config in kubernetes:

```
$ kubectl create configmap my-nginx-v1 --from-file=conf.d
configmap "my-nginx-v1" created
$ kubectl describe configmaps/my-nginx-v1
Name:		my-nginx-v1
Namespace:	default
Labels:		<none>
Annotations:	<none>

Data
====
default.conf:	125 bytes
```

Then create a yaml file that refers to this configmap named "my-nginx-configmap.yaml":

```
$ cat <<EOF > my-nginx-configmap.yaml
apiVersion: extensions/v1beta1
kind: Deployment
metadata:
  labels:
    run: my-nginx
  name: my-nginx
  namespace: default
spec:
  replicas: 2
  selector:
    matchLabels:
      run: my-nginx
  template:
    metadata:
      labels:
        run: my-nginx
    spec:
      containers:
      - image: nginx:alpine
        name: my-nginx
        ports:
        - containerPort: 80
          protocol: TCP
        volumeMounts:
        - name: config-volume
          mountPath: /etc/nginx/conf.d
      volumes:
       - name: config-volume
         configMap:
           name: my-nginx-v1
EOF
```

Load it:

```
$ kubectl create -f ./my-nginx-configmap.yaml
```

You should get two pods starting with "my-nginx":

```
$ kubectld get pods -o wide
NAME                        READY     STATUS             RESTARTS   AGE       IP            NODE
my-nginx-3217887688-018r0   1/1       Running            0          13s       10.192.2.8    kube-node-1
my-nginx-3217887688-c060h   1/1       Running            0          13s       10.192.3.16   kube-node-2
```

Check curl over the 2 ip addresses:

```
$ curl http://10.192.2.8
Kubernetes is hot, time for a beer!
$ curl http://10.192.3.16
Kubernetes is hot, time for a beer!
```

You can also check that the file has been mounted properly by getting an interactive shell on one of the pod:

```
$ kubectl exec -ti my-nginx-3217887688-018r0 /bin/sh
/ # mount | grep nginx
/dev/mapper/docker-251:2-1441971-d7ae4c5ab80804dd03cfd9e9c19d0bc4e308664a43f712493a0e5387cf39d6d6 on /etc/nginx/conf.d type xfs (rw,relatime,nouuid,attr2,inode64,logbsize=64k,sunit=128,swidth=128,noquota)
/ # cd /etc/nginx/conf.d/
/etc/nginx/conf.d # ls
nginx.conf
/etc/nginx/conf.d # ls -al
total 4
drwxrwxrwx    3 root     root            77 Jun 20 19:28 .
drwxr-xr-x    1 root     root          4096 May 30 17:16 ..
drwxr-xr-x    2 root     root            24 Jun 20 19:28 ..6986_20_06_19_28_16.520312211
lrwxrwxrwx    1 root     root            31 Jun 20 19:28 ..data -> ..6986_20_06_19_28_16.520312211
lrwxrwxrwx    1 root     root            17 Jun 20 19:28 nginx.conf -> ..data/nginx.conf
/etc/nginx/conf.d #
```

# CI of the poor

Use case is myimage:latest which is built from HEAD master at each commit, and then pushed to the Docker Hub registry (or a local one on port 5000 HTTP).

Find a way to get it updated on the cluster:

* https://github.com/kubernetes/kubernetes/issues/33664#issuecomment-292895327
* https://kubernetes.io/docs/concepts/containers/images/
* https://github.com/jhadvig/imagepoll
* https://github.com/zoobab/docker-ls/tree/master/scripts (registry-lslayers outputs the sha256 of the image)
* https://github.com/rusenask/keel

# Multi-tier application: Guestbook

https://github.com/kubernetes/kubernetes/tree/master/examples/guestbook

# Links

* https://github.com/sebgoa/oreilly-kubernetes
