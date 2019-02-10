FROM zendesk/samson:latest

# Install docker cli to build images from Samson on the host
ENV DOCKER_VERSION=18.09.1
RUN curl -fsSLO https://download.docker.com/linux/static/stable/x86_64/docker-${DOCKER_VERSION}.tgz \
  && mv docker-${DOCKER_VERSION}.tgz docker.tgz \
  && tar xzvf docker.tgz \
  && mv docker/docker /usr/local/bin \
  && rm -r docker docker.tgz

RUN apt-get update && apt-get install --no-install-recommends -y \
	python-dev=2.7.13-2 \
	unzip=6.0-21 \
	&& rm -rf /var/lib/apt/lists/*

RUN curl -o /get-pip.py https://bootstrap.pypa.io/get-pip.py && \
	python /get-pip.py && \
	rm /get-pip.py

RUN pip install jmespath docker boto3 botocore ansible

RUN apt install unzip
ENV PACKER_VERSION=1.3.4
RUN curl -o /tmp/packer.zip https://releases.hashicorp.com/packer/${PACKER_VERSION}/packer_${PACKER_VERSION}_linux_amd64.zip && \
	unzip /tmp/packer.zip && \
	mv packer /usr/local/bin/

# Samson hangs when cloning new repositories during the first container boot.
# Scan github keys during the build to prevent this
RUN mkdir ~/.ssh/ && ssh-keyscan -H github.com >> ~/.ssh/known_hosts
