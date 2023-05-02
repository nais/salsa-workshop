# Lab 3: Verifying signed containers in a Kubernetes cluster

## Goal

In this lab we will verify signed containers in a Kubernetes cluster using [kyverno](https://kyverno.io/). The goal is to get familiar with the tooling and the process of verifying signed containers in a Kubernetes cluster.

### Kyverno

Kyverno is a policy engine designed for Kubernetes. It can validate, mutate, and generate configurations using admission controls and background scans. Kyverno policies are Kubernetes resources and do not require learning a new language.

## Steps

Start Minikube:

```bash
minikube start
```

Check that the cluster is running:

```bash
kubectl get nodes
```

Install kyverno:

```bash
helm repo add kyverno https://kyverno.github.io/kyverno/
helm repo update
helm install kyverno kyverno/kyverno --namespace kyverno --create-namespace
```

Nw we will create a policy that verifies that all containers in a pod are signed.
Create a file called `verify-signed-containers.yaml` with the following contents:

```yaml
apiVersion: kyverno.io/v1
kind: ClusterPolicy
metadata:
  name: verify-slsa-provenance-keyless
  annotations:
    policies.kyverno.io/title: Verify SLSA Provenance (Keyless)
    policies.kyverno.io/category: Software Supply Chain Security
    policies.kyverno.io/severity: medium
    policies.kyverno.io/subject: Pod
    policies.kyverno.io/minversion: 1.8.3
    kyverno.io/kyverno-version: 1.9.0
    kyverno.io/kubernetes-version: "1.24"
    policies.kyverno.io/description: >-
      Provenance is used to identify how an artifact was produced
      and from where it originated. SLSA provenance is an industry-standard
      method of representing that provenance. This policy verifies that an
      image has SLSA provenance and was signed by the expected subject and issuer
      when produced through GitHub Actions. It requires configuration based upon
      your own values.
spec:
  validationFailureAction: Enforce
  webhookTimeoutSeconds: 30
  rules:
    - name: check-slsa-keyless
      match:
        any:
          - resources:
              kinds:
                - Pod
      verifyImages:
        - imageReferences:
            - "https://github.com/<user>/salsa-workshop/*"
          attestors:
            - entries:
                - keyless:
                    subject: "https://github.com/<user>/salsa-workshop/*"
                    issuer: "https://token.actions.githubusercontent.com"
                    rekor:
                      url: https://rekor.sigstore.dev
```

Apply the policy:

```bash
kubectl apply -f verify-signed-containers.yaml
```

Now we will run a pod that uses a container image that is *not* signed.

```bash
kubectl run --image=ghcr.io/<user>/salsa-workshop:unsigned salsa-workshop--restart=Never --image-pull-policy=Always
```

You will see that the pod is not running:

```bash
kubectl get pods
```

Now we will run a pod that uses a container image that is signed.

```bash
kubectl run --image=ghcr.io/<user>/salsa-workshop:main salsa-workshop--restart=Never --image-pull-policy=Always
```

Check that the pod is running:

```bash
kubectl get pods
```

## Conclusion

In this lab we verified signed containers in a Kubernetes cluster using [kyverno](https://kyverno.io/). We created a policy that verifies that all containers in a pod are signed and applied it to the cluster. We then ran a pod that uses a container image that is *not* signed and saw that the pod did not run. We then ran a pod that uses a container image that is signed and saw that the pod ran.

## Next

Proceed to [Lab 4](../lab-4/README.md) >
