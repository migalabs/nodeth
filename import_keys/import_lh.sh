export $(grep -v '^#' .env | xargs)
sudo docker run -it \
    -v ${LH_DATA_FOLDER}/.lighthouse:/root/.lighthouse \
    -v ${VALIDATOR_KEYS_FOLDER}/lighthouse/:/root/validator_keys \
    sigp/lighthouse:${LIGHTHOUSE_TAG} \
    lighthouse --network ${NETWORK} account validator import --directory /root/validator_keys/keys \
	--password-file /root/validator_keys/secret.txt --reuse-password