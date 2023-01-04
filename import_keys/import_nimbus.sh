export $(grep -v '^#' .env | xargs)

for d in ${VALIDATOR_KEYS_FOLDER}/nimbus/keys/*; do
	sudo cat ${VALIDATOR_KEYS_FOLDER}/nimbus/secret.txt | tee | sudo docker run --rm -i --network=host \
 	-v ${NIMBUS_DATA_FOLDER}/.nimbus:/home/user/.cache/nimbus/BeaconNode \
	-v $d:/key_folder \
	statusim/nimbus-eth2:${NIMBUS_TAG} deposits import \
  	/key_folder
	echo "finished"
done