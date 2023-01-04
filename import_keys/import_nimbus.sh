export $(grep -v '^#' .env | xargs)

sudo cp -r ${VALIDATOR_KEYS_FOLDER}/nimbus/* ${NIMBUS_DATA_FOLDER}/.nimbus