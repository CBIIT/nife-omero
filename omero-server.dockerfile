FROM --platform=linux/amd64 openmicroscopy/omero-server:latest

USER root

RUN dnf -y update && \
    dnf -y install file gzip && \
    dnf clean all

# Install IMOD
RUN pushd /tmp && \
    curl -O https://bio3d.colorado.edu/imod/AMD64-RHEL5/imod_4.11.25_RHEL7-64_CUDA10.1.sh && \
    chmod +x imod_4.11.25_RHEL7-64_CUDA10.1.sh && \
    ./imod_4.11.25_RHEL7-64_CUDA10.1.sh -y && \
    rm -f imod_4.11.25_RHEL7-64_CUDA10.1.sh

ENV IMOD_DIR="/usr/local/IMOD"
ENV PATH="${IMOD_DIR}/bin:${PATH}"

# Install Webknossos CLI
RUN pip3 install "webknossos[all]==0.15.6"

# Ensure omero is in the PATH

ENV PATH="/opt/omero/server/OMERO.server/bin:${PATH}"

# RUN chown -R omero-server:omero-server /opt/omero/server

USER omero-server