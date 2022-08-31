# syntax=docker/dockerfile:1
FROM golang:1.16-alpine
WORKDIR /app
RUN apk add --update git
RUN apk add --update gcc
RUN apk add --update g++
RUN apk add --update openssh-client
RUN git clone -b dev https://github.com/tdahar/vouch.git ./
RUN git submodule update --init --recursive
COPY vouch.yml ./
RUN go mod download
RUN go build -o ./vouch-scorer

ENTRYPOINT ./vouch-scorer --base-dir ./