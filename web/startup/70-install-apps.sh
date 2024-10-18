#!/bin/bash

APP_DIR="/apps"

for app in "$APP_DIR"/*; do
  if [ -d "$app" ]; then
    echo "Installing $app"
    pip install -e "$app"
    omero config append omero.web.apps "\"$(basename $app)\""
  fi
done