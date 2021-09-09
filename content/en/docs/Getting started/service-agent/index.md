---
title: "Service Agents"
linkTitle: "Service Agents"
date: 2021-08-10
weight: 2
description: >
  Instructions how to get started with service agents.
resources:
- src: "**.{png,jpg}"
  title: "Image #:counter"
---

Service agents i.e. organization agents utilize Findy Agency through its GRPC API. The agent creation and authentication is handled through the headless authenticator, *acator*, that implements the WebAuthn protocol. Once authenticated, all agent functionality is available to service agents via the core gRPC API, [findy-agent-api](https://github.com/findy-network/findy-agent-api).

You can use our helper libraries for [golang](https://github.com/findy-network/findy-common-go) or [Typescript](https://github.com/findy-network/findy-common-ts) or use directly [the GRPC interface](https://github.com/findy-network/findy-agent-api) with the language of your choice.

You can also find reference implementations, that you should probably explore before starting to implement an agent of your own:
* golang: [findy-agent-cli](https://github.com/findy-network/findy-agent-cli)
* JavaScript: [findy-issuer-tool](https://github.com/findy-network/findy-issuer-tool), specifically [api/src/agent/index.js](https://github.com/findy-network/findy-issuer-tool/blob/master/api/src/agent/index.js)

## Sample flow: connecting to another agent 

{{< imgproc service Fit "675x675" >}}
<em>Service Agent onboarding and connecting to another agent by creating a connection invitation.</em>
{{< /imgproc >}}

1. Service Agent (SA) registers with acator tool/library to agency. SA should use a unique user name and the selected authenticator key should be kept secret. *Note: the registration needs to be done only once. After the first registration, authentication is done using the same user name and authenticator key.* 
1. SA does login with acator tool/library. After successful login, a JWT token is returned to SA.
1. SA starts listening to agent status events with gRPC API.
1. SA creates connection invitation using gRPC API.
1. SA displays/sends/etc. invitation json to another Aries compatible agent (invitee).
1. Invitee sends connection request to the core agency, that handles the connection protocol on behalf of SA.
1. Core agency notifies SA when the connection is established. SA can query core agency for the needed connection details and continue with e.g. issuing or verifying data with the new connection.
