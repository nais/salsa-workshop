# Lab 0: Setting up local environment

## Goal

In this lab we will set up a local environment to run the workshop.

## Steps

### 1. Install Docker

Follow the instructions for your operating system:

- [Mac](https://docs.docker.com/docker-for-mac/install/)
- [Linux](https://docs.docker.com/engine/install/)
- [Windows](https://docs.docker.com/docker-for-windows/install/)

### 2. Install kubectl

Follow the instructions for your operating system:

- [Mac](https://kubernetes.io/docs/tasks/tools/install-kubectl-macos/)
- [Linux](https://kubernetes.io/docs/tasks/tools/install-kubectl-linux/)
- [Windows](https://kubernetes.io/docs/tasks/tools/install-kubectl-windows/)

### 3. Install Minikube

Follow the instructions for your operating system:

- [All systems](https://minikube.sigs.k8s.io/docs/start/)

### 4. Install Helm

Follow the instructions for your operating system:

- [Mac](https://helm.sh/docs/intro/install/#from-homebrew-macos)
- [Linux](https://helm.sh/docs/intro/install/#from-apt-debianubuntu)
- [Windows](https://helm.sh/docs/intro/install/#from-chocolatey-windows)

### 5. Install cosign

Follow the instructions for your operating system:

- https://docs.sigstore.dev/cosign/installation

### 6. Create a Kubernetes cluster

Start Minikube:

```bash
minikube start
```

Verify that the cluster is running:

```bash
kubectl get nodes
```

### 7. Fork the workshop repository

Fork the workshop repository to your own GitHub account by clicking the "Fork" button in the top right corner of the repository page.

## Conclusion

You have now set up a local environment to run the workshop.

## Next

Proceed to [Lab 1](../lab-1/README.md) >
