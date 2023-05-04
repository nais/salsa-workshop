# Lab 4: Managing policies at scale

## Goal

In this lab we will learn how to manage Kyverno policies at scale using the Kyverno Policy Reporter.

### Policy Reporter

Policy Reporter was created to make the results of your Kyverno validation policies more visible and observable. By default, Kyverno provides the option to create your validation policies in audit or enforce mode. While enforce blocks to applying a manifests that violate the given policy, audit creates PolicyReports that provide information about all resources that pass or fail your policies. Because Policy Reports are simple Custom Resorce Definitions you can access them with kubectl get/describe.

The disadvantages of these PolicyReports are that the results of a policy can be spread across multiple namespaces and both, the passed and failed results of multiple policies, are combined into one PolicyReport. This makes it difficult to find all failed results of a single ClusterPolicy. Since a PolicyReport contains all the results of a namespace, it is also difficult to check for new violations by new policies or resources.

Policy Reporter helps with this problems by providing different features based on PolicyReports:

* New violations can be send to different clients like Grafana Loki, Elasticsearch, Slack, Discord or MS Teams
* The optional metrics endpoint can be used to observe violations in monitoring tools like Grafana
* Policy Reporter provides also a standalone Dashboard to get a graphical overview of all results with filter and an optional Kyverno Plugin to get also information about your Kyverno policies.

## Steps

Install Kyverno Policy Reporter:

```bash
helm install kyverno-policy-reporter kyverno/policy-reporter --namespace kyverno --create-namespace
```

Check that the Policy Reporter is running:

```bash
kubectl get pods -n kyverno
```

Check the Policy Reporter dashboard:

```bash
kubectl port-forward -n kyverno svc/kyverno-policy-reporter 8080:80
```

Open http://localhost:8080 in your browser.

Check the Policy Reporter metrics:

```bash
kubectl port-forward -n kyverno svc/kyverno-policy-reporter 8081:8081
```

Open http://localhost:8081/metrics in your browser.

Check the Policy Reporter plugin:

```bash
kubectl port-forward -n kyverno svc/kyverno-policy-reporter 8082:8082
```

Open http://localhost:8082 in your browser.
