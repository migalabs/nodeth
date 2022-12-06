export $(grep -v '^#' .env | xargs)
sudo docker run --network=host -v ${LODESTAR_DATA_FOLDER}/.lodestar:/root/.local/share/lodestar chainsafe/lodestar:v1.1.0 beacon --checkpointSyncUrl="$1"