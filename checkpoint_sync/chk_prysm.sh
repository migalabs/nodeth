export $(grep -v '^#' .env | xargs)
sudo docker run --network=host -v ${PRYSM_DATA_FOLDER}/.prysm:/home/.eth2/ gcr.io/prysmaticlabs/prysm/beacon-chain:v3.1.1 --checkpoint-sync-url="$1" --genesis-beacon-api-url="$1" --accept-terms-of-use

