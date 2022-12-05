sudo docker run --network=host -v ${NIMBUS_DATA_FOLDER}/.nimbus:/home/user/.cache/nimbus/BeaconNode statusim/nimbus-eth2:amd64-v22.9.1 trustedNodeSync \
  --network:mainnet \
  --trusted-node-url="$1"