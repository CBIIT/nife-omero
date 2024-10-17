FROM --platform=linux/amd64 openmicroscopy/omero-server:latest

USER root

RUN dnf -y update && \
    dnf -y install file gzip && \
    dnf clean all
    
# Install IMOD
ENV IMOD_VERSION=4.11.25
ENV IMOD_DIR="/usr/local/IMOD"
ENV PATH="${IMOD_DIR}/bin:${PATH}"
RUN pushd /tmp && \
    curl -O https://bio3d.colorado.edu/imod/AMD64-RHEL5/imod_${IMOD_VERSION}_RHEL7-64_CUDA10.1.sh && \
    chmod +x imod_${IMOD_VERSION}_RHEL7-64_CUDA10.1.sh && \
    ./imod_${IMOD_VERSION}_RHEL7-64_CUDA10.1.sh -y && \
    rm -f imod_${IMOD_VERSION}_RHEL7-64_CUDA10.1.sh

# Install Webknossos CLI
ENV WEBKNOSSOS_VERSION=0.15.6
RUN python3 -m pip install "webknossos[all]==${WEBKNOSSOS_VERSION}"

# Ensure omero is in the PATH
ENV PATH="/opt/omero/server/OMERO.server/bin:${PATH}"

# Ensure the omero-server user has access to the OMERO.server directory
RUN chown -R omero-server:omero-server /opt/omero/server

USER omero-server