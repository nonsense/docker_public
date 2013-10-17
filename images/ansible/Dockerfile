FROM base

# this forces dpkg not to call sync() after package extraction and
speeds up install
RUN echo "force-unsafe-io" > /etc/dpkg/dpkg.cfg.d/02apt-speedup
# we don't need and apt cache in a container
RUN echo "Acquire::http {No-Cache=True;};" > /etc/apt/apt.conf.d/no-cache

RUN apt-get update
RUN apt-get install -y wget sysklogd

RUN apt-add-repository ppa:rquillo/ansible
RUN apt-get install -y ansible

# python
RUN apt-get install -y python-setuptools python-dev python-pip python-apt

# ansible
RUN pip install ansible

# awx
RUN wget http://ansibleworks.com/releases/awx/setup/awx-setup-latest.tar.gz
RUN cd awx* && ./setup.sh
