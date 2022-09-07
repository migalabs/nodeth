# syntax=docker/dockerfile:1
ARG CACHEBUST=0
FROM ubuntu:18.04

ENV NIM_VERSION 0.14.2
RUN apt-get update && apt-get -y install build-essential git cmake

RUN git clone --branch verify-randao https://github.com/michaelsproul/nimbus-eth2.git /app
WORKDIR /app
RUN git submodule update --init --recursive
RUN make -v
RUN make -d -j4 nimbus_beacon_node
# ADD ./run-mainnet-beacon-node.sh /entrypoint.sh
ENTRYPOINT ["./run-mainnet-beacon-node.sh"]