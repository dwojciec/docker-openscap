FROM registry.access.redhat.com/rhel7/rhel
MAINTAINER Samuel Terburg <sterburg@redhat.com>

LABEL io.k8s.display-name="OpenSCAP Docker-image Scanner" \
      io.k8s.description="Scans docker images for vulnerabilities. Upon clean promote image to OpenShift's public service catalog."

ADD bin/*  /usr/local/bin/

RUN yum install -y \
        --enablerepo=rhel-7-server-rpms \
        --enablerepo=rhel-7-server-extras-rpms \
        --enablerepo=rhel-7-server-optional-rpms \
	openssl \
	openscap-utils \
	openscap-scanner \
#	openscap-engine-sce \
        openscap-content \
        openscap-extra-probes \
        docker-common \
        docker \
	wget \
	which \
        rpm \
        ssmtp \
        html2text

ADD conf/* /etc/

WORKDIR /data
VOLUME ["/data"]

ENTRYPOINT ["/bin/bash","/usr/local/bin/entrypoint.sh"]
