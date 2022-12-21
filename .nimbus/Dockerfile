# syntax=docker/dockerfile:1
ARG CACHEBUST=0
FROM ubuntu:18.04

ENV NIM_VERSION 0.14.2
RUN apt-get update && apt-get -y install build-essential git cmake

RUN git clone -b unstable https://github.com/status-im/nimbus-eth2.git /app
WORKDIR /app
RUN git checkout ad7541
RUN git checkout ad7541567c8ca39387dc23fcde97cdc8601b041b
RUN git submodule update --init --recursive
RUN make -d -j4 nimbus_beacon_node
# ADD ./run-mainnet-beacon-node.sh /entrypoint.sh
ENTRYPOINT ["./run-mainnet-beacon-node.sh"]