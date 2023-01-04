export $(grep -v '^#' .env | xargs)

sudo cp -r ${VALIDATOR_KEYS_FOLDER}/nimbus/secrets ${NIMBUS_DATA_FOLDER}/.nimbus
sudo cp -r ${VALIDATOR_KEYS_FOLDER}/nimbus/validators ${NIMBUS_DATA_FOLDER}/.nimbus