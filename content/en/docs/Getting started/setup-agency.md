---
title: "First Steps with Findy Agency"
linkTitle: "Setup Agency"
weight: 1
date: 2021-08-10
description: >
  Instructions how get started with Findy Agency.
---

## Full Agency Setup

Agency services can be setup easily locally using Docker.
Check further instructions [here](https://github.com/findy-network/findy-wallet-pwa/tree/dev/tools/env#agency-setup-for-local-development).
The instructions describe how to launch all the needed backend services in Docker containers
together with a simulated ledger. There is also a native development setup instructions
for web wallet application which will be needed in order to run web wallet application together
with other agents.

Once you have the services running on your computer,

* try to run [the Alice-Faber-Acme demo](https://github.com/findy-network/findy-agency-demo#findy-agency-demo)
* start to [build a service agent of your own](/docs/getting-started/service-agent/).
* or you can play around with the credentials using the tools: CLI tool [findy-agent-cli](#cli) or
UI tool [findy-issuer-tool](#ui-tool)

## CLI

[findy-agent-cli](https://github.com/findy-network/findy-agent-cli) is a command-line tool that can be used to

* register new agents
* authenticate agents
* operate agents
  * make connections
  * issue and accept credentials
  * verify and prove credentials
* operate bots (simple service agents)
* operate ledger
  * create schemas
  * create credential definitions
* operate agency

```shell
Findy agent cli tool

Usage:
  findy-agent-cli [command]

Available Commands:
  agency      Manage Agency
  agent       Work with the Cloud Agent
  authn       WebAuthn commands
  bot         Manage Bot
  completion  Generate shell completion scripts
  connection  Manage connections
  help        Help about any command
  new-key     Create a new key for the authenticator
  tree        Prints the findy-agent-cli command structure

Flags:
      --config string     configuration file, FCLI_CONFIG
  -n, --dry-run           perform a trial run with no changes made, FCLI_DRY_RUN
  -h, --help              help for findy-agent-cli
      --logging string    logging startup arguments, FCLI_LOGGING (default "-logtostderr=true -v=0")
      --server string     gRPC server addr:port, FCLI_SERVER (default "localhost:50051")
      --tls-path string   TLS cert path, FCLI_TLS_PATH
  -v, --version           version for findy-agent-cli

Use "findy-agent-cli [command] --help" for more information about a command.
```

Check out [the dedicated guide](https://github.com/findy-network/findy-agent-cli/tree/master/scripts/fullstack#steps) for CLI commands to get familiar with the usage.

_Note:_

* before CLI usage, you need to have a working Findy Agency installation
* findy-agent-cli is also a reference on how to use the Agency gRPC API with golang. Check the sources for more details.

## UI Tool

[findy-issuer-tool](https://github.com/findy-network/findy-issuer-tool) is a UI tool for

* making pairwise connections
* issuing credentials
* verifying credentials
* creating schemas and credential definitions.

{{< figure src="https://github.com/findy-network/findy-issuer-tool/raw/master/docs/usage-03.gif" title="" width="925" >}}

See [setup instructions](https://github.com/findy-network/findy-issuer-tool#setup-environment) and [usage instructions](https://github.com/findy-network/findy-issuer-tool#usage) in project repository.

_Note:_

* before UI-tool usage, you need to have a working Findy Agency installation
* findy-issuer-tool works also as a sample implementation for a Findy Agency service agent implemented with JavaScript.
