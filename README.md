## Introduction
Simpel small OpenSCAP scanner that scans docker-images for CVE vulnerabilities.
On Success promote the docker-image to   the OpenShift Marketplace.
On Failure remove  the docker-image from the OenShift Marketplace.
Email the OpenSCAP report to the owner.


## Build the OpenSCAP Scanner container
```shell
oc new-project image-staging
oc policy add-role-to-user view                -z default
oc policy add-role-to-user system:image-puller -z default
oc policy add-role-to-user system:image-pusher -z default
oc policy add-role-to-user system:image-pusher system:serviceaccount:image-staging:default -n openshift
oc policy add-role-to-user view system:serviceaccount:image-staging:default -n openshift
oadm policy add-scc-to-user privileged -z default


oc new-app https://github.com/sterburg/docker-openscap.git
oc start-build openscap --follow --wait

oc create -f examples/scanner-template.yaml
```
The deploymentconfig can be used for testing/debugging. It has not other use-case.


## For every image
For every image that you want to monitor & scan new version & promote to the OpenShift Marketplace
```
oc new-app --template=scanner -p IMAGE=docker.io/sterburg/docker-oracle-xe-11g:latest -p TAG=latest -p NAME=docker-oracle-xe-11g -p EMAIL=sterburg@redhat.com
```

## Deprecated
```
oc env dc/openscap IMAGE=registry.access.redhat.com/rhel7/rhel:latest EMAIL_RESULT=wolfram_s@schiphol.n
oc volume dc/openscap --add --type=hostPath --path=/var/run/docker.sock --mount-path=/var/run/docker.sock --name=docker-sock
oc patch dc/openscap --patch='{"spec": { "template" : { "spec": {"containers": [{ "name": "openscap", "securityContext": { "privileged": true } } ] }  }}}'
```
