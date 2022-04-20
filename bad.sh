#!/bin/sh

rm -rf src
docker system prune -af --volumes

cd ./source || exit
git reset --hard
git pull
VERSION=`git rev-parse --short HEAD`

cd .. || exit

cp -r source src

cd ./src || exit

rm -rf ./dist/ ./.github ./webui/Dockerfile ./webui/package.json ./webui/package-lock.json ./webui/quasar.conf.js
cp ../Dockerfile.webui ./webui/Dockerfile
cp ../package.new.json ./webui/package.json
cp ../quasar.conf.js ./webui/quasar.conf.js
# sed -i 's/FROM node:14.16/FROM node:17.5.0/g' webui/Dockerfile
# sed -i 's/FROM node:14.16/FROM nikolaik\/python-nodejs:python3.8-nodejs17-alpine/g' webui/Dockerfile
sed -i 's/ARG DOCKER_VERSION=18.09.7/ARG DOCKER_VERSION=20.10.12/g' build.Dockerfile
# sed -i 's/FROM golang:1.17-alpine/FROM golang:1.18beta2-alpine3.15/g' build.Dockerfile
sed -i 's/FROM golang:1.17-alpine/FROM golang:1.17.6-alpine3.15/g' build.Dockerfile
make

cd .. || exit

# docker build --tag k0d3r1s/traefik:${VERSION} --tag k0d3r1s/traefik:unstable --squash --compress --no-cache -f Dockerfile.unstable . || exit
docker build --tag k0d3r1s/traefik:${VERSION}-dev --squash --compress --no-cache -f Dockerfile.unstable . || exit

rm -rf src

# docker push k0d3r1s/traefik:${VERSION}-dev
# docker push k0d3r1s/traefik:unstable
