#!/bin/sh

set -e

source ./settings.conf

docker run \
    --detach=true \
    --name="$CONTAINER" \
    --publish="$CONTAINER_PORT_HTTP:$HOST_PORT_HTTP" \
    --publish="$CONTAINER_PORT_RI:$HOST_PORT_RI" \
    --publish="$CONTAINER_PORT_RO:$HOST_PORT_RO" \
    --publish="$CONTAINER_PORT_SBS:$HOST_PORT_SBS" \
    --publish="$CONTAINER_PORT_BI:$HOST_PORT_BI" \
    --publish="$CONTAINER_PORT_BO:$HOST_PORT_BO" \
    "$IMAGE"
