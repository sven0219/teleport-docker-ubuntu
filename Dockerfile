# https://github.com/gravitational/teleport/blob/master/build.assets/charts/Dockerfile

# DEPRECATED: Images from this dockerfile are not published for v15 and above
# https://goteleport.com/docs/changelog/#heavy-container-images-are-discontinued
# Teleport images are built from Dockerfile-distroless
# TODO(hugoShaka): cleanup the Makefile docker/image targets and remove this file.

# Stage to build the image, without FIPS entrypoint argument
FROM ubuntu:20.04 AS teleport

# Install dumb-init and ca-certificates. The dumb-init package is to ensure
# signals and orphaned processes are handled correctly. The ca-certificates
# package is installed because the base Ubuntu image does not come with any
# certificate authorities. libelf1 is a dependency introduced by Teleport 7.0.
#
# The below packages are provided for debug purposes. Installing them adds around
#  six megabytes to the image size. The packages include the following commands:
# * net-tools
#   * netstat
#   * ifconfig
#   * ipmaddr
#   * iptunnel
#   * mii-tool
#   * nameif
#   * plipconfig
#   * rarp
#   * route
#   * slattach
#   * arp
# * iputils-ping
#   * ping
#   * ping4
#   * ping6
# * netcat
#   * netcat
# * tcpdump
#   * tcpdump
# * busybox (see "busybox --list" for all provided utils)
#   * less
#   * nslookup
#   * vi
#   * wget

# Note that /var/lib/apt/lists/* is cleaned up in the same RUN command as
# "apt-get update" to reduce the size of the image.
RUN apt-get update && \
    DEBIAN_FRONTEND=noninteractive apt-get upgrade -y && \
    # Install dependencies
    DEBIAN_FRONTEND=noninteractive apt-get install --no-install-recommends -y ca-certificates dumb-init libelf1 && \
    # Install tools
    DEBIAN_FRONTEND=noninteractive apt-get install --no-install-recommends -y net-tools iputils-ping netcat tcpdump busybox && \
    busybox --install -s && \
    update-ca-certificates && \
    # Cleanup
    apt-get -y clean && \
    rm -rf /var/lib/apt/lists/*


ARG PACKAGE_URL

# Note https://goteleport.com/download/
RUN apt-get update && \
    DEBIAN_FRONTEND=noninteractive apt-get install --no-install-recommends -y curl && \
    curl -L $PACKAGE_URL -o /tmp/package.deb && \
    dpkg -i /tmp/package.deb && \
    rm /tmp/package.deb

# Used to track whether a Teleport agent was installed using this method.
ENV TELEPORT_INSTALL_METHOD_DOCKERFILE=true

# Attempt a graceful shutdown by default
# See https://goteleport.com/docs/reference/signals/ for signal reference.
STOPSIGNAL SIGQUIT

# By setting this entry point, we expose make target as command.
ENTRYPOINT ["/usr/bin/dumb-init", "teleport", "start", "-c", "/etc/teleport/teleport.yaml"]
