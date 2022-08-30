---
date: 2022-08-29
title: "The Findy Agency API"
linkTitle: "The Findy Agency API"
description: "The Findy Agency API serves as an interface for Findy Agency clients who wish to use the agency services programmatically. The core use cases enable verified data exchange: issuing, receiving, verifying, or proving a credential. After onboarding to the agency, the client application can participate in these complex protocol flows using our programmer-friendly API."
author: Laura Vuorenoja
resources:
- src: "**.{png,jpg}"
  title: "Image #:counter"
---

{{< imgproc cover Fit "825x825" >}}
<em>The gRPC API serves the client applications.</em>
{{< /imgproc >}}

The Findy Agency clients can control their agents through the Findy Agency API
over [the high-performing gRPC protocol](https://grpc.io/).
The API design results from iterative planning and multiple development cycles.
Initially, we implemented it using a custom protocol that utilized
JSON structures and DIDComm as the transport mechanism.
The initial design seemed like a good plan, as we got the chance to test the exact DIDComm implementation
we were using to send the agent-2-agent messages (used in the credential exchange flows).

However, as we gained more experience using the API and the agent-2-agent protocol evolved as
[the community introduced Hyperledger Aries](https://www.hyperledger.org/blog/2019/05/14/announcing-hyperledger-aries-infrastructure-supporting-interoperable-identity-solutions), we realized our API was too laborious, clumsy,
and inefficient for modern applications.

One option would have been switching our API implementation to traditional REST over HTTP1.1.
**However, we wanted something better**. We were tired of JSON parsing and wanted a better-performing
solution than REST. We also wanted to be able to use the API using multiple different
languages with ease. **The obvious choice was gRPC**, which provided us with protocol buffer messaging
format, HTTP2-protocol performance gains, and tooling suitable for the polyglot, i.e., multilingual environment.

The technology choice was even better than we expected. Given that we have an agency installation available
in the cloud, we can listen to agent events through the gRPC stream without setting up external endpoints
using tools such as ngrok. Thus, gRPC **streaming capabilities have** considerably **simplified** client application
**development in a localhost environment**. Also, the logic of how gRPC handles errors out-of-the-box have helped
us trace the development time problems efficiently. 

## The API Contract

Our API contract defined with proto files resides in a separate repository, [findy-agent-api](https://github.com/findy-network/findy-agent-api).
Using the gRPC tooling, one can take these proto files and compile them to several target languages,
which enables the use of API structures directly from the target implementation.

A brief example is displayed below.
[We define the structures and an RPC call](https://github.com/findy-network/findy-agent-api/blob/master/idl/v1/agent.proto#L54) for schema creation in protobuf language:

```protobuf
// SchemaCreate is structure for schema creation.
message SchemaCreate {
  string name = 1; // name is the name of the schema.
  string version = 2; // version is the schema version.
  repeated string attributes = 3; // attributes is JSON array string.
}

// Schema is structure to transport schema ID.
message Schema {
  string ID = 1; // ID is a schema ID.
}

/*
AgentService is to communicate with your cloud agent. With the cloud agent
you can Listen your agent's status, create invitations, manage its running environment,
and create schemas and credential definitions.
 */
service AgentService {
  ...

  // CreateSchema creates a new schema and writes it to ledger.
  rpc CreateSchema(SchemaCreate) returns (Schema) {}

  ...
}

```

The protobuf code is compiled to target languages using gRPC tooling, and after that
the structures can be used natively from the application code.

[Go example](https://github.com/findy-network/findy-agent-cli/blob/0dbee240e5cd5693ac818f2cacd0ce86987a950c/cmd/agent/createschema.go#L47):

```go
    agent := agency.NewAgentServiceClient(conn)
    r := try.To1(agent.CreateSchema(ctx, &agency.SchemaCreate{
        Name:       name,
        Version:    version,
        Attributes: attrs,
    }))
    fmt.Println(r.ID) // plain output for pipes
```

[Typescript example](https://github.com/findy-network/findy-issuer-tool/blob/master/api/src/agent/index.js#L40):

```ts
    log.info(`Creating schema ${JSON.stringify(body)}`);

    const msg = new agencyv1.SchemaCreate();
    msg.setName(body.name);
    msg.setVersion(body.version);
    body.attrs.map((item) => msg.addAttributes(item));

    const res = await agentClient.createSchema(msg);

    const schemaId = res.getId();
    log.info(`Schema created with id ${schemaId}`);
```

The examples show that the code is simple and readable compared
to making HTTP requests to arbitrary addresses and JSON manipulation. 
The code generated from the proto-files guides
the programmer in the correct direction, and there are no obscurities about which kind of structures
the API takes in or spits out.

## Helpers and Samples

We have developed two helper libraries that contain some common functionalities needed for building API client applications.
One is for our favorite language Go ([findy-common-go](https://github.com/findy-network/findy-common-go)),
and the other is for Typescript ([findy-common-ts](https://github.com/findy-network/findy-common-ts)) to demonstrate the API usage for one of
the most popular web development languages.

These helper libraries make building a Findy Agency
client application even more straightforward. They contain
* the ready-built proto-code,
* functionality for opening and closing the connection and streaming the data,
* utilities for client authentication, and
* further abstractions on top of the API interface.

There already exist two excellent example client applications that utilize these helper libraries.
In addition to being examples of using the API, they are handy tools for accessing and testing
the agency functionality.

Our [CLI tool](https://github.com/findy-network/findy-agent-cli) provides agent manipulation functionality through a command-line interface.
It uses the agency API internally through the Go helper.

{{< figure src="https://github.com/findy-network/findy-wallet-pwa/raw/dev/tools/env/docs/env-04.gif" title="" width="925" >}}

*Example above shows how it is possible to use the CLI tool for chatting with web wallet user.*

[The issuer tool](https://github.com/findy-network/findy-issuer-tool) is a sample web service with a simple UI
that can issue and verify credentials using the issuer tool's cloud agent.
It is written in Javascript and utilizes the Typescript helper.

{{< figure src="https://github.com/findy-network/findy-issuer-tool/raw/master/docs/usage-04.gif" title="" width="925" >}}

*Issuer tool provides functionality for testing different Aries protocols.*

One is not limited to using these two languages, as using the API from any language with
gRPC tooling support is possible. Stay tuned for my next post that describes our latest experiment
with Kotlin.
