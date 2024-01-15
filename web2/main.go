package main

import (
    "context"
    "fmt"
    "log"
    "net/http"
    "os"

    metav1 "k8s.io/apimachinery/pkg/apis/meta/v1"
    "k8s.io/client-go/kubernetes"
    "k8s.io/client-go/rest"
)

func getK8sInfo() (string, string, string, error) {
    // Creates the in-cluster config
    config, err := rest.InClusterConfig()
    if err != nil {
        return "", "", "", err
    }
    // Creates the clientset
    clientset, err := kubernetes.NewForConfig(config)
    if err != nil {
        return "", "", "", err
    }

    // Get current Pod Name and Namespace
    podName := os.Getenv("HOSTNAME")
    namespace := os.Getenv("NAMESPACE")
    if podName == "" || namespace == "" {
        return "", "", "", fmt.Errorf("unable to get pod name or namespace")
    }

    // Get Pod information
    pod, err := clientset.CoreV1().Pods(namespace).Get(context.TODO(), podName, metav1.GetOptions{})
    if err != nil {
        return "", "", "", err
    }

    nodeName := pod.Spec.NodeName

    // Assume single service for simplicity
    services, err := clientset.CoreV1().Services(namespace).List(context.TODO(), metav1.ListOptions{})
    if err != nil {
        return "", "", "", err
    }
    if len(services.Items) == 0 {
        return nodeName, "", "", nil
    }

    serviceName := services.Items[0].Name
    serviceIP := services.Items[0].Spec.ClusterIP

    return nodeName, serviceName, serviceIP, nil
}

func helloHandler(w http.ResponseWriter, r *http.Request) {
    nodeName, serviceName, serviceIP, err := getK8sInfo()
    if err != nil {
        http.Error(w, err.Error(), http.StatusInternalServerError)
        return
    }

    fmt.Fprintf(w, "Node Name: %s\nService Name: %s\nService IP: %s", nodeName, serviceName, serviceIP)
}

func main() {
    http.HandleFunc("/", helloHandler)
    fmt.Println("Server starting on port 8080...")
    log.Fatal(http.ListenAndServe(":8080", nil))
}

