# nodeth
Repository to host setup files to run Ethereum clients.
This branch, setup/mainnet, is intended to have all the necessary preconfigurations to deploy multiple Execution Layer (EL) and Consensus Layer (CL) clients in the mainnet network, plus some additional tools such as a fork of Vouch, a database and Prometheus.

# Installation / Execution

Clone this repository.

### .env file

Create a .env file in the root of the repository.\
You may copy the .env-example as .env and edit.

### Vouch configuration

Create a vouch.yml file inside the .vouch folder.\
Once again, you can copy the example and edit.\
It is needed to set up the endpoints to track and the database where to persist the data. \
You may refer to [Vouch Repository](https://github.com/attestantio/vouch) for more information about configuration.

### Create a JWT secret

You must create a JWT secret in order to authenticate communications between the CL client and the EL client.\
To do this:

```
mkdir -p ./data/jwt
openssl rand -hex 32 | tr -d "\n" > "./data/jwt/jwtsecret"
```
Keep in mind you must have the openssl package installed.
If not created, the Nethermind client will automatically create it.

# Execution

Please bear in mind folder permissions are very important, especially with Nimbus and Teku.
Regarding Nimbus, it is important that the owner of the data folder is the same as the one executing the docker container.
As for Teku, ownership is also important, but permissions must be ensured so the container user can access the volume.

## Checkpoint Sync

Default sync method is to Checkpoint Sync from a trusted node.
In case of Nimbus, please first use service `nimbus-trusted-sync`. The service will stop automatically and you can now run `nimbus` service.

## Import keys

In case you have keys to be imported, please use the scripts in the import_keys/ folder.
Place all your keys under the same folder.
Please remember to allow sufficient permissions to read the keystores. Permissions should be similar to the volumes mounted.

<pre>
keys 
  |__ prysm
  |__ lighthouse
  |__ teku
  |__ nimbus
  |__ lodestar
</pre>

### Prysm, Lighthouse, Lodestar
For Prysm, Lighthouse, and Lodestar, the folder above should contain something like this:
<pre>
  |__ prysm
        |__ secret.txt
        |__ keys
             |__ keystoreA.json
             |__ keystoreB.json
</pre>
The password should be the same for all validators under the keys/ folder.

### Teku
For Teku, the folder above should contain something like this:
<pre>
|__ teku
     |__ keys
     |    |__ keystoreA.json
     |    |__ keystoreB.json
     |__ passwords
          |__ keystoreA.txt
          |__ keystoreB.txt
</pre>
The files in the passwords/ folder should have the same name as the corresponding keystore file under the keys/ folder.
The password file should contain the password to open the corresponding keystore.

### Nimbus
<pre>
|__ nimbus
      |__ validators
      |      |__ keystoreA
      |      |    |__ keystoreA.json
      |      |__ keystoreB        
      |          |__ keystoreB.json
      |__ secrets
            |__ keystoreA
            |__ keystoreB
</pre>
There should be one folder per keystore containing the keystore json, under the validators/ folder.
Under the secrets/ folder, one file per keystore must be found (with no extension), with the corresponding password of the keystore.
Nimbus import process might take some time to complete.

You may only run this for a few minutes until the client has downloaded the latest checkpoint, after that you can stop with Ctrl+C.

## Run your EL+CL

You can now run your combo with:
```
sudo docker-compose --env-file .env up -d nethermind lighthouse
```
See docker-compose to list services and run your desired EL+CL combo.

### Available Execution Layer (EL) Clients

| Client | Docker Image | Key Features | Resource Requirements |
|--------|--------------|--------------|----------------------|
| **nethermind** | nethermind/nethermind | .NET-based client | 1+ CPU, 8-16GB RAM |
| **besu** | hyperledger/besu | Enterprise-focused Java client | 2+ CPU, 8-16GB RAM |
| **geth** | ethereum/client-go | Go-based reference client | 2+ CPU, 8GB+ RAM |
| **erigon** | erigontech/erigon | Optimized for disk space | 4+ CPU, 16-32GB RAM |
| **reth** | ghcr.io/paradigmxyz/reth | Rust-based high-performance client | 4+ CPU, 16GB+ RAM |

### Available Consensus Layer (CL) Clients

- lighthouse
- prysm
- teku
- nimbus
- lodestar

### Client Configuration

Each execution client can be configured through environment variables in the `.env` file:

**Version Control:**
```
NETHERMIND_VERSION=
BESU_VERSION=
GETH_VERSION=
ERIGON_VERSION=
RETH_VERSION=
```

**Resource Limits:**
```
NETHERMIND_MAX_CPU=
NETHERMIND_MAX_MEM=
GETH_MAX_CPU=
GETH_MAX_MEM=
ERIGON_MAX_CPU=
ERIGON_MAX_MEM=
RETH_MAX_CPU=
RETH_MAX_MEM=
```

**Client-Specific Settings:**
```
ERIGON_PRUNE_MODE=full    # Options: full, archive, minimal
ERIGON_TORRENT_RATE=20mb  # BitTorrent download rate limit
RETH_PRUNE_MODE=full      # Options: full, archive
```

The execution client will need to sync the whole chain, so this might take some time depending on your machine.\
You can run multiple execution clients or multiple consensus clients simultaneously.\
**Note:** Beware of port conflicts.

# Monitoring

## Prometheus

You may also run Prometheus:
```
sudo docker-compose --env-file .env up -d prometheus
```

Prometheus configuration includes monitoring for all EL+CL client combinations. The metrics endpoints are:

| Client | Metrics Endpoint |
|--------|-----------------|
| **nethermind** | localhost:8645 |
| **besu** | localhost:8645 |
| **geth** | localhost:6060 |
| **erigon** | localhost:6061 |
| **reth** | localhost:9002 |
| **lighthouse** | localhost:5054 |
| **prysm** | localhost:8080 |
| **teku** | localhost:8008 |
| **nimbus** | localhost:8009 |
| **lodestar** | localhost:8010 |

To enable monitoring for specific clients, uncomment the corresponding job configurations in `prometheus/prometheus-template.yml`.


# Caddy (Reverse Proxy)

You may run Caddy to expose all your endpoints with whitelisted IPs and authorized users.
Please move to the `certs` folder and execute the script to generate your self-signed certificate.
You will also need to uncomment the TLS clause in the Caddyfile.

# Common Errors

Prometheus may fail to boot as it may not have enough permissions in the given folder.
To fix it, simply stop the Prometheus service and run the following command:

`sudo chown -R nobody:nogroup apps-data/.prometheus`

Then start the service again.

## Client Interchangeability

This repository supports running any combination of execution and consensus clients. To specify which execution client your consensus client should connect to, set the `EXECUTION_CLIENT` variable in your `.env` file:

```
EXECUTION_CLIENT=erigon  # Options: nethermind, besu, geth, erigon, reth
```

This allows you to easily switch between different execution clients without changing the consensus client configuration.

For example, to run Lighthouse with Erigon:

# In your .env file
EXECUTION_CLIENT=erigon

# Then start the services
docker-compose --env-file .env up -d erigon lighthouse
```

To switch to using Geth instead:
```
# Update your .env file
EXECUTION_CLIENT=geth

# Stop the current services and start the new combination
docker-compose --env-file .env down
docker-compose --env-file .env up -d geth lighthouse
```

## Nimbus Consensus Client

### Initial Sync

Nimbus requires a special procedure for initial sync:

1. First run the trusted sync service:
   ```bash
   docker-compose --env-file .env up -d nimbus-trusted-sync
   ```

2. Wait for the trusted sync to complete (this may take a few minutes)

3. Then start the regular Nimbus service:
   ```bash
   docker-compose --env-file .env up -d nimbus
   ```

### Common Issues

- **Permission errors**: Nimbus requires specific permissions on its data directory
  ```bash
  mkdir -p ${DATA_FOLDER:-./data}/.nimbus
  chmod 700 ${DATA_FOLDER:-./data}/.nimbus
  sudo chown -R ${UID:-1000}:${GID:-1000} ${DATA_FOLDER:-./data}/.nimbus
  ```

- **Connection to execution client**: Nimbus may show connection errors to the execution client initially. This is normal if the execution client is still starting up or syncing.

## Reth Execution Client

Reth is a Rust implementation of Ethereum. To use Reth:

1. Set the execution client in your .env file:
   ```
   EXECUTION_CLIENT=reth
   ```

2. Start Reth with your preferred consensus client:
   ```bash
   docker-compose --env-file .env up -d reth lighthouse
   ```

### Configuration Notes

Reth has some unique configuration requirements compared to other execution clients:
- It requires the actual JWT secret value rather than a file path
- It uses different parameter names (e.g., `--rpc.jwtsecret` instead of `--jwt-secret`)
- It has a different pruning configuration system with `--full` for archival mode

These differences are handled automatically in the Docker Compose configuration.