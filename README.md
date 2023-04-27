# Spice up your supply chain

![slsa logo](img/slsa-logo.svg)

A spicy workshop where you will learn about [SLSA](https://slsa.dev/) and how to get started securing your supply chain.

We will sign and verify an app using [Cosign](https://github.com/sigstore/cosign) in a [GitHub workflow](https://docs.github.com/en/actions/quickstart).

## Pre-requisites

- [Docker](https://docs.docker.com/get-docker/)
- [Minikube](https://minikube.sigs.k8s.io/docs/start/)
- [GitHub account](https://github.com/signup)

## What is SALSA?

Several initiatives have been started in an attempt to address the issues surrounding supply chain integrity, the most noticeable one being Supply chain Levels for Software Artifacts - SLSA. SLSA aims to be vendor neutral and is backed by major players like the Cloud Native Computing Foundation and Google in addition to startups such as Chainguard.

### Cosign

Sigstore is a Linux Foundation project which is developing Cosign, a container signing, verification and storage in an Open Container Initiative (OCI) registry, making signatures invisible infrastructure.

### Kyverno

Kyverno is a policy engine designed for Kubernetes. With Kyverno, policies are managed as Kubernetes resources and no new language is required to write policies.

## What is this workshop about?

In this workshop we will make a practical approach to securing your container applications and verify that the container has not been tampered with since it was built.

 * Setting up automated container builds
 * Signing containers using [sigstore/cosign](https://github.com/sigstore/cosign)
 * Verifying signed containers using [Kyverno](https://kyverno.io/docs/writing-policies/verify-images/)
 * Working with Kyverno policy reports at scale

## Overview

The workshop is divided into 3 parts:

1. Introduction to SLSA
2. Setting up local environment
3. Signing containers
4. Verifying signed containers
5. Policies at scale