export $(grep -v '^#' .env | xargs)
sudo chown -R $1:$1 ${VALIDATOR_KEYS_FOLDER}/nimbus

for d in ${VALIDATOR_KEYS_FOLDER}/nimbus/validators/*; do
	sudo cat ${VALIDATOR_KEYS_FOLDER}/nimbus/secret.txt | tee | sudo docker run --rm -i --network=host \
 	-v ${NIMBUS_DATA_FOLDER}/.nimbus:/home/user/.cache/nimbus/BeaconNode \
	-v $d:/key_folder \
	statusim/nimbus-eth2:${NIMBUS_TAG} deposits import \
  	/key_folder
	echo "finished"
done