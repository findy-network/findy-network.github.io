---
title: "Findy Agency Architecture"
linkTitle: "Architecture"
weight: 1
date: 2021-08-20
description: >
  Brief description of Findy Agency architecture
resources:
- src: "**.{png,jpg}"
  title: "Image #:counter"
---

{{< imgproc arch Fit "675x675" >}}
<em>Overview of Findy Agency. See more detailed description in <a href="https://github.com/findy-network/findy-agent#agency-architecture">findy-agent documentation</a>.</em>
{{< /imgproc >}}

The backend server of Findy Agency consists of three services:

* core/[findy-agent](https://github.com/findy-network/findy-agent) that handles all agent functionality including credential handling and Aries protocols
* vault/[findy-agent-vault](https://github.com/findy-network/findy-agent-vault) that maintains a database of agents' data. Currently vault has only GraphQL-interface for data queries, that is intended mainly for browser web wallet use.
* auth/[findy-agent-auth](https://github.com/findy-network/findy-agent-auth) that registers and authenticates all agency users.

{{< imgproc wallet Fit "675x675" >}}
<em>Wallet login screen.</em>
{{< /imgproc >}}

[Reference web wallet](https://github.com/findy-network/findy-wallet-pwa) implementation is a React app that utilizes standard WebAuthn protocol and browser capabilities to authenticate to backend. Web wallet uses GraphQL to fetch and update agency data.

Service agents are applications that handle verified data on behalf of organizations. Service agents utilize Findy Agency through headless authentication and [gRPC API](https://github.com/findy-network/findy-agent-api). Samples and reference implementations can be found in agency gRPC helper libraries for [golang](https://github.com/findy-network/findy-common-go) or [Typescript](https://github.com/findy-network/findy-common-ts).

Agents can be also operated through a CLI, [findy-agent-cli](https://github.com/findy-network/findy-agent-cli), that provides most of the functionality needed for agent and agency manipulation.