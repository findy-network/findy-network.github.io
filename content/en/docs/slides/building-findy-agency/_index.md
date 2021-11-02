---
title: "Findy Agency — Building Highway to Verified Data Networks"
date: "2021-10-26"
type: "slides"
description: "Overview of Findy Agency project for Helsinki Gophers meetup on 3.11.2021"
toc_hide: true
---

background-image: url(https://images.unsplash.com/photo-1581010105267-67447703cfe9?ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&ixlib=rb-1.2.1&auto=format&fit=crop&w=1471&q=80)
background-size: cover
class: center, middle, dark

.image-credit[Photo by <a href="https://unsplash.com/@markusspiske?utm_source=unsplash&utm_medium=referral&utm_content=creditCopyText">Markus Spiske</a> on <a href="https://unsplash.com/s/photos/highway?utm_source=unsplash&utm_medium=referral&utm_content=creditCopyText">Unsplash</a>]

# Findy Agency — <br> Building Highway to Verified Data Networks

.img-200[![Helsinki Gophers logo](https://secure.meetupstatic.com/photos/event/7/1/8/5/clean_485609061.jpeg)]

Helsinki Gophers meetup on 3.11.2021

.author-box.small[Laura Vuorenoja<br> Technology Strategist @ OP Lab]
.author-box.small.github[[@lauravuo-techlab](https://github.com/lauravuo-techlab)]
.author-box.small.twitter[[@vuorenoja](https://twitter.com/vuorenoja)]

---

layout: true
background-image: url(https://images.unsplash.com/photo-1495592822108-9e6261896da8?ixlib=rb-1.2.1&ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=2340&q=80)
background-size: cover
class: center padded-slide
name: network

.image-credit[Photo by <a href="https://unsplash.com/@pietrozj?utm_source=unsplash&utm_medium=referral&utm_content=creditCopyText">Pietro Jeng</a> on <a href="https://unsplash.com/s/photos/net-green-red?utm_source=unsplash&utm_medium=referral&utm_content=creditCopyText">Unsplash</a>]

---

# Findy Agency

--

Findy Agency is _an identity agent service_ for individuals and organisations.

--

It provides functionality and APIs to identity holders for utilizing _verified data networks_.

--

Verified data exchange is based on _asymmetric cryptography_ and _Decentralized Public Key Infrastructure_ (DPKI).

???

- Findy development team at OP Lab has been researching self-sovereign identity and verified data networks for almost three years now.
- Findy Agency project has been born as a side product of the research work, multiple PoCs, and demos around this technology.
- The project codes were published fully as open-source in summer 2021.

---

# Identity Wallet

--

Credentials, i.e., facts signed by different issuers, are stored in _digital wallets_.

--

Using their digital wallet, identity holders can _cryptographically prove_ that the credential data is valid and that they, in fact, own the credential.

--

Proofs are _zero-knowledge_ and support _selective disclosure_.

???

- Identity holder can be any entity that needs to prove facts about themselves. For example, an individual, an organization or an IoT device can be an identity holder.
- Zero-knowledge methods allow keeping the issuer signature and parts of the signed message secret. Thus it is possible to:
  - Prove that the attribute exists in the credential, but do not reveal its value.
  - Reveal the value of an attribute without revealing any other attributes.
- Findy Agency provides the digital wallet service together with needed communication capabilities to identity holders.

---

layout: false

# Verified Data

.img-fill[![Trust Triangle](/docs/slides/building-findy-agency/trust-triangle.png)]

???

- The idea of verified data networks is to utilize cryptography so that different identities can hold and prove facts about themselves digitally.
- The main concepts in verified data handling are
  - Issuing credentials: signing facts and storing those in one's digital wallet
  - Prooving credentials: generating proofs from the signed facts and presenting those to counterparties

---

background-image: url(https://images.unsplash.com/photo-1512428559087-560fa5ceab42?ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&ixlib=rb-1.2.1&auto=format&fit=crop&w=1470&q=80)
background-size: cover
class: center padded-slide

.image-credit[Photo by <a href="https://unsplash.com/@nordwood?utm_source=unsplash&utm_medium=referral&utm_content=creditCopyText">NordWood Themes</a> on <a href="https://unsplash.com/s/photos/mobile-device?utm_source=unsplash&utm_medium=referral&utm_content=creditCopyText">Unsplash</a>]

# Example: Dating Service with Verified Data

--

Bob creates a profile in an online dating service.

--

In the service signup phase, Bob needs to verify his gender and age with his digital wallet. He presents proof for his id card.

--

Verified gender and age are shown to other Service users when they are browsing Bob's profile.

---

class: img-fill middle

### Example: Dating Service with Verified Data

.img-fill[![Trust Triangle](/docs/slides/building-findy-agency/trust-triangle-ex1.png)]

---

background-image: url(https://images.unsplash.com/photo-1535191595495-d3222b2eda44?ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&ixlib=rb-1.2.1&auto=format&fit=crop&w=1471&q=80)
background-size: cover
class: center padded-slide

.image-credit[Photo by <a href="https://unsplash.com/@trojantry?utm_source=unsplash&utm_medium=referral&utm_content=creditCopyText">Andy Art</a> on <a href="https://unsplash.com/s/photos/woman-car?utm_source=unsplash&utm_medium=referral&utm_content=creditCopyText">Unsplash</a>]

# Example: Car Rental Service with Verified Data

--

Alice wants to rent a car with a self-service rental.

--

Car rental wants to verify that Alice has a driver's license before she can make the order.

--

Alice uses her wallet to present the proof of her license to drive, issued by the police.

---

class: img-fill middle

### Example: Car Rental Service with Verified Data

![Trust Triangle](/docs/slides/building-findy-agency/trust-triangle-ex2.png)

---

background-image: url(https://images.unsplash.com/photo-1505751172876-fa1923c5c528?ixlib=rb-1.2.1&ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=2070&q=80)
background-size: cover
class: center padded-slide

.image-credit[Photo by <a href="https://unsplash.com/@hush52?utm_source=unsplash&utm_medium=referral&utm_content=creditCopyText">Hush Naidoo Jade Photography</a> on <a href="https://unsplash.com/s/photos/stethoscope?utm_source=unsplash&utm_medium=referral&utm_content=creditCopyText">Unsplash</a>]

# Example: Doctor Reservation Service with Verified Data

--

Bob is booking an appointment with doctor Dan. He has not visited Dan before.

--

Bob wants to confirm that Dan is not a fake doctor.

--

Before completing the reservation, Bob sends a proof request to Dan for Dan's diploma. He can verify that Dan graduated from a respected university.

---

class: img-fill middle

### Example: Doctor Reservation Service with Verified Data

![Trust Triangle](/docs/slides/building-findy-agency/trust-triangle-ex3.png)

---

class: img-fill

![Findy Network Homepage](/docs/slides/building-findy-agency/findy-homepage.png)
.center.small[[Findy Network](https://findy.fi)]

???

- A public permissioned blockchain stores the shared data, such as the public keys of the credential issuers. Each network has a set of rules, how this data is maintained and updated.
- In Finland, we have a joint public-private effort, the Findy cooperative, aiming to run the national Findy network and to maintain the verifiable data registry in the future.
- Many countries have similar initiatives, such as Germany, Spain and, Canada. EU is also steering legislation in the direction of identity wallets.

---

template: network

# Trust Layer on top of Internet

--

Founded on trust and security

--

Increased privacy

--

Decoupled services

--

The next step of digitalization

???

- Verified data networks make the internet a more secure place.
- Privacy increases as end-users become the owners of their own data, and they may select which data they want to share.
- The need for custom integrations between organizations decreases as they can handle the needed data exchange through the network.
  - User and his digital wallet becomes the integration point between services.
- The use of verified data networks will enable the digitalization of use cases traditionally cumbersome to implement. It will also allow entirely new use cases.

---

template: network

# Used Technologies

--

[`DIDComm`](https://identity.foundation/didcomm-messaging/spec/)

--

[`indy-sdk`](https://github.com/hyperledger/indy-sdk) and `Indy "AnonCreds"`

--

[`Indy Blockchain`](https://wiki.hyperledger.org/display/indy)

--

[`Hyperledger Aries`](https://github.com/hyperledger/aries-rfcs)

???

- The technology is new and it is evolving rapidly. Some of these tools have likely been replaced when first use cases start in production.
- DIDComm-messaging is the foundation of all verified data communication. The DIDComm-connection is a secure messaging channel created by exchanging DIDs (identifiers for decentralized, digital identity).
- Indy-sdk provides the needed cryptographic functionality. It supports the Indy "AnonCreds" credential format.
- Digital identities are rooted in Hyperledger Indy blockchain, which works together with the indy-sdk-tools.
- Hyperledger Aries defines the protocol by how identity agents communicate with each other.

---

class: middle

### Used Technologies

.img-fill[![Agency Technologies](/docs/slides/building-findy-agency/agency-tech.drawio.png)]

???

- Each identity holder owns an agent that can handle the credentials and the needed communication with other agents.
- Depending on the implementation approach, agent functionality can be included in the service as a framework, or agent/agency can run as a separate service.
- Findy Agency is a multitenant service, i.e., a single installation can host multiple identity agents.
- At the time Findy Agency development was started, there were no open-source alternatives to choose from. Nowadays, the situation is better, and there are multiple open source frameworks and agencies that support the Aries protocol.

---

class: img-fill middle center

### Architecture Overview

![Agency Architecture](/docs/slides/building-findy-agency/agency-arch.drawio.png)

???

- Multitenant agency serving both individuals and organizations
- Exceptional cloud-first approach: credential data is stored and handled only in the server-side
- Secure passwordless authentication via WebAuthn
- GraphQL for browser, gRPC for API clients
- Performant microservice architecture implemented with GoLang and gRPC
- Contanerized microservice images are built with GitHub Actions
- Fully open-source

---

# Why GoLang?

--

class: img-fill middle center

.image-credit[Image by [Olivier Poitrey](https://twitter.com/Olivier_Poitrey)]

![Performance](https://pbs.twimg.com/media/CtLy-vuUMAAvJmw?format=png&name=900x900)

???

- Initially the technology was implemented by crypto-specialists coming from the academic world, and most of the examples were written in Python. As software professionals we knew that building an agency for this purpose would need more performant tools.

- We thought that Go was the best choice of modern languages when the target is to make network intensive microservices.

- Our approach using Go is pragmatic. We are not "Go-purists".

---

template: network

# Go: Highlights 1/2

--

C-bindings

--

Concurrency tools

--

Error handling

--

Library support: `gRPC`, `graphQL`, `boltDB`, `WebAuthn`, `postgres`, `cobra`, `viper`, `openAPI` code generation...

---

template: network

# Go: Highlights 2/2

Tooling: testing, `golangci-lint`, integration to CI

--

Cross-platform builds

--

Docker

--

Refactoring

--

Multiple development flavors

???

- C-bindings to Indy
- Concurrency handling with channels etc.
- Excellent library support: gRPC, GraphQL, BoltDB, WebAuthn, postgres, cobra, viper, openAPI generation
- Error handling
- Native builds for CLI
- Tooling: testing, linting, integration to CI

---

template: network

# Go: Challenges

--

Steep learning curve for developers with JS background and less CLI experience

--

Multiple repositories

--

Moving from GOPATH to modules

--

Short variable names

???

- Moving to go packages from GOPATH in the middle of the project, refactoring difficulties
- Multiple repositories instead of monorepo
- Package version mismatches
- Objection among team members

---

class: center, img-fill

# Demo

![Demo](https://github.com/findy-network/findy-wallet-pwa/raw/dev/docs/wallet-login.gif)

[Try it out](https://findy-network.github.io/)

???
