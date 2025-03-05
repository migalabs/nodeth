# Execution Client Integration Guide

This guide explains how to integrate a new Ethereum execution client into the nodeth repository.

## Integration Process

1. **Gather Client Information**:
   - Docker image name and repository
   - Required ports (P2P, RPC, metrics)
   - Configuration parameters
   - Resource requirements
   - Necessary volume mounts

2. **Update Docker Compose File**:
   Add a new service block in `docker-compose.yml` with proper:
   - Image reference
   - Port mappings
   - Volume mounts
   - JWT authentication
   - Command line parameters
   - Resource limits

3. **Update Environment Variables**:
   In `.env-example`, add variables for:
   - Version control
   - Resource limits
   - Client-specific parameters

4. **Update Documentation**:
   In `README.md`, update:
   - Available clients list
   - Configuration instructions
   - Monitoring information

5. **Add Prometheus Configuration**:
   In `prometheus/prometheus-template.yml`, add a job for:
   - Client metrics endpoint
   - Appropriate labels

## Example: Adding a New Client

Here's a basic template for adding a new execution client service to `docker-compose.yml`:

```yaml
new-client:
  image: organization/client-name:${CLIENT_VERSION:-}
  restart: unless-stopped
  init: true
  networks: [cluster]
  ports:
    - "30303:30303/tcp" # P2P port
    - "30303:30303/udp" # P2P port udp
    - "127.0.0.1:8545:8545" # JSON-RPC
    - "127.0.0.1:METRICS_PORT:METRICS_PORT" # Metrics
  volumes:
    - ${DATA_FOLDER:-./data}/.client-name:/data-path
    - ./data/jwt:/jwt
  command: >-
    [client command]
    --network=${NETWORK:-mainnet}
    --datadir=/data-path
    [http configuration]
    [engine api configuration]
    [jwt configuration]
    [metrics configuration]
  deploy:
    resources:
      limits:
        cpus: ${CLIENT_MAX_CPU:-2}
        memory: ${CLIENT_MAX_MEM:-8G}
```

Add these variables to `.env-example`:
```
CLIENT_VERSION=
CLIENT_MAX_CPU=
CLIENT_MAX_MEM=
```

## Engine API Requirements

For compatibility with Consensus Layer clients, all execution clients must implement:

1. **JWT Authentication**:
   - Support for reading a JWT secret file
   - Proper configuration of Engine API endpoints

2. **Engine API Endpoints**:
   - Typically on port 8551
   - Accessible to consensus clients

3. **Metrics Exposure**:
   - Prometheus-compatible metrics endpoint

## Testing New Integrations

After adding a new client:

1. Test with each consensus client
2. Verify JWT authentication works correctly
3. Check that metrics are properly exposed
4. Ensure proper data persistence
5. Verify API compatibility

## Consensus Client Special Requirements

Some consensus clients have specific requirements for proper operation:

### Nimbus

Nimbus requires:
1. A separate trusted sync service for initial setup
2. Strict directory permissions (700)
3. Proper ownership of data directories

When integrating with Nimbus, ensure:
- The data directory has proper permissions before starting
- The trusted sync service is run before the main service
- JWT authentication is properly configured

## Client-Specific Configuration Notes

### Reth
- Docker image: `ghcr.io/paradigmxyz/reth:latest` or `ethpandaops/reth:latest`
- Uses `--rpc.jwtsecret` instead of `--jwt-secret` for JWT authentication
- Requires the actual JWT secret hex value, not a file path
- Metrics are exposed on port 9001 internally (mapped to 9002 externally)
- Uses a completely different pruning configuration system:
  - For full archival mode: `--full`
  - For pruned mode: Various `--prune.*` options like `--prune.receipts.distance`, `--prune.accounthistory.distance`, etc.
- **Important**: The Docker image uses the `reth` binary as its entrypoint, requiring special configuration:
  ```yaml
  entrypoint: >
    sh -c '
    JWT_SECRET=$$(cat /jwt/jwtsecret);
    if [ "${RETH_PRUNE_MODE:-full}" = "full" ]; then
      PRUNE_OPT="--full";
    else
      PRUNE_OPT="--prune.receipts.distance 1000000 --prune.accounthistory.distance 1000000";
    fi;
    exec /usr/local/bin/reth node 
    # ... other parameters ...
    $$PRUNE_OPT
    '
  ```