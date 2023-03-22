export $(grep -v '^#' .env | xargs)
sudo mkdir -p ${TEKU_DATA_FOLDER}/.teku-val/keys
sudo mkdir -p ${TEKU_DATA_FOLDER}/.teku-val/passwords

sudo cp ${VALIDATOR_KEYS_FOLDER}/teku/keys/* ${TEKU_DATA_FOLDER}/.teku-val/keys/
sudo cp ${VALIDATOR_KEYS_FOLDER}/teku/passwords/* ${TEKU_DATA_FOLDER}/.teku-val/passwords/
sudo cp ${VALIDATOR_KEYS_FOLDER}/teku/secret.txt ${TEKU_DATA_FOLDER}/.teku-val/

sudo chown -R $1:$1 ${TEKU_DATA_FOLDER}/.teku-val/