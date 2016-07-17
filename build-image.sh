#!/bin/sh

source ./settings.conf

docker build -t "$IMAGE" .
