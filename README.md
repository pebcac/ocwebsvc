---

# Deploying the Go Web App with Load Balancing using OpenShift

This repository contains the code for deploying a simple web application written in Go on OpenShift with load balancing. The application is designed to be scalable and fault-tolerant, with multiple instances running behind a load balancer.

## Prerequisites

Before you begin, make sure you have the following installed:

* OpenShift CLI (oc)
* Docker
* Go

## Deployment Instructions

To deploy the application, follow these steps:

1. Clone this repository to your local machine using `git clone https://github.com/pebcac/openshift-go-webapp.git`.
2. Change into the cloned directory using `cd openshift-go-webapp`.
3. Build the Docker image for the application by running `docker build -t go-webapp .` in the terminal.
4. Push the Docker image to a registry (e.g. Docker Hub) by running `docker push <image_name>`.
5. Replace the docker image in lines 31 and 105 with your docker image from step 4 above.
6. Create an OpenShift project using `oc new-project <project_name>`.
7. Deploy the application to the OpenShift cluster by running `oc new-app --template=go-webapp` in the terminal.
8. Expose the application as a route by running `oc expose svc/<service_name>` in the terminal.
9. Access the application using the route URL provided by the `oc expose` command.

## Load Balancing Configuration

The load balancing configuration for this application is defined in the `Route` resource file. The `alternateBackends` field specifies two backend services to be used for load balancing. The `weight` field specifies the relative weight of each backend service, with higher weights indicating a greater proportion of traffic should be directed to that service.

## Scaling and Fault Tolerance

The application is designed to be scalable and fault-tolerant. When new instances are added to the cluster, they will automatically join the load balancing pool and start receiving traffic. If an instance fails or becomes unavailable, the load balancer will automatically redirect traffic to other available instances.

## Security

The application is designed with security in mind. The `Route` resource file includes a `tls` section that specifies the TLS termination point for the application. This ensures that all traffic to the application is encrypted and secure. Additionally, the `Service` resource file includes a `type: LoadBalancer` field, which creates a Kubernetes service of type `LoadBalancer`, which exposes the application on an external IP address.

## Conclusion

This repository contains the code for deploying a simple web application written in Go on OpenShift with load balancing. The application is designed to be scalable and fault-tolerant, with multiple instances running behind a load balancer. The load balancing configuration is defined in the `Route` resource file, and the application is exposed as a route using the `oc expose` command.
