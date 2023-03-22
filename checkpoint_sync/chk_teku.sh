export $(grep -v '^#' .env | xargs)
sudo mkdir -p ${TEKU_DATA_FOLDER}/.teku
sudo chown -R $2:$2 ${TEKU_DATA_FOLDER}/.teku
sudo docker run --rm --network=host -v ${TEKU_DATA_FOLDER}/.teku:/opt/teku/.local/share/teku/ consensys/teku:${TEKU_TAG} --network=${NETWORK} --initial-state="$1/eth/v2/debug/beacon/states/finalized" --ee-endpoint http://127.0.0.1:8551