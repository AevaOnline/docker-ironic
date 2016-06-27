FROM python

MAINTAINER Devananda van der Veen <devananda.vdv@gmail.com>

# Install all system prerequisites
RUN apt-get update && \
    apt-get install -y --no-install-recommends \
        libssl-dev libffi-dev libxslt1-dev gettext sqlite supervisor \
        ipmitool amtterm \
        qemu-utils dnsmasq nginx \
        tftp-hpa tftpd-hpa \
        syslinux syslinux-common ipxe pxelinux \
        && \
    apt-get -y autoremove && \
    apt-get clean

# Create service user and relevant directories
RUN useradd --user-group ironic && \
    mkdir -p /etc/ironic /var/log/ironic /var/log/supervisord /tftpboot /httpboot && \
    chown -R ironic: /etc/ironic /var/log/ironic /httpboot /tftpboot

# Install necessary python packages from PIP
RUN pip --no-cache-dir install \
        zmq redis \
        pbr SQLAlchemy alembic eventlet WebOb greenlet netaddr \
        paramiko ironic-lib pytz stevedore pysendfile websockify \
        oslo.concurrency oslo.config oslo.context oslo.db oslo.rootwrap \
        oslo.i18n oslo.log oslo.middleware oslo.policy oslo.serialization \
        oslo.service oslo.utils pecan requests six jsonpatch WSME Jinja2 \
        keystonemiddleware oslo.messaging retrying oslo.versionedobjects \
        jsonschema psutil futurist

# Copy config files
ADD ironic/etc/ironic/* /etc/ironic/
ADD ironic.conf /etc/ironic/ironic.conf
ADD supervisord.conf /etc/ironic/supervisord.conf
ADD tftpboot-map-file /tftpboot/map-file

# Install ironic
COPY ironic.tar.gz /opt/ironic/ironic.tar.gz
RUN pip install /opt/ironic/ironic.tar.gz && rm /opt/ironic/ironic.tar.gz

# Prepare sqlite DB
RUN ironic-dbsync --config-file /etc/ironic/ironic.conf create_schema && \
    chown ironic:ironic /etc/ironic/ironic.sqlite

# ironic-api
EXPOSE 6385:6385
# tftp
EXPOSE 69:69
# dnsmasq
EXPOSE 53:53

ENTRYPOINT ["/usr/bin/supervisord", "-c", "/etc/ironic/supervisord.conf"]
