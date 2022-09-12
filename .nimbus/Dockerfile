# syntax=docker/dockerfile:1
ARG CACHEBUST=0
FROM ubuntu:18.04

ENV NIM_VERSION 0.14.2
RUN apt-get update && apt-get -y install build-essential git cmake

RUN git clone -b unstable https://github.com/tdahar/nimbus-eth2.git /app
WORKDIR /app
RUN git submodule update --init --recursive
RUN git remote add sproul https://github.com/michaelsproul/nimbus-eth2.git
RUN git fetch sproul
RUN git config user.email "tarsuno@gmail.com"
RUN git config user.name "Tarun Mohandas"
RUN git merge sproul/verify-randao
RUN make -v
RUN make -d -j4 nimbus_beacon_node
# ADD ./run-mainnet-beacon-node.sh /entrypoint.sh
ENTRYPOINT ["./run-mainnet-beacon-node.sh"]