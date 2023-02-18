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
❯ cosign sign --key cosign.key dockeruser/my-container:tag
```

### Verifying a Docker image
```bash
❯ cosign verify --key cosign.pub dockeruser/my-container:tag
```

### Attach an SBOM to a Docker image
```bash
❯ cosign attach sbom --sbom my.spdx dockeruser/my-container:tag
…
Uploading SBOM file for [index.docker.io/dockeruser/my-container:tag] to [index.docker.io/dockeruser/my-container:sha256-xxxx.sbom] with mediaType [text/spdx].
```

### Sign the SBOM
```bash
❯ cosign sign --key cosign.key dockeruser/my-container:sha256-xxxx.sbom
```

### Verify the SBOM
```bash
❯ cosign verify --key cosign.pub dockeruser/my-container:sha256-xxxx.sbom
```
