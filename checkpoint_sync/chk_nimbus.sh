export $(grep -v '^#' .env | xargs)
sudo mkdir -p ${NIMBUS_DATA_FOLDER}/.nimbus
sudo chown -R $2:$2 ${NIMBUS_DATA_FOLDER}/.nimbus
sudo docker run --rm --network=host -v ${NIMBUS_DATA_FOLDER}/.nimbus:/home/user/.cache/nimbus/BeaconNode statusim/nimbus-eth2:${NIMBUS_TAG} trustedNodeSync \
  --network:${NETWORK} \
  --trusted-node-url="$1"