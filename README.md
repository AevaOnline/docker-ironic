This repo contains the dockerfiles and related configs and scripts for building
docker images for Ironic. 

The "allinone" image builds a tarball release of a specific version of Ironic,
bakes that into the docker image, and will publish that image for others to
use.  It's an allinone minimal image, using 0mq and sqlite intead of rabbit and
mysql.  Don't try to use this on more than one host.

The "devel" image should mount your ironic source dir as a volume and allow
live editing of the code (locally) while running everything in the container.
It doesn't work yet :)
