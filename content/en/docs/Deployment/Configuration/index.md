---
title: "Configuration"
linkTitle: "Configuration"
date: 2021-11-08
weight: 2
description: >
  Configuration for agency deployment.
resources:
  - src: "**.{png,jpg}"
    title: "Image #:counter"
---

{{< imgproc deployment Fit "675x675" >}}
<em>Overall Findy Agency Deployment Architecture</em>
{{< /imgproc >}}

## Internet-facing reverse proxy

Nginx, AWS load balancer etc. can work as a reverse proxy. It is recommended to use single domain for request routing to avoid hassle with FIDO2 origin requirements and CORS.

### Port 443

| Path              | Target | Note                                                     |
| ----------------- | ------ | -------------------------------------------------------- |
| /                 | pwa    | Static html                                              |
| /query            | vault  | GQL queries from PWA. Websocket support needed.          |
| /register, /login | auth   | Webauthn requires HTTPS. Domain needs to match with PWA. |
| /a2a              | agency | Endpoint can be set with the agency's start up flag.     |

### Port 50051

Agency gRPC interface communication.

**Note:** Currently also all internal microservices assume gRPC SSL/TLS communication. Unencrypted communication should be enabled within private network in the future.

## findy-agent

Sources and more documentation in repository [findy-agent](https://github.com/findy-network/findy-agent)

[Docker image registry in GitHub Packages](https://github.com/findy-network/findy-agent/pkgs/container/findy-agent).

### Settings

| Variable                                                   | Example                      | Default                                             | Description                                        |
| ---------------------------------------------------------- | ---------------------------- | --------------------------------------------------- | -------------------------------------------------- |
| `FCLI_IMPORT_WALLET_FILE`                                  | `/steward.exported`          | `/steward.exported`                                 | File path to steward wallet to import              |
| `FCLI_IMPORT_WALLET_NAME`                                  | `steward`                    | `steward`                                           | Steward wallet name                                |
| `FCLI_IMPORT_WALLET_FILE_KEY`                              | `import-indy-key`            |                                                     | Key to wallet file to import                       |
| `FCLI_IMPORT_WALLET_KEY`, `FCLI_AGENCY_STEWARD_WALLET_KEY` | `valid-indy-key`             |                                                     | Steward wallet key                                 |
| `FCLI_AGENCY_STEWARD_DID`                                  | `Th7MpTaRZVRYnPiabds81Y`     |                                                     | Steward DID                                        |
| `FCLI_POOL_GENESIS_TXN_FILE`                               | `/genesis_transactions`      | `/genesis_transactions`                             | Ledger genesis file path                           |
| `FCLI_POOL_NAME`, `FCLI_AGENCY_POOL_NAME`                  | `findy`                      | `findy`                                             | Ledger pool name                                   |
| `FCLI_AGENCY_HOST_ADDRESS`                                 | `agency.example.com`         | `localhost`                                         | Host address as seen from internet                 |
| `FCLI_AGENCY_HOST_PORT`                                    | `80`                         | `8080`                                              | Host port as seen from internet                    |
| `FCLI_AGENCY_SERVER_PORT`                                  | `8080`                       | `8080`                                              | Server port in local network                       |
| `FCLI_AGENCY_PSM_DATABASE_FILE`                            | `/root/findy.bolt`           | `/root/findy.bolt`                                  | PSM database file path                             |
| `FCLI_AGENCY_REGISTER_FILE`                                | `/root/findy.json`           | `/root/findy.json`                                  | Handshake register file path                       |
| `FCLI_AGENCY_HOST_SCHEME`                                  | `https`                      | `http`                                              | Scheme of the host's url address                   |
| `FCLI_AGENCY_ENCLAVE_KEY`                                  | `0ADF..00DCAE`               | ""                                                  | Secure enclave for wallet keys                     |
| `FCLI_AGENCY_ENCLAVE_PATH`                                 | `findy-enclave.bolt`         | `~/.indy_client/enclave.bolt`                       | Secure enclave's filename                          |
| `FCLI_AGENCY_GRPC`                                         | `true`                       | `true`                                              | Whether to enable gRPC service or not              |
| `FCLI_AGENCY_GRPC_CERT_PATH`                               | `/cert`                      | `src/github.com/findy-network/findy-common-go/cert` | File path to gRPC client and server certificates\* |
| `FCLI_AGENCY_GRPC_JWT_SECRET`                              | `randomstring`               |                                                     | JWT key for token validation                       |
| `FCLI_AGENCY_GRPC_PORT`                                    | `50051`                      | `50051`                                             | gRPC interface port                                |
| `FCLI_AGENCY_ADMIN_ID`                                     | `root039499`                 | `findy-root`                                        | Agency API user ID which is to authorization       |
| `FCLI_AGENCY_ENCLAVE_BACKUP`                               | `~/backups/enclave.bolt.bak` | ""                                                  | Full file name template for enclave backup file    |
| `FCLI_AGENCY_ENCLAVE_BACKUP_TIME`                          | `04:00`                      | ""                                                  | Time of day when enclave backup is started         |
| `FCLI_AGENCY_WALLET_BACKUP`                                | `~/wallet/backups`           | ""                                                  | Path for wallet backups                            |
| `FCLI_AGENCY_WALLET_BACKUP_TIME`                           | `05:00`                      | ""                                                  | Time of day when when wallet backup is started     |
| `FCLI_AGENCY_REGISTER_BACKUP`                              | `~/backups/findy.json.bak`   | ""                                                  | Full file name template for register backup file   |
| `FCLI_AGENCY_REGISTER_BACKUP_INTERVAL`                     | `20m:30s`                    | `12h`                                               | Time interval between backup starts                |

\*Cert path is the root. Both `server` and `client` certificates needs be in this folder in their own separated folders named accordingly: `server` and `client`.

### Configuration files

- Steward wallet
- Genesis transactions
- gRPC client certificate + key (if TLS termination not handled by reverse proxy)
- gRPC server certificate + key (if TLS termination not handled by reverse proxy)

### Data storage (file system)

- **Handshake register** (has backup capability): Text file (JSON) for onboarded agent ids
- **PSM database**: _Bolt_ db for protocol state machine data
- **Enclave** (has backup capability): _Bolt_ db for wallet key data
- **Indy wallets** (has backup capability): _SQLite_ db for wallet data
  - in backup recovery wallet must be imported to system with indy SDK API call

## findy-agent-auth (FIDO2)

Sources and more documentation in repository [findy-agent-auth](https://github.com/findy-network/findy-agent-auth)

[Docker image registry in GitHub Packages](https://github.com/findy-network/findy-agent-auth/pkgs/container/findy-agent-auth).

### Settings

| Variable                | Example                           | Default      | Description                                     |
| ----------------------- | --------------------------------- | ------------ | ----------------------------------------------- |
| `--port`                | `8888`                            |              | Port for auth service                           |
| `--agency`              | `localhost`                       |              | Agency gRPC service host                        |
| `--gport`               | `50051`                           | `50051`      | Agency gRPC service port                        |
| `--domain`              | `agency.example.com`              |              | Site domain name                                |
| `--origin`              | `https://agency.example.com`      |              | Request origin URL                              |
| `--jwt-secret`          | `randomstring`                    |              | JWT key for access token generation             |
| `-sec-file`             | `fido-enclave.bolt`               |              | sec enclave file name                           |
| `-sec-key`              | `0A0834BF...DFEA`                 |              | sec enclave master encrypt key                  |
| `-admin`                | `findy-03029394`                  | `findy-root` | agency admin id                                 |
| `-cert-path`            | `/cert`                           | ""           | gRPC cert root folder                           |
| `-sec-backup-file`      | `~/backups/fido-enclave.bolt.bak` | ""           | Full file name template for enclave backup file |
| ` -sec-backup-interval` | `12`                              | `24`         | Time interval between backup checks             |

### Configuration files

- gRPC client certificate + key
- gRPC server certificate

### Data storage (file system)

- **FIDO enclave** it's key/value database and encrypted by `enclave-key` which should be transferred as _an important secret_ to the app.
  - _Bolt_ db for user data
  - Uses _file system_ for data storage and backups as well
  - a DB is a single file

## findy-agent-vault

Sources and more documentation in repository [findy-agent-vault](https://github.com/findy-network/findy-agent-vault).

[Docker image registry in GitHub Packages](https://github.com/findy-network/findy-agent-vault/pkgs/container/findy-agent-vault).

### Settings

| Variable                    | Example                 | Default     | Description                         |
| --------------------------- | ----------------------- | ----------- | ----------------------------------- |
| `FAV_SERVER_PORT`           | `8085`                  | `8085`      | Port for vault service              |
| `FAV_JWT_KEY`               | `randomstring`          |             | JWT key for access token validation |
| `FAV_DB_HOST`               | `xxx.rds.amazonaws.com` |             | Postgres db host address            |
| `FAV_DB_PORT`               | `5432`                  | `5432`      | Postgres db port                    |
| `FAV_DB_PASSWORD`           | `db-password`           |             | Postgres db password                |
| `FAV_AGENCY_HOST`           | `localhost`             | `localhost` | Agency gRPC server host             |
| `FAV_AGENCY_PORT`           | `50051`                 | `50051`     | Agency gRPC server port             |
| `FAV_AGENCY_GRPC_CERT_PATH` | `/cert`                 |             | Agency gRPC certificate path        |

### Configuration files

- gRPC client certificate + key
- gRPC server certificate

### Data storage (postgres)

- **Database**
  - _Postgres_ (e.g. AWS RDS)
  - **Note**: Already on first start, vault service expects that the database called `vault`exists in the db instance

## findy-wallet-pwa

Sources and more documentation in repository [findy-wallet-pwa](https://github.com/findy-network/findy-wallet-pwa)

### Settings (buildtime)

| Variable                | Example              | Default          | Description                       |
| ----------------------- | -------------------- | ---------------- | --------------------------------- |
| `REACT_APP_GQL_HOST`    | `agency.example.com` | `localhost:8085` | Agency vault service host address |
| `REACT_APP_AUTH_HOST`   | `agency.example.com` | `localhost:8088` | Agency auth service host address  |
| `REACT_APP_HTTP_SCHEME` | `https`              | `http`           | HTTP URL scheme                   |
| `REACT_APP_WS_SCHEME`   | `wss`                | `ws`             | Websocket URL scheme              |
