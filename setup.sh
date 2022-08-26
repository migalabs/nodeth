checkpoint_host=$1
mkdir ./data
mkdir ./data/checkpoint_data
openssl rand -hex 32 | tr -d "\n" > "./data/jwtsecret"

curl $checkpoint_host/eth/v1/beacon/states/finalized/root
curl -o ./data/checkpoint_data/state.finalized.ssz -H 'Accept: application/octet-stream' $checkpoint_host/eth/v2/debug/beacon/states/finalized
curl -o ./data/checkpoint_data/block.finalized.ssz -H 'Accept: application/octet-stream' $checkpoint_host/eth/v2/beacon/blocks/finalized
curl -o ./data/checkpoint_data/state.genesis.ssz -H 'Accept: application/octet-stream' $checkpoint_host/eth/v2/beacon/blocks/genesis