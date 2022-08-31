# eth2-clients-setup
Repository to host setup files to run ethereum clients.
This branch, setup/mainnet, is intended to have all the necessary preconfigurations to deploy all 5 CL clients in the mainnet network, plus some additional tools such as a fork of Vouch, a database and prometheus.

# Installation / Execution

Clone this repository.

## Manual configuration

In order to have this setup running, you will need to create some configuration files.
To start, please execute the setup script:

```
./setup.sh <synced node endpoint>
```
This script will not only create the needed folders, but also download the finalized state from an already synced node that you provide. If you do not have a synced node or do not want to execute a checkpoint sync, do not pass any argument to the script.
```
./setup.sh
```


### .env file

Create a .env file in the root of the repository.\
Example:

```
FEE_RECIPIENT=0x0sdg515sd1g5asd1g...
CHECKPOINT_URL=https://username:key@eth2-beacon-mainnet.infura.io (only for checkpoint sync)
CHECKPOINT_ROOT=0x3dedd15a2dfa5f80c688d70e19f836cef023ad9465577291837662424f98d45a:58206 (only for checkpoint sync)
NETWORK=mainnet
POSTGRES_USER=<db_user>
POSTGRES_PASSWORD=<db_password>
```

### Vouch configuration

Create a vouch.yml file inside the .vouch folder.\
Example:

```
log-file: /app/logs/vouch.log
beacon-node-addresses: [localhost:3500, localhost:5052, localhost:5051, localhost:5053, localhost:9596]
accountmanager:
  wallet:
    accounts:
      - Validators
    passphrases:
      - secret
feerecipient:
  default-address: '0x0000000000000000000000000000000000000001'

strategies:
  # The beaconblockproposal strategy obtains beacon block proposals from multiple sources.
  beaconblockproposal:
    # style can be 'best', which obtains blocks from all nodes and selects the best, or 'first', which uses the first returned
    style: best

database:
  url: "postgresql://<db_user>:<db_password>@localhost:5432/vouch"
```
You may refer to [Vouch Repository](https://github.com/attestantio/vouch) for more information about configuration.

### Create a JWT secret

You must create a JWT secret in order to authenticate communications between the CL client and the EL client.\
To do this:

```
openssl rand -hex 32 | tr -d "\n" > "./data/jwtsecret"
```
Keep in mind you must have installed openssl package.

## Execution

```
sudo docker-compose --env-file .env up -d
```

# Checkpoint Sync

In case you want to execute the clients in checkpoint sync mode.

## Download finalized state

You may use the setup script (setup.sh) to download the finalized state.

```
./setup.sh <synced node endpoint>
```

This will download the needed finalized state and block, and show the finalized block root by the console, so you can go to [BeaconCha](https://beaconcha.in/), search the root and complete the field "checkpoint_root" in the .env file

## Configure URL

You may also configure a synced node to use as source of your checkpoint sync in your .env file


## Execution

```
sudo docker-compose --env-file .env - docker-compose-ws.yml up -d
```


