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