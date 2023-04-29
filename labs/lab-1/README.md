# Lab 1: Sign and verify containers locally using cosign

## Goal

In this lab we will sign and verify containers using [sigstore/cosign](https://docs.sigstore.dev/cosign/) locally. The goal is to get familiar with the tooling and the process of signing and verifying containers.

### Cosign

Cosign is a tool for signing and verifying container images. It is developed by the sigstore project and is currently in alpha.

## Steps

Make a funny name for your container:

```bash
export CONTAINER_NAME="ttl.sh/salsa-workshpp-$(shuf -n1 /usr/share/dict/words):1h"
echo "Your chosen container name is $CONTAINER_NAME"
```

### 1. Build the example container

In the root of this repository we have created an example application with a simple Dockerfile, run the following command:

```bash
docker build -t $CONTAINER_NAME .
docker push $CONTAINER_NAME
```

### 2. Sign the container

Generate a key pair for local signing:

```bash
cosign generate-key-pair
```

Sign the container using the generated key pair:

```bash
cosign sign --key cosign.key $CONTAINER_NAME
```

### 3. Verify the container

Verify the container using the public key:

```bash
cosign verify --key cosign.pub $CONTAINER_NAME
```

## Conclusion

In this lab we have signed and verified a container locally using cosign. In the next lab we will sign and verify the container by keyless signing using sigstore and GitHub Actions.

## Next

Proceed to [Lab 2](../lab-2/README.md) >