#!/bin/sh

set -e

# Respect AZ_OUTPUT_FORMAT if specified
[ -n "$AZ_OUTPUT_FORMAT" ] || export AZ_OUTPUT_FORMAT=json

if [ -n "$AZURE_SERVICE_PEM" ]; then
  mkdir -p "$HOME/.az"
  echo "$AZURE_SERVICE_PEM" > "$HOME/.az/key.pem"
  export AZURE_SERVICE_PASSWORD="$HOME/.az/key.pem"
fi

az login --service-principal --username "$AZURE_SERVICE_APP_ID" --password "$AZURE_SERVICE_PASSWORD" --tenant "$AZURE_SERVICE_TENANT"

sh -c "az $* --output ${AZ_OUTPUT_FORMAT}"
