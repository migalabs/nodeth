sudo docker run --network=host -v $PWD/apps-data/.nimbus:/home/user/.cache/nimbus statusim/nimbus-eth2:amd64-v22.9.1 trustedNodeSync \
  --network:mainnet \
  --trusted-node-url="$1"