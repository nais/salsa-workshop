# Lab 1: Sign and verify containers locally using cosign

## Goal

In this lab we will sign and verify containers using [sigstore/cosign](https://docs.sigstore.dev/cosign/overview/) locally. The goal is to get familiar with the tooling and the process of signing and verifying containers.

We will push the images to [ttl.sh](https://ttl.sh/), an ephemeral registry that is great for testing.
The image tag determines how long the image will live, i.e. "2h" = 2 hours. 

### Cosign

Cosign is a tool for signing and verifying container images. It is developed by the [sigstore](https://www.sigstore.dev/) project.

When you sign an image cosign will upload the signature to the OCI registry alongside the image.

## Steps

Make a random name for your container:

```bash
export CONTAINER_NAME="ttl.sh/salsa-workshop-$(dd if=/dev/urandom bs=1 count=10 status=none | base64 | tr -dc 'a-z')"
echo "Your chosen container name is $CONTAINER_NAME"
```

### 1. Build the example container

In the root of this repository we have created an example application with a simple Dockerfile, run the following command:

```bash
docker build -t $CONTAINER_NAME:2h .
docker push $CONTAINER_NAME:2h
```

> **Note**
> Write down the image digest outputted from `docker push`, you will need it in subsequent steps

### 2. Sign the container

Generate a key pair for local signing:

```bash
cosign generate-key-pair
```

Sign the container using the generated key pair:

```bash
cosign sign --key cosign.key $CONTAINER_NAME@sha256:<digest>
```

### 3. Verify the container

Verify the container using the public key:

```bash
cosign verify --key cosign.pub $CONTAINER_NAME@sha256:<digest>
```

## Conclusion

In this lab we have signed and verified a container locally using cosign. In the next lab we will sign and verify the container by keyless signing using sigstore and GitHub Actions.

## Next

Proceed to [Lab 2](../lab-2/README.md) >