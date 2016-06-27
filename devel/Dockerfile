FROM python

MAINTAINER Devananda van der Veen <devananda.vdv@gmail.com>

# Install all system prerequisites
RUN apt-get update && \
    apt-get install -y --no-install-recommends \
        libssl-dev libffi-dev libxslt1-dev gettext sqlite supervisor \
        && \
    apt-get -y autoremove && \
    apt-get clean

# Create service user and relevant directories
RUN useradd --user-group ironic && \
    mkdir -p /etc/ironic /var/log/ironic /var/log/supervisord /tftpboot /httpboot && \
    chown -R ironic: /etc/ironic /var/log/ironic /httpboot /tftpboot

# Install necessary python packages from PIP
ADD requirements/upper-constraints.txt /opt/
ADD ironic/requirements.txt /opt/
RUN pip --no-cache-dir install -U pip zmq redis
RUN pip --no-cache-dir install -c /opt/upper-constraints.txt -r /opt/requirements.txt

# Copy config files
ADD ironic/etc/ironic/* /etc/ironic/
ADD config/ironic.conf /etc/ironic/ironic.conf
ADD config/supervisord.conf /etc/ironic/supervisord.conf

# Install ironic
#RUN cd /opt/ironic && python setup.py devel

# Prepare sqlite DB
#RUN ironic-dbsync --config-file /etc/ironic/ironic.conf create_schema && \
#    chown ironic:ironic /etc/ironic/ironic.sqlite

# ironic-api
EXPOSE 6385:6385

ENTRYPOINT ["/usr/bin/supervisord", "-c", "/etc/ironic/supervisord.conf"]
