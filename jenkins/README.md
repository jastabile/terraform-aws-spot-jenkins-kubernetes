# Install

Edit `<HOSTNAME>` in `jenkins_values.yaml` and `ingress.yaml` with the jenkins hostname 
```
helm upgrade --install jenkins jenkins \
  -f jenkins_values.yaml \
  --repo https://charts.jenkins.io/ \
  --version 4.2.9 \
  --namespace jenkins --create-namespace


kubectl apply -f ingress.yaml
```

Jenkins should be accesible visiting <HOSTNAME>


# Setup pod agents
Fill in the Kubernetes plugin configuration. In order to do that, you will open the Jenkins UI and navigate to Manage Jenkins -> Nodes -> Clouds -> Add a new cloud -> Kubernetes and set a name, since Jenkins is running in Kubernetes, we only need to check "webSocket" and set "Jenkins URL" with the service name in kubernetes, in my case:
JENKINS URL: http://jenkins.jenkins.svc.cluster.local:8080



## Static pod templates
In addition to that, in the Kubernetes Pod Template section, we need to configure the image that will be used to spin up the agent pod. The Jenkins agent runs by default in a container named jnlp (historical name, kept for backward compatibility).

You may use it, use a different agent container name and/or provide your own container image.

