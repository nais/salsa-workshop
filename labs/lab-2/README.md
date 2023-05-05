# Lab 2: Sign and verify containers using Sigstore and GitHub Actions

## Goal

In this lab we will sign and verify containers using [sigstore](https://sigstore.dev/) and GitHub Actions. The goal is to get familiar with the tooling and the process of signing and verifying containers at scale.

When you sign and/or attest an image cosign will upload the artifacts to the OCI registry alongside your image.

If you get stuck, ask for help or take a peek at the Git branch named "solution".

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
        uses: docker/build-push-action@3b5e8027fcad23fda98b2e3ac259d8d67585f671 # ratchet:docker/build-push-action@v4
        with:
          …
          push: true
          …
```

Next we need to install cosign so that we have the cosign binary in our workflow:

```yaml
      - name: Install cosign
        uses: sigstore/cosign-installer@204a51a57a74d190b284a0ce69b44bc37201f343 # ratchet:sigstore/cosign-installer@main
        with:
          cosign-release: 'v2.0.0'
```

Once we have cosign we can sign the container using the following command:

```yaml
      - name: Sign the container image
        run: cosign sign --yes ghcr.io/${{ github.repository }}@${{ steps.build-push.outputs.digest }}
```

We also create a SBOM to document the contents of our app:

> SBOM stands for Software Bill of Materials and is a list of components that are used to build a software artifact. SBOMs are used to track the components that are used in a software artifact and to identify vulnerabilities in those components.
> In this example we will be using the aquasecurity/trivy-action to generate the SBOM. The action is currently in alpha and is being developed by Aqua Security.

```yaml
      - name: Create SBOM
        uses: aquasecurity/trivy-action@e5f43133f6e8736992c9f3c1b3296e24b37e17f2 # ratchet:aquasecurity/trivy-action@master
        with:
          scan-type: 'image'
          format: 'cyclonedx'
          output: 'cyclone.sbom.json'
          image-ref: ghcr.io/${{ github.repository }}@${{ steps.build-push.outputs.digest }}
```

Finally we sign the SBOM and attach it to our image:

```yaml
      - name: Attest image
        run: cosign attest --yes --predicate cyclone.sbom.json --type cyclonedx ghcr.io/${{ github.repository }}@${{ steps.build-push.outputs.digest }}
```

Commit and push the changes to the repository and the workflow will start running.
Once the workflow has finished you can copy the image digest from the workflow log or the `packages` part of the GitHub UI. You will need this digest in the next step as well as in the next lab.
The signature can be verified by running the following command:

```bash
cosign verify-attestation \
  --type cyclonedx \
  --certificate-identity "https://github.com/<user>/salsa-workshop/.github/workflows/main.yaml@refs/heads/main" \
  --certificate-oidc-issuer "https://token.actions.githubusercontent.com" ghcr.io/<user>/salsa-workshop@sha256:<digest>
```

## Conclusion

In this lab we have signed and verified a container using Sigstore and GitHub Actions. We also attested the image by adding and signing a SBOM.

## Next

Proceed to [Lab 3](../lab-3/README.md) >
