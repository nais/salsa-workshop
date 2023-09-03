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

> **Note**
> Docker image names cannot contain uppercase letters. If your GitHub username contains uppercase letters 
> this may cause problems in subsequent labs. If this is the case you must manually replace occurrences of 
> `${{ github.repository }}` with an all-lowercase hardcoded version in your workflows. Ask for help if you get stuck!

Go to your forked repository and enable GitHub Actions:

```
https://github.com/nais/<user>/actions
```

Clone the repository to your local machine:

```bash
git clone git@github.com:<user>/nais-workshop.git
```

> [!NOTE]
> Throughout these labs we will push our images to the anonymous and ephemeral Docker registry [ttl.sh](https://ttl.sh/). This registry offers a lifetime of at most 24 hours. If you want the images to remain available you must perform step 8 to set up access to [GitHub Packages](https://github.com/features/packages). You will also need to replace all occurrences of `ttl.sh/myimage` with `ghcr.io/<mygithubuser>/myimage`. If you will be using `ttl.sh` step 8 can be skipped. 

### 8. Create a GitHub personal access token

Create a [new GitHub personal access
token](https://github.com/settings/tokens/new) with the following permissions:

- `write:packages`

Log in to GitHub Packages (ghcr.io) with your docker client:

```bash
echo "<token>" | docker login ghcr.io --username <user> --password-stdin
```

## Conclusion

You have now set up a local environment to run the workshop.

## Next

Proceed to [Lab 1](../lab-1/README.md) >

