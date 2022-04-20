#!/bin/bash

VERSION=${1:-"2.5.4"}

MAJOR=`echo ${VERSION} | cut -d. -f1`
MINOR=`echo ${VERSION} | cut -d. -f2`
PATCH=`echo ${VERSION} | cut -d. -f3`

docker build --tag k0d3r1s/traefik:${MAJOR}.${MINOR}.${PATCH} --tag k0d3r1s/traefik:${MAJOR}.${MINOR} --tag k0d3r1s/traefik:${MAJOR} --tag k0d3r1s/traefik:latest --squash --compress --no-cache --build-arg version=${VERSION} . || exit 1

docker push k0d3r1s/traefik:${MAJOR}.${MINOR}.${PATCH}
docker push k0d3r1s/traefik:${MAJOR}.${MINOR}
docker push k0d3r1s/traefik:${MAJOR}
docker push k0d3r1s/traefik:latest
