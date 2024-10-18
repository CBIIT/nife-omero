FROM --platform=linux/amd64 openmicroscopy/omero-web-standalone:latest

USER root

RUN dnf -y update && \
    dnf clean all

RUN python3 -m pip install --upgrade pip

RUN chown -R omero-web:omero-web /opt/omero/web
