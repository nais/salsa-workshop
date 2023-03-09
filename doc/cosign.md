# cosign cheat sheet

## Using local keys

Local keys are the ones that you create and store on your own infrastructure. 

Make sure to properly protect your private keys.

The easiest way to make your public keys easily accessible to everyone that needs them is to host them on a HTTP URL. 

### Generate a keypair
```bash
❯ cosign generate-key-pair
Enter password for private key:
Enter password for private key again:
Private key written to cosign.key
Public key written to cosign.pub
```

### Sign an arbitrary blob
```bash
❯ cosign sign-blob --key cosign.key --output-signature myfile.sig myfile
Using payload from: myfile
Enter password for private key:
Signature wrote in the file myfile.sig
```

### Verifying an arbitrary blob
```bash
❯ cosign verify-blob --key cosign.pub --signature myfile.sig myfile
Verified OK
```

### Signing a Docker image
```bash
❯ cosign sign --key cosign.key dockeruser/my-container@sha256:<shasum>
```

### Verifying a Docker image
```bash
❯ cosign verify --key cosign.pub dockeruser/my-container@sha256:<shasum>
```

### Attach an SBOM to a Docker image
```bash
❯ cosign attach sbom --sbom my.spdx dockeruser/my-container@sha256:<shasum>
…
Uploading SBOM file for [index.docker.io/dockeruser/my-container@sha256:xxxx] to [index.docker.io/dockeruser/my-container:sha256-xxxx.sbom] with mediaType [text/spdx].
```

### Sign the SBOM
```bash
❯ cosign sign --key cosign.key dockeruser/my-container:sha256-xxxx.sbom
```

### Verify the SBOM
```bash
❯ cosign verify --key cosign.pub dockeruser/my-container:sha256-xxxx.sbom
```

## Using remote keys

Remote keys are stored in some type of key vault, typically the ones that are offered by the major cloud vendors. Some of them offer additional security by being backed by dedicated [hardware security modules](https://en.wikipedia.org/wiki/Hardware_security_module).

### Hashicorp Vault

```bash
# Generate key pair
❯ cosign generate-key-pair --kms hashivault://$keyname
Public key written to cosign.pub

# Sign blob
❯ cosign sign-blob --key hashivault://$keyname --output-signature myfile.sig myfile
Using payload from: myfile
Signature wrote in the file myfile.sig

# Verify against Vault
❯ cosign verify-blob --key hashivault://$keyname --signature myfile.sig myfile
Verified OK

# Verify using the public key file from previous step
cosign verify-blob --key cosign.pub --signature myfile.sig myfile
❯ Verified OK
```

The environment variables `VAULT_ADDR` and `VAULT_TOKEN` must be set

### Sign using a "Cloud KMS"

(Se detaljer i [cosign-dokumentasjonen](https://docs.sigstore.dev/cosign/kms_support/))

```bash
# AWS
❯ cosign sign-blob --key awskms://$ENDPOINT/$KEYID --output-signature myfile.sig myfile

# GCP
❯ cosign sign-blob --key gcpkms://projects/$PROJECT/locations/$LOCATION/keyRings/$KEYRING/cryptoKeys/$KEY/versions/$KEY_VERSION --output-signature myfile.sig myfile

# Azure
❯ cosign sign-blob --key azurekms://[VAULT_NAME][VAULT_URI]/[KEY] --output-signature myfile.sig myfile
```

### "Keyless" signing of images with Sigstore

Uses [OIDC](https://openid.net/connect/) to establish identity, generates ephemeral keys and certificates using [Fulcio](https://github.com/sigstore/fulcio), signs the payload and uploads the signature to the [Rekor](https://github.com/sigstore/rekor) transparency log. The Rekor entry is then used to perform validation in the future.  

The OIDC flow must be completed in a web browser. In automated environments (such as CI/CD pipelines) where the end user is not part of the flow Cosign supports using identity tokens from specific issuers. The `audience` claim in these tokens must contain `sigstore`. The issuers currently supported are Google Compute Engine, GitHub Actions and SPIFFE. 

> **Note**
> 
> Some metadata (including your email address) will be uploaded to the public transparency log, do not use this feature if you don't want to share this information with the world. 

#### Signing an arbitraty blob:

```bash
❯ cosign sign-blob --output-signature myfile.sig --output-certificate mycert.crt myfile
Using payload from: myfile
Generating ephemeral keys...
...
tlog entry created with index: 1234567
Signature wrote in the file myfile.sig
Certificate wrote in the file mycert.crt
```


#### GitHub Workflow example for signing a Docker image and attest a SBOM:

```yaml
name: Build, sign and push to the GitHub OCI registry
on:
  push:
    branches:
      - main
jobs:
  build:
    runs-on: ubuntu-20.04
    permissions:
      contents: read
      packages: write
      id-token: write
    env:
      IMG: ghcr.io/${{ github.repository }}
    steps:
      - name: Checkout latest code
        uses: actions/checkout@ac593985615ec2ede58e132d2e21d2b1cbd6127c
      - name: Set up QEMU
        uses: docker/setup-qemu-action@e81a89b1732b9c48d79cd809d8d81d79c4647a18
      - name: Set up Docker Buildx
        id: buildx
        uses: docker/setup-buildx-action@f03ac48505955848960e80bbb68046aa35c7b9e7
      - name: Login to container registry
        uses: docker/login-action@f4ef78c080cd8ba55a85445d5b36e214a81df20a
        with:
          registry: ghcr.io
          username: ${{ github.actor }}
          password: ${{ secrets.GITHUB_TOKEN }}
      - name: Generate Docker image tag with short sha
        id: dockertag
        run: echo "tag=$(git rev-parse --short HEAD)" >> ${GITHUB_OUTPUT}
      - name: Build and push
        id: build-push
        uses: docker/build-push-action@3b5e8027fcad23fda98b2e3ac259d8d67585f671
        with:
          context: .
          file: Dockerfile
          platforms: linux/amd64,linux/arm64
          pull: true
          push: true
          tags: ${{ env.IMG }}:${{ steps.dockertag.outputs.tag }}
          cache-from: type=gha
          cache-to: type=gha,mode=max
      - name: Install cosign
        uses: sigstore/cosign-installer@4079ad3567a89f68395480299c77e40170430341
        with:
          cosign-release: 'v2.0.0'
      - name: Sign the container image
        run: cosign sign --yes ${{ IMG }}@${{ steps.build-push.outputs.digest }}
      - name: Attest image
        run: cosign attest --yes \
        --predicate cyclone.sbom.json \
        --type  cyclonedx \
        ${{ IMG }}@${{ steps.buildpush.outputs.digest }}
```

#### Verifying an image:
```bash
❯ cosign verify \
--certificate-identity "https://github.com/org/repo/.github/workflows/filename.yaml@refs/heads/main" \
--certificate-oidc-issuer "https://token.actions.githubusercontent.com"
ghcr.io/myuser/myimage@sha256<shasum>
...
<json with metadata>
```

#### Verifying an attestation:
```bash
❯ cosign verify-attestation \
-- type cyclonedx \
--certificate-identity "https://github.com/org/repo/.github/workflows/filename.yaml@refs/heads/main" \
--certificate-oidc-issuer "https://token.actions.githubusercontent.com"
ghcr.io/myuser/myimage@sha256<shasum>
...
<json with metadata>
```