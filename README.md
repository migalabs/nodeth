# eth2-clients-setup
Repository to host setup files to run ethereum clients.
This branch, setup/mainnet, is intended to have all the necessary preconfigurations to deploy all 5 CL clients in the mainnet network, plus some additional tools such as a fork of Vouch, a database and prometheus.

# Installation / Execution

Clone this repository.

### .env file

Create a .env file in the root of the repository.\
You may copy the .env-example as .env and edit.

### Vouch configuration

Create a vouch.yml file inside the .vouch folder.\
Once again, you can copy the example and edit.\
It is needed to setup the endpoints to track and the database where to persist the data. \
You may refer to [Vouch Repository](https://github.com/attestantio/vouch) for more information about configuration.

### Create a JWT secret

You must create a JWT secret in order to authenticate communications between the CL client and the EL client.\
To do this:

```
openssl rand -hex 32 | tr -d "\n" > "./data/jwtsecret"
```
Keep in mind you must have installed openssl package.
If not created, the Nethermind client will automatically create it.

# Execution

Please bear in mind folder permissions are very important, specially with Nimbus and Teku.
Regarding Nimbus it is important that the owner of the data folder is the same as the one executing the docker container.
As for Teku, ownership is also important, but permissions must be ensured so the container user can access the volume.

## Checkpoint Sync

You may start by checkpoint syncing your CL client.\
You can do this by executing:

```
./checkpoint_sync/chk_<client>.sh <https://remote_node:port>
```

Yoy may only run this for a few minutes until the client has downloaded the latest checkpoint, after that you can stop with Ctrl+C.

## Import keys

In case you have keys to be imported, please use the scripts in the import_keys/ folder.
Plase all your keys under the same folder.
Please remember to allow enough permissions to read the keystores. Permissions should be similar to the volumes mounted.

<pre>
keys 
  |__ prysm
  |__ lighthouse
  |__ teku
  |__ nimbus
  |__ lodestar
</pre>
### Prysm, Lighthouse, Lodestar
For Prysm Lighthouse and Lodestar, the folder above should contains something like this:
<pre>
  |__ prysm
	|__ secret.txt
	|__ keys
	     |__ keystoreA.json
	     |__ keystoreB.json
</pre>
The password should be the same for all validators under keys/ folder.

### Teku
For Teku, the folder above should contain something like this
<pre>
|__ teku
     |__ keys
     |	  |__ keystoreA.json
     |	  |__ keystoreB.json
     |__ passwords
          |__ keystoreA.txt
          |__ keystoreB.txt
</pre>
The files in the passwords/ folder should have the same name as the corresponing keystore file under the keys/ folder.
The password file should contain the password to open the corresponding keystore.

### Nimbus
<pre>
|__ nimbus
      |__ validators
      |	     |__ keystoreA
      |		   |__ keystoreA.json
      |	     |__ keystoreB		
      |	  	   |__ keystoreB.json
      |__ secrets
            |__ keystoreA
            |__ keystoreB
</pre>
There should be one folder per keystore containing the keystore json, under the validators/ folder.
Under the secrets/ folder, one file per keystore must be found (with no extension), with the corresponding password of the keystore.
Nimbus import process might take some time to complete.

Yoy may only run this for a few minutes until the client has downloaded the latest checkpoint, after that you can stop with Ctrl+C.

## Run your EL+CL

You can now run your combo with:
```
sudo docker-compose --env-file .env up -d nethermind-lh lighthouse
```
See docker-compose to list services and run your desired EL+CL combo.\
Nethermind will need to sync the whole chain, so this might take sometime depending on your machine.\
You can also run several combos at the same time, docker-compose is adapted to not overlap ports.

# Prometheus

Yu may also run Prometheus:
```
sudo docker-compose --env-file .env up -d prometheus
```

Prometheus configuration includes all 5 EL+CL combos monitoring.

# Errors

You might encounter some issues when running nimbus and teku docker containers. This is usually due to folder permissions. Simply change the owner of the nimbus or teku data folder to the same running the container (folders are originally created as root). After that, container should run without issues.



