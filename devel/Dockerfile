FROM python:2

MAINTAINER Devananda van der Veen <devananda.vdv@gmail.com>

EXPOSE 6385
EXPOSE 35357

# Install all system prerequisites
RUN apt-get update && \
    apt-get install -y --no-install-recommends \
        libssl-dev libffi-dev libxslt1-dev gettext sqlite supervisor git && \
    apt-get -y autoremove && \
    apt-get clean

# Create service user and relevant directories
RUN useradd --user-group ironic && \
    mkdir -p /etc/ironic /var/log/ironic /var/log/supervisord /tftpboot /httpboot && \
    chown -R ironic: /etc/ironic /var/log/ironic /httpboot /tftpboot

# Create service user and relevant directories
RUN useradd --user-group keystone && \
    mkdir -p /etc/keystone /var/log/keystone && \
    chown -R keystone: /etc/keystone /var/log/keystone

# Install necessary python packages from PIP
RUN pip --no-cache-dir install -U pip zmq redis python-openstackclient python-ironicclient setuptools

#ADD requirements/upper-constraints.txt /opt/
#COPY ironic.tar.gz /opt/ironic.tar.gz
#COPY keystone.tar.gz /opt/keystone.tar.gz
#RUN pip --no-cache-dir install -c /opt/upper-constraints.txt /opt/keystone.tar.gz /opt/ironic.tar.gz

#COPY ironic /opt/source/ironic
#COPY keystone /opt/source/keystone

RUN mkdir /opt/source && cd /opt/source && \
    git clone --depth=1 https://github.com/openstack/ironic && \
    git clone --depth=1 https://github.com/openstack/keystone && \
    cd /opt/source/ironic && pip install -e . && \
    cd /opt/source/keystone && pip install -e .

# Copy config files
ADD ironic/etc/ironic/* /etc/ironic/
ADD config/ironic-dev.conf /etc/ironic/ironic.conf

ADD keystone/etc/* /etc/keystone/
ADD config/keystone.conf /etc/keystone/keystone.conf

RUN ironic-dbsync create_schema && \
    chown ironic:ironic /etc/ironic/ironic.sqlite && \
    keystone-manage db_sync && \
    chown keystone:keystone /etc/keystone/keystone.sqlite

RUN OS_BOOTSTRAP_USERNAME=admin \
    OS_BOOTSTRAP_PASSWORD=admin_pass \
    OS_BOOTSTRAP_PROJECT_NAME=local \
    OS_BOOTSTRAP_ADMIN_URL=http://127.0.0.1:35357/v3 \
    OS_BOOTSTRAP_PUBLIC_URL=http://127.0.0.1:35357/v3 \
    OS_BOOTSTRAP_INTERNAL_URL=http://127.0.0.1:35357/v3 \
    OS_BOOTSTRAP_SERVICE_NAME=keystone \
    keystone-manage bootstrap

COPY config/supervisord.conf /etc/supervisord.conf
COPY register.sh /etc/init.d/

#ENTRYPOINT ["/usr/bin/supervisord", "-c", "/etc/supervisord.conf"]

CMD /usr/bin/supervisord -c /etc/supervisord.conf
