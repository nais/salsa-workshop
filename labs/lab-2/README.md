# Lab 2: Sign and verify containers using sigstore and GitHub Actions

## Goal

In this lab we will sign and verify containers using [sigstore](https://sigstore.dev/) and GitHub Actions. The goal is to get familiar with the tooling and the process of signing and verifying containers at scale.

### Sigstore

Sigstore is an open source project that aims to make software supply chain security accessible to all open source projects. It is a collection of tools and services that enable the signing and verification of software artifacts. The project is currently in alpha and is being developed by the Linux Foundation Public Health (LFPH) and the Open Source Security Foundation (OpenSSF).

## Steps

In this repository we have created an example GitHub Action workflow that builds our dockerized application. The workflow is located in [.github/workflows/build-and-sign.yml](.github/workflows/main.yaml).

What we need to do is to add a step to the workflow that signs the container after it has been built and pushed to the registry.

First we need to update the permissions of the id token that is used to authenticate with the registry. We do this by adding the `packages: write` in order to push the image and `id-token: write` in order to sign the image.

```yaml
    permissions:
      contents: read
      packages: write
      id-token: write
```

In the `Build and push` step we need to enable pushing the image to the registry by setting the `push` flag to true:

```yaml
      - name: Build and push
        uses: docker/build-push-action@v4
        with:
          …
          push: true
          …
```

Next we need to install cosign so that we have the cosign binary in our workflow:

```yaml
      - name: Install cosign
        uses: sigstore/cosign-installer@main
        with:
          cosign-release: 'v2.0.0'
```

Once we have cosign we can sign the container using the following command:

```yaml
      - name: Sign the container image
        run: cosign sign --yes ghcr.io/${{ github.repository }}@${{ steps.build-push.outputs.digest }}
```

Before we attest the image signature let's add an SBOM to our artifact as well:

> SBOM stands for Software Bill of Materials and is a list of components that are used to build a software artifact. SBOMs are used to track the components that are used in a software artifact and to identify vulnerabilities in those components.
> In this example we will be using the aquasecurity/trivy-action to generate the SBOM. The action is currently in alpha and is being developed by Aqua Security.

```yaml
      - name: Create SBOM
        uses: aquasecurity/trivy-action@master
        with:
          scan-type: 'image'
          format: 'cyclonedx'
          output: 'cyclone.sbom.json'
          image-ref: ghcr.io/${{ github.repository }}@${{ steps.build-push.outputs.digest }}
```

Finally we are ready to attest the image signature using the SBOM:

```yaml
      - name: Attest image
        run: cosign attest --yes --predicate cyclone.sbom.json --type cyclonedx ghcr.io/${{ github.repository }}@${{ steps.build-push.outputs.digest }}
```

Commit and push the changes to the repository and the workflow will start running. Once the workflow has finished running you can copy the verify the signature by running the following command:

```bash
cosign verify-attestation \
  --type cyclonedx \
  --certificate-identity "https://github.com/noeannet/tokendings/.github/workflows/master.yml@refs/heads/master" \
  --certificate-oidc-issuer "https://token.actions.githubusercontent.com" ghcr.io/nais/tokendings@sha256:43201a7b30a38a4790d541323a3d53720c41316b187c2f0472af2bca4cbd221c
```

## Conclusion

In this lab we have signed and verified a container using sigstore and GitHub Actions. We have also added an SBOM to the container and used it to attest the signature.

## Next

Proceed to [Lab 3](../lab-3/README.md) >
