sudo docker run --network=host -v $PWD/apps-data/.prysm:/home/.eth2/ gcr.io/prysmaticlabs/prysm/beacon-chain:v3.1.1 --checkpoint-sync-url="$1" --genesis-beacon-api-url="$1" --accept-terms-of-use

