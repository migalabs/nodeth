
mkdir ./data/checkpoint_data

if [ $# -eq 0 ]
  then
    echo "No checkpoint sync URL provided"
    exit 0
fi

checkpoint_host=$1
curl $checkpoint_host/eth/v1/beacon/states/finalized/root
curl -o ./data/checkpoint_data/state.finalized.ssz -H 'Accept: application/octet-stream' $checkpoint_host/eth/v2/debug/beacon/states/finalized
curl -o ./data/checkpoint_data/block.finalized.ssz -H 'Accept: application/octet-stream' $checkpoint_host/eth/v2/beacon/blocks/finalized
curl -o ./data/checkpoint_data/state.genesis.ssz -H 'Accept: application/octet-stream' $checkpoint_host/eth/v2/beacon/blocks/genesis