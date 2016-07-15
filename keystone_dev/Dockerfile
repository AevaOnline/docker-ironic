FROM ubuntu

MAINTAINER Devananda van der Veen <devananda.vdv@gmail.com>

# Install all system prerequisites
RUN apt-get update && \
    apt-get install -y --no-install-recommends \
        libssl-dev libffi-dev libxslt1-dev gettext sqlite supervisor \
        python2.7 python-pip git && \
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
RUN pip --no-cache-dir install -U pip zmq redis python-openstackclient
ADD requirements/upper-constraints.txt /opt/
ADD ironic/requirements.txt /opt/
RUN pip --no-cache-dir install -c /opt/upper-constraints.txt -r /opt/requirements.txt
ADD keystone/requirements.txt /opt/
RUN pip --no-cache-dir install -c /opt/upper-constraints.txt -r /opt/requirements.txt

# Copy config files
ADD ironic/etc/ironic/* /etc/ironic/
ADD config/ironic-dev.conf /etc/ironic/ironic.conf

ADD keystone/etc/* /etc/keystone/
ADD config/keystone.conf /etc/keystone/keystone.conf

ADD config/supervisord.conf /etc/supervisord.conf

# Prepare sqlite DB
#RUN ironic-dbsync --config-file /etc/ironic/ironic.conf create_schema && \
#    chown ironic:ironic /etc/ironic/ironic.sqlite

EXPOSE 6385:6385
EXPOSE 35357:35357

#ENTRYPOINT ["/usr/bin/supervisord", "-c", "/etc/supervisord.conf"]
