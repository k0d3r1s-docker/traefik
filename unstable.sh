#!/bin/sh

rm -rf src

cd ./source || exit
git reset --hard
git pull
VERSION=`git rev-parse --short HEAD`

cd .. || exit

cp -r source src

cd ./src || exit

rm -rf ./dist/ ./.github
sed -i 's/ARG DOCKER_VERSION=18.09.7/ARG DOCKER_VERSION=20.10.14/g' build.Dockerfile
sed -i 's/FROM golang:1.17-alpine/FROM golang:1.17.9-alpine3.15/g' build.Dockerfile
sed -i 's/apk --no-cache --no-progress/apk --no-cache --no-progress --upgrade --update -X http:\/\/dl-cdn.alpinelinux.org\/alpine\/edge\/testing/g' build.Dockerfile
make

cd .. || exit

docker build --tag k0d3r1s/traefik:${VERSION} --tag k0d3r1s/traefik:unstable --squash --compress --no-cache -f Dockerfile.unstable . || exit

rm -rf src

docker push k0d3r1s/traefik:${VERSION}
docker push k0d3r1s/traefik:unstable

docker system prune -af --volumes
