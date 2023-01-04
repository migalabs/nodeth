export $(grep -v '^#' .env | xargs)
sudo docker run -it \
	-v ${VALIDATOR_KEYS_FOLDER}/prysm:/validators \
	-v ${PRYSM_DATA_FOLDER}/.prysm-val/wallet:/wallet \
	gcr.io/prysmaticlabs/prysm/validator:${PRYSM_TAG} \
	accounts import --keys-dir=/validators/keys --wallet-dir=/wallet --wallet-password-file=/validators/secret.txt