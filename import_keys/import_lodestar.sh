export $(grep -v '^#' .env | xargs)
sudo mkdir -p ${LODESTAR_DATA_FOLDER}/.lodestar-val/keys

sudo cp ${VALIDATOR_KEYS_FOLDER}/lodestar/keys/* ${LODESTAR_DATA_FOLDER}/.lodestar-val/keys/
sudo cp ${VALIDATOR_KEYS_FOLDER}/lodestar/secret.txt ${LODESTAR_DATA_FOLDER}/.lodestar-val/